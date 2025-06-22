# Pokemon Hub

GitHubのコミット量に応じてポケモン図鑑が埋まっていくゲーミフィケーションアプリケーション

## 📁 プロジェクト構成

```
Pokemon_hub/
├── README.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── Makefile
│
├── backend/                          # Go バックエンド
│   ├── go.mod
│   ├── go.sum
│   ├── main.go                       # エントリーポイント
│   ├── config/                       # 設定
│   │   ├── config.go
│   │   └── database.go
│   ├── handlers/                     # HTTPハンドラー
│   │   ├── auth.go
│   │   ├── user.go
│   │   ├── pokemon.go
│   │   ├── commit.go
│   │   └── webhook.go
│   ├── models/                       # データモデル
│   │   ├── user.go
│   │   ├── pokemon.go
│   │   ├── commit.go
│   │   └── github.go
│   ├── services/                     # ビジネスロジック
│   │   ├── auth_service.go
│   │   ├── pokemon_service.go
│   │   ├── github_service.go
│   │   └── commit_service.go
│   ├── middleware/                   # ミドルウェア
│   │   ├── auth.go
│   │   ├── cors.go
│   │   └── rate_limit.go
│   ├── utils/                        # ユーティリティ
│   │   ├── jwt.go
│   │   ├── response.go
│   │   └── validator.go
│   ├── infra/                        # インフラ層
│   │   ├── database/
│   │   │   ├── connection.go
│   │   │   ├── migrations/
│   │   │   └── seeds/
│   │   ├── redis/
│   │   │   └── connection.go
│   │   └── external/
│   │       ├── github_client.go
│   │       └── pokemon_api_client.go
│   ├── docs/                         # API仕様書
│   │   ├── swagger.json
│   │   └── swagger.yaml
│   └── tests/                        # テスト
│       ├── handlers/
│       ├── services/
│       └── testdata/
│
├── frontend/                         # Next.js フロントエンド
│   ├── package.json
│   ├── next.config.ts
│   ├── tailwind.config.js
│   ├── tsconfig.json
│   ├── src/
│   │   ├── app/                      # App Router
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   ├── dashboard/
│   │   │   │   └── page.tsx
│   │   │   ├── pokedex/
│   │   │   │   └── page.tsx
│   │   │   └── profile/
│   │   │       └── page.tsx
│   │   ├── components/               # 共通コンポーネント
│   │   │   ├── ui/                   # shadcn/ui
│   │   │   ├── layout/
│   │   │   │   ├── Header.tsx
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   └── Footer.tsx
│   │   │   ├── pokemon/
│   │   │   │   ├── PokemonCard.tsx
│   │   │   │   ├── PokemonDetail.tsx
│   │   │   │   └── PokedexGrid.tsx
│   │   │   └── dashboard/
│   │   │       ├── StatsCard.tsx
│   │   │       └── RecentActivity.tsx
│   │   ├── lib/                      # ユーティリティ
│   │   │   ├── api.ts
│   │   │   ├── auth.ts
│   │   │   ├── utils.ts
│   │   │   └── validations.ts
│   │   ├── hooks/                    # カスタムフック
│   │   │   ├── useAuth.ts
│   │   │   ├── usePokemon.ts
│   │   │   └── useCommits.ts
│   │   ├── store/                    # Zustand ストア
│   │   │   ├── authStore.ts
│   │   │   └── pokemonStore.ts
│   │   └── types/                    # TypeScript型定義
│   │       ├── api.ts
│   │       ├── pokemon.ts
│   │       └── user.ts
│   └── public/
│       ├── images/
│       └── icons/
│
├── deploy/                           # デプロイ設定
│   ├── docker/
│   │   ├── backend.Dockerfile
│   │   └── frontend.Dockerfile
│   └── scripts/
│       ├── deploy.sh
│       └── setup.sh
│
├── .github/                          # GitHub Actions
│   └── workflows/
│       ├── backend-ci.yml
│       ├── frontend-ci.yml
│       └── deploy.yml
│
└── docs/                             # プロジェクト文書
    ├── api.md
    ├── setup.md
    └── deployment.md
```

## 🏗️ 各ディレクトリの役割

### Backend (Go)
- **handlers/**: HTTPリクエストの処理、ルーティング
- **services/**: ビジネスロジック（GitHub API連携、ポケモン獲得処理）
- **models/**: GORM構造体、データモデル定義
- **middleware/**: 認証、CORS、レート制限などの横断的関心事
- **utils/**: JWT処理、バリデーション、レスポンス形成
- **infra/**: 外部システム（DB、Redis、外部API）との接続
- **config/**: アプリケーション設定、環境変数管理

### Frontend (Next.js)
- **app/**: ページコンポーネント（App Router）
- **components/**: 再利用可能なUIコンポーネント
- **lib/**: API呼び出し、認証処理、ユーティリティ関数
- **hooks/**: カスタムReactフック
- **store/**: Zustand状態管理
- **types/**: TypeScript型定義

### Development & Deployment
- **deploy/**: Docker設定、デプロイスクリプト
- **.github/**: CI/CDワークフロー
- **docs/**: API仕様、セットアップガイド

詳細な開発手順については [docs/setup.md](./docs/setup.md) を参照してください。