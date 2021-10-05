FROM alpine

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL maintainer="Hauke Mettendorf <hauke@mettendorf.it>" \
      org.opencontainers.image.title="proum/prometheus-extra-labels-metric" \
      org.opencontainers.image.description="Creates a fake metric containing extra labels." \
      org.opencontainers.image.authors="Hauke Mettendorf <hauke@mettendorf.it>" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.version=${BUILD_VERSION} \
      org.opencontainers.image.url="https://gitlab.com/proum-public/docker/prometheus-extra-labels-metric" \
      org.opencontainers.image.vendor="https://mettendorf.it" \
      org.opencontainers.image.licenses="GNUv2"

RUN apk --no-cache --update add bash \
    && mkdir -p /scripts

COPY src/sh/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh

CMD /scripts/run.sh
