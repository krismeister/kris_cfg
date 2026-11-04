# AGENTS.md

Personal dotfiles repo (public). Each subdirectory mirrors one software's
live config; root `install.sh` backs up originals and symlinks tracked
files into place.

## Security rules

- Never commit sensitive data: credentials, tokens, API keys, private
  keys, auth files, or personal information (including agent memory files).
- `.gitignore` already blocks `muse/auth.json`, `muse/trust.json`, and
  `*.bak.*`. When adding a software, extend it for that tool's secrets.
- This repo is public. If in doubt whether something is sensitive, do not
  commit it — ask.

## Before every commit

Always run the guardrail against the staged changes:

```sh
./check-secrets.sh
```

- Exit 0 means clean — proceed.
- Any finding means stop: do not commit, unstage or remove the flagged
  content, and report what was found.
