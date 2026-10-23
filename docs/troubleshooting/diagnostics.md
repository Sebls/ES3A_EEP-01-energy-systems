# Diagnostic Tools Reference

Caldis includes built-in diagnostic tools (`caldis.core.diagnostics`) to inspect system health, conditioning, and convergence failure points.

---

## 1. Jacobian Structure Report (`jacobian_report`)

```python
from caldis.core.diagnostics import jacobian_report

jacobian_report(system, top=6)
```

Evaluates the finite-difference Jacobian at the current state $x$, balancing rows by residual magnitude and columns by variable scale.

### Output Insights
- **Full Rank**: Confirms the linear system is regular and nonsingular.
- **Rank Deficient**: Computes the Singular Value Decomposition (SVD):
  - **Right null vector**: Lists specific variables that have lost sensitivity and need start re-anchoring.
  - **Left null vector**: Lists the redundant or unconstrained equations.

---

## 2. Convergence Report (`convergence_report`)

```python
from caldis.core.diagnostics import convergence_report

convergence_report(system, sol, top=8)
```

Post-mortem analyzer invoked automatically when `solve()` fails.
- Ranks residuals by **scaled violation magnitude** (normalizing units so mass balances and energy balances are directly comparable).
- Dissects connection mismatches (e.g., showing exact pressure or enthalpy discrepancies across connected ports).
- Identifies any variables stuck against their lower or upper bounds (`v.lower`, `v.upper`).

---

## 3. Structural & Preflight Inspection

### Print Component Hierarchy
```python
sys.structure()
```
Recursively displays the tree of components, child sub-components, ports, and internal variables.

### Pre-solve Sanity Check
```python
sys.check_start_sanity(verbose=True)
```
Evaluates all component-level physical sanity checks against $x_0$ before attempting a solve.

