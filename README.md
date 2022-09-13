## Using Zig as a CGI script for Apache2

It could prove to be a nice stateless way to run some zig programs.

Just follow the instructions below and you should be up and running in no time.

## Build

```
docker build . -t zig-cgi
```

## Run

```
docker run -p 8080:80 zig-cgi
```

Visit `localhost:8080/cgi-bin/zig.cgi` and see the hello world message!