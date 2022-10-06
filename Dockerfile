FROM debian:bullseye as builder

RUN apt update && apt install -y xz-utils wget

RUN mkdir /download
RUN cd /download && wget https://ziglang.org/download/0.9.1/zig-linux-x86_64-0.9.1.tar.xz

WORKDIR /download
RUN tar -xf zig-linux-x86_64-0.9.1.tar.xz

COPY . /app
WORKDIR /app
RUN /download/zig-linux-x86_64-0.9.1/zig build

FROM httpd:bullseye

ARG NAME
COPY --from=builder /app/zig-out/bin/zig.cgi /usr/local/apache2/cgi-bin/zig.cgi
RUN chmod 755 /usr/local/apache2/cgi-bin/zig.cgi

CMD httpd-foreground -c "LoadModule cgid_module modules/mod_cgid.so"
