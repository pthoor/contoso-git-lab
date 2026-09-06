# Contributing to the Contoso Security Knowledge Hub

This is a training repository, but we treat it like a real one — that's the
point. A few conventions keep it usable and safe.

## 1. Synthetic content only — no exceptions

Never commit:

- Real tenant IDs, subscription IDs, customer names, or internal URLs
- Real credentials, tokens, connection strings, or API keys — not even
  temporarily, and not even in a commit you plan to "fix later." Deleting a
  secret in a later commit does **not** remove it from history.
- Any content that could reasonably be mistaken for a real Contoso customer
  environment

Use obviously fake placeholders: `contoso.onmicrosoft.com`,
`00000000-0000-0000-0000-000000000000`, `demo-tenant`, etc.

If you're unsure whether something is safe to commit, ask before you push.

## 2. Branch naming

```
type/short-kebab-description
```

| Type | Use for |
|---|---|
| `feature/` | A new recommendation or new content |
| `fix/` | Correcting an existing recommendation |
| `docs/` | Documentation-only changes |
| `chore/` | Repository maintenance (templates, CI, links) |
| `conflict/` | The guided merge-conflict exercise |

Examples: `feature/defender-for-key-vault`, `fix/rbac-permission-typo`.

One branch per change. Lowercase, no spaces.

## 3. Commit messages

Write the imperative, present-tense summary of what the commit does:

```
Add Defender for Key Vault recommendation
Fix RBAC permission scope in storage baseline
Document required approval workflow for privileged roles
```

Avoid: `fix`, `update stuff`, `wip`, `final`, `final_v2`.

## 4. One recommendation per pull request

Keep pull requests small and reviewable — one recommendation, one fix, or one
documentation change per PR. This makes the diff easy to read and easy to
review honestly, which is the entire point of the exercise.

## 5. Recommendation file format

Every file in `docs/recommendations/` starts from
[`_TEMPLATE.md`](docs/recommendations/_TEMPLATE.md) and must include:

- A clear title
- Severity (`Low` / `Medium` / `High` / `Critical`)
- The risk being addressed
- The recommended action
- A synthetic example (config snippet, CLI command, or policy excerpt)

## 6. Review etiquette

- Read the diff, not just the description.
- Leave at least one comment or question — silence isn't review.
- Be specific: point at a line, suggest a change, or ask why.
- It is completely fine to request changes. That's what the process is for.

An approval counts toward a protected branch only when GitHub recognizes the
reviewer as having the required repository permission. In fork-based classes,
a participant's review is still useful practice but normally does not satisfy
the required approval; the facilitator or another designated source-repository
reviewer must submit the approval and perform the merge. In direct-access
classes, a different participant with Write access may approve, and the
facilitator decides whether participants or maintainers click merge.

## 7. Verify before opening or updating a pull request

From a clean branch, compare against the source repository's current `main`:

```bash
git fetch upstream                         # fork workflow
bash scripts/verify-lab.sh recommendation # uses upstream/main when present
```

For direct access, use `git fetch origin`; the verifier then uses
`origin/main`. During the conflict exercise, run:

```bash
bash scripts/verify-lab.sh conflict
```

A successful verification ends with `PASS:`. A `FAIL:` line identifies the
branch, file, formatting, commit, or unresolved-conflict condition to fix.
