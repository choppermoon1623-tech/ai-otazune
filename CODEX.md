# Codex 作業指示書（CODEX.md）

Codexは、このリポジトリにおける**「テスト・修正担当」**エージェントです。

---

## 1. 基本役割と連携ルール

| エージェント | 担当 | 連携方法 |
|---|---|---|
| **Codex (あなた)** | **テスト・修正** | Claude Codeの実装を受け取り、テスト実行・検証・不具合修正を担当 |
| **Claude Code** | 実装 | Geminiのレビューを受けて主要な機能や修正を実装 |
| **Gemini (Antigravity CLI)** | レビュー・リサーチ | コードの事前/事後レビュー、技術調査、メディアプロンプト作成を担当 |

---

## 2. テスト・検証作業の流れ

1. **タスクの確認**:
   作業を開始する前に、[docs/handoff.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/handoff.md) の「現在のステータス」と「Codexへの指示（テスト依頼）」を確認してください。
   Claude Codeがどのファイルをどのように修正したかを把握します。

2. **スモークテストの実行**:
   リポジトリに用意されている統合スモークテストを実行します。
   ```bash
   node scratchpad/smoke/test_otazune.js
   ```
   ※もし `jsdom` が見つからない場合は、`npm install jsdom` を実行してください。

3. **不具合の検出と修正**:
   - テストが失敗した場合、またはエッジケースのバグを見つけた場合は、原因を特定してコード（`index.html` 等）を直接修正してください。
   - 大幅な仕様変更が必要な場合は、[docs/handoff.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/handoff.md) にその旨を記録してClaude Codeへ差し戻してください。

4. **テスト完了後の記録**:
   すべてのテスト項目が合格（All passed）したら、[docs/handoff.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/handoff.md) を更新してください。
   - 「作業ログ / 履歴」にテスト結果（通過項目数、修正点など）を追記
   - 「現在の担当エージェント」を `Gemini`（最終レビュー・完了判定）または `完了` に更新

---

## 3. 注意点・制約事項

- **Firestoreルールのテスト視点**:
  [HANDOVER.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/HANDOVER.md) にある通り、「Firestoreルールはフィルタではない」ため、クエリとルールの整合性に注意して検証してください。
- **ワークツリーの確認**:
  Orca等の別ワークツリーで動いている場合、ローカル原本（`C:\Users\USER\Desktop\Work\01_アプリ\ai-otazune`）との変更同期に注意してください。詳細は [docs/agent-workflow.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/agent-workflow.md) を参照してください。
