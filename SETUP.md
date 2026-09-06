# Repository setup checklist (for facilitators)

Run these steps after this content is transferred into a real GitHub
repository (personal account first; org later — see chat notes). Publishing
the participant repository is a launch dependency: the facilitator must
create it, push this content, and verify its URL before learners start.
This checklist cannot publish it automatically.

## 1. Repository basics

- [ ] Repository name: `contoso-git-lab` (or similar)
- [ ] Visibility: **Public**
- [ ] Description: "Training repository for Contoso's Git & GitHub
      Fundamentals lab. Synthetic content only — not real Contoso data."
- [ ] Add topics: `training`, `git`, `github-skills`, `contoso`
- [ ] Default branch: `main`
- [ ] Give participants the final HTTPS URL as `<source-repository-url>`;
      the lab intentionally does not depend on an unpublished example URL

## 2. Branch protection / ruleset on `main`

Settings → Rules → Rulesets (or classic branch protection):

- [ ] Require a pull request before merging
- [ ] Require at least 1 approval from a reviewer who has permission to
      approve and merge
- [ ] Require status checks to pass — select the
      `validate-recommendations` check from
      `.github/workflows/validate-recommendations.yml`
- [ ] Block force pushes
- [ ] (Optional) Require conversation resolution before merging

For fork mode, participants without write access can submit reviews or
comments, but their approval does not satisfy a protected branch's required
approval rule. A facilitator or designated reviewer with Write or Maintain
access must approve and merge each PR. In direct-clone mode, a different
participant with Write access may provide the qualifying approval. Authors
cannot approve their own PR.

Note: for the guided merge-conflict exercise, do **not** enable "require
branches to be up to date before merging" as a hard block until you've
decided whether pairs resolve conflicts locally (as written in `LAB.md`) or
via GitHub's web conflict editor — both work, but the instructions currently
assume local resolution.

The workflow runs on every pull request. Recommendation PRs validate changed
recommendation files; unrelated and conflict-lab PRs print
`No recommendation content files changed; check passes.` and finish quickly.
Create a temporary non-recommendation PR during the dry run and confirm the
required `validate-recommendations` check appears and passes.

## 3. Security settings

Settings → Code security:

- [ ] Enable secret scanning
- [ ] Enable push protection for secrets
- [ ] Enable Dependabot alerts (harmless default, repo has no real
      dependencies but costs nothing to enable)

## 4. CODEOWNERS

`.github/CODEOWNERS` currently references synthetic team names
(`@contoso/cloud-security` etc.) copied from the slide deck for narrative
consistency. Before relying on required code-owner review:

- [ ] Either replace these with real GitHub usernames/teams, **or**
- [ ] Remove the CODEOWNERS requirement from the ruleset for this lab (a
      single facilitator account can't satisfy a team-based CODEOWNERS rule
      alone during a live lab)

## 5. Collaborator access (if using Option B: direct clone, no forks)

- [ ] Add each participant as a collaborator with **Write** access, or
- [ ] Create a GitHub team and grant the team Write access

If participants are forking instead (Option A in `LAB.md`), no collaborator
access is needed for contributors; the facilitator/reviewer still needs
permission on the source repository to approve and merge.

## 6. Approval and merge ownership

Choose one model and announce it before participants clone:

| Access model | Practice review | Approval that satisfies the rule | Who merges |
|---|---|---|---|
| Fork | Pair participant may comment or approve for practice | Facilitator or designated reviewer with Write/Maintain access to the source repository | Facilitator or source-repository maintainer |
| Direct | A different participant with Write access may approve | Participant reviewer or facilitator with Write/Maintain access | Participant with Write access or facilitator, as announced |

- [ ] Ensure at least two qualified reviewers are available, so a
      facilitator's own test PR can receive an independent approval
- [ ] Tell participants who will supply the qualifying approval and who will
      merge in the selected model
- [ ] Tell fork participants not to expect an active merge button

## 7. Actions

- [ ] Confirm Actions are enabled for the repository (Settings → Actions →
      General → Allow all actions)
- [ ] The included `validate-recommendations` workflow is a lightweight Bash
      check, so it runs fast and does not depend on an external service or
      secret.

## 8. Seed content

- [ ] Confirm at least 3 seed recommendation files under `docs/recommendations/`
      look reasonable as "history the team inherited"
- [ ] Confirm the published repository has at least two commits, or verify
      the one-commit history fallback in `LAB.md`
- [ ] Confirm `conflict-lab/retry-policy.md` exists and is untouched before
      the lab starts (each pairing needs it in its original state)

## 9. Objective completion verification

On each participant branch, fetch the source remote and run the matching local
verifier:

```bash
git fetch upstream && bash scripts/verify-lab.sh recommendation  # fork
git fetch origin && bash scripts/verify-lab.sh recommendation    # direct
bash scripts/verify-lab.sh conflict                              # after conflict merge
```

The verifier checks branch naming, a clean working tree, commits ahead of
source `main`, exact changed-file scope, recommendation format/indexing, and
the resolved conflict value plus merge commit. Success ends with `PASS:`.

For each GitHub PR, use the PR page or the GitHub CLI to confirm the hosted
requirements that a local script cannot prove:

```bash
gh pr view <PR-URL> \
  --json headRefName,reviewDecision,statusCheckRollup,mergedAt \
  --jq '{branch: .headRefName, review: .reviewDecision, checks: [.statusCheckRollup[].conclusion], merged: .mergedAt}'
```

Expected after completion: the intended `feature/...` or `conflict/...`
branch, `review: "APPROVED"`, every check conclusion `SUCCESS`, and a non-null
`merged` timestamp. Record both PR URLs on the attendance/completion sheet.

## 10. Dry run

Before the live session:

- [ ] Fork/clone the repo yourself under a throwaway test account (or ask a
      colleague) and walk through `LAB.md` end to end once, including the
      merge-conflict exercise, to confirm the required check and branch
      protection rules behave as expected.
- [ ] Test from a one-commit copy of the repository to confirm the history
      inspection command does not assume `HEAD~1`.
- [ ] Run both verifier modes and the `gh pr view` completion check above.
