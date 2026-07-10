---
title: "HypatiaX Tutorial 2: Running Benchmark Experiments"
date: 2026-02-21
permalink: /tutorials/hypatiax/experiments/
layout: single
classes:
  - inner-page
  - header-image-readability
author_profile: true
author: HypatiaX Team
header:
  overlay_image: /assets/images/tutorials/hypatiax-experiments-banner.png
  overlay_filter: 0.5
  caption: "Reproduce the benchmark test suite from the JMLR paper — Core 15, DeFi 74-case, and Feynman SR"
sidebar:
  nav: "tutorials"
toc: true
toc_label: "Contents"
toc_icon: "cog"
categories: [machine-learning, tutorials, symbolic-regression]
tags: [hypatiax, benchmarks, reproducibility, experiments]
---

# HypatiaX Tutorial 2: Running Benchmark Experiments

**Time:** 45 minutes (active) + 3–8 hours (compute)  
**Difficulty:** Intermediate  
**Previous:** [Tutorial 1: Environment Setup](/tutorials/hypatiax/setup/)  
**Next:** [Tutorial 3: Analysis and Visualization](/tutorials/hypatiax/analysis/)

> **v2 Note (March 2026):** A measurement bug in `evaluate_llm_formula` was
> corrected before paper submission (see `sec:r2_bugfix` in the paper). Use
> the `--v2` flag on all benchmark commands below to ensure the corrected
> evaluation harness is used. Results generated before March 2026 should be
> regenerated.

---

## Overview

This tutorial reproduces the three benchmark evaluations from the JMLR paper:

| Benchmark | Equations | Primary metric | Section |
|---|---|---|---|
| **Core 15** | 15 across 4 domains | Extrapolation error (%) | §6.4 |
| **DeFi Extrapolation** | 74 test cases | R²>0.99 at fixed n=74 | §6.5 |
| **Feynman SR** | 30-equation subset | Recovery rate at R²>0.9999 | §5.8 |

**Key results to reproduce:**
- Core 15: HypatiaX median extrapolation error < 10⁻¹², Mann-Whitney U=0, p<10⁻⁶
- DeFi: HypatiaX 89.2% R²>0.99 vs Pure LLM 62.2% (fixed n=74 denominator, post routing fixes)
- Feynman: HypatiaX 9/30 (30.0%) under aggressive PCA-directed extrapolation protocol, comparable to AI Feynman 2.0

---

## Reproducibility Repository

All experiments run from the dedicated reproducibility repo:

```bash
git clone https://github.com/sednabcn/LLM-HypatiaX-REPRO.git
cd LLM-HypatiaX-REPRO
pip install -r requirements.txt
```

### Full pipeline (recommended)

The full pipeline is driven by `run_all.sh`, a single bash script that runs
every step end-to-end (environment check → benchmarks → tables/figures →
validation → audit). There is no separate `run_all_checkpoint.py` — that
script does not exist in this repo. Steps are selected with `--step` /
`--from`, or a bare step name:

```bash
# Full pipeline — every step, in order
bash run_all.sh

# Resume from a given step onward (e.g. after an interruption during exp2)
bash run_all.sh --from exp2

# Run a single step only (e.g. DeFi benchmark)
bash run_all.sh --step exp1b
# equivalently, as a bare argument:
bash run_all.sh exp1b

# Preview what a run would execute, without running anything
bash run_all.sh --dry-run
```

**Pipeline step IDs** (use with `--step` or `--from`):

```
env_check  exp1  exp1b  exp1_ablation  exp1_pca  exp1b_pca  extrap
hybrid_all_domains  instability  exp2_feynman  exp2_feynman_pca_4060
exp2_feynman_extrap  exp2  exp3  exp3b  suppA  suppB  suppB_sc
tables  figures  validate  qualify  audit_paper  audit_setup
audit_nb01  audit_nb02  audit_nb03  audit_nb04  audit_nb05
audit_nb06_fixc3_disclosure  audit_nb06_fixc3_rerun  audit_guard
audit_print_verify  audit_print_findings  audit_figures_tables
audit_final_gate
```

Note: `run_all.sh` has no `--one-equation` smoke-test flag or `--verify-only`
flag. For a quick sanity check, use `--dry-run` to preview a run without
executing it; to check existing results without re-running benchmarks, use
`--step validate` or `--step qualify`.
| Phase 5 | `qualify` `audit_paper` |

Central configuration (seeds, paths, timeouts) lives in `config/repro.yaml`.

---

## Understanding the Test Suite

### Five Experimental Campaigns (131 unique tests)

The paper reports five campaigns totalling 131 unique test instances:

| Campaign | Method | Domain | n |
|---|---|---|---|
| 1 | Pure LLM baseline | Classical science + DeFi | 40* |
| 2 | Pure symbolic (PySR) | Core 15 benchmark | 18 |
| 3 | LLM-guided hybrid | Core 15 benchmark | 30 |
| 4 | DeFi suite | Decentralized finance | 23** |
| 5 | Hybrid LLM+NN (v40) | All domains | 30 |

\* Campaign 1 comprises 20 classical science and 20 DeFi tests; 10 DeFi tests overlap with Campaign 4.  
\*\* 23 unique DeFi equations; the full DeFi extrapolation benchmark runs **74 test cases** (difficulty variants + extrapolation splits) across them.

### Core 15 Benchmark Domains

```
Physics        (3 equations): kinetic energy, gravitational force, ideal gas law
Chemistry      (3 equations): Arrhenius, Henderson-Hasselbalch, Michaelis-Menten
Biology        (3 equations): logistic growth, allometric scaling, population dynamics
DeFi AMM       (3 equations): constant product, price impact, liquidity depth
DeFi Risk      (3 equations): Value-at-Risk, Expected Shortfall, portfolio variance
```

> **Note:** Earlier documentation listed an "Economics" domain. The JMLR paper
> does not have a separate Economics campaign. The five domains are as listed above.

---

## Campaign A: Core 15 Benchmark

### Run All Three Systems

```bash
source venv/bin/activate

python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py \
    --output data/results/core15/ \
    --domains all \
    --parallel 4 \
    --v2
```

**Progress output:**
```
[2026-02-21 10:30:15] HypatiaX Benchmark Suite v2
[2026-02-21 10:30:15] Total problems: 131 (unique)
[2026-02-21 10:30:15] Evaluation harness: v2 (relative R² threshold)

Domain: Physics (3 equations)
  [1/3] mechanics_kinetic_energy .................. ✓ (45.2s, R²=0.9998)
  ...

FINAL RESULTS (Core 15)
============================================================
Hybrid v40 extrapolation: median < 10⁻¹² (n=14)
Neural Net extrapolation: mean 1231%, median 86.7% (n=13)
Mann-Whitney U=0, p=1.11×10⁻⁶ (complete rank separation)
```

### Step-by-Step: Physics Domain

```python
from hypatiax.protocols import experiment_protocol_all_30
from hypatiax.tools.symbolic.hybrid_system_v50_2 import HybridSystem
import json, time, numpy as np

protocol = experiment_protocol_all_30.ExperimentProtocol()
problems = protocol.get_core15_problems()

system = HybridSystem(use_llm=False, symbolic_timeout=600)
results = []

for i, problem in enumerate(problems, 1):
    print(f"\n[{i}/{len(problems)}] {problem['name']}")
    X_train, y_train   = problem['generate_data'](n_samples=200, regime='train')
    X_test,  y_test    = problem['generate_data'](n_samples=50,  regime='test')
    X_extrap, y_extrap = problem['generate_data'](n_samples=50,  regime='extrapolation')

    t0     = time.time()
    result = system.discover(
        X_train=X_train, y_train=y_train,
        X_test=X_test,   y_test=y_test,
        variable_names=problem['variables'],
        problem_description=problem['description']
    )

    y_pred  = result.predict(X_extrap)
    extrap  = np.median(np.abs(y_pred - y_extrap) / np.abs(y_extrap))

    results.append({
        'problem': problem['name'], 'formula': result.formula,
        'r2_test': result.r2_score, 'extrapolation_error': float(extrap),
        'time': time.time() - t0, 'success': result.r2_score >= 0.90
    })

    print(f"  {'✓' if results[-1]['success'] else '✗'} "
          f"R²={result.r2_score:.4f}  extrap={extrap:.2e}  {results[-1]['time']:.1f}s")

with open('data/results/core15_results.json', 'w') as f:
    json.dump(results, f, indent=2)
```

### Sample Result JSON

```json
{
  "problem_id": "chemistry_arrhenius_equation",
  "domain": "chemistry",
  "discovered_formula": "A * exp(-Ea / (R * T))",
  "true_formula": "A * exp(-Ea / (R * T))",
  "exact_match": true,
  "r2_train": 0.9999,
  "r2_test": 0.9995,
  "extrapolation_error": 5.7e-13,
  "discovery_time": 127.3,
  "discovery_path": "symbolic",
  "validation_passed": true
}
```

---

## Campaign B: DeFi Extrapolation Benchmark (74 Cases)

This campaign is distinct from the Core 15 benchmark. Each test case splits
data so the **test set lies outside the training feature range**, directly
probing extrapolation ability. The benchmark includes difficulty variants
and is run across all three methods.

### Key design decisions

- **Denominator:** Use fixed n=74 for all cross-method comparisons (v3.0 benchmark).
  All 74 cases are tractable; 0 cases flagged `extrapolation_intractable`.
- **NaN policy:** NaN results (formula execution failures) count as failures,
  not missing data.
- **Routing improvements:** Fixes 0–5 are applied before running; they improve
  the HypatiaX rate from ~62% to 89.2% R²>0.99.

### Run the DeFi extrapolation benchmark

```bash
python hypatiax/experiments/benchmarks/hypatiax_defi_benchmark_v3c.py \
    --output data/results/defi_extrap/ \
    --v2 \
    --fixed-denominator 74 \
    --nan-penalty      # NaN = failure (honest metric)
```

**Expected output:**
```
DeFi Extrapolation Benchmark (v3.0, n=74 fixed denominator)
=============================================================
HypatiaX  R²>0.99 : 66/74 = 89.2%   ← beats Pure LLM by 27 pp!
Pure LLM  R²>0.99 : 46/74 = 62.2%
Neural Net R²>0.99 :  0/74 =  0.0%
Catastrophic failures (R²<-10): HypatiaX=0, LLM=6, NN=N/A
```

### Python: run a single DeFi case

```python
from hypatiax.protocols import experiment_protocol_defi
from hypatiax.experiments.tests.test_enhanced_defi_extrapolation import EnhancedExtrapolationTest

protocol = experiment_protocol_defi.ExperimentProtocol()
# Load standard cases only (exclude intractable)
problems = [p for p in protocol.get_defi_problems()
            if not p.get('extrapolation_intractable', False)]

print(f"Standard cases: {len(problems)}")   # 66

tester  = EnhancedExtrapolationTest(enable_routing_fixes=True)  # Fixes 0-5 active
results = tester.run_all(problems, methods=['llm', 'hybrid', 'nn'])

# Honest denominator summary
for method in ['llm', 'hybrid', 'nn']:
    method_results = [r for r in results if r['method'] == method]
    passes = sum(1 for r in method_results
                 if r.get('r2_test') is not None and r['r2_test'] >= 0.99)
    nans   = sum(1 for r in method_results if r.get('r2_test') is None)
    print(f"{method.upper():10s}: {passes}/66 = {passes/66*100:.1f}%  "
          f"(NaN failures: {nans})")
```

### Routing improvements summary

| Fix | Change | Measured gain |
|---|---|---|
| 0 | Reserve Ratio / Spot Price: independent log-uniform sampling | +2 pp |
| 0b | IL Breakeven flagged structurally intractable | +1 pp |
| 1 | Extrapolation probe: ΔR²≥0.15 → route to LLM | +6 pp |
| 2 | Transcendental token detection → route to LLM | +5 pp |
| 3 | LLM predictions as NN feature (X_aug) | +1 pp |
| 4 | Distance-gated blend weight | +1 pp |
| 5 (proj.) | Unified formula evaluator + routing guard | +3 pp (projected) |

See `sec:routing` in the paper and [Tutorial 4](/tutorials/hypatiax/extensions/) for implementation details.

---

## Campaign C: Feynman SR Benchmark

The paper evaluates on a 30-equation subset of the Feynman SR Benchmark
(Udrescu & Tegmark 2020), spanning Series I/II/III plus domain extensions
in biology, chemistry, and electrochemistry.

### Run Phase 2 (noisy, practical threshold)

```bash
python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py \
    --methods 1 \
    --samples 200 \
    --no-llm-cache \   # Disable LLM prompt cache; use this for fresh reproducibility runs
    --v2
```

### Run Phase 3 (noiseless, literature-comparable threshold)

```bash
python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py \
    --noiseless \
    --threshold 0.9999 \
    --nn-seeds 3 \
    --samples 200 \
    --method-timeout 900 \
    --pysr-timeout 900 \
    --v2
```

**Expected output (Phase 3, v2 corrected):**
```
Feynman SR Benchmark — Phase 3 (noiseless, aggressive PCA-directed extrapolation)
==================================================================================
HypatiaX      :   9/30 = 30.0%  (comparable to AI Feynman 2.0)
Symbolic only :   8/30 = 26.7%
Neural Net    :   5/30 = 16.7%

Published baselines (under equivalent conditions):
  AI Feynman 2.0 : ~30%
  NeSymReS       : comparable
```

> **Note:** The 30.0% rate reflects HypatiaX's aggressive PCA-directed extrapolation
> protocol (5× training range). Performance under relaxed interpolation thresholds is
> significantly higher. See paper §5.8 for protocol details and the hardware-sensitivity
> note in Appendix B.

### Python: load and display Feynman results

```python
from hypatiax.protocols.experiment_protocol_benchmark_v2 import BenchmarkProtocol

protocol = BenchmarkProtocol(
    benchmark='feynman',
    num_samples=200,
    noiseless=True   # Phase 3
)

equations = protocol.get_feynman_equations()
print(f"Feynman subset: {len(equations)} equations")
print(f"Series I: {sum(1 for e in equations if e.series == 'I')}")
print(f"Series II: {sum(1 for e in equations if e.series == 'II')}")
print(f"Crossover (domain extensions): "
      f"{sum(1 for e in equations if e.series == 'crossover')}")

BenchmarkProtocol.describe()
```

---

## Compare All Three Benchmarks

```python
import pandas as pd

summary = {
    'Core 15 — HypatiaX extrapolation':
        {'metric': 'Median extrap error', 'value': '< 10⁻¹²', 'vs_baseline': 'NN mean: 1231%'},
    'Core 15 — Mann-Whitney U':
        {'metric': 'U statistic', 'value': '0 (complete separation)', 'vs_baseline': 'p < 10⁻⁶'},
    'DeFi 74 — HypatiaX R²>0.99 (n=74)':
        {'metric': 'Recovery rate', 'value': '89.2%', 'vs_baseline': 'LLM: 62.2%'},
    'Feynman — HypatiaX recovery (aggressive protocol)':
        {'metric': 'R²>0.9999 exact recovery', 'value': '30.0%', 'vs_baseline': 'AI Feynman 2.0: ~30%'},
}

df = pd.DataFrame(summary).T
print(df.to_string())
```

---

## Parallel Execution

```python
from multiprocessing import Pool, cpu_count
from functools import partial

def run_single(problem, system):
    result = system.discover(
        X_train=problem['X_train'], y_train=problem['y_train'],
        X_test=problem['X_test'],   y_test=problem['y_test'],
        variable_names=problem['variables']
    )
    return {'problem': problem['name'], 'r2': result.r2_score,
            'time': result.discovery_time}

n_cores = min(4, cpu_count())
system  = HybridSystem(use_llm=False, symbolic_timeout=600)

with Pool(n_cores) as pool:
    results = pool.map(partial(run_single, system=system), all_problems)

print(f"Completed {len(results)} problems on {n_cores} cores")
# 1 core: ~8 hours | 4 cores: ~2.5 hours | 8 cores: ~1.5 hours
```

---

## Checkpointing

For long runs, enable checkpointing to resume if interrupted:

```python
from hypatiax.experiments.benchmarks.run_hybrid_system_benchmark import run_with_checkpoints

results = run_with_checkpoints(
    problems=all_problems,
    checkpoint_file='data/results/checkpoint.json',
    checkpoint_interval=10  # Save every 10 problems
)

# Resume from checkpoint
results = run_with_checkpoints(
    problems=all_problems,
    checkpoint_file='data/results/checkpoint.json',
    resume=True
)
```

---

## Output Files

```
data/results/
├── core15/
│   └── all_domains_extrap_v4_TIMESTAMP.json
├── defi_extrap/
│   ├── consolidated_hybrid_TIMESTAMP.json     ← n=74 fixed denominator (v3.0)
│   └── routing_fix_progression.json           ← per-fix gain tracking
├── feynman/
│   ├── protocol_core_noiseless_20260304_154510.json  ← Phase 3 results
│   └── protocol_core_noisy_TIMESTAMP.json            ← Phase 2 results
└── checkpoint.json
```

---

## Reproducing Paper Statistics Exactly

```bash
python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py \
    --seed 42 \
    --symbolic-timeout 1800 \
    --n-iterations 50 \
    --populations 15 \
    --output data/results/paper_reproduction/ \
    --v2
```

Expected: success rate 95.8%, median extrapolation error < 10⁻¹², Mann-Whitney U=0.

---

## Troubleshooting

### Wrong DeFi numbers

```python
# WRONG: per-method NaN exclusion gives incomparable rates
rate = df[df['method']=='llm']['r2_test'].dropna().gt(0.99).mean()  # inflated!

# CORRECT: fixed denominator, NaN = failure
n_standard = 74
passes = df[df['method']=='llm']['r2_test'].gt(0.99).sum()  # NaN → False
rate = passes / n_standard
```

### Feynman run very slow (Arrhenius hanging)

The Arrhenius equation (test 4) can cause Julia to hang if `--method-timeout`
is not set before test 19. Always use `--method-timeout 900` for the full
30-equation run.

### Some problems fail

Expected. Under the aggressive PCA-directed extrapolation protocol, HypatiaX
recovers 9/30 Feynman equations (30.0%), comparable to AI Feynman 2.0 under
equivalent conditions. Performance is hardware-sensitive; see Appendix B of the
paper. Check `data/results/feynman/` JSON for per-equation details.

### Discovery times too slow

```python
# Reduce symbolic search time for testing
system = HybridSystem(
    symbolic_timeout=300,  # 5 minutes instead of 10
    niterations=30
)
```

### Out of memory

```bash
# Run campaigns sequentially
python run_single_domain.py --domain physics
python run_single_domain.py --domain biology
python run_single_domain.py --domain defi
```

---

## Quick Reference

```bash
# Full benchmark (v2)
python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py --v2

# DeFi benchmark only
python hypatiax/experiments/benchmarks/hypatiax_defi_benchmark_v3c.py --v2 --fixed-denominator 74

# Feynman benchmark (Phase 3)
python hypatiax/experiments/benchmarks/run_comparative_suite_benchmark_v2.py --noiseless --threshold 0.9999 --method-timeout 900 --v2

# Resume interrupted run
bash run_all.sh --from <step>   # e.g. bash run_all.sh --from exp2

# Parallel execution (4 cores)
python run_parallel.py --workers 4
```

---

## Next Steps

✅ You've reproduced all three benchmark evaluations!

1. **[Tutorial 3: Analysis and Visualization](/tutorials/hypatiax/analysis/)** — generate publication figures
2. **[Tutorial 4: Custom Applications](/tutorials/hypatiax/extensions/)** — apply to your domain

---

```bibtex
@article{bonetchaple2026hypatiax,
  title={HypatiaX: A Hybrid Symbolic-Neural Framework for Extrapolation-Reliable Analytical Discovery},
  author={Bonet Chaple, Ruperto Pedro},
  journal={Journal of Machine Learning Research},
  year={2026}
}
```
