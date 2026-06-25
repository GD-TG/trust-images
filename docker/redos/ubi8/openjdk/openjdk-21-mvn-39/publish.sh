#!/usr/bin/env sh
# Скрипт для сборки и публикации образа registry DevZone
source ../../../../.env

docker buildx build \
  --platform=linux/amd64 \
  --build-context=common=../../../../../common \
  -t "${REGISTRY_CUSTOM}${OPENJDK_21_MVN_39_IMAGE_NAME}:${VERSION}" \
  -t "${REGISTRY_CUSTOM}${OPENJDK_21_MVN_39_IMAGE_NAME}:latest" \
  -f Dockerfile \
  --build-arg REGISTRY_REDSOFT="${REGISTRY_REDSOFT}" \
  --build-arg BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT}" \
  --pull \
  --push \
  --no-cache \
  --progress plain \
  .
