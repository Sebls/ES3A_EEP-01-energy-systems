# Vessels, Tanks & Storage

0-D dynamic fluid control volumes, composite storage tanks with wall thermal mass, lumped thermal capacitances, and phase separators.

---

## ControlVolume

`caldis.components.vessels.control_volume.ControlVolume` models a rigid, constant-volume 0-D transient fluid vessel.

### Constructor & Parameters

```python
ControlVolume(name, backend, V, p_init, h_init, Qdot=0.0)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Component identifier string. |
| `backend` | `FluidBackend` | *required* | — | Fluid thermodynamic properties backend. |
| `V` | `float` | *required* | $\text{m}^3$ | Constant geometric volume ($V > 0$). |
| `p_init` | `float` | *required* | $\text{Pa}$ | Initial pressure for variable initialization and density evaluation. |
| `h_init` | `float` | *required* | $\text{J/kg}$ | Initial specific enthalpy for variable initialization. |
| `Qdot` | `float` | `0.0` | $\text{W}$ | External thermal heat flow into the control volume ($\dot{Q} > 0$ heating). |

### Internal Variables & States

- **Differential States**:
  - `_M`: Total mass inventory ($M$), initialized to $M_0 = V \cdot \rho(p_{\text{init}}, h_{\text{init}})$.
  - `_U`: Total internal energy ($U$), initialized to $U_0 = V \cdot (\rho_0 h_{\text{init}} - p_{\text{init}})$.
- **Algebraic Variables**:
  - `_p`: Fluid volume pressure ($p$), bounded below by $0.0$.
  - `_h`: Fluid volume specific enthalpy ($h$).

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | Fluid admission port ($p_{\text{inl}} = p$). |
| `out` | Outlet | `FluidPort` | Fluid discharge port ($p_{\text{out}} = p$, $h_{\text{out}} = h$). |

### Governing Equations & Residuals

The component defines 7 algebraic-differential residuals (`residuals()`):

| Index | Residual Name | Equation |
| :--- | :--- | :--- |
| 1 | `"mass_dyn"` | $\frac{dM}{dt} - (\dot{m}_{\text{inl}} + \dot{m}_{\text{out}}) = 0$ |
| 2 | `"energy_dyn"` | $\frac{dU}{dt} - (\dot{m}_{\text{inl}} h_{\text{inl}} + \dot{m}_{\text{out}} h_{\text{out}} + \dot{Q}) = 0$ |
| 3 | `"M_def"` | $M - V \cdot \rho(p, h) = 0$ |
| 4 | `"U_def"` | $U - V \cdot (\rho(p, h) \cdot h - p) = 0$ |
| 5 | `"inl_p"` | $p_{\text{inl}} - p = 0$ |
| 6 | `"out_p"` | $p_{\text{out}} - p = 0$ |
| 7 | `"out_h"` | $h_{\text{out}} - h = 0$ |

### Outputs & State Properties

- Direct state properties: `cv.M` ($\text{kg}$), `cv.U` ($\text{J}$), `cv.p` ($\text{Pa}$), `cv.h` ($\text{J/kg}$).
- Updated outputs (`cv.update_outputs()`):
  - `cv.rho`: Fluid density ($\text{kg/m}^3$).
  - `cv.T`: Fluid temperature ($\text{K}$).
  - `cv.x`: Vapor quality ($-1.0$ if subcooled liquid, $2.0$ if superheated vapor).

---

## ControlVolumeP

`caldis.components.vessels.tank.ControlVolumeP` is the constant-pressure (variable-volume) counterpart of `ControlVolume` (e.g. accumulator or expanding bladder).

### Constructor & Parameters

```python
ControlVolumeP(name, backend, p, h_init, V_init, Qdot=0.0)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Component identifier string. |
| `backend` | `FluidBackend` | *required* | — | Fluid thermodynamic properties backend. |
| `p` | `float` | *required* | $\text{Pa}$ | Imposed constant operating pressure. |
| `h_init` | `float` | *required* | $\text{J/kg}$ | Initial fluid specific enthalpy. |
| `V_init` | `float` | *required* | $\text{m}^3$ | Initial volume of the accumulator. |
| `Qdot` | `float` | `0.0` | $\text{W}$ | Prescribed external thermal heat addition. |

### Internal Variables & Residuals

- **Differential States**: `_M` ($\text{kg}$) and `_U` ($\text{J}$).
- **Algebraic Variables**: `_V` ($\text{m}^3$, breathes to maintain pressure $p$) and `_h` ($\text{J/kg}$).
- **Residuals (`7`)**: `"mass_dyn"`, `"energy_dyn"`, `"M_def"`, `"U_def"`, `"inl_p"`, `"out_p"`, `"out_h"`.
- **Properties**: `cv.M`, `cv.U`, `cv.V`, `cv.h`, `cv.p` (fixed parameter), `cv.T`, `cv.rho`, `cv.x`, `cv.V_out`.

---

## ThermalMass

`caldis.components.vessels.thermal_mass.ThermalMass` models a lumped 0-D solid thermal capacitance.

### Constructor & Parameters

```python
ThermalMass(name, C, UA, T_init, T_env=None, Qdot_ext=0.0)
```

| Parameter | Type | Default | Units | Description & Constraints |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | — | Component identifier string. |
| `C` | `float` | *required* | $\text{J/K}$ | Total heat capacity ($C = m \cdot c_p$). |
| `UA` | `float` | *required* | $\text{W/K}$ | Thermal conductance to environment. |
| `T_init` | `float` | *required* | $\text{K}$ | Initial body temperature. |
| `T_env` | `float` or `None` | `None` | $\text{K}$ | Ambient environmental temperature (defaults to `T_init`). |
| `Qdot_ext` | `float` | `0.0` | $\text{W}$ | External thermal power input. |

### Governing Equation & Residual

1 differential state `_T` ($\text{K}$):
$$C \frac{dT}{dt} - [UA (T_{\text{env}} - T) + \dot{Q}_{\text{ext}}] = 0 \quad (\text{"energy"})$$

- Property: `tm.T` ($\text{K}$).

---

## TankConstV & TankConstP

Composite storage systems coupling fluid volumes with container wall thermal masses.

### Constructor Signatures

```python
TankConstV(name, backend, V, p_init, h_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
TankConstP(name, backend, p, h_init, V_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
```

| Parameter | Units | Description |
| :--- | :--- | :--- |
| `backend` | — | Thermodynamic fluid property backend. |
| `V` / `p` | $\text{m}^3$ / $\text{Pa}$ | Fixed volume for `TankConstV`; fixed pressure for `TankConstP`. |
| `p_init` / `V_init` | $\text{Pa}$ / $\text{m}^3$ | Initial state for the free conjugate variable. |
| `h_init` | $\text{J/kg}$ | Initial fluid specific enthalpy. |
| `C_wall` | $\text{J/K}$ | Metal vessel wall heat capacity. |
| `T_wall_init` | $\text{K}$ | Initial metal vessel wall temperature. |
| `UA_wall` | $\text{W/K}$ | Internal wall-to-fluid convective heat transfer conductance. |
| `Q_heater` | $\text{W}$ | Heating element power injected directly into the wall. |

### Coupling Mechanism

Every iteration during `_own_residuals()`:
$$\dot{Q}_{\text{wall}\to\text{fluid}} = UA_{\text{wall}} \cdot (T_{\text{wall}} - T_{\text{fluid}})$$
- Fluid volume receives $\dot{Q}_{\text{fluid}} = \dot{Q}_{\text{wall}\to\text{fluid}}$.
- Wall receives $\dot{Q}_{\text{ext}} = \dot{Q}_{\text{heater}} - \dot{Q}_{\text{wall}\to\text{fluid}}$.

### Post-Solve Outputs

- `tank.Q`: Current heat transfer from wall to fluid ($\text{W}$).
- `tank.T_fluid`: Bulk fluid temperature ($\text{K}$).
- `tank.T_wall`: Wall temperature ($\text{K}$).
- `tank.V`: Live fluid volume in `TankConstP` ($\text{m}^3$).
- `tank.exergy_balance(T0, p0)` returns `None` (storage systems have no steady-state product).

---

## FlashTank

`caldis.components.vessels.flash_tank.FlashTank` models a steady-state adiabatic flash separator operating at isobaric equilibrium.

### Constructor & Parameters

```python
FlashTank(name, backend)
```

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | Component identifier string. |
| `backend` | `FluidBackend` | *required* | Fluid property backend. |

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | Two-phase entry stream ($\dot{m}_{\text{inl}} > 0$). |
| `vap` | Outlet | `FluidPort` | Saturated vapor discharge stream ($\dot{m}_{\text{vap}} < 0$, $x = 1.0$). |
| `liq` | Outlet | `FluidPort` | Saturated liquid drain stream ($\dot{m}_{\text{liq}} < 0$, $x = 0.0$). |

### Governing Equations & Residuals

The component contributes 6 algebraic residuals (`residuals()`):

1. **Mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{inl}} + \dot{m}_{\text{vap}} + \dot{m}_{\text{liq}} = 0$$
2. **Energy conservation (`"energy"`)**:
   $$\dot{m}_{\text{inl}} h_{\text{inl}} + \dot{m}_{\text{vap}} h_g(p_{\text{inl}}) + \dot{m}_{\text{liq}} h_f(p_{\text{inl}}) = 0$$
3. **Vapor outlet saturation (`"sat_vapour"`)**:
   $$h_{\text{vap}} - h_g(p_{\text{inl}}) = 0$$
4. **Liquid outlet saturation (`"sat_liquid"`)**:
   $$h_{\text{liq}} - h_f(p_{\text{inl}}) = 0$$
5. **Vapor pressure equilibrium (`"p_vap"`)**:
   $$p_{\text{vap}} - p_{\text{inl}} = 0$$
6. **Liquid pressure equilibrium (`"p_liq"`)**:
   $$p_{\text{liq}} - p_{\text{inl}} = 0$$

where $h_g(p) = \text{backend.h\_pq}(p, 1.0)$ and $h_f(p) = \text{backend.h\_pq}(p, 0.0)$.

### Post-Solve Outputs

- `flash.vapour_fraction`: Dryness / separated vapor fraction:
  $$x_{\text{sep}} = \frac{-\dot{m}_{\text{vap}}}{\dot{m}_{\text{inl}}}$$

### Pre-Solve Sanity Checks (`_own_start_sanity`)

- $\dot{m}_{\text{inl}} > 0$ (must be an inflow).
- $\dot{m}_{\text{vap}} < 0$ and $\dot{m}_{\text{liq}} < 0$ (must be outflows).


