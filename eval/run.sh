#!/usr/bin/env bash
# 4条件比較ランナー
#   ref      : Fable 5   + 中立システムプロンプト(素のFable 5。スタイルがプロンプト由来であることの対照用)
#   refstyle : Fable 5   + 中立 + スタイルプロンプト(★主参照。ユーザーが体験する目標出力)
#   base     : Opus 4.8  + 中立システムプロンプト(素の乖離測定用)
#   style    : Opus 4.8  + 中立 + スタイルプロンプト(処置。これをrefstyleに近づける)
#
# 使い方: eval/run.sh <round> [prompt-file] [arms...]
#   例:    eval/run.sh 1                 # PROMPT.md で全アーム実行
#   例:    eval/run.sh 2 PROMPT.md style # styleアームのみ再実行
set -u

ROUND="${1:?usage: run.sh <round> [prompt-file] [arms...]}"
PROMPT_FILE="${2:-PROMPT.md}"
shift 2 2>/dev/null || shift $#
ARMS=("${@:-ref refstyle base style}")
[ $# -eq 0 ] && ARMS=(ref refstyle base style)

REPO="$(cd "$(dirname "$0")/.." && pwd)"
QDIR="$REPO/eval/questions"
OUT="$REPO/eval/results/round${ROUND}"
NEUTRAL="あなたは親切で有能なAIアシスタントのClaudeです。日本語で応答してください。"
STYLE_PROMPT="$NEUTRAL

$(cat "$REPO/$PROMPT_FILE")"
WORKDIR="$(mktemp -d)"
MAXPAR=6

run_one() {
  local arm="$1" model="$2" sys="$3" qfile="$4"
  local qname out
  qname="$(basename "$qfile" .txt)"
  out="$OUT/$arm/$qname.md"
  [ -s "$out" ] && return 0   # 既存の非空結果はスキップ(再実行に安全)
  mkdir -p "$OUT/$arm"
  ( cd "$WORKDIR" && timeout 240 claude -p --model "$model" \
      --system-prompt "$sys" --tools "" \
      < "$qfile" > "$out.tmp" 2>"$out.err" )
  if [ -s "$out.tmp" ] && ! grep -q '^API Error' "$out.tmp"; then
    mv "$out.tmp" "$out"; rm -f "$out.err"
  else
    echo "FAIL: $arm/$qname (see $out.err / $out.tmp)" >&2
  fi
}

pids=0
for arm in "${ARMS[@]}"; do
  case "$arm" in
    ref)      model="claude-fable-5";  sys="$NEUTRAL" ;;
    refstyle) model="claude-fable-5";  sys="$STYLE_PROMPT" ;;
    base)     model="claude-opus-4-8"; sys="$NEUTRAL" ;;
    style)    model="claude-opus-4-8"; sys="$STYLE_PROMPT" ;;
    *) echo "unknown arm: $arm" >&2; exit 1 ;;
  esac
  for qfile in "$QDIR"/q*.txt; do
    run_one "$arm" "$model" "$sys" "$qfile" &
    pids=$((pids+1))
    [ $((pids % MAXPAR)) -eq 0 ] && wait
  done
done
wait
echo "done: $OUT"
find "$OUT" -name '*.md' | sort | while read -r f; do
  printf '%s\t%s字\n' "${f#$OUT/}" "$(wc -m < "$f")"
done
