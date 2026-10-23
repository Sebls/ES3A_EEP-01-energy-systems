# Components API Reference

Summary of component constructors and properties in `caldis.components`.

---

## Machines (`caldis.components.machines`)

### `Compressor`
```python
Compressor(name, backend, eta_is)
```
- **Ports**: `inl`, `out`.
- **Properties**: `Wdot` ($\text{W} < 0$), `pressure_ratio`.

### `Turbine`
```python
Turbine(name, backend, eta_is=0.89, eta_mech=1.0)
```
- **Ports**: `inl`, `out`.
- **Properties**: `Wdot` ($\text{W} > 0$), `Wdot_is`, `pressure_ratio`, `T_out_s`.

---

## Heat Exchangers (`caldis.components.HEX`)

### `SizingHX`
```python
SizingHX(name, backend_hot, backend_cold, h_hot, h_cold, area_ratio_cold_to_hot)
```
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.
- **Properties**: `UA`, `A_hot`, `A_cold`, `A_total`, `Qdot`, `DTLM`.

### `RatingHX`
```python
RatingHX(name, backend_hot, backend_cold, A_hot, h_hot, h_cold, area_ratio_cold_to_hot)
```
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.
- **Properties**: `Qdot`, `UA`, `DTLM`.

### `HXSim`
```python
HXSim(name, backend_hot, backend_cold, n_elements=10, flow_config="counterflow", ...)
```
- **Ports**: `hot_in`, `hot_out`, `cold_in`, `cold_out`.

---

## Combustion & Heaters (`caldis.components.combustion`)

### `CombustionChamber`
```python
CombustionChamber(name, backend_air, backend_fuel, LHV=50.0e6, eta_comb=1.0, dp_rel=0.04, ...)
```
- **Ports**: `air_in`, `fuel_in`, `gas_out`.
- **Properties**: `Qdot_fuel`, `Qdot_released`, `AFR`, `excess_air`.

### `SimpleHeater`
```python
SimpleHeater(name, backend, Qdot=None, dp=0.0, T_source=None)
```
- **Ports**: `inl`, `out`.
- **Properties**: `Qdot`.

---

## Valves & Vessels

### `Valve`
```python
Valve(name, Kv=None, backend=None, flow_law="quadratic", eps=1e-9)
```
- **Ports**: `inl`, `out`.
- **Properties**: `Kv`, `dp`.

### `ControlVolume`
```python
ControlVolume(name, backend, V, p_init, h_init, Qdot=0.0)
```
- **Ports**: `inl`, `out`.
- **Properties**: `M`, `U`, `p`, `h`, `T`, `rho`, `x`.

### `TankConstV` / `TankConstP`
```python
TankConstV(name, backend, V, p_init, h_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
TankConstP(name, backend, p, h_init, V_init, C_wall, T_wall_init, UA_wall, Q_heater=0.0)
```
- **Ports**: `inl`, `out`.
- **Properties**: `Q`, `T_fluid`, `T_wall`, `V` (in TankConstP).

### `FlashTank`
```python
FlashTank(name, backend)
```
- **Ports**: `inl`, `vap`, `liq`.
- **Properties**: `vapour_fraction`.

