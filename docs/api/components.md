# Components API Reference

Summary of constructors, arguments, ports, and outputs for all component classes in `caldis.components`.

---

## Machines (`caldis.components.machines`)

### `Compressor`
```python
Compressor(name, backend, eta_is)
```
- **Parameters**: `name` (*str*), `backend` (*FluidBackend*), `eta_is` (*float*).
- **Ports**: `inl` (suction), `out` (discharge).
- **Residuals**: `"mass"`, `"isentropic"`.
- **Outputs**: `comp.Wdot` ($\text{W} < 0$), `comp.pressure_ratio`.
- **Exergy**: `comp.exergy_balance(T0, p0)`.

### `Turbine`
```python
Turbine(name, backend, eta_is=0.89, eta_mech=1.0)
```
- **Parameters**: `name` (*str*), `backend` (*FluidBackend*), `eta_is` (*float*, default `0.89`), `eta_mech` (*float*, default `1.0`).
- **Ports**: `inl` (admission), `out` (exhaust).
- **Residuals**: `"mass"`, `"isentropic"`.
- **Outputs**: `turb.Wdot` ($\text{W} > 0$), `turb.Wdot_is`, `turb.pressure_ratio`, `turb.h_out_s`, `turb.T_out_s`.
- **Exergy**: `turb.exergy_balance(T0, p0)`.

---

## Heat Exchangers (`caldis.components.HEX`)

### `SizingHX`
```python
SizingHX(name, backend_hot, backend_cold, h_hot, h_cold, area_ratio_cold_to_hot)
```
- **Parameters**: `name` (*str*), `backend_hot` (*FluidBackend*), `backend_cold` (*FluidBackend*), `h_hot` (*float*), `h_cold` (*float*), `area_ratio_cold_to_hot` (*float*).
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.
- **Residuals**: `"mass_hot"`, `"dp_hot"`, `"mass_cold"`, `"dp_cold"`, `"coupling_Q"`, `"def_UA"`, `"def_A"`.
- **Outputs**: `hx.UA`, `hx.A_hot`, `hx.A_cold`, `hx.A_total`, `hx.U_overall_hot`, `hx.U_overall_cold`, `hx.Qdot`, `hx.DTLM`.

### `RatingHX`
```python
RatingHX(
    name, backend_hot, backend_cold,
    UA=None, h_hot=None, h_cold=None,
    area_ratio_cold_to_hot=None, A_hot=None,
    flow_config="counterflow"
)
```
- **Parameters**: `name` (*str*), `backend_hot` (*FluidBackend*), `backend_cold` (*FluidBackend*), and either `UA` (*float*) or the complete physical set (`h_hot`, `h_cold`, `area_ratio_cold_to_hot`, `A_hot`). `flow_config` (*"counterflow"* or *"coflow"*).
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.
- **Residuals**: `"mass_hot"`, `"dp_hot"`, `"mass_cold"`, `"dp_cold"`, `"energy_hot"`, `"energy_cold"`.
- **Outputs**: `hx.Qdot`, `hx.effectiveness`, `hx.NTU`, `hx.Cr`, `hx.C_hot`, `hx.C_cold`, `hx.UA`, `hx.T_hot_out`, `hx.T_cold_out`.

### `HXSim`
```python
HXSim(
    name, backend_hot, backend_cold,
    n_elements=10, flow_config="counterflow", geometry_params=None,
    m_wall=1.0, cp_wall=500.0, R_fouling=0.0, geometry_fn=None,
    h_conv_hot=None, h_conv_cold=None,
    h_rad_hot=None, h_rad_cold=None,
    dp_hot=None, dp_cold=None,
    void_hot=None, void_cold=None
)
```
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.
- **Outputs**: `hx.T_hot`, `hx.T_cold`, `hx.Tw`, `hx.x_hot`, `hx.x_cold`, `hx.charge_hot`, `hx.charge_cold`, `hx.Qdot_total`.

---

## Combustion & Heaters (`caldis.components.combustion`)

### `SimpleHeater`
```python
SimpleHeater(name, backend, Qdot=None, dp=0.0, T_source=None)
```
- **Parameters**: `name` (*str*), `backend` (*FluidBackend*), `Qdot` (*float or None*), `dp` (*float*, default `0.0`), `T_source` (*float or None*).
- **Ports**: `inl`, `out`.
- **Residuals**: `"mass"`, `"dp"`, `"energy"`.
- **Outputs**: `heater.Qdot`.

### `CombustionChamber`
```python
CombustionChamber(
    name, backend_air, backend_fuel,
    LHV=50.0e6, eta_comb=1.0, dp_rel=0.04,
    AFR_stoich=17.2, T_ref=298.15, p_ref=101325.0,
    T_max_warn=1700.0
)
```
- **Ports**: `air_in`, `fuel_in`, `gas_out`.
- **Residuals**: `"mass"`, `"pressure"`, `"energy"`.
- **Outputs**: `cc.Qdot_fuel`, `cc.Qdot_released`, `cc.AFR`, `cc.excess_air`.

---

## Sources & Boundaries (`caldis.components.sources`)

### `FluidBoundary`
```python
FluidBoundary(name, p=None, T=None, h=None, mdot=None, backend=None)
```
- **Parameters**: `name` (*str*), at most 2 of (`p`, `T`, `h`), optional `mdot`, and `backend` (required if `T` or `h` is set).
- **Ports**: `port`.
- **Outputs**: Accessed directly on `port` (`port.p`, `port.h`, `port.mdot`, `port.T`).

---

## Fittings (`caldis.components.fittings`)

### `Mixer`
```python
Mixer(name, backend)
```
- **Ports**: `in1`, `in2`, `out`.
- **Residuals**: `"mass"`, `"energy"`, `"p_in2"`, `"p_out"`.
- **Outputs**: `mixer.mdot_out`.

### `Splitter`
```python
Splitter(name, backend)
```
- **Ports**: `inl`, `out1`, `out2`.
- **Residuals**: `"mass"`, `"h_out1"`, `"h_out2"`, `"p_out1"`, `"p_out2"`.
- **Outputs**: `splitter.mdot_in`.

---

## Valves & Vessels (`caldis.components.valves`, `caldis.components.vessels`)

### `Valve`
```python
Valve(name, Kv=None, backend=None, flow_law="quadratic", eps=1e-9)
```
- **Parameters**: `name` (*str*), `Kv` (*float or None*), `backend` (*FluidBackend*), `flow_law` (*"quadratic"* or *"linear"*), `eps` (*float*, default `1e-9`).
- **Ports**: `inl`, `out`.
- **Residuals**: `"mass"`, `"flow_law"`, `"isenthalpic"`.
- **Outputs**: `valve.Kv`, `valve.dp`.

### `ControlVolume`
```python
ControlVolume(name, backend, V, p_init, h_init, Qdot=0.0)
```
- **Parameters**: `name` (*str*), `backend` (*FluidBackend*), `V` (*float*), `p_init` (*float*), `h_init` (*float*), `Qdot` (*float*, default `0.0`).
- **Ports**: `inl`, `out`.
- **Residuals**: `"mass_dyn"`, `"energy_dyn"`, `"M_def"`, `"U_def"`, `"inl_p"`, `"out_p"`, `"out_h"`.
- **Outputs**: `cv.M`, `cv.U`, `cv.p`, `cv.h`, `cv.rho`, `cv.T`, `cv.x`.

### `ControlVolumeP`
```python
ControlVolumeP(name, backend, p, h_init, V_init, Qdot=0.0)
```
- **Parameters**: `name` (*str*), `backend` (*FluidBackend*), `p` (*float*), `h_init` (*float*), `V_init` (*float*), `Qdot` (*float*, default `0.0`).
- **Ports**: `inl`, `out`.
- **Outputs**: `cv.M`, `cv.U`, `cv.V`, `cv.h`, `cv.p`, `cv.rho`, `cv.T`, `cv.x`, `cv.V_out`.

### `ThermalMass`
```python
ThermalMass(name, C, UA, T_init, T_env=None, Qdot_ext=0.0)
```
- **Parameters**: `name` (*str*), `C` (*float*), `UA` (*float*), `T_init` (*float*), `T_env` (*float or None*), `Qdot_ext` (*float*, default `0.0`).
- **Outputs**: `tm.T`, `tm.Qdot_ext`.

### `TankConstV` / `TankConstP`
```python
TankConstV(name, backend, V, p_init, h_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
TankConstP(name, backend, p, h_init, V_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
```
- **Ports**: `inl`, `out`.
- **Outputs**: `tank.Q`, `tank.T_fluid`, `tank.T_wall`, `tank.V` (in TankConstP).

### `FlashTank`
```python
FlashTank(name, backend)
```
- **Ports**: `inl`, `vap`, `liq`.
- **Residuals**: `"mass"`, `"energy"`, `"sat_vapour"`, `"sat_liquid"`, `"p_vap"`, `"p_liq"`.
- **Outputs**: `flash.vapour_fraction`.


