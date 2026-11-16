# Gemini担当の起動手順（Antigravity CLI）

設定日：2026-10-13。公式Antigravity CLI 1.3.3を導入。

## 起動とログイン

PowerShellで次を実行する。フルパスなので、PATH反映前のターミナルでも起動できる。

```powershell
Set-Location -LiteralPath 'C:\Users\USER\Desktop\Work\01_アプリ\ai-otazune'
& "$env:LOCALAPPDATA\agy\bin\agy.exe"
```

- 個人Googleアカウントのログインを選び、Google AI Pro契約中のアカウントで本人が認証する。
- ブラウザが自動で開く場合がある。既存の有効なセッションがあれば、CLI自身が標準の保存済み認証を利用する。
- APIキー、Business／Google Cloud経路、追加クレジットの購入は選ばない。
- ログイン後、会話を送る前に `/config` を開き、「Use AI Credits／Use G1 Credits」が `off` であることを確認する。
- `~/.gemini/antigravity-cli/settings.json` に `"useG1Credits": false` を設定済み。`modelProvider` は設定していない。
- OrcaのAgentsには登録せず、独立した対話型ターミナルで使う。

## レビューを依頼する例

```text
AGENTS.mdとGEMINI.mdを読み、このリポジトリのレビュー担当として作業してください。
index.htmlをレビューし、問題箇所・根拠・影響・修正案を日本語でまとめ、
docs/reviews/に本日の日付付きMarkdownで保存してください。
実装コードは編集せず、APIキーや追加クレジットは使わないでください。
```

レビューは `docs/reviews/`、URL付きの調査結果は `docs/research/`、メディア用プロンプトは `media-prompts/` に保存する。
人間がGeminiアプリ／Flowで手動生成した素材を `assets/generated/` に置く。

Orca側が別ワークツリーに変更を持つ場合、その未コミット変更はこの原本には自動反映されない。レビュー対象のパスを明示する。

## 確認の範囲

- バージョン表示・ヘルプ表示、設定ファイルの構文を確認済み。
- Googleログインとモデルへのレビュー依頼は本人が行う。認証後の動作は未検証。
- 旧Gemini CLIと `.gemini/settings.json` は残している。通常の起動には `gemini` ではなく `agy` を使う。

## 公式資料

- [個人向けGemini CLIの提供終了と移行告知](https://github.com/google-gemini/gemini-cli/discussions/27274)
- [インストールと認証](https://antigravity.google/docs/cli/install/)
- [AIクレジットの設定](https://antigravity.google/docs/cli/credits/)
- [GEMINI.md・AGENTS.mdの継続利用](https://antigravity.google/docs/cli/gcli-migration/)
- [個人契約での外部アプリ組み込みに関するFAQ](https://antigravity.google/docs/faq)
