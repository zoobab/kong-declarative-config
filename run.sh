#!/bin/bash

if [[ "$#" -ne "1" ]] ; then
    echo "Error, please specify a type of example to load (simple, transformer, withkey)"
    echo "Usage: $0 simple"
    exit 1
fi

TYPE="$1"
docker run -d -e KONG_DATABASE=off -e KONG_DECLARATIVE_CONFIG=/etc/kong/kong-$TYPE.yml -v $PWD:/etc/kong -p8000:8000 zoobab/kong:1.1.1-openshift
