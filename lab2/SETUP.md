# Lab 2 facilitator setup checklist

Lab 2 reuses the published `contoso-git-lab` participant repository from Lab
1. Complete the Lab 1 [`SETUP.md`](../SETUP.md) first;
this file lists only the additional Copilot checks.

## 1. Confirm the supported path

- [ ] Announce whether participants should reopen their Lab 1 clone or make a
      fresh clone of their Lab 1 fork.
- [ ] Keep the same fork/direct-access model and explain who can approve and
      merge PRs.
- [ ] Confirm each participant's Lab 1 work is merged, or tell them to start
      from the current source `main` rather than an old feature branch.
- [ ] Budget 60–75 minutes for the core lab. Treat the coding-agent exercise
      as stretch content, not a completion requirement.

## 2. Verify Copilot access in VS Code

For every participant account:

- [ ] A GitHub Copilot plan/seat is active.
- [ ] VS Code is current and signed in to the intended GitHub account.
- [ ] GitHub Copilot Chat opens in VS Code and can answer a test prompt.
- [ ] Inline suggestions are enabled if you plan to demonstrate them.
- [ ] Organization/enterprise policy permits the Chat modes you plan to use.

The core lab requires only Copilot Chat plus normal file editing. Agent mode,
model selection, and exact UI labels vary by VS Code release and policy, so
participants may use Ask, Agent, or Plan mode to produce the same file. Do not
make a preview-only surface a core dependency.

Official references:

- [Asking Copilot questions in your IDE](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide?tool=vscode)
- [Getting code suggestions in your IDE](https://docs.github.com/en/copilot/how-tos/get-code-suggestions/get-ide-code-suggestions)

## 3. Dry-run the deliberate review moment

The participant prompt intentionally supplies an unverified `Low` severity
assumption for restricting anonymous blob access. Copilot may follow it,
challenge it, or produce different wording. All outcomes are acceptable; the
learning moment is that the participant must independently assess the output.

- [ ] Confirm participants can access public vendor documentation during the
      lab.
- [ ] During the debrief, expect a defensible final severity of **High** for
      this synthetic baseline because unintended anonymous access can expose
      stored data. The exercise is about documenting that reasoning, not
      pretending severity is universal across all environments.
- [ ] Confirm the sample uses only synthetic names and the all-zero
      subscription ID if an ID appears.
- [ ] Point out that `validate-recommendations` checks structure, not factual
      correctness. A well-formatted but wrong severity can pass CI.

## 4. Repository and hosted checks

- [ ] Actions are enabled and the `validate-recommendations` required check is
      still configured on `main`.
- [ ] `docs/recommendations/_TEMPLATE.md`, `CONTRIBUTING.md`, and
      `scripts/validate-recommendations.sh` are present on current `main`.
- [ ] At least one qualified human reviewer is available; authors cannot
      approve their own PR.
- [ ] The merge method remains **Squash and merge**.

Dry-run the core change on a temporary branch. Confirm:

```bash
git switch -c feature/restrict-anonymous-blob-access-<your-initials>
# Add the recommendation and index row described in LAB.md.
bash scripts/validate-recommendations.sh HEAD^ HEAD
git diff main...HEAD --check
git diff --name-only main...HEAD
```

Expected changed paths are exactly:

```text
docs/recommendations/README.md
docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md
```

Also open the PR and confirm its required check passes, a reviewer can request
changes, and the author can update the same branch before approval.

## 5. Optional coding-agent stretch

Only offer the stretch if all of these are true:

- [ ] GitHub Copilot cloud agent is enabled by the account and organization.
- [ ] The repository is eligible and the participant can create/assign issues.
- [ ] GitHub Actions can run the agent-created PR's checks.
- [ ] You have time to review agent output without rushing the human review.

Coding agent is a GitHub-hosted workflow that opens a PR; it is not the same
thing as local VS Code agent mode. If unavailable, skip the stretch with no
penalty.

Official reference: [Assigning tasks to Copilot](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/assign-copilot-to-an-issue)

## 6. Completion evidence

For the core PR, confirm:

- [ ] Branch name starts with `feature/`.
- [ ] Only the recommendation and index changed.
- [ ] The final recommendation has all required sections, severity `High`, a
      concrete risk, an actionable recommendation, synthetic data, and a
      public reference.
- [ ] The participant can identify what they changed after Copilot's draft.
- [ ] `validate-recommendations` passed.
- [ ] A different human reviewed the Files changed diff.
- [ ] The PR was squash-merged and the branch was deleted.

Hosted verification, where GitHub CLI is available:

```bash
gh pr view <PR-URL> \
  --json headRefName,files,reviewDecision,statusCheckRollup,mergedAt \
  --jq '{branch: .headRefName, files: [.files[].path], review: .reviewDecision, checks: [.statusCheckRollup[].conclusion], merged: .mergedAt}'
```
