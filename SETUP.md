# Repository setup checklist (for facilitators)

Run these steps after this content is transferred into a real GitHub
repository (personal account first; org later — see chat notes). Publishing
the participant repository is a launch dependency: the facilitator must
create it, push this content, and verify its URL before learners start.
This checklist cannot publish it automatically.

## 1. Repository basics

Published at **https://github.com/pthoor/contoso-git-lab**. The participant
guides link to that URL directly, so if you fork or rename this repository for
your own session, update the links in `LAB.md` Step 0 and Step 1, `lab2/LAB.md`
Step 1, and `README.md`.

- [ ] Visibility: **Public** — participants must be able to fork it
- [ ] Default branch: `main`
- [ ] Forking enabled (Settings → General → Features)
- [ ] Description: "Training repository for Contoso's Git & GitHub
      Fundamentals lab. Synthetic content only — not real Contoso data."
- [ ] Topics: `training`, `git`, `github-skills`, `contoso`

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

`.github/CODEOWNERS` assigns every path to `@pthoor`, the owner of the
published training repository. The `@contoso/*` team names shown on the slide
deck are illustrative only and deliberately do not exist here — no GitHub
organization backs them, so a lab repo that used them would route reviews to
nobody. Required code-owner review is currently **off**
(`require_code_owner_reviews: false`), so this file does not gate any merge.

If you do want code-owner review to be enforced:

- [ ] Either replace these with real GitHub usernames/teams, **or**
- [ ] Remove the CODEOWNERS requirement from the ruleset for this lab (a
      single facilitator account can't satisfy a team-based CODEOWNERS rule
      alone during a live lab)

## 5. Collaborator access (only on request)

The labs are fork-based, so **no collaborator access is needed by default**.
Participants fork, push to their own copy, and open pull requests here.

The root `README.md` invites anyone who wants to work directly in this
repository to open an issue asking for access. If you grant one:

- [ ] Add them as a collaborator with **Write** access
- [ ] Remember they can now approve other participants' pull requests, which
      changes who can satisfy the branch protection rule
- [ ] Remove the access when the session is over

## 6. Approval and merge ownership

Branch protection counts approvals only from people with write access, so on a
fork-based lab **every approving review and every merge is yours**. Participants
can review each other fully — comments, suggestions, even an Approve — and none
of it will satisfy the rule. Lab 1 Step 9 explains this to them as a lesson
about who gets to vouch for a merge, so they aren't surprised.

Budget for it: roughly two approve-and-merge actions per participant across
Lab 1 (the recommendation PR and the conflict PR).

- [ ] Plan for ~2 merges per participant, and decide whether you'll merge as
      they arrive or in batches at set points
- [ ] Have a second reviewer with write access available if you want your own
      dry-run PR independently approved
- [ ] Tell participants up front that the merge button won't be active for
      them — it's expected, not a misconfiguration

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
