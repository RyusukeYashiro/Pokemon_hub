# syntax=docker/dockerfile:1

# ===== Build Stage =====
FROM golang:1.21-alpine AS builder

# セキュリティ: 非rootユーザーでビルド
RUN adduser -D -s /bin/sh appuser

# 必要なパッケージをインストール
RUN apk add --no-cache \
    ca-certificates \
    git \
    tzdata

WORKDIR /app

# Goモジュールの依存関係を先にコピーしてキャッシュを活用
COPY go.mod go.sum ./

# Go modulesキャッシュを使用してダウンロード
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download && \
    go mod verify

# ソースコードをコピー
COPY . .

# ビルド時の最適化オプション
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Go buildキャッシュを使用してビルド
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    go build \
    -ldflags='-w -s -extldflags "-static"' \
    -a -installsuffix cgo \
    -o app ./main.go

# ===== Production Stage =====
FROM gcr.io/distroless/static-debian12:nonroot

# タイムゾーンデータをコピー
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# アプリケーションバイナリをコピー
COPY --from=builder /app/app /app

# 設定ファイルをコピー（存在する場合）
COPY --from=builder /app/config /config

# ポート公開
EXPOSE 8080

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD ["/app", "health-check"] || exit 1

# 非rootユーザーで実行（distrolessのnonrootユーザー使用）
USER nonroot:nonroot

# エントリーポイント
ENTRYPOINT ["/app"]