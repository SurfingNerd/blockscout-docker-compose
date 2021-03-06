
FROM bitwalker/alpine-elixir:1.11.0



# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2021-01-14

RUN apk --no-cache --update add alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3


# Install NPM
RUN \
    mkdir -p /opt/app && \
    chmod -R 777 /opt/app && \
    apk update && \
    apk --no-cache --update add \
      make \
      g++ \
      wget \
      curl \
      inotify-tools \
      nodejs \
      nodejs-npm && \
    npm install npm -g --no-progress && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*


# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH


# Ensure latest versions of Hex/Rebar are installed on build
ONBUILD RUN mix do local.hex --force, local.rebar --force


# Get Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"

EXPOSE 4000

ENV PORT=4000 \
    MIX_ENV="prod" \
    SECRET_KEY_BASE="RMgI4C1HSkxsEjdhtGMfwAHfyT6CKWXOgzCboJflfSm4jeAlic52io05KB6mqzc5"

# Cache elixir deps
ADD submodules/blockscout/mix.exs submodules/blockscout/mix.lock ./
ADD submodules/blockscout/apps/block_scout_web/mix.exs ./apps/block_scout_web/
ADD submodules/blockscout/apps/explorer/mix.exs ./apps/explorer/
ADD submodules/blockscout/apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
ADD submodules/blockscout/apps/indexer/mix.exs ./apps/indexer/

RUN mix do deps.get, local.rebar --force, deps.compile

ADD submodules/blockscout/. .

ARG COIN
RUN if [ "$COIN" != "" ]; then sed -i s/"POA"/"${COIN}"/g apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; fi

# Run forderground build and phoenix digest
RUN mix compile

# Add blockscout npm deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd -

RUN cd apps/explorer/ && \
    npm install && \
    apk update && apk del --force-broken-world alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3

RUN mix deps.get

RUN mix phx.digest

ADD  dockerContent/* ./

# USER default
# "mix", "do", "ecto.create", "ecto.migrate", "phx.server"

#CMD ["mix", "do", "ecto.create", "ecto.migrate", "phx.server"]
CMD ["./start-blockscout.sh"]
