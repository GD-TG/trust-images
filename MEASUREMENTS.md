# Замеры Docker-образов

Замеры разделены на два этапа:

- до минимизации: образ успешно собирается, запускается и проходит базовые проверки;
- после минимизации: те же проверки повторяются после оптимизации Dockerfile.

## Окружение

| Поле | Значение |
| --- | --- |
| Дата baseline-замера | 2026-06-30 |
| Docker server | 28.5.2 |
| Команда сборки | `sh ./build.sh` |
| Режим сборки | `BUILD_ENVIRONMENT=devzone` |
| Кэш сборки | отключен через `--no-cache` в `build.sh` |
| Платформа | `linux/amd64` |
| Базовый образ | `registry.red-soft.ru/ubi8/ubi-minimal:latest` |

## До минимизации

| Образ | Версия Go | Время сборки | Размер образа | Image ID |
| --- | --- | ---: | ---: | --- |
| `redos/ubi8/go/1.25:latest` | `go1.25.8 linux/amd64` | 354.758 s | 982 MB | `de01db061c34` |
| `redos/ubi8/go/1.24:latest` | `go1.24.8 linux/amd64` | 255.851 s | 1.13 GB | `ba6720f7598e` |

Проверки для обоих образов до минимизации:

| Проверка | `go-125` | `go-124` |
| --- | --- | --- |
| `go version` | `go version go1.25.8 linux/amd64` | `go version go1.24.8 linux/amd64` |
| `id` | `uid=1001 gid=0(root) groups=0(root)` | `uid=1001 gid=0(root) groups=0(root)` |
| `pwd` | `/workspace` | `/workspace` |
| `go env GOPATH` | `/go` | `/go` |

## После минимизации

Оптимизация выполнена через multi-stage сборку: RPM-пакет Go устанавливается в промежуточном слое, а в итоговый образ копируется только Go toolchain из `/usr/lib/golang`. В итоговом образе нет `gcc`, `git`, `systemd`, `grub` и других пакетов, которые подтягиваются при установке RPM. Для явного поведения задано `CGO_ENABLED=0`.

| Образ | Версия Go | Время сборки | Размер образа | Image ID | Изменение размера | Изменение времени |
| --- | --- | ---: | ---: | --- | ---: | ---: |
| `redos/ubi8/go/1.25:latest` | `go1.25.8 linux/amd64` | 310.785 s | 414 MB | `73bf0cc45c6d` | -568 MB | -43.973 s |
| `redos/ubi8/go/1.24:latest` | `go1.24.8 linux/amd64` | 312.327 s | 489 MB | `8c57c583c91c` | примерно -641 MB | +56.476 s |

Проверки для обоих образов после минимизации:

| Проверка | `go-125` | `go-124` |
| --- | --- | --- |
| `go version` | `go version go1.25.8 linux/amd64` | `go version go1.24.8 linux/amd64` |
| `id` | `uid=1001(appuser) gid=0(root) groups=0(root)` | `uid=1001(appuser) gid=0(root) groups=0(root)` |
| `pwd` | `/workspace` | `/workspace` |
| `go env GOROOT` | `/usr/lib/golang` | `/usr/lib/golang` |
| `go env GOPATH` | `/go` | `/go` |
| `go env GOCACHE` | `/go/.cache/go-build` | `/go/.cache/go-build` |
| `go env CGO_ENABLED` | `0` | `0` |
| Сборка простой Go-программы | `GO125_BUILD_SMOKE_OK` | `GO124_BUILD_SMOKE_OK` |

## Команды

Замер времени сборки:

```powershell
$elapsed = Measure-Command { sh ./build.sh | Out-Host }
"ELAPSED_SECONDS={0:N3}" -f $elapsed.TotalSeconds
```

Проверка размера:

```powershell
docker images --format "{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}" "redos/ubi8/go/*"
```

Базовые проверки:

```powershell
docker run --rm redos/ubi8/go/1.25:latest go version
docker run --rm redos/ubi8/go/1.25:latest id
docker run --rm redos/ubi8/go/1.25:latest pwd
docker run --rm redos/ubi8/go/1.25:latest go env GOROOT GOPATH GOCACHE CGO_ENABLED
docker run --rm redos/ubi8/go/1.25:latest sh -lc "printf '%s\n' 'package main' 'func main(){}' > main.go && go mod init smoke >/tmp/go-mod.log && go build -o app . && ./app"

docker run --rm redos/ubi8/go/1.24:latest go version
docker run --rm redos/ubi8/go/1.24:latest id
docker run --rm redos/ubi8/go/1.24:latest pwd
docker run --rm redos/ubi8/go/1.24:latest go env GOROOT GOPATH GOCACHE CGO_ENABLED
docker run --rm redos/ubi8/go/1.24:latest sh -lc "printf '%s\n' 'package main' 'func main(){}' > main.go && go mod init smoke >/tmp/go-mod.log && go build -o app . && ./app"
```
