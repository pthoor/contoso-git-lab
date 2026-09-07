#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-}"
head_ref="${2:-HEAD}"

if [[ -z "$base_ref" ]]; then
  echo "Usage: $0 <base-ref> [head-ref]" >&2
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Run this command inside a Git repository." >&2
  exit 2
}
cd "$repo_root"

if ! git rev-parse --verify --quiet "$base_ref^{commit}" >/dev/null; then
  echo "Base ref '$base_ref' is not available. Fetch it and try again." >&2
  exit 2
fi
if ! git rev-parse --verify --quiet "$head_ref^{commit}" >/dev/null; then
  echo "Head ref '$head_ref' is not available." >&2
  exit 2
fi

fail=0
checked=0
mapfile -d '' files < <(
  git diff --name-only --diff-filter=AM -z "$base_ref...$head_ref" -- \
    'docs/recommendations/**/*.md'
)

for file in "${files[@]}"; do
  base="$(basename "$file")"
  if [[ "$base" == "_TEMPLATE.md" || "$base" == "README.md" ]]; then
    continue
  fi

  checked=$((checked + 1))
  echo "Checking $file"

  for heading in "## Risk" "## Recommendation" "## Example"; do
    if ! grep -qE "^${heading}[[:space:]]*$" "$file"; then
      echo "::error file=$file::Missing required section '$heading'"
      fail=1
    fi
  done

  if ! grep -qE '^\*\*Severity:\*\* (Low|Medium|High|Critical)[[:space:]]*$' "$file"; then
    echo "::error file=$file::Missing or invalid 'Severity' line (expected Low/Medium/High/Critical)"
    fail=1
  fi
done

if (( fail != 0 )); then
  echo "One or more recommendation files are invalid. See LAB.md and docs/recommendations/_TEMPLATE.md."
  exit 1
fi

if (( checked == 0 )); then
  echo "No recommendation content files changed; check passes."
else
  echo "All $checked changed recommendation file(s) look good."
fi
