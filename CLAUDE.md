# Claude Code 作業指示書（CLAUDE.md）

Claude Codeは、このリポジトリにおける**「実装担当」**エージェントです。

---

## 1. 基本役割と連携ルール

| エージェント | 担当 | 連携方法 |
|---|---|---|
| **Claude Code (あなた)** | **実装** | Geminiのレビュー・設計を受け取り、コードを実装・修正する |
| **Codex** | テスト・修正 | あなたの実装完了後、スモークテスト実行と軽微なバグ修正を担当 |
| **Gemini (Antigravity CLI)** | レビュー・リサーチ | コードの事前/事後レビュー、技術調査、メディアプロンプト作成を担当 |

---

## 2. 実装作業の流れ（ハンドオフ手順）

1. **タスクの確認**:
   作業を開始する前に、[docs/handoff.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/handoff.md) の「現在のステータス」と「進行中タスク詳細」を確認してください。
   また、Geminiのレビュー報告書（`docs/reviews/YYYY-MM-DD-*.md`）が指定されている場合は、その指摘内容と修正案を精読してください。

2. **実装の原則遵守**:
   - [HANDOVER.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/HANDOVER.md) の基本方針（AIへの丸投げ防止、入力フォームの構造化、コピー方式の既定維持）を絶対に崩さないでください。
   - `index.html` などのシングルファイル構成を尊重し、不要なファイル分割や破壊的変更は避けてください。

3. **実装完了後のバトンタッチ**:
   実装・修正が完了したら、[docs/handoff.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/handoff.md) を更新してください。
   - 「現在の担当エージェント」を `Codex` に変更
   - 「作業ログ / 履歴」に実施した内容を1行追記
   - 「Codexへの指示（テスト依頼）」に、特に重点的にテストしてほしい観点や修正した関数名を明記

---

## 3. 注意点・制約事項

- **テストと微修正はCodexと分担**: 網羅的なスモークテスト（`scratchpad/smoke/test_otazune.js`）はCodexが担当します。構文エラーチェック（SyntaxError防止）を済ませた段階でCodexへ引き渡してください。
- **ワークツリーの確認**: Orca等の別ワークツリーで動いている場合、ローカル原本（`C:\Users\USER\Desktop\Work\01_アプリ\ai-otazune`）との変更同期に注意してください。詳細は [docs/agent-workflow.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/agent-workflow.md) を参照してください。
