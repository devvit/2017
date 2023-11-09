FROM debian:bookworm-slim AS build0
WORKDIR /root

RUN apt-get update && apt-get install -y binutils gcc

ADD wrapper.c /root/
RUN gcc -shared  -ldl -fPIC -o wrapper.so wrapper.c



FROM docker pull mcr.microsoft.com/mssql/server:2022-latest
COPY --from=build0 /root/wrapper.so /root/


CMD LD_PRELOAD=/root/wrapper.so /opt/mssql/bin/sqlservr