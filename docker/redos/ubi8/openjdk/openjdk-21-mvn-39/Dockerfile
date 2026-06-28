ARG REGISTRY_REDSOFT="redos-registry.repos.devzone.local"
ARG BASE_IMAGE_TAG=8.0.2-260616

FROM ${REGISTRY_REDSOFT}/ubi8/ubi-minimal:${BASE_IMAGE_TAG}
ARG BUILD_ENVIRONMENT="devzone"

USER 0
# Добавим сертификаты и источники обновления пакетов для сборки в КСПД
# Сертификаты скачиваются из Nexus для актуальности и безопасности
RUN --mount=type=bind,from=common,target=/common \
    if [ $BUILD_ENVIRONMENT = 'trust' ]; then \
        rm -r /etc/yum.repos.d/* && \
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
        grep -q 'Gazprom' /etc/pki/tls/certs/ca-bundle.crt && echo "Gazprom certificates added to ca-bundle" && \
        mkdir -p /root/.m2 && \
        cp /common/maven-trust.repo/settings.xml /root/.m2/settings.xml; \
    fi

# Установка последней доступной версии Maven
RUN dnf update -y && \
    dnf install -y maven && \
    dnf clean all

# Проверка установленной версии (для информации при сборке)
RUN mvn --version

# Дополнительные настройки (можно оставить пустыми или добавить при необходимости)
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

WORKDIR /workspace
RUN mkdir -p /workspace && chmod -R 755 /workspace

ARG APP_UID=1001
USER $APP_UID

LABEL maintainer="GpnDs"