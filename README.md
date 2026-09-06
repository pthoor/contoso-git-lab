# Contoso Security Knowledge Hub

> **⚠️ This is a training repository.** All recommendations, tenants, secrets, and
> customer names in this repository are **synthetic** — invented for the purpose
> of learning Git and GitHub. Nothing here reflects a real Contoso customer,
> environment, or credential.

This repository is the hands-on companion to the **Contoso Git & GitHub
Fundamentals** lunch & learn. It is a small, growing library of security
recommendations — the kind a cloud security team might maintain internally —
written as plain Markdown files.

You are going to add to this **existing repository** using the workflow real
engineering teams use every day: **branch -> edit -> commit -> push -> pull
request -> review -> merge.** Creating a repository with `git init` is outside
this collaboration-focused lab.

## Start here

👉 **[Open the Lab 1 guide](LAB.md)** and follow it step by step.

Your facilitator must provide the published source-repository URL and announce
whether the class is using forks or direct collaborator access. Do not assume
an example repository name in screenshots or course notes is live.

## What's in this repository

```
docs/recommendations/   Security recommendations, grouped by category
  identity/              Identity & access recommendations
  azure/                 Azure platform recommendations
conflict-lab/           A file used for the guided merge-conflict exercise
.github/                Pull request template, CODEOWNERS, and CI checks
scripts/                CI validation and local completion verification
CONTRIBUTING.md         Branch naming and commit message conventions
LAB.md                  The Lab 1 step-by-step guide
SETUP.md                Repo-admin checklist (branch protection, etc.) — not for participants
```

## Ground rules for this repository

- Never commit a real credential, tenant ID, customer name, or internal URL —
  synthetic values only (see [`CONTRIBUTING.md`](CONTRIBUTING.md)).
- One recommendation change per pull request.
- Every change goes through a pull request — nobody pushes directly to `main`.

## Learning objective

> AI can write it. Git tells us what changed. GitHub controls how it gets accepted.

This repository is where that sentence stops being a slide and starts being
something you've done with your own hands.
