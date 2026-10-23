# Boundaries & Sources

`caldis.components.sources.boundary.FluidBoundary` specifies boundary conditions and closes mass/energy streams in thermodynamic network models.

---

## FluidBoundary

The component fixes thermodynamic intensive state properties $(p, T, h)$ and/or extensive throughput ($\dot{m}$) at system boundaries.

### Constructor & Parameters

```python
FluidBoundary(name, p=None, T=None, h=None, mdot=None, backend=None)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Component identifier string. |
| `p` | `float` or `None` | `None` | $\text{Pa}$ | Imposed boundary pressure. |
| `T` | `float` or `None` | `None` | $\text{K}$ | Imposed boundary temperature. Requires `backend`. |
| `h` | `float` or `None` | `None` | $\text{J/kg}$ | Imposed boundary specific enthalpy. Requires `backend`. |
| `mdot` | `float` or `None` | `None` | $\text{kg/s}$ | Imposed mass flow rate. Sign convention: **$\dot{m} < 0$** represents fluid leaving the boundary and entering the system; **$\dot{m} > 0$** represents fluid entering the boundary from the system. |
| `backend` | `FluidBackend` or `None` | `None` | — | Thermodynamic fluid property backend. Mandatory if either `T` or `h` is provided. |

### Constraints & Validation Rules

- **State Over-specification Constraint**: At most **two** of $(p, T, h)$ may be specified. If more than two are provided, a `ValueError` is raised (`at most two of (p, T, h) may be imposed`).
- **Backend Requirement**: If `T` or `h` is specified, `backend` must not be `None`, otherwise `ValueError` is raised.
- **Specification Duality**: Any parameter provided is added to `params["specs"]` and formulated as an equality constraint equation. Any omitted parameter remains free and is determined by downstream system impedance and conservation balances.

### Ports & Internal Variables

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `port` | Bidirectional | `FluidPort` | Fluid connection port exposing state variables `port.p`, `port.h`, `port.mdot`, and computed `port.T`. |

Fluid-aware start values (`port._p.start`, `port._mdot.start`, `port._h.start`) are automatically initialized from specified parameters upon creation. If both `p` and `T` are provided, `port._h.start` is initialized using `backend.h_pt(p, T)`.

### Governing Residual Equations

Each imposed specification adds one residual equation to `residuals()` (with matching identifiers in `residual_names()`):

| Specification | Residual Name | Residual Formulation | Notes |
| :--- | :--- | :--- | :--- |
| `p` | `"p"` | $p_{\text{port}} - p_{\text{spec}} = 0$ | Direct pressure pinning. |
| `mdot` | `"mdot"` | $\dot{m}_{\text{port}} - \dot{m}_{\text{spec}} = 0$ | Direct flow rate constraint. |
| `h` | `"h"` | $h_{\text{port}} - h_{\text{spec}} = 0$ | Enthalpy pinning. |
| `T` | `"T"` | $h(p_{\text{port}}, T_{\text{spec}}) - h_{\text{port}} = 0$ | Evaluated robustly via `backend.h_pt(p, T_spec)` on current port pressure. |

### Post-Solve Outputs

`FluidBoundary` exposes no separate outputs via `_outputs`. State variables and properties are accessed directly on its port:
- `boundary.port.p`
- `boundary.port.h`
- `boundary.port.mdot`
- `boundary.port.T`

---

## Common Boundary Patterns

### 1. Inflow Source (Fully Imposed)
Fluid entering a cycle at 3 bar, 40 °C, and 2 kg/s ($\dot{m} = -2\text{ kg/s}$):
```python
src = FluidBoundary("feed", p=3.0e5, T=313.15, mdot=-2.0, backend=be)
```

### 2. Discharge Sink (Pressure Pinned)
Exhaust discharging to atmospheric pressure; mass flow rate and enthalpy are dictated by upstream cycle dynamics:
```python
sink = FluidBoundary("exhaust", p=1.01325e5, backend=be)
```

### 3. Floating-Pressure Flow Source
Inlet where mass flow and temperature are fixed, while source pressure adapts to flow resistance:
```python
inlet = FluidBoundary("inlet", T=293.15, mdot=-0.5, backend=be)
```

### 4. Bare Floating Sink
Closes a stream loop without imposing pressure, enthalpy, or mass flow:
```python
bare_sink = FluidBoundary("sink", backend=be)
```


