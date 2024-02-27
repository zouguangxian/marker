#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

BUILDER=${BUILDER:-"default"}

docker buildx build \
    --builder $BUILDER \
    --progress=plain \
    --platform=linux/amd64,linux/arm64 \
    --tag zouguangxian/marker:latest \
    --push \
    -f $DIR/Dockerfile \
    $DIR/../

