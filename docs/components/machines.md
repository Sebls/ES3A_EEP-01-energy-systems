# Turbomachinery: Compressor & Turbine

Turbomachinery components model fluid work interactions with constant isentropic efficiencies.

---

## Compressor

`caldis.components.machines.compressor.Compressor` models an adiabatic compressor.

### Physics
**Mass balance**:

$$\dot{m}_{\text{inl}} + \dot{m}_{\text{out}} = 0$$

**Isentropic enthalpy rise**:

$$s_{\text{in}} = s(p_{\text{in}}, h_{\text{in}})$$

$$h_{\text{out}, s} = h(p_{\text{out}}, s_{\text{in}})$$

$$h_{\text{out}} = h_{\text{in}} + \frac{h_{\text{out}, s} - h_{\text{in}}}{\eta_{\text{is}}}$$

### Constructor Arguments
```python
Compressor(name, backend, eta_is)
```
- `name` (*str*): Unique component name.
- `backend` (*FluidBackend*): Fluid property backend.
- `eta_is` (*float*): Isentropic efficiency ($0 < \eta_{\text{is}} \le 1$).

### Ports
- `inl`: Suction port (`FluidPort`).
- `out`: Discharge port (`FluidPort`).

### Outputs (Post-Solve)
- `comp.Wdot`: Shaft work absorbed in Watts ($\dot{W} < 0$).
- `comp.pressure_ratio`: Discharge to suction pressure ratio ($p_{\text{out}} / p_{\text{in}}$).

### Start Sanity Checks
- Verifies that $p_{\text{out}} > p_{\text{in}}$ (warns if start pressure indicates expansion).

---

## Turbine

`caldis.components.machines.turbine.Turbine` models an adiabatic expansion turbine.

### Physics
**Mass balance**:

$$\dot{m}_{\text{inl}} + \dot{m}_{\text{out}} = 0$$

**Isentropic enthalpy drop**:

$$s_{\text{in}} = s(p_{\text{in}}, h_{\text{in}})$$

$$h_{\text{out}, s} = h(p_{\text{out}}, s_{\text{in}})$$

$$h_{\text{out}} = h_{\text{in}} - \eta_{\text{is}} \cdot (h_{\text{in}} - h_{\text{out}, s})$$

### Constructor Arguments
```python
Turbine(name, backend, eta_is=0.89, eta_mech=1.0)
```
- `name` (*str*): Unique component name.
- `backend` (*FluidBackend*): Fluid property backend.
- `eta_is` (*float*): Isentropic expansion efficiency. Default is `0.89`.
- `eta_mech` (*float*): Mechanical shaft efficiency. Default is `1.0`.

### Ports
- `inl`: Expansion inlet port (`FluidPort`).
- `out`: Expansion exhaust port (`FluidPort`).

### Outputs (Post-Solve)
- `turb.Wdot`: Net shaft power delivered in Watts ($\dot{W} > 0$).
- `turb.Wdot_is`: Ideal isentropic shaft power.
- `turb.pressure_ratio`: Expansion ratio ($p_{\text{in}} / p_{\text{out}}$).
- `turb.T_out_s`: Isentropic exhaust temperature ($K$).

### Start Sanity Checks
- Verifies $p_{\text{out}} < p_{\text{in}}$.
- Verifies $\dot{m}_{\text{in}} > 0$.
- Warns if $T_{\text{in}} < 500\text{ K}$ for gas turbines to catch forgotten thermal starts.

