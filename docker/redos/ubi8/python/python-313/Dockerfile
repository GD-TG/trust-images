ARG REGISTRY_REDSOFT="redos-registry.repos.devzone.local"
ARG BASE_IMAGE_TAG=latest

# Используем минимальный образ, как просил Денис
FROM ${REGISTRY_REDSOFT}ubi8/ubi-minimal:${BASE_IMAGE_TAG}
ARG BUILD_ENVIRONMENT='devzone'

USER 0

# Устанавливаем Python 3.13 и нужные утилиты, затем сразу очищаем кэш пакетного менеджера!
RUN microdnf update -y && \
    microdnf install -y python3.13 curl openssl && \
    microdnf clean all

# Гарантируем наличие pip для нужной версии Python
RUN python3.13 -m ensurepip --upgrade

# Блок сертификатов Газпромнефти (оставлен без изменений)
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
        grep -q 'Gazprom' /etc/pki/tls/certs/ca-bundle.crt && echo "Gazprom certificates added to ca-bundle"; \
    fi

# Настройка pip для использования корпоративных сертификатов
ENV PIP_CERT=/etc/pki/tls/certs/ca-bundle.crt

ARG PIP_INDEX_URL
# Обновляем pip и setuptools, используя безопасный синтаксис
# Создаем удобные симлинки, чтобы команды python3 и pip3 работали корректно
RUN ln -sf /usr/bin/python3.13 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3.13 /usr/bin/pip3

ARG PIP_INDEX_URL
# Обновляем pip и setuptools, используя безопасный синтаксис
RUN PACKAGES=$(pip3 list --outdated 2>/dev/null | tail -n +3 | awk '{print $1}') && \
    if [ -n "$PACKAGES" ]; then \
        if [ -n "$PIP_INDEX_URL" ]; then \
            echo "$PACKAGES" | xargs -r python3 -m pip install --index-url ${PIP_INDEX_URL} --no-cache-dir --upgrade; \
        else \
            echo "$PACKAGES" | xargs -r python3 -m pip install --no-cache-dir --upgrade; \
        fi \
    fi

ARG APP_UID=1001
USER $APP_UID