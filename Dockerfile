FROM ubuntu:22.04

COPY common.sh /
RUN /common.sh

COPY scripts/ /scripts/

ENTRYPOINT [ "/lib/systemd/systemd" ]
