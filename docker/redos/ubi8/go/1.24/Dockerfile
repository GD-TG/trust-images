# syntax=docker/dockerfile:1.4
ARG REGISTRY_REDSOFT="registry.red-soft.ru"
ARG BASE_IMAGE_TAG="latest"

FROM ${REGISTRY_REDSOFT}/ubi8/ubi-minimal:${BASE_IMAGE_TAG} AS base
ARG BUILD_ENVIRONMENT="devzone"

USER 0

# Для trust-сборки подменяем репозитории пакетов и добавляем корпоративные CA.
RUN --mount=type=bind,from=common,target=/common \
    if [ "${BUILD_ENVIRONMENT}" = "trust" ]; then \
        rm -rf /etc/yum.repos.d/* && \
        cp /common/yum.repos.d/RedOS-trust.repo /etc/yum.repos.d/ && \
        curl -k https://nexus.gazprom-neft.local:443/repository/local-repo/CA/root-ca-gazprom-neft.pem \
            --output /etc/pki/ca-trust/source/anchors/gazprom-neft_Root_CA.crt && \
        curl -k https://nexus.gazprom-neft.local:443/repository/local-repo/CA/sub-ca.pem \
            --output /etc/pki/ca-trust/source/anchors/gazprom-neft_Root_CA_mid.crt && \
        echo "Certificate validation:" && \
        openssl x509 -in /etc/pki/ca-trust/source/anchors/gazprom-neft_Root_CA.crt -noout -subject -issuer -dates && \
        openssl x509 -in /etc/pki/ca-trust/source/anchors/gazprom-neft_Root_CA_mid.crt -noout -subject -issuer -dates && \
        update-ca-trust && \
        echo "CA bundle contains $(grep -c 'BEGIN CERTIFICATE' /etc/pki/tls/certs/ca-bundle.crt) certificates" && \
        grep -q "Gazprom" /etc/pki/tls/certs/ca-bundle.crt && echo "Gazprom certificates added to ca-bundle"; \
    fi

FROM base AS builder
ARG GO_VERSION="1.24.8"

RUN dnf install -y "golang-${GO_VERSION}" && \
    dnf clean all && \
    rm -rf /var/cache/dnf

FROM base
ARG GO_VERSION="1.24.8"
ENV GO_VERSION=${GO_VERSION}
ENV GOROOT=/usr/lib/golang
ENV GOPATH=/go
ENV GOCACHE=${GOPATH}/.cache/go-build
ENV CGO_ENABLED=0
ENV PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}

COPY --from=builder /usr/lib/golang /usr/lib/golang

WORKDIR /workspace

ARG APP_UID=1001
RUN mkdir -p "${GOPATH}" /workspace && \
    echo "appuser:x:${APP_UID}:0:Application User:/workspace:/bin/sh" >> /etc/passwd && \
    chown -R "${APP_UID}:0" "${GOPATH}" /workspace && \
    chmod -R 775 "${GOPATH}" /workspace

USER ${APP_UID}

LABEL maintainer="GpnDs"
