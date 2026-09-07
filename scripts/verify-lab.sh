#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
base_ref="${2:-}"

usage() {
  echo "Usage: $0 <recommendation|conflict> [base-ref]" >&2
  exit 2
}

[[ "$mode" == "recommendation" || "$mode" == "conflict" ]] || usage

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "FAIL: run this command inside the lab repository." >&2
  exit 1
}
cd "$repo_root"

if [[ -z "$base_ref" ]]; then
  if git rev-parse --verify --quiet refs/remotes/upstream/main >/dev/null; then
    base_ref="upstream/main"
  elif git rev-parse --verify --quiet refs/remotes/origin/main >/dev/null; then
    base_ref="origin/main"
  else
    echo "FAIL: neither upstream/main nor origin/main exists. Fetch the source remote first." >&2
    exit 1
  fi
fi

if ! git rev-parse --verify --quiet "$base_ref^{commit}" >/dev/null; then
  echo "FAIL: base ref '$base_ref' does not exist. Fetch it and try again." >&2
  exit 1
fi

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "FAIL: HEAD is detached; switch to your lab branch." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "FAIL: the working tree is not clean. Commit or discard the intended changes first." >&2
  git status --short
  exit 1
fi

ahead="$(git rev-list --count "$base_ref..HEAD")"
if (( ahead == 0 )); then
  echo "FAIL: '$branch' has no commits ahead of '$base_ref'." >&2
  exit 1
fi

mapfile -d '' changed_files < <(
  git diff --name-only -z "$base_ref...HEAD"
)

if [[ "$mode" == "recommendation" ]]; then
  [[ "$branch" == feature/* ]] || {
    echo "FAIL: recommendation branch must match feature/<short-name>; found '$branch'." >&2
    exit 1
  }

  recommendation_files=()
  unexpected_files=()
  index_changed=0

  for file in "${changed_files[@]}"; do
    case "$file" in
      docs/recommendations/README.md)
        index_changed=1
        ;;
      docs/recommendations/identity/*.md|docs/recommendations/azure/*.md)
        recommendation_files+=("$file")
        ;;
      *)
        unexpected_files+=("$file")
        ;;
    esac
  done

  (( index_changed == 1 )) || {
    echo "FAIL: docs/recommendations/README.md was not changed." >&2
    exit 1
  }
  (( ${#recommendation_files[@]} == 1 )) || {
    echo "FAIL: expected exactly one recommendation file; found ${#recommendation_files[@]}." >&2
    exit 1
  }
  (( ${#unexpected_files[@]} == 0 )) || {
    printf 'FAIL: unexpected changed file: %s\n' "${unexpected_files[@]}" >&2
    exit 1
  }

  recommendation_file="${recommendation_files[0]}"
  [[ -f "$recommendation_file" ]] || {
    echo "FAIL: recommendation file '$recommendation_file' was deleted." >&2
    exit 1
  }
  index_target="${recommendation_file#docs/recommendations/}"
  grep -qF "($index_target)" docs/recommendations/README.md || {
    echo "FAIL: the recommendation index does not link to '$index_target'." >&2
    exit 1
  }

  bash scripts/validate-recommendations.sh "$base_ref" HEAD
  echo "PASS: recommendation branch '$branch' has the expected committed files and format."
  exit 0
fi

[[ "$branch" == conflict/* ]] || {
  echo "FAIL: conflict branch must match conflict/<name>-retry-policy; found '$branch'." >&2
  exit 1
}

if (( ${#changed_files[@]} != 1 )) ||
   [[ "${changed_files[0]:-}" != "conflict-lab/retry-policy.md" ]]; then
  echo "FAIL: the conflict branch must change only conflict-lab/retry-policy.md." >&2
  printf 'Changed file: %s\n' "${changed_files[@]:-<none>}" >&2
  exit 1
fi

[[ -f conflict-lab/retry-policy.md ]] || {
  echo "FAIL: conflict-lab/retry-policy.md was deleted." >&2
  exit 1
}

if grep -qE '^(<<<<<<<|=======|>>>>>>>)' conflict-lab/retry-policy.md; then
  echo "FAIL: unresolved conflict markers remain in conflict-lab/retry-policy.md." >&2
  exit 1
fi

mapfile -t retry_lines < <(
  grep -E '^retry_count[[:space:]]*=[[:space:]]*[0-9]+[[:space:]]*$' conflict-lab/retry-policy.md || true
)
if (( ${#retry_lines[@]} != 1 )) || [[ "${retry_lines[0]:-}" == *"= 3" ]]; then
  echo "FAIL: retry_count must be one resolved numeric value different from the seed value 3." >&2
  exit 1
fi

if ! git rev-list --merges "$base_ref..HEAD" | grep -q .; then
  echo "FAIL: no merge commit was found after '$base_ref'; complete the local conflict merge first." >&2
  exit 1
fi

echo "PASS: conflict branch '$branch' contains one resolved retry-policy change and a merge commit."
