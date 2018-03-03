FROM ubuntu:17.10
ENV DEBIAN_FRONTEND noninteractive
COPY scripts/ /tmp
RUN /tmp/install.sh \
    && /tmp/cleanup.sh
VOLUME /root/app-store
