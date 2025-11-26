# YouTube Summary Backend

忙しいビジネスパーソンのために、YouTube長尺動画を手軽に要約するAPIサーバー

## スクリーンショット

| システムフロー |
|:---:|
| ![システムフロー](docs/00_youtube-summary-flow.png) |

| ホーム画面 | 要約結果 |
|:---:|:---:|
| <img src="docs/01_home.png" width="250"> | <img src="docs/02_1_summary.png" width="250"> |

## 機能

- YouTube動画の文字起こし取得（YouTube Transcript API）
- Gemini API 1.5 Flash による自動要約生成
- 非同期ジョブ処理（Solid Queue）

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| バックエンド | Ruby 3.3.6 / Rails 8 |
| データベース | PostgreSQL |
| ジョブキュー | Solid Queue |
| AI | Google Gemini API 1.5 Flash |
| 文字起こし | youtube-transcript-api (Python) |
| デプロイ | Kamal |

## ローカル開発

```bash
bundle install
pip install youtube-transcript-api
bin/rails db:setup
bin/dev
```

詳細は [開発ガイド](docs/development.md) を参照
