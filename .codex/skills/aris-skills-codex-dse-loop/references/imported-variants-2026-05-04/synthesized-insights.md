# Synthesized Imported Variant Insights

This file is synthesized from full reads of disabled overlapping skills. Treat these notes as active guidance for the keeper skill, not as an archive. Read the source folders only when this synthesis is insufficient.

Keeper: aris-skills-codex-dse-loop

## How To Apply

- Prefer the keeper skill workflow as the default path.
- Add the trigger phrases, verification checks, output contracts, and resource pointers below when they fit the task.
- If a disabled variant contains scripts, templates, references, examples, or assets, treat them as reusable resources from this keeper skill.
- Do not resurrect a disabled variant as a separate active skill unless the keeper cannot express its behavior cleanly.

## Source: aris-dse-loop

Trigger/description delta: Autonomous design space exploration loop for computer architecture and EDA. Runs a program, analyzes results, tunes parameters, and iterates until objective is met or timeout. Use when user says \"DSE\", \"design space exploration\", \"sweep parameters\", \"optimize\", \"find best config\", or wants iterative parameter tuning.
Actionable imported checks:
- **Objective metric**: what to optimize (and how to extract it from output)
- **Constraints**: hard limits that must not be violated (e.g., timing must close)
- **Infer missing parameter ranges** — If the user provides parameter names but NOT ranges/options, you MUST infer them before exploring:
- How to parse the objective metric from output
- `dse_results/outputs/` — raw output for each run
- **Write a parameter extraction script** (`dse_results/parse_result.py` or similar) that takes a run's output and returns the objective metric as a number. Test it on a baseline run first.
- Avoid re-running configurations already evaluated
- **Run the program**: execute and capture output
- **Parse results**: extract the objective metric and check constraints
- **Check stopping conditions**:
- Resume from next iteration
- Work AUTONOMOUSLY — do not ask the user for permission at each iteration
- **Every run must be logged** — even failed runs, constraint violations, errors. The log is the ground truth.
- **Never re-run an identical configuration** — check `dse_log.csv` before each run
- **Respect the timeout** — check elapsed time before starting a new iteration. If the next run is likely to exceed the timeout, stop and report.
- **Keep raw outputs** — save each run's full output in `dse_results/outputs/iter_N/`
Workflow excerpt to incorporate:
```text
## Workflow
### Phase 0: Parse Task & Setup
1. **Parse $ARGUMENTS** to extract:
   - **Program**: what to run (command, script, or Makefile target)
   - **Parameter space**: which knobs to tune and their ranges/options (may be incomplete — see step 2)
   - **Objective metric**: what to optimize (and how to extract it from output)
   - **Constraints**: hard limits that must not be violated (e.g., timing must close)
   - **Timeout**: wall-clock budget
   - **Success criteria**: when is the result "good enough" to stop early?
2. **Infer missing parameter ranges** — If the user provides parameter names but NOT ranges/options, you MUST infer them before exploring:
   a. **Read the source code** — search for the parameter names in the codebase:
      - Look for argparse/click definitions, config files, Makefile variables, module parameters, `#define`, `parameter` (SystemVerilog), `localparam`, etc.
      - Extract defaults, types, and any comments hinting at valid values
   b. **Apply domain knowledge** to set reasonable ranges:
      | Parameter type | Inference strategy |
      |---------------|-------------------|
      | Cache/memory sizes | Powers of 2, typically 1KB–16MB |
      | Associativity | Powers of 2: 1, 2, 4, 8, 16 |
      | Pipeline width / issue width | Small integers: 1, 2, 4, 8 |
      | Buffer/queue/FIFO depth | Powers of 2: 4, 8, 16, 32, 64 |
      | Clock period / frequency | Based on technology node; try ±50% from default |
      | Bound depth (BMC/formal) | Geometric: 5, 10, 20, 50, 100 |
      | Timeout values | Geometric: 10s, 30s, 60s, 120s, 300s |
      | Boolean/enum flags | Enumerate all options found in source |
      | Continuous (learning rate, threshold) | Log-scale sweep: 5 points spanning 2 orders of magnitude around default |
      | Integer counts (threads, cores) | Linear: from 1 to hardware max |
   c. **Start conservative** — begin with 3-5 values per parameter. Expand range later if the best result is at a boundary.
   d. **Log inferred ranges** — write the inferred parameter space to `dse_results/inferred_params.md` so the user can review:
```
