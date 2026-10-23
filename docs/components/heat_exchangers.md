# Heat Exchangers

Caldis provides both single-zone lumped models (`SizingHX`, `RatingHX`) for sizing and design, and a full 1D discretized model (`HXSim`) for dynamic and transient simulation.

---

## SizingHX (Heat Exchanger Sizing)

`caldis.components.HEX.heat_exchanger.SizingHX` sizes the required heat transfer area and overall conductance for a given duty.

### Physics
****Coupling & Energy Balance****:

$$\dot{Q}_{\text{hot}} = \dot{m}_{\text{hot}} (h_{\text{hot,in}} - h_{\text{hot,out}})$$

$$\dot{Q}_{\text{cold}} = \dot{m}_{\text{cold}} (h_{\text{cold,out}} - h_{\text{cold,in}})$$

$$\dot{Q}_{\text{hot}} - \dot{Q}_{\text{cold}} = 0$$

****LMTD & Conductance ($UA$)****:

$$\Delta T_1 = T_{\text{hot,in}} - T_{\text{cold,out}}, \quad \Delta T_2 = T_{\text{hot,out}} - T_{\text{cold,in}}$$

$$\text{LMTD} = \frac{\Delta T_1 - \Delta T_2}{\ln(\Delta T_1 / \Delta T_2)}$$

$$UA = \frac{|\dot{Q}_{\text{hot}}|}{\text{LMTD}}$$

****Film Resistance & Sizing Area****:

$$U_{\text{overall,hot}} = \left(\frac{1}{h_{\text{hot}}} + \frac{1}{\text{area\_ratio} \cdot h_{\text{cold}}}\right)^{-1}$$

$$A_{\text{hot}} = \frac{UA}{U_{\text{overall,hot}}}, \quad A_{\text{cold}} = \text{area\_ratio} \cdot A_{\text{hot}}$$

### Constructor Arguments
```python
SizingHX(name, backend_hot, backend_cold, h_hot, h_cold, area_ratio_cold_to_hot)
```

### Unknowns & Outputs
- **Internal Unknowns**: `UA`, `A_hot`.
- **Outputs**: `hx.UA`, `hx.A_hot`, `hx.A_cold`, `hx.A_total`, `hx.Qdot`, `hx.DTLM`.

---

## RatingHX (Heat Exchanger Rating)

`caldis.components.HEX.heat_exchanger.RatingHX` evaluates off-design performance when geometry and heat transfer area are fixed.

### Constructor Arguments
```python
RatingHX(name, backend_hot, backend_cold, A_hot, h_hot, h_cold, area_ratio_cold_to_hot)
```

---

## HXSim (Discretized Finite-Volume Heat Exchanger)

`caldis.components.HEX.hex_discretized.HXSim` models a discretized counterflow or coflow heat exchanger with $N$ elements.

### Physics
- Finite-volume formulation with staggered grid:
  - Per cell: mass ($M$), internal energy ($U$), pressure ($p$), enthalpy ($h$).
  - Per element: transient wall temperature ($T_{\text{wall}}$).
  - Internal face mass flows resolved via momentum equations.
- Replaceable correlation bricks for convection, radiation, pressure drop, and void fraction.

### Constructor Arguments
```python
HXSim(
    name, backend_hot, backend_cold,
    n_elements=10,
    flow_config="counterflow",      # or "coflow"
    geometry_params=None,
    m_wall=1.0,
    cp_wall=500.0,
    R_fouling=0.0,
    h_conv_hot=None, h_conv_cold=None,
    dp_hot=None, dp_cold=None
)
```

### Correlation Bricks
Caldis includes standard correlations under `caldis.components.HEX.correlations`:
- `h_conv_constant(val)` / `dp_linear(k)`
- `void_homogeneous()` / `geometry_plate(...)`

