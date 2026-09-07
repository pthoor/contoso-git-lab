# Lab 2 — GitHub Copilot in VS Code

**Scenario:** You are back with the synthetic Contoso cloud security team and
the same recommendation repository from Lab 1. Copilot will help draft the
next change, but it does not get to approve its own work.

**Time:** ~60–75 minutes  
**You'll practice:** Copilot Chat, reviewing AI output, optionally accepting an
inline suggestion, inspecting a diff, validating the change, and governing it
through a pull request and human review.

> **Copilot changes how we create the change — not how we govern it.**

This lab assumes Lab 1's Git and GitHub mechanics are familiar — commands
appear as reminders, not lessons. Copilot's UI labels shift between versions,
so if a button isn't where this guide says, use Chat and apply the edit by
hand. The outcome is the same either way: a file you reviewed before anyone
else saw it.

---

## Step 0 — Preflight

- [ ] Your Lab 1 fork is still cloned locally, and your Lab 1 pull request was
      merged.
- [ ] Your GitHub Copilot seat is active, and VS Code is signed in to the same
      GitHub account.
- [ ] Copilot Chat opens and answers a throwaway question such as
      `Summarize the purpose of this workspace.`
- [ ] You can reach Microsoft Learn in a browser — you'll verify Copilot's
      claims against it.

If Chat doesn't work, stop and tell your facilitator — the core lab needs it.
Inline suggestions and the cloud agent are optional, so it's fine if those
aren't available to you.

**Prompt safety:** prompts are another place data can leave your control. Use
only synthetic names and values. Do not paste real tenant IDs, subscription
IDs, customer data, credentials, internal URLs, or private incident details.

✅ **Checkpoint:** Copilot Chat works in the Lab 1 repository and `git status`
shows no uncommitted work.

---

## Step 1 — Start from current `main`

Bring your fork up to date first — other people's Lab 1 recommendations were
merged into the original repository while you were working:

```bash
git checkout main
git pull upstream main
git switch -c feature/restrict-anonymous-blob-access-<your-initials>
```

Replace `<your-initials>` everywhere it appears in this guide with your own
initials. Everyone in the room is writing about the same control, so the
initials are what keep your branch, your file, and your pull request separate
from everyone else's.

Do not continue on your old Lab 1 branch. Confirm:

```bash
git branch --show-current
git status --short
```

Expected: `feature/restrict-anonymous-blob-access-<your-initials>` and no changed files.

---

## Step 2 — Give Copilot context before asking for content

Before prompting, open and read these files yourself:

- `CONTRIBUTING.md`
- `docs/recommendations/_TEMPLATE.md`
- `docs/recommendations/azure/enable-defender-for-storage.md`
- `scripts/validate-recommendations.sh`

Answer these questions before asking Copilot:

1. Which sections does the template require?
2. What does CI actually check?
3. What important qualities can CI **not** verify?

Open Copilot Chat and ask:

```text
Using only the files in this workspace, summarize the conventions for a new
Azure platform security recommendation. Separate requirements enforced by the
validator from requirements that still need human judgment. Do not edit files.
```

Compare its answer with the files. If it misses something, point to the file
and ask it to revise. This is your first review: even an explanation needs a
source.

✅ **Checkpoint:** You can explain why passing CI does not prove a
recommendation is correct, safe, or useful.

---

## Step 3 — Ask Copilot to draft the recommendation

First, give Copilot the files it is supposed to work from. Attaching context
is a deliberate act — Chat does not read your repository automatically, and a
model answering from memory will invent plausible-looking headings that the
validator rejects. Add `docs/recommendations/_TEMPLATE.md` and one existing
recommendation to the chat context before you send anything.

The draft has to clear the validator, so know the bar before you read the
output. It must contain the headings `## Risk`, `## Recommendation` and
`## Example`, spelled exactly, plus a severity line in exactly this form:

```markdown
**Severity:** High
```

This prompt contains an **unverified assumption on purpose**. Do not silently
fix it before Copilot responds; you will test it in the next step.

```text
Create docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md from
_TEMPLATE.md for the synthetic Contoso training environment. Recommend
disabling anonymous public blob access on Azure Storage accounts. Assume the
severity is Low. Keep it concise, use only obviously synthetic values, include
a short Azure CLI example, and cite public Microsoft documentation. Do not
change any other file.
```

Depending on your available Copilot surface:

- **Ask mode:** copy the proposed Markdown into the new file yourself.
- **Editing/agent surface:** review the proposed edit before accepting it.
- If Copilot edits another file, reject or undo that unrelated change.

**If the structure comes back wrong** — invented headings such as `## Impact`
or `## Remediation`, or a reworded severity line — do not argue with it. Copy
the template and move the prose across yourself:

```bash
cp docs/recommendations/_TEMPLATE.md \
   docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md
```

Then paste Copilot's wording into the sections it belongs in. This is the same
move you made in Lab 1 Step 4, and it is the point of the lab: you own the
file's shape, Copilot only drafts the words.

Do not add the index row yet.

Run:

```bash
git status --short
git diff -- docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md
```

Because the file is untracked, ordinary `git diff` may show nothing. Use VS
Code's file diff, or run this read-only comparison:

```bash
git diff --no-index /dev/null docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md || true
```

✅ **Checkpoint:** Exactly one new file exists, and you have read every line
Copilot proposed.

---

## Step 4 — Verify the proposal instead of trusting it

Review the draft against this acceptance checklist:

| Check | How to verify |
|---|---|
| Required structure | Compare with `_TEMPLATE.md` and the validator script |
| Severity | Judge the likely impact; do not accept the prompt's assumption |
| Technical accuracy | Check the CLI syntax and claim in public Microsoft docs |
| Actionability | A reader should know what setting to change |
| Synthetic safety | No real identifiers, customers, secrets, or internal links |
| Scope | Only this recommendation should have changed so far |

The supplied `Low` severity was deliberately questionable. For this synthetic
baseline, unintended anonymous access can expose stored data, so the defensible
value is:

```markdown
**Severity:** High
```

**Two things can have happened, and both are your call to make:**

- **Copilot wrote `Low`** — it accepted your assumption without challenging it.
  Correct the file yourself and record the correction in your PR description.
- **Copilot wrote `High` (or another value) anyway** — it challenged your
  prompt. Do not just accept that either: verify its reasoning against the
  Microsoft documentation, then record in your PR that you *ratified* its
  judgment and why. Agreeing with a correct answer is still your decision.

This is not a universal risk score: environment and data classification still
matter. The point is that an assumption repeated confidently by Copilot is
still only an assumption.

Verify the Azure CLI example against public documentation. A defensible
example uses synthetic names and disables the account-level setting, such as:

```text
az storage account update \
  --name stcontosolab001 \
  --resource-group rg-contoso-security-lab \
  --allow-blob-public-access false
```

Ask Copilot to critique its own output, but make the final decision yourself:

```text
Review this recommendation as a skeptical security reviewer. Identify any
unsupported severity assumption, vague risk language, unsafe/non-synthetic
data, incorrect Azure CLI option, or missing required section. Do not edit.
```

Correct every issue you agree with. If inline suggestions are enabled, start
rewriting one vague sentence and inspect the suggestion before pressing
**Tab** to accept it. If no suggestion appears, edit the sentence manually;
inline completion is not required for lab completion.

✅ **Checkpoint:** You can name at least one material decision a human made
that was not safely delegated to Copilot.

---

## Step 5 — Add the index entry and inspect the whole change

Ask Copilot for a **proposed** one-line index entry, or add it yourself, under
`Azure platform` in `docs/recommendations/README.md`:

```markdown
| [Restrict anonymous blob access](azure/restrict-anonymous-blob-access-<your-initials>.md) | <severity you decided in Step 4> |
```

Now inspect the complete scope:

```bash
git status --short
git diff -- docs/recommendations/README.md
git diff --no-index /dev/null docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md || true
```

Expected changed files:

```text
docs/recommendations/README.md
docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md
```

Check that the title and severity agree between the file and index. Remove any
unrelated edits Copilot made.

---

## Step 6 — Stage and review the staged diff

Stage only the two intended files:

```bash
git add docs/recommendations/azure/restrict-anonymous-blob-access-<your-initials>.md \
        docs/recommendations/README.md
```

Before committing, inspect the exact staged snapshot:

```bash
git diff --cached --check
git diff --cached --name-only
git diff --cached
```

Read the entire staged diff. Confirm only the two expected files are staged.

> A green structural check later will not validate the severity, prose, CLI
> behavior, or safety of the example. Those remain review responsibilities.

✅ **Checkpoint:** `git diff --cached --check` prints nothing, and the staged
diff contains exactly the intended change.

---

## Step 7 — Commit and run the supported validator

Commit with a specific, imperative message:

```bash
git commit -m "Add recommendation: restrict anonymous blob access"
bash scripts/verify-lab.sh recommendation
bash scripts/validate-recommendations.sh main HEAD
git status
```

`verify-lab.sh` is the repository's own gate — the one the pull request
template asks you to confirm you ran. Compare against `main`, not `HEAD^`:
`HEAD^` only looks at your most recent commit, so once you make a second commit
the check can report success while validating nothing.

Expected validator ending:

```text
All 1 changed recommendation file(s) look good.
```

Expected status: working tree clean.

Then inspect exactly what will enter the PR:

```bash
git diff --check main...HEAD
git diff --name-only main...HEAD
git diff main...HEAD
```

If your source `main` is a remote-tracking branch, you may compare with
`upstream/main` (fork) or `origin/main` (direct) instead. Fix any unexpected
file, commit the correction, and inspect again.

✅ **Checkpoint:** The branch is ahead of current source `main`; validation
passes; the PR diff contains exactly the recommendation and index row.

---

## Step 8 — Push and open the pull request

```bash
git push -u origin feature/restrict-anonymous-blob-access-<your-initials>
```

Open a pull request into the source repository's `main`. Use a title such as:

```text
Add anonymous blob access recommendation
```

In the description, include:

- What Copilot drafted.
- What you verified independently.
- What you corrected (including `Low` → `High`) and why.
- Which public source you used to verify the control and CLI example.

Wait for `validate-recommendations` to finish. If it passes, ask yourself:
**Would it also have passed before the severity correction?** The answer is
why human review is part of the control system.

✅ **Checkpoint:** Files changed contains only the two intended files and the
required check passes.

---

## Step 9 — Human review is still required

Pair with another participant. The reviewer must use the **Files changed** tab,
not just the PR description.

Reviewer checklist:

- [ ] Does the risk justify the stated severity?
- [ ] Is the recommendation specific and technically plausible?
- [ ] Is the command consistent with the prose?
- [ ] Are all names and identifiers obviously synthetic?
- [ ] Does the public reference support the claim?
- [ ] Is the index entry accurate?

Leave at least one line comment or question and submit a review. If the
reviewer requests a change, the author updates the same branch, pushes, and
waits for CI/re-review. Do not open a replacement PR to hide the discussion.

As in Lab 1, a fork participant's approval may be practice only; a facilitator
or designated reviewer with sufficient permission supplies the qualifying
approval and merge.

✅ **Checkpoint:** A different human has reviewed the actual diff, and any
requested changes are resolved rather than bypassed.

---

## Step 10 — Merge and clean up

After the required check and qualifying approval:

1. The authorized person selects **Squash and merge**.
2. Delete the remote branch on GitHub.
3. Update local `main` and delete the local branch. Use `-D`, not `-d`:
   a squash merge replays your work as one new commit, so `-d`'s safety
   check cannot tell the branch was merged and will refuse to delete it.

```bash
git checkout main
git pull origin main          # direct access
# or: git pull upstream main  # fork workflow
git branch -D feature/restrict-anonymous-blob-access-<your-initials>
```

🎉 Copilot helped create the change. Git exposed what changed. GitHub and a
human reviewer controlled what merged.

---

## Optional stretch A — Refine an existing recommendation

Only start this after the core PR is merged. Create a separate `fix/...`
branch and ask Copilot to make one tightly scoped improvement to
`docs/recommendations/identity/rotate-service-principal-credentials.md`.
For example, ask it to make the recommendation distinguish secrets,
certificates, and workload identity more precisely without inventing a
one-size-fits-all rotation policy.

Review its proposal against public documentation. If you keep the change,
use a separate commit and PR because `CONTRIBUTING.md` requires one focused
change per PR. Apply the same diff → validation → PR → human review sequence.

## Optional stretch B — Assign a small issue to cloud agent

GitHub Copilot cloud agent is optional and may be unavailable under your plan
or organization policy. It runs on GitHub and opens a PR; it is different from
VS Code's local agent mode.

Create this narrowly scoped issue:

```text
Title: Require a References section in recommendation validation

Update scripts/validate-recommendations.sh so every changed recommendation
must contain a `## References` heading. Do not introduce new dependencies or
change unrelated behavior. Run the existing validation checks; if no automated
test covers this case, document the focused manual test in the PR.
```

Assign the issue to Copilot using the option your facilitator demonstrated.
When its PR arrives, do not merge because the agent says it is done:

1. Read every changed line.
2. Check whether the script validates the heading, useful content, or only
   the heading's existence.
3. Look for scope creep and test gaps.
4. Run the relevant validation locally if practical.
5. Comment, request changes, or approve exactly as you would for a human PR.

If cloud agent is unavailable, skip this stretch with no penalty.

---

## Recap — what you just practiced

| Stage | Copilot's role | Human/GitHub control |
|---|---|---|
| Explain | Summarized repository conventions | You checked the source files |
| Draft | Proposed recommendation text and a command | You corrected severity, accuracy, and safety |
| Refine | Suggested wording or edits | You accepted only useful changes |
| Inspect | Could critique its own draft | Git diff showed the actual change |
| Validate | Helped interpret failures | CI checked structure, not truth |
| Review | Could summarize the PR | A different human reviewed the lines |
| Merge | None | Rules, checks, approval, and an authorized merger governed `main` |

The durable habit is not a particular prompt or Copilot button. It is this:
**AI proposes; humans verify; Git records; GitHub governs.**
