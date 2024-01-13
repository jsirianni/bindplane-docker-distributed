#!/bin/bash

set -e

cd $(dirname $0)

docker-compose rm -f
sudo rm -rf data/
