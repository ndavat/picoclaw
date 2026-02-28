# Multi-stage build for a minimal HTTP wrapper that uses OpenRouter

FROM golang:alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
COPY . .
# Prepare embedded files for the onboard command
RUN cp -r workspace cmd/picoclaw/internal/onboard/
# Build both binaries
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/picoclaw ./cmd/picoclaw
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/picoclaw-render ./cmd/render-openrouter

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw /usr/local/bin/picoclaw
COPY --from=builder /app/picoclaw-render /usr/local/bin/picoclaw-render
EXPOSE 8080
ENV PORT=8080
ENV TZ=America/Chicago
ENV PICOCLAW_AGENTS_DEFAULTS_MODEL=llama-3.3-70b
ENV PICOCLAW_AGENTS_DEFAULTS_PROVIDER=groq
ENV PICOCLAW_PROVIDERS_GROQ_API_KEY=
ENV GROQ_API_KEY=
ENTRYPOINT ["/usr/local/bin/picoclaw", "gateway"]
