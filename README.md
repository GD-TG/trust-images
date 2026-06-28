# Trust Images

Docker images for Red Soft UBI based build and runtime platforms.

## Images

| Image | Path | Version |
| --- | --- | --- |
| Go 1.25 | `docker/redos/ubi8/go/1.25` | `1.25.8` |
| Go 1.24 | `docker/redos/ubi8/go/1.24` | `1.24.8` |
| OpenJDK 21 + Maven | `docker/redos/ubi8/openjdk/openjdk-21-mvn-39` | `3.9.6` |

## Configuration

Shared build variables are stored in:

```text
docker/.env
```

The `common` directory is used as an additional Docker build context for `trust` builds and contains corporate package repository configuration.

## Build

Run a build script from the target image directory:

```sh
cd docker/redos/ubi8/go/1.25
./build.sh
```

Each image README contains its build, publish, and verification commands.
