ARG REGISTRY_CUSTOM="registry.gazprom-neft.local:5000/gpnds/"
ARG BASE_IMAGE_TAG=latest

FROM ${REGISTRY_CUSTOM}redos/ubi8/python-313:${BASE_IMAGE_TAG}

USER 0
WORKDIR /test

# Аргументы передаются из build-props.yaml при сборке через Jenkins
ARG PYPI_REPOSITORY
ARG PYPI_REPOSITORY_EXTRA

# Тест 1: Установка pipenv БЕЗ --trusted-host
# Проверяем, что ENV PIP_CERT работает
RUN pip install \
      --index-url ${PYPI_REPOSITORY} \
      --extra-index-url ${PYPI_REPOSITORY_EXTRA} \
      --no-cache-dir \
      pipenv==2025.0.4

# Тест 2: Создание Pipfile для тестирования
RUN echo '[[source]]' > Pipfile && \
    echo 'url = "'${PYPI_REPOSITORY}'"' >> Pipfile && \
    echo 'verify_ssl = true' >> Pipfile && \
    echo 'name = "pypi"' >> Pipfile && \
    echo '' >> Pipfile && \
    echo '[packages]' >> Pipfile && \
    echo 'requests = "*"' >> Pipfile && \
    echo 'pytest = "*"' >> Pipfile && \
    echo '' >> Pipfile && \
    echo '[requires]' >> Pipfile && \
    echo 'python_version = "3.13"' >> Pipfile

# Создаем Pipfile.lock
RUN pipenv lock

# Устанавливаем зависимости в системное окружение
RUN pipenv install --system --deploy

# Проверяем
RUN python3 -c "import requests; import pytest; print('Python 3.13: Packages installed successfully')"

# Тест 3: Установка через pipenv с REQUESTS_CA_BUNDLE (как в реальных проектах)
# Если не работает - сборка упадет
RUN REQUESTS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt \
    pipenv install --system

# Тест 4: Проверка установленных пакетов
# Если импорт не работает - сборка упадет
RUN python3 -c "import requests; import pytest; print('Python 3.13: Packages installed successfully')"

# Тест 5: Проверка SSL контекста
RUN python3 -c "import ssl; print('SSL context OK')"

USER 1001
CMD ["python3", "--version"]
