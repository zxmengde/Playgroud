# Operational Acceptance Trace

## Baseline

- command: `git fetch --all --prune`; `git status --short --branch`; `git branch -vv`; `git log --oneline --decorate -8`
- observed output: current branch is `fix/adoption-proof-state-drift`; HEAD is `93ded58`; branch matches `origin/fix/adoption-proof-state-drift`; `main` and `origin/main` remain at `3d0e91d`; worktree was clean before Phase 1 edits.
- files changed: none during baseline.
- expected state transition: no state transition; only establish facts.
- actual state transition: no state transition.
- result: pass.
- rollback path: none required.

## Probe 1: Task attempt lifecycle

- command: `scripts/codex.ps1 task attempt -Id ATT-20260503-004 ... -Status running`; `scripts/codex.ps1 task recover`; `check-finish-readiness.ps1 -Strict`; `scripts/codex.ps1 task attempt -Id ATT-20260503-004 ... -Status review_needed`; `scripts/codex.ps1 task recover`; `check-finish-readiness.ps1 -Strict`.
- observed output: `task attempt` wrote `updated docs\tasks\attempts.md: ATT-20260503-004`; `task recover` showed latest attempt `ATT-20260503-004` first as `running`, then `review_needed`; strict finish failed while open. After adding `final-claim-manifest.md` and adjusting the file-count eval threshold to 180, strict output reached the intended warnings: working tree dirty, latest task attempt open, active validation pending.
- files changed: `docs/tasks/attempts.md`; `docs/tasks/active.md`; `docs/tasks/board.md`; `docs/validation/final-claim-manifest.md`; `scripts/lib/commands/eval-agent-system.ps1`.
- expected state transition: `ATT-20260503-004` moves `running -> review_needed -> done`; strict finish fails while open and may pass only after terminal status and validation evidence.
- actual state transition: `running -> review_needed -> done` has been observed through public command output; latest attempt is `ATT-20260503-004` with `status: done`.
- result: pass.
- rollback path: remove `ATT-20260503-004` entries before commit, or revert the final commit.

## Probe 2: Knowledge promotion lifecycle

- command: `scripts/codex.ps1 knowledge promote -Id KPL-20260503-002 -Status raw_note ...`; `scripts/codex.ps1 knowledge promote -Id KPL-20260503-002 -Status curated_note ...`; `scripts/codex.ps1 knowledge promote -Id KPL-20260503-002 -Status verified_knowledge ...`; `scripts/codex.ps1 knowledge promotions`; `validate-delivery-system.ps1`.
- observed output: each `knowledge promote` call wrote `updated docs\knowledge\promotion-ledger.md: KPL-20260503-002`; `knowledge promotions` displayed raw, curated and verified records; validator returned `PASS knowledge promotion ledger checked`.
- files changed: `docs/knowledge/promotion-ledger.md`.
- expected state transition: `KPL-20260503-002` moves `raw_note -> curated_note -> verified_knowledge` with non-self evidence; no external Obsidian vault write.
- actual state transition: `raw_note -> curated_note -> verified_knowledge`; evidence points to `docs/knowledge/system-improvement/failures/FAIL-20260503-102000-4a33c5.yaml`, `docs/Codex-adoption-proof-state-drift-audit.md`, and this operational trace, not only to self-referential files.
- result: pass.
- rollback path: remove `KPL-20260503-002` entries before commit, or revert the final commit.

## Probe 3: Research queue review gate

- command: `scripts/codex.ps1 research enqueue -Id RQ-20260503-003 -State queued ...`; `scripts/codex.ps1 research review-gate -Id RQ-20260503-003 -Decision done ...`; `scripts/codex.ps1 research enqueue -Id RQ-20260503-003 -State done ...`; `scripts/codex.ps1 research queue`; `scripts/codex.ps1 research run-log`; `validate-delivery-system.ps1`.
- observed output: enqueue wrote `updated docs\knowledge\research\research-queue.md: RQ-20260503-003`; review gate wrote `updated docs\knowledge\research\run-log.md: review-gate RQ-20260503-003`; queue output shows `state: queued` and later `state: done`; run log shows `decision: done`; validator returned `PASS research queue checked`.
- files changed: `docs/knowledge/research/research-queue.md`; `docs/knowledge/research/run-log.md`.
- expected state transition: `RQ-20260503-003` moves `queued -> review_gate -> done` with run-log consistency; no daemon or unattended runtime claim.
- actual state transition: `queued -> review_gate(done) -> done`; queue and run log both reference `RQ-20260503-003`; authorization boundary remains no external write and no background service.
- result: pass.
- rollback path: remove `RQ-20260503-003` queue and run-log entries before commit, or revert the final commit.

## Probe 4: Negative guard tests

- command: temporary backup under `.cache\negative-guard-backup`; append `KPL-NEG-SELF`; run `validate-delivery-system.ps1`; restore; append `ATT-NEG-OPEN` and temporary final-claim active status; run `check-finish-readiness.ps1 -Strict`; restore; append `RQ-NEG-NO-GATE`; run `validate-delivery-system.ps1`; restore and delete backup.
- observed output: Negative 1 exited 1 and matched `FAIL knowledge promotion proof KPL-NEG-SELF uses self-referential evidence only`; Negative 2 exited 1 and matched open-attempt/final-claim failures; Negative 3 exited 1 and matched `FAIL research queue item RQ-NEG-NO-GATE terminal state lacks review_gate`.
- files changed: temporary mutations to `promotion-ledger.md`, `active.md`, `attempts.md`, `research-queue.md`, `run-log.md`, and this trace; all restored before continuing.
- expected state transition: bad temporary states fail validation or strict finish, then are restored before commit.
- actual state transition: all three bad states failed as expected; final `git status` after restore showed only intended real-task changes, not negative records.
- result: pass.
- rollback path: temporary backups restore `promotion-ledger.md`, `active.md`, `attempts.md`, `research-queue.md`, and `run-log.md`; final fallback is `git restore` for uncommitted negative-state changes.

## Probe 5: Final claim guard

- command: add `docs/validation/final-claim-manifest.md`; update `check-finish-readiness.ps1`; run `check-finish-readiness.ps1 -Strict` while latest attempt was open.
- observed output: strict finish printed manifest fields and failed while latest attempt was `review_needed`; after eval threshold repair, the failure reached the intended warnings rather than a script syntax error.
- files changed: `docs/validation/final-claim-manifest.md`; `scripts/lib/commands/check-finish-readiness.ps1`; `scripts/lib/commands/validate-delivery-system.ps1`.
- expected state transition: `check-finish-readiness.ps1 -Strict` checks `docs/validation/final-claim-manifest.md` fields before allowing final claims.
- actual state transition: strict gate now requires the manifest file, required fields, clean worktree for clean claims, terminal latest attempt for done claims, no pending validation, and true validation fields.
- result: pass.
- rollback path: revert `check-finish-readiness.ps1` and remove `final-claim-manifest.md`.

## Merge Decision

- decision: conditional.
- reason: three positive probes and three negative guards passed; merge to `main` still requires final validation, commit, branch push, fast-forward merge, post-merge validation and main push.

## Rollback

- uncommitted rollback: restore changed files from Git or remove this trace's pending entries.
- committed branch rollback: `git revert <operational-acceptance-commit>`.
- merged main rollback: `git revert <merge-or-fast-forward-commit>` on `main`, then run `validate`, `eval`, `git diff --check`, and strict finish.
