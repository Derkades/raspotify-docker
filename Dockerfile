FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get -y install alsa-utils libasound2-plugin-equal gettext curl apt-transport-https && \
    update-ca-certificates --fresh && \
    curl -sSL https://dtcooper.github.io/raspotify/key.asc | tee /usr/share/keyrings/raspotify_key.asc > /dev/null && \
    chmod 644 /usr/share/keyrings/raspotify_key.asc && \
    echo 'deb [signed-by=/usr/share/keyrings/raspotify_key.asc] https://dtcooper.github.io/raspotify raspotify main' | tee /etc/apt/sources.list.d/raspotify.list && \
    apt-get update && \
    apt-get -y install raspotify && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV SPOTIFY_NAME RaspotifySpeaker
ENV BACKEND_NAME 'alsa'
ENV DEVICE_NAME 'equal'
ENV ALSA_SLAVE_PCM 'plughw:0,0'
ENV ALSA_SOUND_LEVEL '100%'
ENV INITIAL_VOLUME '40'
ENV VERBOSE 'false'
ENV EQUALIZATION ''

COPY /asound.conf /
COPY /equalizer.sh /

COPY /startup.sh /
ENTRYPOINT /startup.sh
