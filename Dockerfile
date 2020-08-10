FROM debian:buster-slim AS build
RUN apt-get update && apt-get -y --no-install-recommends install \
      gcc make git ca-certificates \
      libc-dev libncurses-dev \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /build/uemacs
RUN git init \
 && git remote add origin https://github.com/torvalds/uemacs.git \
 && git fetch origin 1cdcf9df88144049750116e36fe20c8c39fa2517 --depth 1 \
 && git reset --hard FETCH_HEAD
RUN sed -i 's@/usr/@/usr/local/@' Makefile
RUN make
RUN make install

FROM debian:buster-slim
RUN apt-get update && apt-get -y --no-install-recommends install \
      libncurses6 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/ /usr/local/
CMD ["em"]
