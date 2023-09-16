#!/bin/bash

cd $(dirname $0)
pwd
set -e

docker run -it --rm -p 8080:8080 -v `pwd`:/usr/local/structurizr structurizr/lite
