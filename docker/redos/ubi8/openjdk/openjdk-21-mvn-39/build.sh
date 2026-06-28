#!/usr/bin/env sh
# Скрипт для локальной сборки образа
source ../../../../.env

docker buildx build \
  --platform=linux/amd64 \
  --build-context=common=../../../../../common \
  -t "${OPENJDK_21_MVN_IMAGE_NAME}:${VERSION}" \
  -t "${OPENJDK_21_MVN_IMAGE_NAME}:latest" \
  -f Dockerfile \
  --build-arg REGISTRY_REDSOFT="${REGISTRY_REDSOFT}" \
  --build-arg BASE_IMAGE_TAG="${BASE_IMAGE_TAG}" \
  --build-arg BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT}" \
  --pull \
  --load \
  --no-cache \
  --progress plain \
  .