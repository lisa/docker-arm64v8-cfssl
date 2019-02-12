FROM arm64v8/ubuntu:19.04

ARG CFSSL_REV=b94e044

ENV \
  GOPATH=/root/go

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install golang-go git && \
  mkdir /root/go
  
RUN \
  git clone https://github.com/cloudflare/cfssl.git  /root/go/src/github.com/cloudflare/cfssl && \
  cd /root/go/src/github.com/cloudflare/cfssl && \
  git checkout $CFSSL_TAG && \
  make GOPATH=/root/go -j$(nproc)

RUN mkdir /input /output

FROM scratch

COPY \
  --from=0 \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssl           \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssl-bundle    \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssl-certinfo  \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssl-newkey    \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssl-scan      \
    /root/go/src/github.com/cloudflare/cfssl/bin/cfssljson       \
    /root/go/src/github.com/cloudflare/cfssl/bin/mkbundle        \
    /root/go/src/github.com/cloudflare/cfssl/bin/multirootca     \
  /

COPY --from=0 /input/ /output/ /

CMD ["/cfssl"]
