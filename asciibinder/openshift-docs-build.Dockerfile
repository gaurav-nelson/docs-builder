FROM ruby:3.1.2-alpine3.16 AS builder
RUN apk update && apk add --no-cache --virtual build-dependencies build-base \
    && gem install listen asciidoctor asciidoctor-diagram ascii_binder \
    && apk del build-dependencies

FROM ruby:3.1.2-alpine3.16
COPY --from=builder /usr/local/bundle /usr/local/bundle
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache git bash python3 python3-dev \
    && ln -sf python3 /usr/bin/python \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools \
    && rm -rf /var/cache/apk/*
WORKDIR /openshift-docs-build
COPY ./aura.tar.gz /openshift-docs-build
RUN pip3 install --no-cache-dir pyyaml aura.tar.gz \
    && git config --global --add safe.directory /openshift-docs-build
