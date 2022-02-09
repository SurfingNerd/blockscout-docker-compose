#!/bin/sh

#sometimes --no-cache might help.
docker build --no-cache -f Dockerfile . -t surfingnerd/blockscout-dmd:v0.9-411

