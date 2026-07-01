#!/usr/bin/env sh
# Скрипт для локальной сборки образа
source ../../../../../.env
# source .env


docker buildx build \
  --platform=linux/amd64 \
  --build-context=common=../../../../../common \
  -t "${PYTHON_313_IMAGE_NAME}:${PYTHON_313_VERSION}" \
  -t "${PYTHON_313_IMAGE_NAME}:latest" \
  -f Dockerfile \
  --build-arg REGISTRY_REDSOFT="${REGISTRY_REDSOFT}" \
  --build-arg BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT}" \
  --pull \
  --load \
  --no-cache \
  --progress plain \
  .