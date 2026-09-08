# Contributing to ShopVerse

Thanks for helping improve ShopVerse. This guide keeps changes easy to review and helps contributors validate both the Flutter client and Node.js API before opening a pull request.

## Development workflow

1. Fork the repository and clone your fork.
2. Create a focused branch from `main`:
   ```bash
   git checkout -b feature/short-description
   ```
3. Install the dependencies for the area you are changing.
4. Make the smallest practical change and update documentation when behavior changes.
5. Run the relevant checks locally.
6. Commit with a clear message that describes the change.
7. Push the branch and open a pull request against `main`.

## Flutter checks

From `mobile/`:

```bash
flutter pub get
flutter analyze
flutter test
```

If you change platform-specific code, also verify the affected target when a suitable development environment is available.

## Backend checks

From `backend/`:

```bash
npm install
node src/server.js
```

Confirm the API starts successfully and, when the server is running locally, verify the health endpoint:

```bash
curl http://localhost:4000/api/health
```

## Pull request checklist

Before opening a PR, make sure:

- [ ] The change has a focused purpose.
- [ ] Existing behavior was preserved unless the PR intentionally changes it.
- [ ] Relevant Flutter analysis/tests were run.
- [ ] Backend startup or API checks were run when applicable.
- [ ] Documentation was updated when needed.
- [ ] No secrets, API keys, passwords, or local configuration files were committed.
- [ ] The PR description explains what changed and how it was tested.

## Commit and review guidance

Prefer small, descriptive commits and avoid mixing unrelated refactors with feature or bug-fix work. Reviewers should be able to understand the intent of the PR without reconstructing a large unrelated change.

For larger changes, describe the motivation, implementation approach, testing performed, and any follow-up work in the PR description.
