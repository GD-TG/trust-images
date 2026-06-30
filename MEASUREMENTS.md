# Image Measurements

Measurements are split into two stages:

- before minimization: the image builds successfully and smoke tests pass;
- after minimization: the same checks are repeated after Dockerfile optimization.

## Environment

| Field | Value |
| --- | --- |
| Date | 2026-06-30 |
| Docker server | 28.5.2 |
| Build command | `sh ./build.sh` |
| Build mode | `BUILD_ENVIRONMENT=devzone` |
| Build cache | disabled by `--no-cache` in `build.sh` |
| Platform | `linux/amd64` |
| Base image | `registry.red-soft.ru/ubi8/ubi-minimal:latest` |

## Before Minimization

| Image | Go version | Build time | Image size | Image ID |
| --- | --- | ---: | ---: | --- |
| `redos/ubi8/go/1.25:latest` | `go1.25.8 linux/amd64` | 354.758 s | 982 MB | `de01db061c34` |
| `redos/ubi8/go/1.24:latest` | `go1.24.8 linux/amd64` | 255.851 s | 1.13 GB | `ba6720f7598e` |

Smoke checks for both images:

| Check | `go-125` | `go-124` |
| --- | --- | --- |
| `go version` | `go version go1.25.8 linux/amd64` | `go version go1.24.8 linux/amd64` |
| `id` | `uid=1001 gid=0(root) groups=0(root)` | `uid=1001 gid=0(root) groups=0(root)` |
| `pwd` | `/workspace` | `/workspace` |
| `go env GOPATH` | `/go` | `/go` |

## After Minimization

To be measured after optimization.

| Image | Go version | Build time | Image size | Image ID | Size delta | Time delta |
| --- | --- | ---: | ---: | --- | ---: | ---: |
| `redos/ubi8/go/1.25:latest` | TBD | TBD | TBD | TBD | TBD | TBD |
| `redos/ubi8/go/1.24:latest` | TBD | TBD | TBD | TBD | TBD | TBD |

## Commands

Build time:

```powershell
$elapsed = Measure-Command { sh ./build.sh | Out-Host }
"ELAPSED_SECONDS={0:N3}" -f $elapsed.TotalSeconds
```

Image size:

```powershell
docker images --format "{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}" "redos/ubi8/go/*"
```

Smoke tests:

```powershell
docker run --rm redos/ubi8/go/1.25:latest go version
docker run --rm redos/ubi8/go/1.25:latest id
docker run --rm redos/ubi8/go/1.25:latest pwd
docker run --rm redos/ubi8/go/1.25:latest go env GOPATH

docker run --rm redos/ubi8/go/1.24:latest go version
docker run --rm redos/ubi8/go/1.24:latest id
docker run --rm redos/ubi8/go/1.24:latest pwd
docker run --rm redos/ubi8/go/1.24:latest go env GOPATH
```
