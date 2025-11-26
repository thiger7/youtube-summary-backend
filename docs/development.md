# 開発ガイド

## 必要な環境

- Ruby 3.3.6
- PostgreSQL 14+
- Python 3.9+

## セットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/YOUR_USERNAME/youtube-summary-backend.git
cd youtube-summary-backend
```

### 2. 依存関係のインストール

```bash
bundle install
pip install youtube-transcript-api
```

### 3. データベースのセットアップ

```bash
bin/rails db:create
bin/rails db:migrate
```

### 4. Gemini API キーの設定

```bash
bin/rails credentials:edit
```

以下の形式で追加：

```yaml
google:
  gemini_api_key: your_gemini_api_key
```

API キーは [Google AI Studio](https://aistudio.google.com/) で取得できます。

### 5. サーバーの起動

```bash
bin/dev
```

## アーキテクチャ

```
[React Native App]
    ↓ POST /videos (YouTube URL)
[Rails API]
    ↓ Solid Queue (非同期ジョブ)
[YoutubeSummaryJob]
    ↓ 1. YouTube Transcript API で文字起こし取得
    ↓ 2. Gemini API で要約生成
    ↓ 3. PostgreSQL に保存
[React Native App]
    ↓ GET /videos (ポーリング)
[要約結果を表示]
```

## プロジェクト構成

```
app/
├── controllers/
│   └── videos_controller.rb    # API エンドポイント
├── jobs/
│   └── youtube_summary_job.rb  # 非同期ジョブ
├── models/
│   └── summary.rb              # 要約データモデル
└── services/
    └── youtube_transcript_service.rb  # 文字起こし・要約サービス
lib/
└── get_transcript.py           # Python 文字起こしスクリプト
```

## API エンドポイント

### POST /videos

YouTube動画の要約ジョブを開始

```bash
curl -X POST http://localhost:3000/videos \
  -H "Content-Type: application/json" \
  -d '{"youtube_url": "https://www.youtube.com/watch?v=VIDEO_ID"}'
```

**レスポンス:**
```json
{
  "message": "Job started for YouTube URL: https://www.youtube.com/watch?v=VIDEO_ID"
}
```

### GET /videos

要約結果を取得（ポーリング用）

```bash
curl "http://localhost:3000/videos?youtube_url=https://www.youtube.com/watch?v=VIDEO_ID"
```

**レスポンス（処理完了時）:**
```json
{
  "summary": "要約テキスト...",
  "transcript": "文字起こしテキスト..."
}
```

**レスポンス（処理中）:**
```json
{
  "message": "Processing, please wait..."
}
```

## 開発コマンド

| コマンド | 説明 |
|---------|------|
| `bin/dev` | 開発サーバー起動 |
| `bin/rails test` | テスト実行 |
| `bin/rubocop` | Lint |
| `bin/brakeman` | セキュリティチェック |

## 環境変数

| 変数名 | 説明 | 必須 |
|--------|------|------|
| `RAILS_MASTER_KEY` | credentials 復号化キー | 本番のみ |
| `RAILS8_SANDBOX_DATABASE_PASSWORD` | 本番DBパスワード | 本番のみ |

## デプロイ

```bash
kamal setup   # 初回のみ
kamal deploy
```

## トラブルシューティング

### 文字起こしが取得できない

- `pip install youtube-transcript-api` を確認
- 動画に字幕が存在するか確認

### 要約が生成されない

- `bin/rails credentials:show` で API キーを確認

### ジョブが実行されない

- `bin/rails solid_queue:start` でワーカーを起動
