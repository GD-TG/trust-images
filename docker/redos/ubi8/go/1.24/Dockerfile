# syntax=docker/dockerfile:1.4
ARG REGISTRY_REDSOFT="registry.red-soft.ru"
ARG BASE_IMAGE_TAG="latest"

FROM ${REGISTRY_REDSOFT}/ubi8/ubi-minimal:${BASE_IMAGE_TAG}
ARG BUILD_ENVIRONMENT="devzone"

USER 0

# Trust builds replace package repositories and install corporate CA certificates.
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

ARG GO_VERSION="1.24.8"
ENV GO_VERSION=${GO_VERSION}

RUN dnf update -y && \
    dnf install -y "golang-${GO_VERSION}" && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENV GOPATH=/go
ENV PATH=${PATH}:${GOPATH}/bin

WORKDIR /workspace

RUN mkdir -p "${GOPATH}" /workspace && \
    chmod -R 755 "${GOPATH}" /workspace

ARG APP_UID=1001
USER ${APP_UID}

LABEL maintainer="GpnDs"
