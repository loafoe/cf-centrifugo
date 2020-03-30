FROM alpine:latest AS builder
ENV CENTRIFUGO_VERSION 2.4.0

WORKDIR /build
RUN apk update \
 && apk add curl

ADD run.sh /build
# Fix exec permissions issue that come up due to the way source controls deal with executable files.
RUN chmod a+x /build/run.sh
RUN curl -L -Os https://github.com/centrifugal/centrifugo/releases/download/v${CENTRIFUGO_VERSION}/centrifugo_${CENTRIFUGO_VERSION}_linux_amd64.tar.gz


# Verify the signature file is untampered.
RUN curl -L -Os https://github.com/centrifugal/centrifugo/releases/download/v${CENTRIFUGO_VERSION}/centrifugo_${CENTRIFUGO_VERSION}_checksums.txt
RUN CENTRIFUGO_CHECKSUM=$(cat centrifugo_${CENTRIFUGO_VERSION}_checksums.txt |grep linux_amd64|cut -f 1 -d ' ') && \
    echo ${CENTRIFUGO_CHECKSUM}"  "centrifugo_${CENTRIFUGO_VERSION}_linux_amd64.tar.gz > centrifugo_shasum && \
    cat centrifugo_shasum|sha256sum -c
RUN tar xvf centrifugo_${CENTRIFUGO_VERSION}_linux_amd64.tar.gz

FROM alpine:latest 
LABEL maintainer="Andy Lo-A-Foe <andy.lo-a-foe@philips.com>"
RUN apk update \
 && apk add jq \
 && apk add ca-certificates \
 && rm -rf /var/cache/apk/*

WORKDIR /app
COPY --from=builder /build/centrifugo /app
COPY --from=builder /build/run.sh /app
EXPOSE 8080
CMD ["/app/run.sh"]
