# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-overleaf-sync

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-overleaf-sync

Trigger/description delta: Two-way sync between a local paper directory and an Overleaf project via the Overleaf Git bridge (Premium feature). Lets you keep ARIS audit/edit workflows on the local copy while collaborators edit in the Overleaf web UI. Token never touches the agent — user does the one-time auth via macOS Keychain. Use when user says \"同步 overleaf\", \"overleaf sync\", \"推送到 overleaf\", \"connect overleaf\", \"Overleaf 桥接\", \"pull overleaf\", \"push overleaf\", or wants to bridge their ARIS paper directory with an Overleaf project.
Actionable imported checks:
- A collaborator made changes in Overleaf and you want to pull + diff them before continuing local work
- **CREDENTIAL_HELPER** = `osxkeychain` (macOS) / `manager` (Windows) / `cache` (Linux fallback)
- **TOKEN_HANDLING** = **NEVER write token to disk, env var, or chat**. User pastes it once into the terminal credential prompt; the OS keychain stores it from then on.
- Reads the token from a hidden prompt (no chat history, no shell history)
- Strips the token from the remote URL immediately after cloning
- **Auto-installs a `pre-commit` hook in `paper-overleaf/.git/hooks/` that refuses to commit any blob containing the token pattern `olp_[A-Za-z0-9]{20,}`** — a hard technical block, not a behavioral rule
- **Number changes** that should re-trigger `/paper-claim-audit`
- **Cite key changes** that should re-trigger `/citation-audit`
- `paper-write: regenerated sec/3.assurance after audit cascade refactor`
- **Do not** run `git pull` (which would auto-merge).
- **Do not** run `git reset --hard` or `git push --force` (destructive).
- **Never** ask the user to paste a token into chat. If they do anyway: (a) acknowledge it, (b) tell them to revoke it at https://www.overleaf.com/user/settings, (c) recover via keychain if already primed.
- **Never** write a token to a file (`.env`, `.netrc`, `tools/*.sh`, etc.) committed to any repo.
- **Never** include a token in a `git remote -v` URL — strip it after clone.
- On `401 Unauthorized` from push/pull, tell the user the keychain entry expired and to re-run `overleaf_setup.sh`. Do **not** ask for a fresh token.
- If the user is in an active Overleaf editing session, ARIS skills should **read-only** access `paper/` until the user runs `/overleaf-sync pull`.
- If ARIS is in the middle of `/auto-paper-improvement-loop` or `/paper-write`, the user should pause Overleaf editing until the loop finishes and `/overleaf-sync push` is run.
- `paper-overleaf/` directory at repo root, git clone of Overleaf project (origin URL has NO token)
