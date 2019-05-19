FROM node:9-alpine

ARG CONDUCTOR_VERSION=v2.12.1

RUN apk update && apk add \
    autoconf \
    automake \
    libtool \
    build-base \
    libstdc++ \
    gcc \
    abuild \
    binutils \
    nasm \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    python \
    bash \
    git

RUN mkdir -p /app/ui

# Copy the ui files onto the image
WORKDIR /tmp
RUN git clone https://github.com/Netflix/conductor.git
WORKDIR /tmp/conductor
RUN git checkout tags/$CONDUCTOR_VERSION
RUN cp -rp docker/ui/bin/* /app/ \
    && cp -rp ui /app/ \
    && rm -rf /tmp/*

# Get and install conductor UI
WORKDIR /app/ui
RUN npm install \
    && npm run build --server

RUN chmod +x /app/startup.sh

EXPOSE 5000

CMD [ "/app/startup.sh" ]
ENTRYPOINT ["/bin/sh"]