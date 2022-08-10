FROM golang:1.17 as builder

ARG CADDY_VERSION="v2.5.1"
ENV CADDY_VERSION=$CADDY_VERSION
RUN echo building caddy $CADDY_VERSION for "$TARGETOS"

WORKDIR /workspace

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN GOOS=linux GOARCH=amd64 xcaddy build \
  --with github.com/abiosoft/caddy-yaml \
  --with github.com/mholt/caddy-l4 \
  --with github.com/caddy-dns/cloudflare

FROM alpine

COPY --from=builder /workspace/caddy /bin/caddy

# Run the binary.
ENTRYPOINT ["/bin/caddy"]