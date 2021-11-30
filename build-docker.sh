#!/bin/sh

set -ex

docker build -t thunderhead/auth-fastapi-image -f Dockerfile .
