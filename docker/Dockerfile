FROM ubuntu:17.10
ENV DEBIAN_FRONTEND noninteractive
COPY scripts/ /tmp
RUN /tmp/install.sh \
    && rm -rf /root/packages
VOLUME /root/app-store
