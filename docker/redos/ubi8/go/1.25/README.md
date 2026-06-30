# Образ Go 1.25

Платформенный образ для сборки и запуска Go-приложений на базе Red Soft UBI 8.

Образ минимизирован через multi-stage сборку: Go устанавливается в промежуточном слое, а в итоговый образ копируется только toolchain из `/usr/lib/golang`.

## Техническая информация

| Поле | Значение |
| --- | --- |
| Базовый образ | `registry.red-soft.ru/ubi8/ubi-minimal:latest` |
| Имя образа | `redos/ubi8/go/1.25` |
| Версия Go | `1.25.8` |
| Архитектура | `linux/amd64` |
| Пользователь | `1001` |
| Рабочая директория | `/workspace` |
| GOROOT | `/usr/lib/golang` |
| GOPATH | `/go` |
| GOCACHE | `/go/.cache/go-build` |
| CGO | `CGO_ENABLED=0` |

## Аргументы сборки

| Аргумент | Значение по умолчанию | Описание |
| --- | --- | --- |
| `REGISTRY_REDSOFT` | `registry.red-soft.ru` | Registry с базовым образом. |
| `BASE_IMAGE_TAG` | `latest` | Тег базового образа. |
| `BUILD_ENVIRONMENT` | `devzone` | Значение `trust` включает корпоративные репозитории и CA-сертификаты. |
| `GO_VERSION` | `1.25.8` | Версия пакета Go. |
| `APP_UID` | `1001` | UID пользователя внутри контейнера. |

## Локальная сборка

Из директории образа:

```sh
./build.sh
```

Эквивалентная команда напрямую:

```sh
docker buildx build \
  --platform=linux/amd64 \
  --build-context=common=../../../../../common \
  -t redos/ubi8/go/1.25:1.25.8 \
  -t redos/ubi8/go/1.25:latest \
  -f Dockerfile \
  --build-arg REGISTRY_REDSOFT=registry.red-soft.ru \
  --build-arg BASE_IMAGE_TAG=latest \
  --build-arg BUILD_ENVIRONMENT=devzone \
  --build-arg GO_VERSION=1.25.8 \
  --pull \
  --load \
  --no-cache \
  --progress plain \
  .
```

## Проверка

```sh
docker run --rm redos/ubi8/go/1.25:latest go version
docker run --rm redos/ubi8/go/1.25:latest id
docker run --rm redos/ubi8/go/1.25:latest pwd
docker run --rm redos/ubi8/go/1.25:latest go env GOROOT GOPATH GOCACHE CGO_ENABLED
docker run --rm redos/ubi8/go/1.25:latest sh -lc "printf '%s\n' 'package main' 'func main(){}' > main.go && go mod init smoke && go build -o app . && ./app"
```

Ожидаемый результат:

- `go version` показывает Go `1.25.8`;
- `id` показывает пользователя `1001` (`appuser`);
- `pwd` возвращает `/workspace`;
- `go env GOROOT GOPATH GOCACHE CGO_ENABLED` возвращает `/usr/lib/golang`, `/go`, `/go/.cache/go-build`, `0`;
- простая Go-программа успешно собирается и запускается.

## Публикация

Если образ нужно отправить в отдельный registry, задайте `REGISTRY_CUSTOM` в `docker/.env` и запустите:

```sh
./publish.sh
```

Если используется префикс registry, `REGISTRY_CUSTOM` должен включать завершающий слеш:

```sh
REGISTRY_CUSTOM="registry.example.com/"
```

## Trust-сборка

Для `BUILD_ENVIRONMENT=trust` Docker использует именованный build context `common`:

```sh
--build-context=common=../../../../../common
```

Контекст должен содержать:

```text
common/yum.repos.d/RedOS-trust.repo
```

В этом режиме образ подменяет источники пакетов, скачивает корпоративные CA-сертификаты из Nexus, проверяет их и обновляет системный CA bundle перед установкой Go.

## Ограничение

Для уменьшения размера в итоговом образе нет `gcc`, `git`, `systemd`, `grub` и других пакетов, которые подтягивает RPM-установка Go. Поэтому CGO отключен через `CGO_ENABLED=0`. Для проектов с CGO потребуется отдельный образ с компилятором C или расширение этого образа.
