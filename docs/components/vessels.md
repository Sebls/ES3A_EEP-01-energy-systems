# Vessels, Tanks & Storage

Caldis includes 0-D transient vessels, storage tanks with thermal mass, and two-phase separators.

---

## ControlVolume

`caldis.components.vessels.control_volume.ControlVolume` models a rigid, constant-volume 0-D vessel.

### Differential States
**Mass inventory $M$**:

$$\frac{dM}{dt} = \dot{m}_{\text{in}} + \dot{m}_{\text{out}}$$

**Internal energy $U$**:

$$\frac{dU}{dt} = (\dot{m}_{\text{in}} h_{\text{in}} + \dot{m}_{\text{out}} h_{\text{out}}) + \dot{Q}$$

### Algebraic Relations
- $M = V \cdot \rho(p, h)$
- $U = V \cdot (\rho(p, h) \cdot h - p)$
- Port pressures match volume pressure: $p_{\text{inl}} = p, \, p_{\text{out}} = p$
- Outlet enthalpy matches volume enthalpy: $h_{\text{out}} = h$

### Constructor Arguments
```python
ControlVolume(name, backend, V, p_init, h_init, Qdot=0.0)
```

---

## ControlVolumeP

`caldis.components.vessels.tank.ControlVolumeP` is the constant-pressure counterpart of `ControlVolume`. Pressure $p$ is a fixed parameter, and volume $V$ becomes the algebraic variable (e.g., a flexible bladder or accumulator).

```python
ControlVolumeP(name, backend, p, h_init, V_init, Qdot=0.0)
```

---

## TankConstV & TankConstP

Composite tanks coupling fluid volume and thermal vessel walls:
- `TankConstV`: Combines `ControlVolume` and `ThermalMass`.
- `TankConstP`: Combines `ControlVolumeP` and `ThermalMass`.

Both feature internal heat exchange between wall and fluid:

$$\dot{Q}_{\text{wall}\rightarrow\text{fluid}} = UA_{\text{wall}} \cdot (T_{\text{wall}} - T_{\text{fluid}})$$

### Constructor Arguments
```python
TankConstV(name, backend, V, p_init, h_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
TankConstP(name, backend, p, h_init, V_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
```

---

## ThermalMass

`caldis.components.vessels.thermal_mass.ThermalMass` models a pure thermal capacitance:

$$C \frac{dT}{dt} = UA (T_{\text{env}} - T) + \dot{Q}_{\text{ext}}$$

```python
ThermalMass(name, C, UA, T_init, T_env=None, Qdot_ext=0.0)
```

---

## FlashTank

`caldis.components.vessels.flash_tank.FlashTank` models an adiabatic two-phase flash separator operating at constant pressure.

### Residuals
**Total mass conservation**:

$$\dot{m}_{\text{inl}} + \dot{m}_{\text{vap}} + \dot{m}_{\text{liq}} = 0$$

**Energy balance**:

$$\dot{m}_{\text{inl}} h_{\text{inl}} + \dot{m}_{\text{vap}} h_g(p) + \dot{m}_{\text{liq}} h_f(p) = 0$$

**Saturated liquid ($x=0$) and vapor ($x=1$) outlet enthalpies**:

$$h_{\text{vap}} = h_g(p), \quad h_{\text{liq}} = h_f(p)$$

```python
FlashTank(name, backend)
```
- Ports: `inl`, `vap`, `liq`.
- Output: `flash.vapour_fraction`.

