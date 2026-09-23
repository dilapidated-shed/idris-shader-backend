#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
INPUT=${1:-"$HERE/archive-targets.tsv"}
OUTPUT=${2:-"$HERE/archive-captures-$(date -u +%Y-%m-%d).tsv"}
ARCHIVE_TODAY=${ARCHIVE_TODAY:-archivetoday}
SLEEP_SECONDS=${ARCHIVE_SLEEP_SECONDS:-2}

usage() {
  cat <<'USAGE'
usage: archive-now.sh [archive-targets.tsv] [output.tsv]

Request a fresh archive.today-family snapshot for every live URL in the target
ledger. ARCHIVE_TODAY may name another compatible CLI or an absolute path.
ARCHIVE_SLEEP_SECONDS controls the delay between submissions (default: 2).
USAGE
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

command -v "$ARCHIVE_TODAY" >/dev/null 2>&1 || {
  printf 'archive-now: command not found: %s\n' "$ARCHIVE_TODAY" >&2
  exit 127
}

test -r "$INPUT" || {
  printf 'archive-now: cannot read target ledger: %s\n' "$INPUT" >&2
  exit 2
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

TAB=$(printf '\t')
printf 'title\tlive_url\tstatus\tsnapshot_url\tattempted_at\tnote\n' > "$OUTPUT"

tail -n +2 "$INPUT" |
while IFS="$TAB" read -r title live_url rest; do
  attempted_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  stdout="$TMP/stdout"
  stderr="$TMP/stderr"
  : > "$stdout"
  : > "$stderr"

  if "$ARCHIVE_TODAY" --renew --incomplete --quiet "$live_url" >"$stdout" 2>"$stderr"; then
    snapshot=$(tail -n 1 "$stdout" | tr -d '\r\n')
    case "$snapshot" in
      https://archive.*/*)
        status=requested
        ;;
      *)
        status=invalid-output
        ;;
    esac
  else
    snapshot=
    status=failed
  fi

  note=$(tr '\t\r\n' '   ' < "$stderr" | cut -c1-500)
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$title" "$live_url" "$status" "$snapshot" "$attempted_at" "$note" >> "$OUTPUT"

  sleep "$SLEEP_SECONDS"
done

printf '%s\n' "$OUTPUT"
