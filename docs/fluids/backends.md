# Fluid Backends & Properties

All thermophysical and transport properties in Caldis are managed through backends implementing `caldis.fluids.backend.FluidBackend`.

---

## CoolPropBackend

`caldis.fluids.coolprop_backend.CoolPropBackend` wraps CoolProp's high-accuracy Helmholtz equations of state.

```python
from caldis.fluids import CoolPropBackend

# Initialize pure or pseudo-pure fluids
air = CoolPropBackend("Air")
water = CoolPropBackend("Water")
r134a = CoolPropBackend("R134a")
co2 = CoolPropBackend("CO2")
```

---

## Backend Method Reference

### State & Thermodynamic Evaluation
All primary state evaluations take $(p, h)$ as input coordinates:

| Method | Description | Units | Notes |
| :--- | :--- | :--- | :--- |
| `T(p, h)` | Temperature | $\text{K}$ | Valid in single-phase and two-phase. |
| `rho(p, h)` | Mass density | $\text{kg/m}^3$ | Mixture density under the dome. |
| `quality(p, h)` | Vapor quality $x$ | $-$ | $0 \le x \le 1$ in two-phase; `-1.0` if subcooled liquid; `2.0` if superheated vapor. |
| `s(p, h)` | Specific entropy | $\text{J/kg/K}$ | Reference state depends on CoolProp convention. |
| `h_ps(p, s)` | Isentropic enthalpy | $\text{J/kg}$ | Used for ideal turbine/compressor expansions. |
| `h_pt(p, T)` | Enthalpy from $(p, T)$ | $\text{J/kg}$ | Used for seeding starts or boundary conversions. |
| `h_pq(p, Q)` | Saturation enthalpy | $\text{J/kg}$ | $Q=0$ (bubble point $h_f$), $Q=1$ (dew point $h_g$). |
| `default_state(T_hint)` | Universal start point | `(p, h)` | Returns $(10^5 \text{ Pa}, h(10^5, T_{\text{hint}}))$. |

### Transport & Thermal Properties

| Method | Description | Units |
| :--- | :--- | :--- |
| `mu(p, h)` | Dynamic viscosity | $\text{Pa}\cdot\text{s}$ |
| `cond(p, h)` | Thermal conductivity | $\text{W/m/K}$ |
| `cp(p, h)` | Specific heat capacity $c_p$ | $\text{J/kg/K}$ |
| `Pr(p, h)` | Prandtl number | $-$ |
| `sigma(p, h)` | Surface tension | $\text{N/m}$ |

---

## Abstract Interface (`FluidBackend`)

To implement custom fluid models (e.g. ideal gases or tabulated bicubic splines), subclass `FluidBackend` and implement `T`, `rho`, and `quality`.

