# blockscout-docker-compose
A docker-compose ready setup for blockscout to spin up a new instance fast,
and makes it available under http://localhost:4000/

the examples directory contains example usages.
In addition to this blockscout Dockerfile it requires a postgres db,
that is included in the docker-compose examples.

`docker-compose up` : start's a new Blockscout instance. beware: might reuse an existing database.
`docker-compose down` : delete's the database
`docker-compose down && docker-compose up` : start Blockscout from a fresh Database.

# Bash into container:

```
#/bin/sh 
docker exec -ti dockerdev_blockscout_1 /bin/bash
```

# Notes

`network_mode: host`: This allows docker to access ports from your localhost
`172.17.0.1`: In the default configuration in docker networks, this represents localhost.