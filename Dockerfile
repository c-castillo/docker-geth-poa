FROM alpine:3.5

RUN \
    apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
    git clone --depth 1 -b v1.7.2 https://github.com/ethereum/go-ethereum && \
    (cd go-ethereum && make geth) && \
    cp go-ethereum/build/bin/geth /geth && \
    apk del go git make gcc musl-dev linux-headers && \
    rm -rf /go-ethereum && rm -rf /var/cache/apk/*
EXPOSE 8545
EXPOSE 30303

VOLUME /root/.ethereum

COPY entrypoint.sh prepare.sh genesis.json /
RUN chmod +x /entrypoint.sh prepare.sh

ENTRYPOINT ["/entrypoint.sh", "--rpc", "--rpcaddr", "0.0.0.0", "--syncmode=fast", "--maxpeers", "150", "init", "/genesis.json"]
