FROM ubuntu:17.10
ENV DEBIAN_FRONTEND noninteractive
COPY scripts /tmp
RUN /tmp/scripts/install.sh \
    && /tmp/scripts/cleanup.sh
VOLUME /root/app-store
