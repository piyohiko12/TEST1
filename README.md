# TEST1: Opus 4.8 → Fable 5 応答スタイル近似プロンプト

Opus 4.8 に与えるスタイルプロンプト(`PROMPT.md`)を、Fable 5 が同じプロンプトで生成する出力(目標)に近づけるプロジェクト。

## 構成

- `PROMPT.md` — スタイルプロンプト現行版(過去版は `prompts/`)
- `docs/fable5-analysis.md` — Fable 5 の出力特性調査
- `docs/findings.md` — ラウンドごとの実測ギャップ分析と改訂記録
- `eval/run.sh` — 4条件比較ランナー(claude CLI 必須)
- `eval/questions/` — 固定テスト質問(現在14問)
- `eval/results/roundN/` — 実測出力(ref / refstyle / base / style)
- `.claude/output-styles/fable5-japanese.md` — Claude Code の output style として組み込んだ版(下記)

## Claude Code で使う

確定版(v6)を Claude Code の output style として同梱している。有効化するとこのセッションの応答が Fable 5 風の簡潔なスタイルになる。

```
/output-style              # 一覧から「Fable 5 風」を選ぶ
/output-style fable5-japanese
```

`.claude/output-styles/fable5-japanese.md` の本文は `PROMPT.md` と同一内容。`PROMPT.md` を更新したらこちらも同期すること。トグル式なので、選ばなければ通常のスタイルのまま。

## 検証方法

```bash
eval/run.sh <round> [prompt-file] [arms...]
# 例: eval/run.sh 2 PROMPT.md        # 全4アーム
# 例: eval/run.sh 2 PROMPT.md style  # 処置アームのみ
```

- `refstyle`(Fable 5+プロンプト)が目標、`style`(Opus 4.8+プロンプト)が処置。
- 判定チェックリストは `docs/findings.md` 冒頭を参照。
