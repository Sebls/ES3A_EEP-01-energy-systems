# Core API Reference

!!! note "Document Type: Reference"
    Information-oriented technical specification of the foundational topological and structural abstractions in `caldis.core`.

---

## `System`

::: caldis.core.system.System
    handler: python
    options:
      show_root_heading: false

```python
caldis.core.system.System(name: str = "system")
```

The central container managing components, fluid streams, algebraic constraints, and global unknowns.

### Methods

#### `add(*components: Component) -> Tuple[Component, ...]`
Registers one or more physical components with the system container.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `*components` | `Component` | Arbitrary number of component instances (`Compressor`, `FluidBoundary`, etc.). |

**Returns:** The component or tuple of components registered.

---

#### `connect(port_a: FluidPort, port_b: FluidPort, close_loop: bool = False) -> Connection`
Creates an acausal connection between two fluid ports.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `port_a` | `FluidPort` | *required* | First fluid port. |
| `port_b` | `FluidPort` | *required* | Second fluid port. |
| `close_loop` | `bool` | `False` | When `True`, omits the mass balance equation ($\dot{m}_a + \dot{m}_b = 0$) to eliminate linear dependency in closed cycles. |

**Residuals Generated:**
- Equality of pressure: $p_a - p_b = 0$
- Equality of specific enthalpy: $h_a - h_b = 0$
- Mass conservation (if `close_loop=False`): $\dot{m}_a + \dot{m}_b = 0$

---

#### `add_constraint(fn: Callable[[], float], name: str = "") -> None`
Appends a custom scalar constraint equation residual $r = f() = 0$ to the system.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `fn` | `Callable[[], float]` | Zero-argument callable returning the residual scalar. |
| `name` | `str` | Optional identifier for logging and diagnostic reports. |

---

#### `remove_constraint(name: str) -> None` / `replace_constraint(name: str, fn: Callable[[], float]) -> None`
Modifies or replaces an existing system-level constraint by name.

---

#### `assemble() -> List[Variable]`
Collects all unknown variables across all registered components and connections, assigning each variable a global index.

**Returns:** Flat list of unknown `Variable` instances in the global equation vector.

---

#### `residuals() -> np.ndarray`
Evaluates all component balances, connection equations, and system constraints at current variable values.

**Returns:** `np.ndarray` 1D array of residuals with length equal to $N_{\text{equations}}$.

---

#### `port_table(as_dataframe: bool = True) -> Union[pd.DataFrame, List[Dict[str, Any]]]`
Extracts the state of every fluid port in the model.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `as_dataframe` | `bool` | `True` | Returns a Pandas `DataFrame` if `True`, else a list of dictionaries. |

**Reported Columns:** `port`, `p_bar`, `T_C`, `h_kJkg`, `s_kJkgK`, `quality`, `rho_kgm3`, `mdot`.

---

#### `set_reference(T_ref: float, p_ref: float = 101325.0) -> None`
Sets the environmental dead-state temperature ($T_0$) and pressure ($p_0$) for second-law exergy balances.

---

#### `exergy_report(T0: Optional[float] = None, p0: Optional[float] = None) -> pd.DataFrame`
Computes exergy balances across all components ($X_{\text{in}}$, $X_{\text{out}}$, $X_{\text{dest}}$, $\eta_{\text{II}}$).

---

## `Variable`

```python
caldis.core.variable.Variable(
    owner: Any,
    local_name: str,
    start: float = 1.0,
    differential: bool = False,
    lower: Optional[float] = None,
    upper: Optional[float] = None,
    scale: float = 1.0
)
```

Represents an unknown scalar variable in the system.

### Attributes

| Attribute | Type | Description |
| :--- | :--- | :--- |
| `name` | `str` | Fully qualified hierarchical identifier (e.g. `"comp.out.p"`). |
| `start` | `float` | Initial numerical guess for iterative solvers. |
| `value` | `float` | Current evaluation value. |
| `der` | `float` | Derivative $\dot{x} = \frac{dx}{dt}$ (when `differential=True`). |
| `lower` | `Optional[float]` | Lower bound constraint during solving. |
| `upper` | `Optional[float]` | Upper bound constraint during solving. |
| `scale` | `float` | Characteristic magnitude for residual and Jacobian normalization. |

---

## `FluidPort`

```python
caldis.core.port.FluidPort(owner: Component, name: str)
```

Interface node representing a thermodynamic fluid stream passing into or out of a component.

### Properties & Accessors

| Property | Type | Units | Description |
| :--- | :--- | :--- | :--- |
| `p` | `float` | $\text{Pa}$ | Static pressure (backed by unknown `Variable`). |
| `h` | `float` | $\text{J/kg}$ | Specific enthalpy (backed by unknown `Variable`). |
| `mdot` | `float` | $\text{kg/s}$ | Mass flow rate (backed by unknown `Variable`). Inflow $>0$, outflow $<0$. |
| `T` | `float` | $\text{K}$ | Temperature evaluated via `backend.T(p, h)`. |
| `s` | `float` | $\text{J/kg/K}$ | Specific entropy evaluated via `backend.s(p, h)`. |
| `rho` | `float` | $\text{kg/m}^3$ | Density evaluated via `backend.rho(p, h)`. |
| `quality` | `float` | $-$ | Vapor quality $x \in [0, 1]$ (subcooled: `-1.0`, superheated: `2.0`). |
| `backend` | `FluidBackend` | $-$ | Attached thermophysical equation of state backend. |

### Methods

#### `exergy_flow(T0: float, p0: float) -> float`
Calculates the total flow exergy rate $\dot{X} = |\dot{m}| \cdot e_{\text{flow}}$ in Watts ($\text{W}$).


