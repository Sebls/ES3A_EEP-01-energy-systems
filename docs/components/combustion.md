# Combustion & Heaters

Thermal heat additions and fuel combustion are handled by `SimpleHeater` and `CombustionChamber`.

---

## SimpleHeater

`caldis.components.combustion.heater.SimpleHeater` represents a thermal source or sink on a single fluid stream.

### Dual Operating Modes
1. **Parameter Mode (`Qdot` given as float)**:
   Thermal power is fixed. The outlet enthalpy adjusts accordingly:

    $$\dot{m}_{\text{in}} (h_{\text{out}} - h_{\text{in}}) - \dot{Q} = 0$$

2. **Sizing / Unknown Mode (`Qdot=None`)**:
   $\dot{Q}$ is declared as an internal unknown `Variable`. The system must impose a downstream constraint (e.g., target temperature via `fix_port(sys, heater.out, T=...)`).

### Constructor Arguments
```python
SimpleHeater(name, backend, Qdot=None, dp=0.0, T_source=None)
```
- `name` (*str*): Component name.
- `backend` (*FluidBackend*): Fluid property backend.
- `Qdot` (*float or None*): Heat flow in Watts ($\dot{Q} > 0$ heating, $\dot{Q} < 0$ cooling).
- `dp` (*float*): Pressure drop in Pascals. Default is `0.0`.
- `T_source` (*float or None*): Heat reservoir temperature ($K$) for exergy balance. Set to `float('inf')` for electric resistance.

### Ports & Outputs
- Ports: `inl`, `out`.
- Output: `heater.Qdot`.

---

## CombustionChamber

`caldis.components.combustion.combustion_chamber.CombustionChamber` models a gas-turbine combustion chamber with real mass and energy balances and relative pressure loss.

### Physics
**Mass conservation (including fuel mass)**:

$$\dot{m}_{\text{air}} + \dot{m}_{\text{fuel}} + \dot{m}_{\text{gas}} = 0$$

**Pressure loss**:

$$p_{\text{gas}} = p_{\text{air}} \cdot (1 - \Delta p_{\text{rel}})$$

**Energy balance (referenced to $T_{\text{ref}}, p_{\text{ref}}$)**:

$$\dot{m}_{\text{air}} (h_a - h_{a,\text{ref}}) + \dot{m}_{\text{fuel}} (h_f - h_{f,\text{ref}} + \eta_{\text{comb}} \text{LHV}) + \dot{m}_{\text{gas}} (h_{\text{out}} - h_{a,\text{ref}}) = 0$$

### Constructor Arguments
```python
CombustionChamber(
    name, backend_air, backend_fuel,
    LHV=50.0e6,
    eta_comb=1.0,
    dp_rel=0.04,
    AFR_stoich=17.2,
    T_ref=298.15,
    p_ref=101325.0,
    T_max_warn=1700.0
)
```

### Ports
- `air_in`: Air inlet port (`FluidPort`, `backend_air`).
- `fuel_in`: Fuel inlet port (`FluidPort`, `backend_fuel`).
- `gas_out`: Exhaust gas port (`FluidPort`, `backend_air`).

### Outputs
- `cc.Qdot_fuel`: Total chemical power ($\dot{m}_{\text{fuel}} \cdot \text{LHV}$).
- `cc.Qdot_released`: Net thermal heat released ($\eta_{\text{comb}} \cdot \dot{Q}_{\text{fuel}}$).
- `cc.AFR`: Air-to-fuel ratio ($\dot{m}_{\text{air}} / \dot{m}_{\text{fuel}}$).
- `cc.excess_air`: Excess air factor ($\lambda = \text{AFR} / \text{AFR}_{\text{stoich}}$).

