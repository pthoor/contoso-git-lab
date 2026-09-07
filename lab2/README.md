# Lab 2 — GitHub Copilot in VS Code

**Scenario:** You are continuing with the synthetic Contoso cloud security
team and the same `contoso-git-lab` repository used in Lab 1. This time,
GitHub Copilot helps create the change. Your branch, diff, pull request, and
human reviewer still decide whether it belongs on `main`.

> **Copilot changes how we create the change — not how we govern it.**

## Start here

👉 **[Open the Lab 2 guide](LAB.md)** and follow it step by step.

This lab continues in the fork you made in Lab 1, so keep that clone. If you
no longer have it, redo Lab 1's Step 1 before starting.

## What you will do

- Ask Copilot to explain and draft a security recommendation.
- Catch and correct a deliberately questionable assumption in its draft.
- Inspect the complete Git diff and run the repository validator.
- Put the AI-authored change through the same PR, review, and merge controls
  used in Lab 1.
- Optionally try an inline refinement and the GitHub Copilot coding agent.

## Ground rules

- Use synthetic values only. Never paste real tenant IDs, subscriptions,
  customer data, credentials, or internal URLs into a prompt or file.
- Treat Copilot output as a proposal, not evidence.
- One focused change per pull request.
- No direct pushes to `main`.

> AI can write it. Git tells us what changed. GitHub controls how it gets
> accepted.
