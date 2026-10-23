# Valves & Pressure Restrictions

`caldis.components.valves.valve.Valve` models an adiabatic, isenthalpic expansion valve or hydraulic restriction.

---

## Operating Modes

1. **Simulation Mode (`Kv` provided)**:
   The flow coefficient $K_v$ is fixed. Mass flow rate is determined by the pressure drop:

    $$\dot{m} = f(\Delta p, K_v)$$

2. **Sizing Mode (`Kv=None`)**:
   $K_v$ is treated as an unknown `Variable` ($K_v \ge 0$). The system must impose flow or pressure conditions to determine the required valve size.

---

## Flow Laws

****Quadratic (`flow_law="quadratic"`)**: Standard orifice equation**:

$$\dot{m} = K_v \cdot \text{sgn}(\Delta p) \sqrt{|\Delta p| + \varepsilon}$$

****Linear (`flow_law="linear"`)**: Smoothed laminar law used to improve solver convergence during difficult initializations**:

$$\dot{m} = K_v \cdot \Delta p$$

---

## Constructor Arguments

```python
Valve(name, Kv=None, backend=None, flow_law="quadratic", eps=1e-9)
```
- `name` (*str*): Unique component name.
- `Kv` (*float or None*): Flow coefficient. If `None`, sizing mode is activated.
- `backend` (*FluidBackend*): Optional fluid backend.
- `flow_law` (*str*): `"quadratic"` or `"linear"`.
- `eps` (*float*): Regularization parameter preventing infinite derivatives at $\Delta p = 0$.

---

## Ports & Outputs

- Ports: `inl`, `out`.
- Outputs:
  - `valve.Kv`: Value of $K_v$ (parameter or solved unknown).
  - `valve.dp`: Pressure drop $p_{\text{inl}} - p_{\text{out}}$.

---

## Start Sanity Check

- Verifies that $p_{\text{inl}} \ge p_{\text{out}}$ (warns if start state exhibits reverse pressure gradient).

