# syntax=docker/dockerfile:1

# ===== Base Stage =====
FROM node:20-alpine AS base

# セキュリティとパフォーマンスの向上
RUN apk add --no-cache \
    libc6-compat \
    dumb-init

WORKDIR /app

# Next.jsテレメトリーを無効化
ENV NEXT_TELEMETRY_DISABLED=1

# ===== Dependencies Stage =====
FROM base AS deps

# package.jsonとlockファイルをコピー
COPY package.json package-lock.json* ./

# npmキャッシュを使用して依存関係をインストール
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production --no-audit

# ===== Builder Stage =====
FROM base AS builder

# 依存関係をコピー
COPY --from=deps /app/node_modules ./node_modules

# ソースコードをコピー
COPY . .

# ビルドキャッシュを使用
RUN --mount=type=cache,target=/root/.npm \
    --mount=type=cache,target=/app/.next/cache \
    npm run build

# ===== Production Runner Stage =====
FROM base AS runner

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# セキュリティ: 非rootユーザーを作成
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# 必要なファイルのみをコピー
COPY --from=builder /app/public ./public

# standalone出力を活用
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# 非rootユーザーに切り替え
USER nextjs

# ポート公開
EXPOSE 3000

# 環境変数設定
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "const http = require('http'); \
    const options = { hostname: 'localhost', port: 3000, path: '/api/health', method: 'GET' }; \
    const req = http.request(options, (res) => { \
        process.exit(res.statusCode === 200 ? 0 : 1); \
    }); \
    req.on('error', () => process.exit(1)); \
    req.end();"

# dumb-initを使用してプロセス管理を改善
ENTRYPOINT ["dumb-init", "--"]

# アプリケーション起動
CMD ["node", "server.js"]