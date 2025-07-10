FROM eclipse-temurin:17-jre-jammy AS builder
RUN apt-get -qq update && apt-get -qq install -y unzip jq

WORKDIR /data
RUN curl -fsSL -o "/tmp/pack.zip" "https://mediafilez.forgecdn.net/files/6057/416/Create%20Astral%20Server%20Pack%20v2.1.3.zip"
RUN curl -fsSL -o "/tmp/old.zip" "https://mediafilez.forgecdn.net/files/4496/671/Create%20Astral%20Server%20Pack%20v2.0.4c.zip"
RUN unzip -q /tmp/pack.zip -d /data
RUN unzip -q /tmp/old.zip -d /tmp/old/
RUN cp /tmp/old/mods/vinery-1.1.4.jar mods/
RUN cp /tmp/old/mods/Hephaestus-1.18.2-3.5.2.155.jar mods/
RUN curl -fsSL -o "server.jar" "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.16.3/0.11.1/server/jar"

FROM container-registry.oracle.com/graalvm/jdk:24

RUN mkdir /init && touch /init/now
COPY --from=builder /data /data
COPY --chmod=755 entrypoint.sh /entrypoint.sh

WORKDIR /data

VOLUME [ "/data/world", "/data/backups" ]
EXPOSE 25565/tcp

ENTRYPOINT [ "/entrypoint.sh" ]
