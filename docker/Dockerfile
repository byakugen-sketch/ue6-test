FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libcurl4 \
    libgomp1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -s /bin/bash gameserver

COPY --chown=gameserver:gameserver LinuxServer/ /home/gameserver/server/

WORKDIR /home/gameserver/server/

EXPOSE 7777/udp
EXPOSE 15000/tcp

USER gameserver

ENTRYPOINT ["sh", "-c", "./$(ls *Server/Binaries/Linux/*Server 2>/dev/null | head -1) -log -port=7777 -NOSTEAM -nullrhi"]
