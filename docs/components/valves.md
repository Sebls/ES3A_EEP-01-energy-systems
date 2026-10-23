# Valves & Pressure Restrictions

`caldis.components.valves.valve.Valve` models an adiabatic, isenthalpic expansion valve, throttle, or hydraulic flow restriction.

---

## Valve

Models flow rate as a function of differential pressure $\Delta p = p_{\text{inl}} - p_{\text{out}}$ with isenthalpic expansion ($h_{\text{out}} = h_{\text{inl}}$).

### Constructor & Parameters

```python
Valve(name, Kv=None, backend=None, flow_law="quadratic", eps=1e-9)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Component identifier string. |
| `Kv` | `float` or `None` | `None` | Law-dependent | Valve flow conductance coefficient. If `float`, fixed simulation mode is used. If `None`, valve sizing mode is triggered. |
| `backend` | `FluidBackend` or `None` | `None` | — | Optional fluid thermodynamic backend. |
| `flow_law` | `str` | `"quadratic"` | — | Flow regime law: `"quadratic"` or `"linear"`. Raises `ValueError` for any other value. |
| `eps` | `float` | `1e-9` | $\text{Pa}$ | Smoothing regularization parameter avoiding singular Jacobians at zero pressure drop ($\Delta p \to 0$). |

### Operating Modes & Unknowns

- **Simulation Mode (`Kv` given as a number)**:
  - $K_v$ is saved in `params["Kv"]`.
  - The mass flow rate is determined algebraically by the imposed pressure drop across the component.
- **Sizing Mode (`Kv=None`)**:
  - Sets `self.sizing = True` and instantiates an internal unknown `Variable`:
    $$\text{self.\_Kv\_var} = \text{Variable}("Kv", \text{start}=10^{-4}, \text{lower}=0.0, \text{scale}=10^{-4})$$
  - The system must provide a closing equation elsewhere (such as fixing stream mass flow rate or outlet pressure) to calculate the required valve opening.

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | Upstream high-pressure entry port. |
| `out` | Outlet | `FluidPort` | Downstream throttled discharge port. |

### Governing Equations & Residuals

The component contributes 3 non-linear residuals (`residuals()`):

1. **Mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{inl}} + \dot{m}_{\text{out}} = 0$$
2. **Hydraulic flow law (`"flow_law"`)**:
   $$\dot{m}_{\text{inl}} - \dot{m}_{\text{law}} = 0$$
   where $\dot{m}_{\text{law}}$ depends on `flow_law`:
   - **`"quadratic"`** (Turbulent orifice flow):
     $$\dot{m}_{\text{law}} = K_v \cdot \text{sgn}(\Delta p) \sqrt{|\Delta p| + \varepsilon}$$
     Units of $K_v$: $\text{kg} \cdot \text{s}^{-1} \cdot \text{Pa}^{-0.5}$.
   - **`"linear"`** (Laminar / smoothed flow for stiff initializations):
     $$\dot{m}_{\text{law}} = K_v \cdot \Delta p$$
     Units of $K_v$: $\text{kg} \cdot \text{s}^{-1} \cdot \text{Pa}^{-1}$.
3. **Isenthalpic expansion (`"isenthalpic"`)**:
   $$h_{\text{out}} - h_{\text{inl}} = 0$$

### Post-Solve Outputs & Properties

Updated upon solver convergence via `update_outputs()`:

| Property | Symbol | Type / Units | Description |
| :--- | :--- | :--- | :--- |
| `valve.Kv` | $K_v$ | `float` | Conductance coefficient (either parameter value or solved unknown). |
| `valve.dp` | $\Delta p$ | `float` ($\text{Pa}$) | Differential pressure drop: $p_{\text{inl}} - p_{\text{out}}$. |

### Exergy Balance & Dissipation

Evaluated via `valve.exergy_balance(T0, p0)`:
Throttling is an unrecoverable, purely dissipative process:
$$\dot{S}_{\text{gen}} = \dot{m}_{\text{inl}} (s_{\text{out}} - s_{\text{inl}})$$
$$\dot{X}_{\text{dest}} = T_0 \dot{S}_{\text{gen}}$$
$$\dot{X}_{\text{supplied}} = \dot{X}_{\text{dest}}, \quad \dot{X}_{\text{recovered}} = 0.0$$

### Pre-Solve Sanity Checks (`_own_start_sanity`)

- Validates flow direction impedance: $p_{\text{inl}} \ge p_{\text{out}}$ (warns if start state specifies negative pressure drop across the valve).


