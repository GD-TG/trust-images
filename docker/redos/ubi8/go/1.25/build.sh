#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE="${SCRIPT_DIR}/../../../../.env"
COMMON_CONTEXT="${SCRIPT_DIR}/../../../../../common"

if [ -f "${ENV_FILE}" ]; then
  . "${ENV_FILE}"
fi

: "${REGISTRY_REDSOFT:=registry.red-soft.ru}"
: "${BASE_IMAGE_TAG:=latest}"
: "${BUILD_ENVIRONMENT:=devzone}"
: "${GO_125_IMAGE_NAME:=redos/ubi8/go/1.25}"
: "${GO_125_VERSION:=1.25.8}"

docker buildx build \
  --platform=linux/amd64 \
  --build-context=common="${COMMON_CONTEXT}" \
  -t "${GO_125_IMAGE_NAME}:${GO_125_VERSION}" \
  -t "${GO_125_IMAGE_NAME}:latest" \
  -f "${SCRIPT_DIR}/Dockerfile" \
  --build-arg REGISTRY_REDSOFT="${REGISTRY_REDSOFT}" \
  --build-arg BASE_IMAGE_TAG="${BASE_IMAGE_TAG}" \
  --build-arg BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT}" \
  --build-arg GO_VERSION="${GO_125_VERSION}" \
  --pull \
  --load \
  --no-cache \
  --progress plain \
  "${SCRIPT_DIR}"
