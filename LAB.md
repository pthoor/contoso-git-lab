# Lab 1 — Git & GitHub Fundamentals

**Scenario:** You're joining the (synthetic) Contoso cloud security team. Your
first task is to add one new security recommendation to the team's knowledge
hub — and to do it the way every real pull request happens: on a branch,
reviewed, and merged through GitHub.

**Time:** ~60–75 minutes
**You'll practice:** working in an existing repository; clone/fork, branch,
edit, stage, commit, push, pull request, review, merge, and resolving a merge
conflict through both the Git CLI and VS Code Source Control.

Work through the steps in order. Don't skip the verification checks — they
catch the most common beginner mistakes before they become confusing.

**Out of scope for today:** `git stash` and `git rebase`. They're useful, but
not needed for this workflow — ask your facilitator if you're curious.
This lab starts from an existing GitHub repository; it does not cover
`git init`, repository creation, or publishing a repository.

---

## Step 0 — Preflight

You need three things. Check them now, not when a command fails halfway
through Step 4.

- [ ] A GitHub account, signed in.
- [ ] Git and VS Code installed.
- [ ] VS Code signed in to GitHub (or a working credential helper / SSH key).

Two commands confirm the tools:

```bash
git --version
code --version
```

Both should print a version. If `code` isn't found, that's fine — open VS Code
normally and use **File → Open Folder** wherever this guide says `code .`.

And one command confirms you can reach the repository:

```bash
git ls-remote https://github.com/pthoor/contoso-git-lab HEAD
```

Expected: a long commit ID followed by `HEAD`. If you get `Repository not
found` or an authentication prompt, fix that with your facilitator before
going further — everything after this depends on it.

✅ **Checkpoint:** both versions printed, and `ls-remote` printed a commit ID.

---

## Step 1 — Fork the repository and clone your fork

You don't have write access to the training repository, and you don't need it.
You'll work in your own copy — a **fork** — and propose your change back with
a pull request. This is exactly how contributing to any open-source project
works.

1. Open https://github.com/pthoor/contoso-git-lab and click **Fork**
   (top right) → **Create fork**. You now have your own copy at
   `https://github.com/<your-username>/contoso-git-lab`.

2. Clone **your fork** — not the original. Copy the HTTPS URL from your fork's
   green **Code** button:

   ```bash
   git clone https://github.com/<your-username>/contoso-git-lab.git
   cd contoso-git-lab
   ```

3. Tell Git where the original lives, so you can pull in other people's merged
   work later. The conventional name for it is `upstream`:

   ```bash
   git remote add upstream https://github.com/pthoor/contoso-git-lab.git
   git remote -v
   ```

   You should see **two** remotes: `origin` is your fork (you can push to it),
   `upstream` is the original (you can only read from it).

Open the folder in VS Code:

```bash
code .
```

If you opened VS Code manually, use **File → Open Folder** and pick the
`contoso-git-lab` folder. Trust the folder if prompted, then open
**Terminal → New Terminal** and check the prompt is inside that folder.

✅ **Checkpoint:** VS Code Explorer shows `LAB.md`, and `git remote -v` lists
both `origin` (your fork) and `upstream` (the original).

---

## Step 2 — Look around before you touch anything

```bash
git status
git log --oneline -n 10
git branch -a
```

- `git status` -> confirms you're on `main` and your working directory is clean.
- `git log` -> the history you just inherited by cloning.
- `git branch -a` -> local and remote branches you can see.

Expected output includes `On branch main`, `nothing to commit, working tree
clean`, and `* main` in the branch listing. Your commit IDs and the number of
remote branches may differ.

Now look a little closer at that history — you'll use these same commands
constantly once you start making your own changes:

```bash
git show --stat --oneline HEAD
if git rev-parse --verify --quiet HEAD^ >/dev/null; then
  git diff HEAD^ HEAD -- docs/recommendations/README.md
else
  git show --format= HEAD -- docs/recommendations/README.md
fi
```

- `git show` reports the newest commit and its changed-file summary.
- The conditional command compares the last two commits when a parent exists.
  In a one-commit repository it instead shows that initial commit's change to
  the file, without failing on a nonexistent `HEAD~1`.

If the file was not changed in the inspected commit, an empty diff is expected.

Open `docs/recommendations/` in VS Code and skim two or three existing
recommendation files so you know the format you're about to copy.

Select the **Source Control** icon in the Activity Bar. It should show no
Changes. Expand **Source Control Graph** (or run **Git: View History** from the
Command Palette if available) and select a commit to inspect its files. This
is the UI view of the same history shown by `git log` and `git show`.

While you're looking around, open `.gitignore` at the repo root. It lists
patterns Git will **never** track (editor noise, `node_modules/`,
anything that looks like a secret file). It doesn't hide files that are
already committed — it only stops new, untracked files from being staged by
accident.

---

## Step 3 — Create your branch

Pick a recommendation to add, and decide which category it belongs in — this
matters, because `CODEOWNERS` routes review requests based on folder:

- `docs/recommendations/identity/` → identity & access recommendations
  (e.g. Enable Conditional Access for break-glass accounts, Require approval
  workflows for privileged role activation)
- `docs/recommendations/azure/` → Azure platform recommendations
  (e.g. Enable Microsoft Defender for Key Vault, Restrict public network
  access on storage accounts)

Make sure you're starting from an up-to-date `main`, then branch:

```bash
git checkout main
git pull upstream main        # the original repo, not your fork
git switch -c feature/<short-recommendation-name>
```

Example: `feature/defender-for-key-vault`

Branches are cheap and safe to try out. To see this before it matters, you
can switch back and forth once:

```bash
git switch main                          # back to main, no changes lost
git switch feature/<short-recommendation-name>   # forward again
```

`git branch` (no args) always shows you which branch you're on.

VS Code equivalent: click the branch name in the lower-left status bar, choose
**Create new branch**, and enter the same `feature/...` name. Use either the
CLI or UI to create it, not both.

✅ **Checkpoint:** `git branch` shows `* feature/...`, and the same branch name
appears in VS Code's lower-left status bar.

---

## Step 4 — Add your recommendation

1. Copy the template into the right category folder (`identity/` or `azure/`):

   ```bash
   cp docs/recommendations/_TEMPLATE.md docs/recommendations/<category>/<your-recommendation-slug>.md
   ```

2. Open your new file in VS Code and fill in every section of the template.
   Keep it short — 15–25 lines is plenty.
3. Add a row for your recommendation to the table in
   `docs/recommendations/README.md`.

**Reminder:** synthetic content only. No real tenant IDs, customer names,
credentials, or internal URLs — see [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Step 5 — Look at what you changed before you stage it

```bash
git status
git diff
```

Read the `diff` output. This is the single most useful habit in Git: **look
at your diff before you commit it**, every time.

### VS Code Source Control path

The new recommendation should appear under **Untracked files** in
`git status`; the index should appear under **Changes not staged for commit**.
Nothing should be under **Changes to be committed** yet.

In VS Code Source Control, both files appear under **Changes**. Select each
file to open the side-by-side diff editor: the left side is the committed
version and the right side is your working copy.

✅ **Checkpoint:** the CLI and VS Code show the same two changed files and no
unrelated files.

---

## Step 6 — Stage and commit

**First, check Git knows who you are.** Your name and email are stamped into
every commit you make, permanently and publicly:

```bash
git config --global user.name
git config --global user.email
```

If either prints nothing, set them now — `git commit` will refuse otherwise:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Use an email tied to your GitHub account so your commits are attributed to
you. If you'd rather not publish a personal address, GitHub gives you a private
`<id>+<username>@users.noreply.github.com` one under **Settings → Emails**.

Now commit. Choose one path; do not stage and commit the same work twice.

### Git CLI

```bash
git add docs/recommendations/<category>/<your-recommendation-slug>.md docs/recommendations/README.md
git status
git commit -m "Add recommendation: <short description>"
```

### VS Code Source Control

1. Hover over each intended file under **Changes** and select **+**.
2. Confirm both move to **Staged Changes** and no unrelated file is staged.
3. Enter `Add recommendation: <short description>` in the message box.
4. Select **Commit**.

Notes:

- `git add` is deliberate — only the files you listed are staged.
- Write the commit message as if the next reader has never seen your PR.
  Compare `fix stuff` with `Add Defender for Key Vault recommendation`.

After staging, CLI `git status` lists both paths under **Changes to be
committed**; VS Code lists them under **Staged Changes**. After committing,
`git status` says the working tree is clean and Source Control has no Changes.

✅ **Checkpoint:** `git log --oneline -n 1` shows your new commit on your
branch, and `git status` reports a clean working tree.

**Made a mistake? Here's how to undo it, before you push:**

| Situation | Command |
|---|---|
| Typo in the commit message you just wrote | `git commit --amend` |
| Forgot to add a file to that commit | `git add <file>` then `git commit --amend` |
| Staged a file you didn't mean to (`git add`) | `git restore --staged <file>` |
| Want to discard uncommitted edits to a file | `git restore <file>` |

These are all safe as long as you haven't pushed yet. Once a commit is
pushed and possibly reviewed, prefer a new commit that fixes it over
rewriting history (`--amend`/`git reset`) that others may have already
pulled.

---

## Step 7 — Push your branch

First run the objective local check:

```bash
bash scripts/verify-lab.sh recommendation
```

Expected final line: `PASS: recommendation branch ...`. If it reports a stale
base, run `git fetch upstream`,
then retry.

```bash
git push -u origin feature/<short-recommendation-name>
```

The `-u` links your local branch to the remote one, so next time a plain
`git push` is enough.
Expected output includes a new remote branch and a line such as `branch
'feature/...' set up to track 'origin/feature/...'`.

VS Code equivalent: select **Publish Branch** in Source Control or the status
bar. Confirm the tracking relationship with:

```bash
git status -sb
```

The first line should contain your local `feature/...` branch followed by
`...origin/feature/...`; the three dots are Git's tracking separator.

---

## Step 8 — Open a pull request

1. GitHub will show a **"Compare & pull request"** banner after your push —
   click it (or open the **Pull requests** tab → **New pull request**).
2. **Base** should be `main` on the source repository. If
   you're on a fork, GitHub usually gets this right automatically — double
   check the base/head repos shown at the top of the compare view.
3. Give the PR a clear title and fill in the description: what recommendation
   you added and why.
4. Click **Create pull request**.

✅ **Checkpoint:** Your PR page shows a **Files changed** tab with only the
files you intended to touch, and the `validate-recommendations` check has
started running.

---

## Step 9 — Review someone else's pull request

Pair up with another participant:

1. Open their pull request.
2. Read the **Files changed** diff.
3. Leave at least one comment (a question, a suggestion, or just "approve
   with a note").
4. Submit your review as **Comment** or **Approve**.

This is the step that turns a private change into a team decision.

**Why your approval doesn't merge it — and why that's the point.**

Your review is real. It's recorded on the pull request, your comments are
permanent, and you can submit it as **Approve**. What it cannot do is satisfy
this repository's protection rule, because that rule counts approvals only
from people with write access — and you're contributing from a fork.

That isn't a limitation of your review. It's the repository deciding who is
allowed to vouch for a merge, which is the same question every real engineering
team has to answer. Your facilitator supplies the approving review and merges.

You also can't approve your own pull request — no repository lets you do that.

---

## Step 10 — Merge

Once your own PR has a passing `validate-recommendations` check and your
facilitator's approval:

1. Your facilitator clicks **Squash and merge**.
2. Confirm the merge.
3. Click **Delete branch** (cleans up the now-merged branch on GitHub).

Then bring your local `main` up to date and remove your local branch too.
Note the capital `-D`: a squash merge replays your branch as one brand-new
commit on `main`, so the lowercase `-d` safety check cannot see that your
work was merged and refuses to delete the branch.

```bash
git checkout main
git pull upstream main        # the original repo, not your fork
git branch -D feature/<short-recommendation-name>
```

VS Code equivalents: choose `main` from the lower-left branch selector, run
**Git: Pull** from the Command Palette, then run **Git: Delete Branch** for the
local feature branch.

🎉 **You just shipped a change the same way it happens on a real team.**

---

## Guided challenge — resolve a merge conflict

Work in the same pair as Step 9.

1. Both of you branch from the latest `main`:

   ```bash
   git switch -c conflict/<your-name>-retry-policy
   ```

2. Both of you open `conflict-lab/retry-policy.md` and change the same line
   (`retry_count = 3`) to **different** values.
3. Both of you commit and push your branch, then open a PR into `main`.
4. **Person A merges first.** Their PR merges cleanly.
5. **Person B's PR now shows a conflict.** Pull the updated `main` into your
   branch to surface it locally:

   ```bash
   git checkout conflict/<your-name>-retry-policy
   # Fetch and merge the original repository's main.
   git fetch upstream
   git merge upstream/main
   ```

   Watch the remote name: Person A's change was merged into the *original*
   repository, which is `upstream` — not `origin`, which is your own fork.

6. Git marks the conflicting section directly in the file, and running
   `git status` will list it under **"Unmerged paths"**. Open the file — it
   will look something like this:

   ```text
   <<<<<<< HEAD
   retry_count = 5
   =======
   retry_count = 7
   >>>>>>> upstream/main
   ```

   How to read this:

   - `<<<<<<< HEAD` down to `=======` is **your** change (what's currently on
     your branch).
   - `=======` down to `>>>>>>> upstream/main` (or `origin/main` for direct
     access) is the **incoming** change Person A already merged.
   - The three marker lines (`<<<<<<<`, `=======`, `>>>>>>>`) are not valid
     file content — Git inserted them so you can see both versions at once.
     They must **all** be removed before you're done.

   To resolve it:

   1. Talk to your pair partner and agree on the correct final value (or a
      new one that supersedes both).
   2. Edit the file so it contains **only** that final value — delete the
      `<<<<<<<`/`=======`/`>>>>>>>` lines and whichever line(s) you didn't
      keep.
   3. Save the file.

   In VS Code, you can also click **Accept Current Change**, **Accept
   Incoming Change**, or **Accept Both Changes** in the inline buttons above
   the conflict — but read the result afterwards; VS Code doesn't know which
   value is actually correct, only you and your partner do.

   💡 If you want to back out and try again: `git merge --abort` returns you
   to the state before you ran `git merge`.

7. Confirm the markers are gone, then re-check the file looks right:

   ```bash
   git diff
   ```

   In Source Control, `retry-policy.md` appears under **Merge Changes** until
   it is resolved. Open it in the Merge Editor if offered, choose or edit the
   final result, select **Complete Merge**, and inspect the resulting diff.

8. Finish the merge:

   ```bash
   git add conflict-lab/retry-policy.md
   git status
   git commit
   git push
   ```

   Git pre-fills a commit message like `Merge branch 'main' into
   conflict/...` — you can keep it as is.
   After `git add`, expected `git status` says
   `All conflicts fixed but you are still merging` and lists the file under
   **Changes to be committed**. In VS Code, stage the resolved file with `+`,
   enter or accept the merge message, and commit; use either UI or CLI, not
   both.

9. Verify the completed branch before refreshing the PR:

   ```bash
   bash scripts/verify-lab.sh conflict
   ```

   Expected final line: `PASS: conflict branch ...`. Refresh your PR; the
   conflict should be gone and `validate-recommendations` should pass quickly
   with `No recommendation content files changed; check passes.` The
   authorized person then merges it.

✅ **Checkpoint:** the verifier passes, the PR is merged after a qualifying
approval, and you can explain why Git could not choose between two edits to
the same line.

---

## Recap — what you just practiced

| Concept | What you did |
|---|---|
| Remote | Talked to GitHub via `origin` (and `upstream` if you forked) |
| Branch | Isolated your change from `main` |
| Staging | Chose exactly what went into each commit |
| Commit | Recorded a snapshot with a message that explains itself |
| Push / Pull | Moved history between your laptop and GitHub |
| Pull request | Asked GitHub to review your branch before integrating it |
| Review | Read someone else's diff and gave feedback |
| Merge | Integrated an approved change into `main` |
| Conflict | Resolved two changes to the same line, by hand |

Next up: **Lab 2 — GitHub Copilot in VS Code**, where an AI agent helps write
the change, and this exact workflow is what keeps it under control.
