#!/bin/bash
docker run -d -e KONG_DATABASE=off -e KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml -v $PWD:/etc/kong -p8000:8000 zoobab/kong:1.1.1-openshift
