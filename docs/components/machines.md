# Turbomachinery: Compressor & Turbine

Turbomachinery components model fluid work interactions with constant isentropic and mechanical efficiencies.

---

## Compressor

`caldis.components.machines.compressor.Compressor` models a steady-state adiabatic compressor.

### Constructor & Parameters

```python
Compressor(name, backend, eta_is)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Unique identifier string for the component. |
| `backend` | `FluidBackend` | *required* | — | Fluid thermodynamic properties backend. |
| `eta_is` | `float` | *required* | — | Isentropic efficiency ($0 < \eta_{\text{is}} \le 1$). Divides the isentropic enthalpy rise. |

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | Fluid suction / inlet port. |
| `out` | Outlet | `FluidPort` | Fluid discharge / outlet port. |

### Governing Equations & Residuals

The component contributes 2 non-linear algebraic residuals (`residuals()`):

1. **Mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{inl}} + \dot{m}_{\text{out}} = 0$$
2. **Isentropic compression relation (`"isentropic"`)**:
   $$h_{\text{out}} - \left( h_{\text{inl}} + \frac{h_{\text{out}, s} - h_{\text{inl}}}{\eta_{\text{is}}} \right) = 0$$

where:
- $s_{\text{inl}} = s(p_{\text{inl}}, h_{\text{inl}})$
- $h_{\text{out}, s} = h(p_{\text{out}}, s_{\text{inl}})$ evaluated via `backend.h_ps(self.out.p, s_in)`.

### Post-Solve Outputs & Properties

Updated upon solver convergence via `update_outputs()`:

| Property | Symbol | Type / Units | Description |
| :--- | :--- | :--- | :--- |
| `comp.Wdot` | $\dot{W}$ | `float` ($\text{W}$) | Shaft power absorbed by the compressor. Follows thermodynamic sign convention ($\dot{W} < 0$ for work done on fluid): $\dot{W} = -\dot{m}_{\text{inl}} (h_{\text{out}} - h_{\text{inl}})$. |
| `comp.pressure_ratio` | $\Pi$ | `float` | Pressure ratio: $p_{\text{out}} / p_{\text{inl}}$. |

### Exergy Balance

Evaluated via `comp.exergy_balance(T0, p0)`:
$$\dot{X}_{\text{in}} = \dot{m}_{\text{inl}} \cdot e_{x}(p_{\text{inl}}, h_{\text{inl}}; T_0, p_0)$$
$$\dot{X}_{\text{out}} = \dot{m}_{\text{out}} \cdot e_{x}(p_{\text{out}}, h_{\text{out}}; T_0, p_0)$$
$$\dot{W}_{\text{absorbed}} = |\dot{m}_{\text{inl}} (h_{\text{out}} - h_{\text{inl}})|$$
$$\dot{X}_{\text{dest}} = \dot{W}_{\text{absorbed}} - (\dot{X}_{\text{out}} - \dot{X}_{\text{in}})$$

### Pre-Solve Sanity Checks (`_own_start_sanity`)

Prior to system solving, `Compressor` validates:
- **Pressure Gradient**: $p_{\text{out}} > p_{\text{inl}}$. Warns or fails if initial conditions specify expansion through the compressor.

---

## Turbine

`caldis.components.machines.turbine.Turbine` models an adiabatic expansion turbine.

### Constructor & Parameters

```python
Turbine(name, backend, eta_is=0.89, eta_mech=1.0)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Unique identifier string for the component. |
| `backend` | `FluidBackend` | *required* | — | Fluid thermodynamic properties backend. |
| `eta_is` | `float` | `0.89` | — | Isentropic expansion efficiency ($0 < \eta_{\text{is}} \le 1$). Multiplies the isentropic drop. |
| `eta_mech` | `float` | `1.0` | — | Mechanical shaft efficiency ($0 < \eta_{\text{mech}} \le 1$). Accounts for mechanical bearing/windage losses in delivered shaft power. |

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | High-pressure turbine inlet / admission port. |
| `out` | Outlet | `FluidPort` | Low-pressure turbine exhaust port. |

### Governing Equations & Residuals

The component contributes 2 non-linear algebraic residuals (`residuals()`):

1. **Mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{inl}} + \dot{m}_{\text{out}} = 0$$
2. **Expansion enthalpy equation (`"isentropic"`)**:
   $$h_{\text{out}} - \left[ h_{\text{inl}} - \eta_{\text{is}} \cdot (h_{\text{inl}} - h_{\text{out}, s}) \right] = 0$$

where:
- $s_{\text{inl}} = s(p_{\text{inl}}, h_{\text{inl}})$
- $h_{\text{out}, s} = h(p_{\text{out}}, s_{\text{inl}})$ evaluated via `backend.h_ps(self.out.p, s_in)`.

### Post-Solve Outputs & Properties

Updated upon solver convergence via `update_outputs()`:

| Property | Symbol | Type / Units | Description |
| :--- | :--- | :--- | :--- |
| `turb.Wdot` | $\dot{W}$ | `float` ($\text{W}$) | Net mechanical shaft power delivered ($\dot{W} > 0$): $\dot{W} = \eta_{\text{mech}} \cdot \dot{m}_{\text{inl}} (h_{\text{inl}} - h_{\text{out}})$. |
| `turb.Wdot_is` | $\dot{W}_{\text{is}}$ | `float` ($\text{W}$) | Maximum theoretical isentropic shaft power: $\dot{W}_{\text{is}} = \eta_{\text{mech}} \cdot \dot{m}_{\text{inl}} (h_{\text{inl}} - h_{\text{out}, s})$. |
| `turb.pressure_ratio` | $\Pi$ | `float` | Expansion pressure ratio: $p_{\text{inl}} / p_{\text{out}}$. |
| `turb.h_out_s` | $h_{\text{out}, s}$ | `float` ($\text{J/kg}$) | Ideal isentropic discharge specific enthalpy. |
| `turb.T_out_s` | $T_{\text{out}, s}$ | `float` ($\text{K}$) | Ideal isentropic discharge temperature: $T(p_{\text{out}}, h_{\text{out}, s})$. |

### Exergy Balance

Evaluated via `turb.exergy_balance(T0, p0)`:
$$\dot{X}_{\text{in}} = \dot{m}_{\text{inl}} \cdot e_{x}(p_{\text{inl}}, h_{\text{inl}}; T_0, p_0)$$
$$\dot{X}_{\text{out}} = \dot{m}_{\text{out}} \cdot e_{x}(p_{\text{out}}, h_{\text{out}}; T_0, p_0)$$
$$\dot{W}_{\text{shaft}} = \eta_{\text{mech}} \cdot \dot{m}_{\text{inl}} (h_{\text{inl}} - h_{\text{out}})$$
$$\dot{X}_{\text{dest}} = (\dot{X}_{\text{in}} - \dot{X}_{\text{out}}) - \dot{W}_{\text{shaft}}$$

### Pre-Solve Sanity Checks (`_own_start_sanity`)

Validates turbine start conditions before solving:
- **Pressure drop direction**: $p_{\text{out}} < p_{\text{inl}}$ (expansion requirement).
- **Inlet mass flow**: $\dot{m}_{\text{inl}} > 0$.
- **High temperature check**: $T_{\text{inl}} > 500\text{ K}$ (warns if start state seems too cold for high-temperature turbines).


