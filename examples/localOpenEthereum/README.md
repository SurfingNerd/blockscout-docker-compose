A config for running a docker instance for a local openethereum instance on linux.

`docker-compose up` : start's a new Blockscout instance. beware: might reuse an existing database.
`docker-compose down` : delete's the database
`docker-compose down && docker-compose up` : start Blockscout from a fresh Database.


# Notes

`network_mode: host`: This allows docker to access ports from your localhost
`172.17.0.1`: In the default configuration in docker networks, this represents localhost.