# Skill Consolidation Report

Date: 2026-05-04

## Method

This run followed category-level full reading. Before each source skill was disabled, its SKILL.md was read completely and hashed. The complete source folder was copied into the retained keeper skill under references/imported-variants-2026-05-04/, then moved to C:\Users\mengde\.codex\skills.disabled\2026-05-04\. No skill was permanently deleted.

## Result

- active_skill_directories_after_initial_consolidation: 283
- active_skill_md_after_initial_consolidation: 281
- active_skill_directories_after_final_fit_map: 284
- active_skill_md_after_final_fit_map: 284
- disabled_this_run: 175
- inventory_before: docs/skill-inventory-2026-05-04.json
- validation_after_initial_consolidation: 281 active skills checked with `skill-creator/scripts/quick_validate.py`; 0 failed
- synthesized_insight_files: 105 keepers now include `references/imported-variants-2026-05-04/synthesized-insights.md`
- direct_keeper_rule_updates: 108 keeper `SKILL.md` files received explicit category-specific merged rules, not just imported folders
- imported_variant_active_skill_md_after: 0 nested imported variant `SKILL.md` files remain discoverable; imported copies were renamed to `SOURCE_SKILL.md`

## Disabled By Category

- aris-base: 67
- aris-review-overlay: 23
- coding-review: 4
- context-mode-ops: 5
- oh-my-codex-plugin: 29
- paper-writing: 1
- security-review: 1
- trellis-archive: 1
- trellis-platform: 35
- trellis-rename: 3
- uiux: 6

## Keeper Policy

- ARIS: keep aris-skills-codex-*; import and disable base plus Gemini/Claude review overlays when a Codex keeper exists.
- oh-my-codex: keep omx-*; import and disable omx-plugin-*, except review/security plugin variants were imported into the final keeper.
- Trellis: keep Codex template skills and short renamed trellis-contribute, trellis-first-principles-thinking, trellis-python-design; import and disable non-Codex platform duplicates.
- context-mode: keep context-mode-context-mode and context-mode-context-mode-ops; import and disable command-fragment skills.
- UI/UX: keep uipro-ui-ux-pro-max as UI/UX review/build keeper; import and disable overlapping UI review skills.
- Coding/security: keep coding-workflow and security-best-practices; import and disable overlapping code/security review skills.
- Paper writing: keep ai-research-20-ml-paper-writing-ml-paper-writing; import and disable overlapping claude-scholar-ml-paper-writing.

## Actual Merge Correction

The initial 2026-05-04 pass only copied variant folders into keeper references before disabling duplicates. That was insufficient because the unique mechanisms were not synthesized into keeper behavior. The correction pass did two things:

- Generated `synthesized-insights.md` for every keeper with imported variants. These files are synthesized from full reads of the disabled source `SKILL.md` files and extract trigger deltas, unique headings, actionable checks, workflow excerpts, output contracts, and reusable resource pointers.
- Replaced the earlier generic `Merged Imported Variant Rules` sections with category-specific merge sections. These sections live in the keeper `SKILL.md` files and encode actual behavior changes for UI/UX, coding/debug/review, security, context-mode ops, scholar writing, oh-my-codex, Trellis, and ARIS.
- Renamed imported source copies from `SKILL.md` to `SOURCE_SKILL.md` under `references/imported-variants-2026-05-04/`. This preserves rollback evidence while preventing imported copies from remaining active as separate skills in future sessions.

The disabled folders and imported source copies remain only as rollback/deep-reference material. The keeper skill now contains direct rules derived from the disabled skills instead of merely pointing at a passive archive.

## Verification After Direct Merge

- `nested_imported_skill_md=0`
- `active_keepes_with_old_generic_merge=0`
- `manual_consolidated=108`
- `checked=281`
- `failed=0`

## Project-Level Migration

User preference was corrected from global-only skills to project-level skills.
The consolidated active skills were copied from
`C:\Users\mengde\.codex\skills` into `D:\Code\Playgroud\.codex\skills`.
After hash verification, the original global active skill folders were moved
to `C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration`.
They were not deleted, but they no longer trigger globally.

Migration verification:

- project_top_skill_dirs: 281
- project_SKILL_md: 281
- imported_variant_active_SKILL_md: 0
- imported_variant_SOURCE_SKILL_md: 175
- project_total_files: 1829
- global_to_project_hash_mismatch: 0
- remaining_global_active_skills: 0
- global_migration_backup_skills: 281
- project validation: 281 checked, 0 failed with `skill-creator/scripts/quick_validate.py`

## Manual Category Rework

After user review, the UI/UX category was reworked again because the previous
105-file pass was still too mechanical. This category was handled by reading the
keeper and all six disabled source `SKILL.md` files, then replacing the generic
generated merge block in `uipro-ui-ux-pro-max/SKILL.md` with a hand-merged
`Consolidated UI/UX Skill Merge` section.

Read source evidence:

| Source | Lines | SHA-256 prefix | Retained mechanism |
| --- | ---: | --- | --- |
| `claude-scholar-frontend-design` | 44 | `0798116511AE29CA` | deliberate aesthetic direction; avoid generic AI visual defaults |
| `claude-scholar-ui-ux-pro-max` | 137 | `EA3A24F41BF50B72` | design-system-first workflow; targeted domain/stack lookup |
| `claude-scholar-web-design-reviewer` | 370 | `A18D72051FFA2C65` | running target, screenshots, source-file detection, before/after verification |
| `omx-frontend-ui-ux` | 35 | `7AD70E56F87A2B31` | designer route, narrowed to explicit/justified specialist use |
| `omx-visual-ralph` | 160 | `ED6344A37BCCC813` | approved visual reference, visual iteration loop, design token extraction |
| `omx-visual-verdict` | 83 | `F57F3CB72EE030B7` | JSON visual verdict, score threshold, pixel diff as secondary evidence |

Validation after this manual category merge:

- `python -X utf8 C:\Users\mengde\.codex\skills\.system\skill-creator\scripts\quick_validate.py C:\Users\mengde\.codex\skills\uipro-ui-ux-pro-max`
- result: `Skill is valid!`

Additional category rewrites completed after the UI/UX correction:

| Category | Keeper files changed | Source files merged | Main section |
| --- | ---: | ---: | --- |
| coding/debug/review | 1 | 5 | `Consolidated Coding / Debug / Review Merge` |
| security review | 1 | 2 | `Consolidated Security Review Merge` |
| context-mode ops | 1 | 5 | `Consolidated Context-Mode Ops Merge` |
| scholar writing | 1 | 1 | `Consolidated Scholar Writing Merge` |
| oh-my-codex plugin duplicates | 25 | 25 | `Consolidated OMX Plugin Merge` |
| Trellis platform/rename/archive duplicates | 11 | 39 | `Consolidated Trellis Skill Merge` |
| ARIS base and review overlays | 67 | 90 | `Consolidated ARIS Source Merge` |

Validation after all category rewrites:

- `active_keepes_with_old_generic_merge=0`
- `Consolidated UI/UX Skill Merge=1`
- `Consolidated Coding / Debug / Review Merge=1`
- `Consolidated Security Review Merge=1`
- `Consolidated Context-Mode Ops Merge=1`
- `Consolidated Scholar Writing Merge=1`
- `Consolidated OMX Plugin Merge=25`
- `Consolidated Trellis Skill Merge=11`
- `Consolidated ARIS Source Merge=67`
- `checked=281`
- `failed=0`

## Detailed Disabled Skills

- [aris-base] aris-ablation-planner
- [aris-base] aris-alphaxiv
- [aris-base] aris-analyze-results
- [aris-base] aris-arxiv
- [aris-base] aris-auto-paper-improvement-loop
- [aris-base] aris-auto-review-loop
- [aris-base] aris-auto-review-loop-llm
- [aris-base] aris-auto-review-loop-minimax
- [aris-base] aris-citation-audit
- [aris-base] aris-claims-drafting
- [aris-base] aris-comm-lit-review
- [aris-base] aris-deepxiv
- [aris-base] aris-dse-loop
- [aris-base] aris-embodiment-description
- [aris-base] aris-exa-search
- [aris-base] aris-experiment-audit
- [aris-base] aris-experiment-bridge
- [aris-base] aris-experiment-plan
- [aris-base] aris-experiment-queue
- [aris-base] aris-feishu-notify
- [aris-base] aris-figure-description
- [aris-base] aris-figure-spec
- [aris-base] aris-formula-derivation
- [aris-base] aris-grant-proposal
- [aris-base] aris-idea-creator
- [aris-base] aris-idea-discovery
- [aris-base] aris-idea-discovery-robot
- [aris-base] aris-invention-structuring
- [aris-base] aris-jurisdiction-format
- [aris-base] aris-mermaid-diagram
- [aris-base] aris-meta-optimize
- [aris-base] aris-monitor-experiment
- [aris-base] aris-novelty-check
- [aris-base] aris-overleaf-sync
- [aris-base] aris-paper-claim-audit
- [aris-base] aris-paper-compile
- [aris-base] aris-paper-figure
- [aris-base] aris-paper-illustration
- [aris-base] aris-paper-plan
- [aris-base] aris-paper-poster
- [aris-base] aris-paper-slides
- [aris-base] aris-paper-write
- [aris-base] aris-paper-writing
- [aris-base] aris-patent-novelty-check
- [aris-base] aris-patent-pipeline
- [aris-base] aris-patent-review
- [aris-base] aris-pixel-art
- [aris-base] aris-prior-art-search
- [aris-base] aris-proof-checker
- [aris-base] aris-proof-writer
- [aris-base] aris-qzcli
- [aris-base] aris-rebuttal
- [aris-base] aris-research-lit
- [aris-base] aris-research-pipeline
- [aris-base] aris-research-refine
- [aris-base] aris-research-refine-pipeline
- [aris-base] aris-research-review
- [aris-base] aris-research-wiki
- [aris-base] aris-result-to-claim
- [aris-base] aris-run-experiment
- [aris-base] aris-semantic-scholar
- [aris-base] aris-serverless-modal
- [aris-base] aris-specification-writing
- [aris-base] aris-system-profile
- [aris-base] aris-training-check
- [aris-base] aris-vast-gpu
- [aris-base] aris-writing-systems-papers
- [aris-review-overlay] aris-skills-codex-claude-review-auto-paper-improvement-loop
- [aris-review-overlay] aris-skills-codex-claude-review-auto-review-loop
- [aris-review-overlay] aris-skills-codex-claude-review-novelty-check
- [aris-review-overlay] aris-skills-codex-claude-review-paper-figure
- [aris-review-overlay] aris-skills-codex-claude-review-paper-plan
- [aris-review-overlay] aris-skills-codex-claude-review-paper-write
- [aris-review-overlay] aris-skills-codex-claude-review-research-refine
- [aris-review-overlay] aris-skills-codex-claude-review-research-review
- [aris-review-overlay] aris-skills-codex-gemini-review-auto-paper-improvement-loop
- [aris-review-overlay] aris-skills-codex-gemini-review-auto-review-loop
- [aris-review-overlay] aris-skills-codex-gemini-review-grant-proposal
- [aris-review-overlay] aris-skills-codex-gemini-review-idea-creator
- [aris-review-overlay] aris-skills-codex-gemini-review-idea-discovery
- [aris-review-overlay] aris-skills-codex-gemini-review-idea-discovery-robot
- [aris-review-overlay] aris-skills-codex-gemini-review-novelty-check
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-figure
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-plan
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-poster
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-slides
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-write
- [aris-review-overlay] aris-skills-codex-gemini-review-paper-writing
- [aris-review-overlay] aris-skills-codex-gemini-review-research-refine
- [aris-review-overlay] aris-skills-codex-gemini-review-research-review
- [coding-review] claude-scholar-bug-detective
- [coding-review] claude-scholar-code-review-excellence
- [coding-review] omx-code-review
- [coding-review] omx-review
- [context-mode-ops] context-mode-ctx-doctor
- [context-mode-ops] context-mode-ctx-insight
- [context-mode-ops] context-mode-ctx-purge
- [context-mode-ops] context-mode-ctx-stats
- [context-mode-ops] context-mode-ctx-upgrade
- [oh-my-codex-plugin] omx-plugin-ai-slop-cleaner
- [oh-my-codex-plugin] omx-plugin-analyze
- [oh-my-codex-plugin] omx-plugin-ask-claude
- [oh-my-codex-plugin] omx-plugin-ask-gemini
- [oh-my-codex-plugin] omx-plugin-autopilot
- [oh-my-codex-plugin] omx-plugin-autoresearch
- [oh-my-codex-plugin] omx-plugin-cancel
- [oh-my-codex-plugin] omx-plugin-code-review
- [oh-my-codex-plugin] omx-plugin-configure-notifications
- [oh-my-codex-plugin] omx-plugin-deep-interview
- [oh-my-codex-plugin] omx-plugin-doctor
- [oh-my-codex-plugin] omx-plugin-help
- [oh-my-codex-plugin] omx-plugin-hud
- [oh-my-codex-plugin] omx-plugin-note
- [oh-my-codex-plugin] omx-plugin-omx-setup
- [oh-my-codex-plugin] omx-plugin-pipeline
- [oh-my-codex-plugin] omx-plugin-plan
- [oh-my-codex-plugin] omx-plugin-ralph
- [oh-my-codex-plugin] omx-plugin-ralplan
- [oh-my-codex-plugin] omx-plugin-security-review
- [oh-my-codex-plugin] omx-plugin-skill
- [oh-my-codex-plugin] omx-plugin-team
- [oh-my-codex-plugin] omx-plugin-trace
- [oh-my-codex-plugin] omx-plugin-ultraqa
- [oh-my-codex-plugin] omx-plugin-ultrawork
- [oh-my-codex-plugin] omx-plugin-visual-ralph
- [oh-my-codex-plugin] omx-plugin-visual-verdict
- [oh-my-codex-plugin] omx-plugin-wiki
- [oh-my-codex-plugin] omx-plugin-worker
- [paper-writing] claude-scholar-ml-paper-writing
- [security-review] omx-security-review
- [trellis-archive] trellis-.trellis-tasks-archive-2026-01-01-19-readme-redesign-taosu-bootstrap-skill
- [trellis-platform] trellis-.agents-skills-trellis-before-dev
- [trellis-platform] trellis-.agents-skills-trellis-brainstorm
- [trellis-platform] trellis-.agents-skills-trellis-break-loop
- [trellis-platform] trellis-.agents-skills-trellis-check
- [trellis-platform] trellis-.agents-skills-trellis-finish-work
- [trellis-platform] trellis-.agents-skills-trellis-meta
- [trellis-platform] trellis-.agents-skills-trellis-update-spec
- [trellis-platform] trellis-.claude-skills-contribute
- [trellis-platform] trellis-.claude-skills-first-principles-thinking
- [trellis-platform] trellis-.claude-skills-python-design
- [trellis-platform] trellis-.claude-skills-trellis-before-dev
- [trellis-platform] trellis-.claude-skills-trellis-brainstorm
- [trellis-platform] trellis-.claude-skills-trellis-break-loop
- [trellis-platform] trellis-.claude-skills-trellis-check
- [trellis-platform] trellis-.claude-skills-trellis-meta
- [trellis-platform] trellis-.claude-skills-trellis-update-spec
- [trellis-platform] trellis-.cursor-skills-trellis-before-dev
- [trellis-platform] trellis-.cursor-skills-trellis-brainstorm
- [trellis-platform] trellis-.cursor-skills-trellis-break-loop
- [trellis-platform] trellis-.cursor-skills-trellis-check
- [trellis-platform] trellis-.cursor-skills-trellis-meta
- [trellis-platform] trellis-.cursor-skills-trellis-update-spec
- [trellis-platform] trellis-.opencode-skills-trellis-before-dev
- [trellis-platform] trellis-.opencode-skills-trellis-brainstorm
- [trellis-platform] trellis-.opencode-skills-trellis-break-loop
- [trellis-platform] trellis-.opencode-skills-trellis-check
- [trellis-platform] trellis-.opencode-skills-trellis-meta
- [trellis-platform] trellis-.opencode-skills-trellis-update-spec
- [trellis-platform] trellis-.pi-skills-trellis-before-dev
- [trellis-platform] trellis-.pi-skills-trellis-brainstorm
- [trellis-platform] trellis-.pi-skills-trellis-break-loop
- [trellis-platform] trellis-.pi-skills-trellis-check
- [trellis-platform] trellis-.pi-skills-trellis-meta
- [trellis-platform] trellis-.pi-skills-trellis-update-spec
- [trellis-platform] trellis-packages-cli-src-templates-common-bundled-skills-trellis-meta
- [trellis-rename] trellis-.agents-skills-contribute
- [trellis-rename] trellis-.agents-skills-first-principles-thinking
- [trellis-rename] trellis-.agents-skills-python-design
- [uiux] claude-scholar-frontend-design
- [uiux] claude-scholar-ui-ux-pro-max
- [uiux] claude-scholar-web-design-reviewer
- [uiux] omx-frontend-ui-ux
- [uiux] omx-visual-ralph
- [uiux] omx-visual-verdict

## Rollback

For project-level migration rollback, move folders from
`C:\Users\mengde\.codex\skills.disabled\2026-05-04-project-level-migration\<skill>`
back to `C:\Users\mengde\.codex\skills\<skill>` and remove or move
`D:\Code\Playgroud\.codex\skills`.

Move folders from C:\Users\mengde\.codex\skills.disabled\2026-05-04\<category>\<skill> back to C:\Users\mengde\.codex\skills\<skill>. If a keeper was edited, remove its Consolidated External Variants section and optional references/imported-variants-2026-05-04/ folder after restoring the original skill.

## Final Fit Map Re-review

This pass re-reviewed the project active skills and the 2026-05-04 disabled
candidate pool against the corrected rule: only identical trigger, input,
output, and execution path is a duplicate. Stage, product, tool, provider,
ecosystem, and abstraction differences are retained or explicitly modeled.

Full fit map: `docs/skill-inventory-2026-05-04.json`.

Current counts:

- active project skills: 284
- disabled candidates re-reviewed: 175
- active skill role missing: 0
- active skill name duplicates: 0
- active imported-variant `SKILL.md`: 0
- restored or rebuilt active boundaries: 6
- removed active facade / deprecated duplicate: 3

Active roles:

- `primary`: 7
- `pipeline`: 14
- `provider_variant`: 87
- `stage_specialist`: 74
- `domain_specialist`: 50
- `service_adapter`: 2
- `command_adapter`: 49
- `output_contract`: 1

Disabled conclusions:

- `merged_into_keeper`: 40
- `restore_active`: 2
- `reference_only`: 1
- `platform_duplicate`: 102
- `distribution_duplicate`: 30

Corrections from the earlier consolidation:

- `context-mode-ctx-doctor`, `ctx-stats`, `ctx-insight`, `ctx-purge`, and
  `ctx-upgrade` are no longer hidden inside the heavy GitHub ops skill. They are
  modeled by `context-mode-command-adapters`.
- `omx-visual-verdict` is restored as an `output_contract`, because the JSON
  verdict can be used without loading the full UI/UX primary skill.
- `omx-visual-ralph` is restored as a `stage_specialist`, because the
  reference-driven UI loop has a distinct lifecycle and output boundary.
- `omx-swarm` was a pure compatibility facade and is merged into `omx-team`.
  Swarm requests route to the team lifecycle.
- `omx-web-clone` was a deprecated duplicate route and is removed from active
  skills. Live-URL visual implementation now routes to `omx-visual-ralph`.
- `claude-scholar-daily-coding` was an ordinary coding duplicate and is removed
  from active skills. Its read-before-edit, minimal-change, type-safety,
  security, and cleanup checks were merged into `coding-workflow`.
- Path-like Trellis skill names were shortened to Codex project names, for
  example `trellis-before-dev`, `trellis-check`, and `trellis-start`; each file
  records its former path-like name for compatibility.
- `vibe-kanban-service` and `aris-watchdog-service` were added as explicit
  original-service adapters, separate from the local Markdown workflows.
- `workspace-state-workflow` was added as the local Markdown state workflow for
  task board, attempt, recover, research queue, review gate, and run log.
- `knowledge-capture` now carries the obsidian-skills promotion lifecycle and
  the boundary between repository ledger and external Obsidian vault.
- `context-mode-context-mode` was narrowed from a broad default-for-all-commands
  primary skill into a `command_adapter` for large-output processing only.
- `doc` was narrowed from a second office primary into a DOCX
  `stage_specialist`; `office-workflow` remains the broader office keeper.
- `research-workflow` is now the primary research workflow and routes specialized
  AI-Research, ARIS, Zotero, and claude-scholar work to narrower skills.
- UIPro boundary fixes now keep `uipro-ui-ux-pro-max` as the broad UI/UX primary,
  `uipro-ui-styling` as shadcn/Radix/Tailwind implementation, `uipro-design`
  as non-UI visual assets, `uipro-design-system` as token architecture, and
  `uipro-slides` as presentation generation.
- `playwright` and `playwright-interactive` now model CLI automation versus
  persistent js_repl browser/Electron QA as separate roles.

Provider and pipeline decisions:

- ARIS Claude/Gemini review overlays remain disabled but are not treated as
  ordinary duplicates. Their provider-selection differences are retained in the
  corresponding ARIS keepers; restore as separate provider variants only if a
  future task needs independent model-specific trigger behavior.
- AI research provider/tool variants are active because they represent different
  frameworks, services, or implementation ecosystems.
- Single-step paper skills and full pipelines are both retained, with trigger
  descriptions narrowed so section drafting, full paper generation, slides, and
  systems-paper writing do not compete for the same request.
- ARIS and AI-Research presentation skills are retained as ecosystem variants:
  ARIS owns stateful paper-slide workflow; AI-Research owns lightweight
  conference talk guidance outside ARIS.

Latest validation:

- `quick_validate.py`: 284 checked, 0 failed.
- active skill role missing: 0.
- active skill name duplicates: 0.
- active imported-variant `SKILL.md`: 0.
