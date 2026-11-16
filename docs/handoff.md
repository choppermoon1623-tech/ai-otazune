# エージェント連携引き継ぎボード（handoff.md）

3エージェント（Claude Code / Codex / Gemini）が非同期で作業を引き継ぐための共通管理ファイルです。
作業を開始したエージェントは「現在の状態」を更新し、完了したら次の担当へバトンを渡してください。

---

## 現在のステータス

- **最終更新日時**: 2026-10-13 22:02
- **現在の担当エージェント**: `完了`（動画6本への反映・機械検証完了。聴感による最終確認は未実施）
- **現在のタスク**: 《魔法使いの弟子》通常版・入力版6本の音声修正を反映済み（index.htmlの保留タスクは別件）
- **参照資料**: [docs/reviews/2026-10-13-sorcerers-apprentice-metazun-review.md](file:///C:/Users/USER/Desktop/Work/01_アプリ/ai-otazune/docs/reviews/2026-10-13-sorcerers-apprentice-metazun-review.md)

---

## 引き継ぎサイクル（標準フロー）

```mermaid
flowchart LR
    A[Gemini<br/>レビュー・リサーチ] -->|レビュー作成| B[Claude Code<br/>実装]
    B -->|コード修正完了| C[Codex<br/>テスト・検証]
    C -->|全テスト合格| D[Gemini<br/>最終確認・完了]
    C -->|不具合検出| B
```

---

## 進行中タスク詳細

### タスク 1: 《魔法使いの弟子》めたずん動画の音声・読み間違い修正

- **対象コード**:
  - `C:\Users\USER\Desktop\Work\02_スライド\sorcerers-apprentice-metazun\_work\build.py`
  - `C:\Users\USER\Desktop\Work\02_スライド\sorcerers-apprentice-metazun\_work\slides-input\video_revision.py`
- **実施された修正内容**:
  1. **読み替え辞書 `PRONUNCIATION_MAP` & `clean_for_tts()` の導入**:
     - 「二、三文」→「に・さんぶん」（誤読「にさんもん」防止）
     - 「二文程度」→「にぶん程度」
     - 「音色」→「ねいろ」（誤読「おんしょく」防止）
     - 「初演」→「しょえん」（誤読「はつえん」防止）
     - 「木管楽器」→「もっかんがっき」（促音抜け防止）
     - 「オケで聴く」→「オーケストラで聴く」（風呂桶アクセント防止）
     - 「三つの行」→「みっつのぎょう」
     - 「台詞」→「せりふ」
     - 「魔法使いの弟子」→「魔法使いのでし」
     - 「組、番、名前」→「くみ、ばん、名前」（「なまえ」が「ナマ／エ」に分かれるため、名前は漢字を維持）
     - 「ポール・デュカス」→「ポールデュカス」
     - 「一言」→「ひとこと」（実クエリで「イチゲン」となる箇所を検出し追加）
  2. **ずんだもんのイントネーション微調整**:
     - `speaker == 3`（ずんだもん）の `intonationScale` を `1.00` に設定（文末疑問形の極端なピッチ跳ね上がりを抑制）。
     - ずんだもんのみ `/synthesis` の `enable_interrogative_upspeak=False`。インストール済みVOICEVOX 0.25.2のOpenAPIで対応を確認。
  3. **字幕・台本保護**:
     - 台本テキストや字幕（.srt）の美しい漢字表記を維持したまま、VOICEVOXクエリ送信時のみ読み仮名へ変換する構造を実現。

- **Codexへの指示（2026-10-13 実施済み）**:
  VOICEVOX（ポート50021）が起動している状態で、以下の再生成コマンドを実行し、音声合成と動画レンダリングを検証してください。
  ```bash
  # 1. 通常版の音声再生成
  cd C:\Users\USER\Desktop\Work\02_スライド\sorcerers-apprentice-metazun\_work
  python build.py audio

  # 2. 入力版の音声再生成
  cd C:\Users\USER\Desktop\Work\02_スライド\sorcerers-apprentice-metazun\_work\slides-input
  python video_revision.py audio

  # 3. 動画レンダリング（必要時）
  python build.py render
  python video_revision.py render
  ```

- **完了結果（Codex／2026-10-13 22:02）**:
  - ユーザーの「最終的な動画に修正を入れて」に基づき、通常版3本・入力版3本のMP4を元の名前で再出力。
  - キャッシュキーへ話者・読み上げ文・話速・抑揚・疑問文設定を含め、設定変更で旧音声が残る問題を修正。入力版は同じキーの通常版音声を共有。
  - 入力版生成時の字幕・台本バックアップを毎回更新し、通常版の新しい時刻が古いファイルへ戻る不具合を修正。
  - 字幕本文は旧版6本と一致。字幕時刻・章時刻は新しい音声に同期。台本と授業案の実尺も更新。
  - 通常版の実尺：410.877秒／42.403秒／80.709秒。入力版：435.397秒／44.208秒／92.245秒。
  - 6本すべて1280×720・24fps・H.264／AAC。全映像・音声デコード、音声クリッピングなし、字幕同期、章時刻を確認。MP4内の音声と新ナレーションの相関は全6本0.9999以上。
  - 6本のプレビュー生成時に全発話の字幕が2行以内であることを確認。通常版の鑑賞前、入力版の鑑賞前・鑑賞後のコンタクトシートを目視確認。
  - 読み確認はVOICEVOXの生成クエリ（kana）による機械検証。人による聴感評価は未実施。
  - 検証記録：`C:\Users\USER\Desktop\Work\02_スライド\sorcerers-apprentice-metazun\_work\review-audio-check.json`、`review-video-verification.json`。
  - 修正前の動画・字幕・台本・コード・授業案は案件内 `_work/before-review-fix-20261013/` に保存。

---

### タスク 2: index.html レビュー指摘の修正（保留/並行）

- **対象ファイル**: `index.html`
- **レビューレポート**: `docs/reviews/2026-10-13-index-html-review.md`

---

## 作業ログ / 履歴

| 日時 | エージェント | 作業内容 | 次の担当 |
|---|---|---|---|
| 2026-10-13 14:21 | Gemini | `docs/reviews/2026-10-13-index-html-review.md` 作成 | Claude Code |
| 2026-10-13 14:35 | Gemini | 3エージェント連携引き継ぎボード（本ファイル）開設 | Claude Code |
| 2026-10-13 21:45 | Gemini | 《魔法使いの弟子》めたずん動画レビュー作成（`docs/reviews/2026-10-13-sorcerers-apprentice-metazun-review.md`） | Claude Code |
| 2026-10-13 21:50 | Gemini | ユーザー明示指示に基づき、読み替え辞書 `clean_for_tts()` とイントネーション調整を `build.py`, `video_revision.py` へ実装反映 | Codex |
| 2026-10-13 22:02 | Codex | 音声キャッシュ・入力版字幕復元の不具合を修正。通常版・入力版6本を再生成し、読みクエリ・字幕同期・全区間デコード・新音声のMP4反映を検証 | 完了（聴感による最終確認は未実施） |
