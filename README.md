# vnm

## Build

```shell
docker build -t vnm:latest .
```

## Run

```shell
docker run -p 8080:8080 --rm --name vnm vnm:latest
```

This container provides [this server](localhost:8080).
For now, there is one user with no username and no password (leave everything blank).
The two proposed connections won't work as they are not linked to actual runners.
