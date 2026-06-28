# Go 1.24 Image

Platform image for building and running Go based applications on Red Soft UBI 8.

## Technical Information

| Field | Value |
| --- | --- |
| Base image | `registry.red-soft.ru/ubi8/ubi-minimal:latest` |
| Repository name | `redos/ubi8/go/1.24` |
| Go version | `1.24.8` |
| Architecture | `linux/amd64` |
| User | `1001` |
| Working directory | `/workspace` |
| GOPATH | `/go` |

## Build Arguments

| Argument | Default | Description |
| --- | --- | --- |
| `REGISTRY_REDSOFT` | `registry.red-soft.ru` | Base image registry. |
| `BASE_IMAGE_TAG` | `latest` | Base image tag. |
| `BUILD_ENVIRONMENT` | `devzone` | Use `trust` to enable corporate repositories and CA certificates. |
| `GO_VERSION` | `1.24.8` | Go package version to install. |
| `APP_UID` | `1001` | Runtime user ID. |

## Local Build

From this directory:

```sh
./build.sh
```

Equivalent direct command:

```sh
docker buildx build \
  --platform=linux/amd64 \
  --build-context=common=../../../../../common \
  -t redos/ubi8/go/1.24:1.24.8 \
  -t redos/ubi8/go/1.24:latest \
  -f Dockerfile \
  --build-arg REGISTRY_REDSOFT=registry.red-soft.ru \
  --build-arg BASE_IMAGE_TAG=latest \
  --build-arg BUILD_ENVIRONMENT=devzone \
  --build-arg GO_VERSION=1.24.8 \
  --pull \
  --load \
  --no-cache \
  --progress plain \
  .
```

## Verification

```sh
docker run --rm redos/ubi8/go/1.24:latest go version
docker run --rm redos/ubi8/go/1.24:latest id
docker run --rm redos/ubi8/go/1.24:latest pwd
docker run --rm redos/ubi8/go/1.24:latest go env GOPATH
```

Expected checks:

- `go version` shows Go `1.24.8`.
- `id` shows user `1001`.
- `pwd` returns `/workspace`.
- `go env GOPATH` returns `/go`.

## Publish

Set `REGISTRY_CUSTOM` in `docker/.env` if the image must be pushed to a custom registry, then run:

```sh
./publish.sh
```

`REGISTRY_CUSTOM` should include the trailing slash when a registry prefix is used, for example:

```sh
REGISTRY_CUSTOM="registry.example.com/"
```

## Trust Build

For `BUILD_ENVIRONMENT=trust`, the Docker build uses the named build context `common`:

```sh
--build-context=common=../../../../../common
```

The context must contain:

```text
common/yum.repos.d/RedOS-trust.repo
```

In this mode the image replaces package repositories, downloads corporate CA certificates from Nexus, validates them, and updates the system CA bundle before installing Go.
