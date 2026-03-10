
# Contributing to LivestockCRM

Thank you for your interest in contributing! Here's how to get started.

## Development Setup

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/livestock-crm.git
   cd livestock-crm
   ```
3. **Install** dependencies:
   ```bash
   pnpm install
   ```
4. **Configure** environment variables (see `README.md`)
5. **Start** the development server:
   ```bash
   pnpm dev
   ```

## Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Production-ready code |
| `develop` | Integration branch for features |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `chore/*` | Maintenance tasks |

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

[optional body]
[optional footer]
```

### Types

| Type | Description |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Code style (formatting, missing semicolons, etc.) |
| `refactor` | Code refactoring |
| `test` | Adding or updating tests |
| `chore` | Build process or tooling changes |

### Examples

```bash
git commit -m "feat(animals): add bulk import from CSV"
git commit -m "fix(auth): resolve session expiry redirect loop"
git commit -m "docs(readme): update environment variable instructions"
```

## Pull Request Process

1. Ensure your branch is up to date with `main`
2. Run `pnpm lint` and fix any issues
3. Run `pnpm build` to verify the build passes
4. Open a Pull Request with a clear title and description
5. Reference any related issues using `Closes #123`

## Code Style Guidelines

- Use **TypeScript** for all new files
- Follow the existing **component structure** in `src/components/`
- Use **Tailwind CSS** for styling — avoid inline styles
- Use **shadcn/ui** components where possible
- Keep components **small and single-purpose** (< 50 lines)
- Use **optional chaining** (`?.`) when accessing nested object properties
- Add `"use client"` directive only when the component requires browser APIs or React hooks

## Reporting Issues

When reporting a bug, please include:
- Steps to reproduce
- Expected behavior
- Actual behavior
- Browser and OS version
- Screenshots if applicable

## Feature Requests

Open a GitHub Issue with the label `enhancement` and describe:
- The problem you're trying to solve
- Your proposed solution
- Any alternatives you've considered

---

Thank you for helping make LivestockCRM better! 🐄
