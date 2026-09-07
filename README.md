# Contoso Security Knowledge Hub

> **⚠️ This is a training repository.** All recommendations, tenants, secrets, and
> customer names in this repository are **synthetic** — invented for the purpose
> of learning Git and GitHub. Nothing here reflects a real Contoso customer,
> environment, or credential.

This repository is the hands-on companion to the **Contoso Git & GitHub
Fundamentals** lunch & learn. It is a small, growing library of security
recommendations — the kind a cloud security team might maintain internally —
written as plain Markdown files.

You'll add to this **existing repository** the way engineering teams work every
day: **fork → branch → commit → push → pull request → review → merge.**
Creating a repository from scratch with `git init` is not part of these labs —
joining one that already exists is the harder and more common skill.

## Start here

This repository hosts **two labs**, done in order. Both work in the same
recommendation library, so finish Lab 1 before starting Lab 2.

| | Lab | Guide | Time |
|---|---|---|---|
| 1 | Git & GitHub fundamentals — branch, commit, pull request, review, merge, and a guided merge conflict | 👉 **[LAB.md](LAB.md)** | 60–75 min |
| 2 | GitHub Copilot in VS Code — Copilot drafts the change, the Lab 1 workflow still governs what merges | 👉 **[lab2/LAB.md](lab2/LAB.md)** | 75–85 min |

The slide deck that introduces both is
[`docs/contoso-git-github-fundamentals.html`](docs/contoso-git-github-fundamentals.html)
— download it and open it in a browser.

**You don't need write access.** Fork this repository to your own account and
propose changes with a pull request — the same way you'd contribute to any
open-source project. Lab 1 Step 1 walks you through it.

If you'd rather work directly in this repository instead of a fork, open an
issue asking for collaborator access and say why.

## What's in this repository

```
docs/recommendations/   Security recommendations, grouped by category
  identity/              Identity & access recommendations
  azure/                 Azure platform recommendations
docs/*.html             The lunch & learn slide deck
conflict-lab/           The file used for the guided merge-conflict exercise
.github/                Pull request template, CODEOWNERS, and CI checks
scripts/                CI validation and local completion verification
CONTRIBUTING.md         Branch naming and commit message conventions
LAB.md                  The Lab 1 step-by-step guide
SETUP.md                Lab 1 repo-admin checklist — not for participants
lab2/                   Lab 2: guide, orientation, and its own facilitator checklist
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
