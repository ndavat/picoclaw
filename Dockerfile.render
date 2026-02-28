# Multi-stage build for a minimal HTTP wrapper that uses OpenRouter

FROM golang:1.22-alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/picoclaw-render ./cmd/render-openrouter

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw-render /usr/local/bin/picoclaw-render
EXPOSE 8080
# Ensure the default agent model/provider inside this image is OpenRouter (avoids fallback to glm-4.7)
ENV PORT=8080
ENV TZ=America/Chicago
ENV PICOCLAW_AGENTS_DEFAULTS_MODEL=llama-3.3-70b
ENV PICOCLAW_AGENTS_DEFAULTS_PROVIDER=groq
ENV PICOCLAW_PROVIDERS_GROQ_API_KEY=
ENV GROQ_API_KEY=
ENTRYPOINT ["/usr/local/bin/picoclaw-render"]
