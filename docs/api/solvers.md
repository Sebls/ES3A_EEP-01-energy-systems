# Solvers & Autostart API Reference

!!! note "Document Type: Reference"
    Information-oriented technical reference for steady-state Newton routines, homotopy continuation, dynamic DAE integration, and the automatic start point inference engine.

---

## Solvers (`caldis.solvers`)

### `solve`

```python
caldis.solvers.solve(
    system: System,
    steps: int = 3,
    verbose: bool = True,
    show_homotopy: bool = False,
    diagnostics: bool = True,
    raise_on_fail: bool = False,
    strict_physical: bool = False,
    try_newton_first: bool = True
) -> NewtonResult
```

Solves a square algebraic system of equations using a multi-stage solver strategy.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `system` | `System` | *required* | The assembled thermodynamic system model. |
| `steps` | `int` | `3` | Number of intermediate continuation intervals if homotopy fallback triggers. |
| `verbose` | `bool` | `True` | Prints iteration logs and solver status messages. |
| `show_homotopy` | `bool` | `False` | Displays detailed per-stage continuation progress. |
| `diagnostics` | `bool` | `True` | Runs Jacobian singular-value condition reporting and DOF preflight. |
| `raise_on_fail` | `bool` | `False` | Raises `RuntimeError` if solver fails instead of returning `success=False`. |
| `strict_physical` | `bool` | `False` | Rejects converged solutions if physical-validity checks fail (e.g. temperature crossings). |
| `try_newton_first` | `bool` | `True` | Attempts direct damped Newton before invoking homotopy continuation. |

**Returns:** [`NewtonResult`](file:///Users/usuario/Documents/github/energy-systems/docs/api/solvers.md#newtonresult) containing:
- `success: bool`: Convergence status flag.
- `x: np.ndarray`: Final variable vector values.
- `nit: int`: Total Newton iterations consumed.
- `message: str`: Solver termination diagnostic description.
- `physical: bool`: Whether physical sanity checks (no temp cross, positive density) passed.

---

### `simulate`

```python
caldis.solvers.simulate(
    system: System,
    t_end: float,
    dt: float,
    update_inputs: Optional[Callable[[float, System], None]] = None,
    init: str = "steady",
    tol: float = 1e-8,
    progress: bool = False
) -> Results
```

Integrates an index-1 differential-algebraic equation (DAE) system over time.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `system` | `System` | *required* | System containing differential variables (e.g. tanks, storage). |
| `t_end` | `float` | *required* | End simulation time in seconds ($\text{s}$). |
| `dt` | `float` | *required* | Fixed or nominal time step in seconds ($\text{s}$). |
| `update_inputs` | `Optional[Callable]` | `None` | Callback `f(t, sys)` invoked at every step to update time-dependent boundary conditions. |
| `init` | `str` | `"steady"` | Initialization strategy (`"steady"` to compute steady start or `"keep"` to keep starts). |
| `tol` | `float` | `1e-8` | Local algebraic Newton tolerance per time step. |
| `progress` | `bool` | `False` | Displays a console progress bar. |

**Returns:** `Results` object containing timeline history arrays for all differential and algebraic unknowns.

---

## Autostart (`caldis.solvers.autostart`)

### `autostart`

```python
caldis.solvers.autostart.autostart(
    sys: System,
    T_default: float = 283.15,
    verbose: bool = False
) -> None
```

Infers initial guess values across the entire network using deterministic fixpoint propagation rules.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `sys` | `System` | *required* | System whose unknown variables need initial guess values. |
| `T_default` | `float` | `283.15` | Default fallback temperature in $\text{K}$ (10 °C). |
| `verbose` | `bool` | `False` | Prints each propagated variable and its assigned provenance level. |

---

### `fix_port`

```python
caldis.solvers.autostart.fix_port(
    system: System,
    port: FluidPort,
    p: Optional[float] = None,
    T: Optional[float] = None,
    h: Optional[float] = None,
    mdot: Optional[float] = None
) -> None
```

Applies a design target constraint to a port and sets its starting guess with high provenance (`BOUNDARY`).

| Parameter | Type | Default | Units | Description |
| :--- | :--- | :--- | :--- | :--- |
| `system` | `System` | *required* | $-$ | Target system container. |
| `port` | `FluidPort` | *required* | $-$ | Fluid port to constrain. |
| `p` | `Optional[float]` | `None` | $\text{Pa}$ | Imposed target pressure. |
| `T` | `Optional[float]` | `None` | $\text{K}$ | Imposed target temperature (converted to enthalpy via backend). |
| `h` | `Optional[float]` | `None` | $\text{J/kg}$ | Imposed target specific enthalpy. |
| `mdot` | `Optional[float]` | `None` | $\text{kg/s}$ | Imposed mass flow rate. |

---

## Preflight & Checking (`caldis.core.dof`)

### `check_dof(system: System) -> DOFReport`
Performs topological counting of unknown variables versus independent physical equations.

**Returns:** `DOFReport` with attributes:
- `n_unknowns: int`: Total number of unknown variables.
- `n_equations: int`: Total number of residual equations.
- `dof: int`: $N_{\text{unknowns}} - N_{\text{equations}}$.
- `ok: bool`: `True` if system is square ($\text{DOF} = 0$).

---

### `preflight(system: System, verbose: bool = True, check_start: bool = True, raise_on_fail: bool = False) -> bool`
Unified pre-solve validator checking DOF, start-point evaluability (preventing CoolProp out-of-domain crashes), and component sanity.


