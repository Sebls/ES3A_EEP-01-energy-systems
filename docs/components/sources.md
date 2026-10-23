# Boundaries & Sources

`caldis.components.sources.boundary.FluidBoundary` specifies thermodynamic conditions at open system boundaries.

---

## Operating Principle

`FluidBoundary` accepts four named parameters:
- `p`: Pressure ($\text{Pa}$)
- `T`: Temperature ($K$)
- `h`: Specific enthalpy ($\text{J/kg}$)
- `mdot`: Mass flow rate ($\text{kg/s}$)

### The Specification Rule
- **Any argument provided is IMPOSED as an equation.**
- **Any argument omitted is FREE and solved for by the system.**
- **Maximum of 2 state variables**: At most two of $(p, T, h)$ may be imposed (three raises `ValueError` due to over-specification).
- If `T` or `h` is specified, a `backend` must be supplied.

---

## Usage Examples

### 1. Inflow Source (All Imposed)
Fluid entering the system at 3 bar, 40 °C, and 2 kg/s. Since flow leaves the boundary into the system, `mdot` is negative:
```python
src = FluidBoundary("feed", p=3.0e5, T=313.15, mdot=-2.0, backend=be)
```

### 2. Discharge Sink (Pressure Fixed)
Exhaust discharging to atmospheric pressure; mass flow and enthalpy are dictated by upstream components:
```python
sink = FluidBoundary("exhaust", p=1.01325e5, backend=be)
```

### 3. Flow-Imposed Inlet (Free Pressure)
Inlet stream where flow rate and temperature are specified, but pressure floats with loop impedance:
```python
inlet = FluidBoundary("inlet", T=293.15, mdot=-0.5, backend=be)
```

### 4. Bare Sink (Completely Free)
Used to close an open stream without imposing any conditions:
```python
bare_sink = FluidBoundary("sink", backend=be)
```

