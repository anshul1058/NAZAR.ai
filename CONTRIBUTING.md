# Contributing to PERISAI

Thanks for your interest in contributing! This document explains the workflow & standards used in this project.

## Quick Links

- 📋 [Full working rules](CLAUDE.md) — commit convention, checklist, definition of done
- 🛠️ [Development setup](README.md#-quick-start)

## Short Workflow

1. **Fork** this repo (for external contributors) or **clone** it directly (if you're on the team)
2. Create a branch from `dev` (not from `main`):

   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feat/feature-name
   ```

3. Make your changes, following the [code style rules](CLAUDE.md#code-conventions)
4. Make sure it passes the [Pre-Commit Checklist](CLAUDE.md#pre-commit-checklist)
5. Push the branch + open a Pull Request to `dev`
6. Wait for review, fix any feedback, merge

## Branching Strategy

```text
main         ← production-ready, tagged releases only
 │
dev          ← integration branch, all features/fixes land here first
 │
feat/*       ← new feature branches, from dev
fix/*        ← bug fix branches, from dev
hotfix/*     ← urgent fix branches for production, from main
release/*    ← release preparation branches, from dev
```

**Important rules:**

- **DON'T push directly to `main`** — always go through a PR from `release/*` or `hotfix/*`
- **DON'T push directly to `dev`** — always go through a PR from `feat/*` or `fix/*`
- Feature branches **must be rebased onto dev** before the PR is merged

## Commit Convention

Use **Conventional Commits** (messages in English):

```text
feat(child-detail): add pause button
fix(detection): convert UTC to local time before time formatting
refactor(dashboard): split _ChildAvatar into a reusable widget
docs: update CONTRIBUTING with branching strategy
chore(android): bump ndkVersion to 27.0.12077973
```

Full details in [CLAUDE.md → Git & Commit Convention](CLAUDE.md#git--commit-convention).

## Pull Request

When opening a PR, fill in the template that appears automatically. At minimum include:

- **What** — what the change is
- **Why** — why it's needed
- **How to test** — manual test steps
- **Screenshots** — if it's a UI change

PRs are reviewed by maintainers ([CODEOWNERS](.github/CODEOWNERS)). It may take a few days to merge — don't be offended 😄.

## Code Style

- Comments & UI text in **casual English**
- Use `AppColors` — don't inline `Color(0xFF...)`
- Run `dart format .` before committing
- `flutter analyze` must be clean (no errors)

## Reporting Bugs / Feature Requests

Use GitHub Issues. Templates are available for:

- 🐛 Bug report
- ✨ Feature request

## Security Issues

See [SECURITY.md](.github/SECURITY.md) — don't open public issues for security vulnerabilities.

## Questions?

Open a [GitHub Discussion](https://github.com/anshul1058/periai_app/discussions) or DM a maintainer.