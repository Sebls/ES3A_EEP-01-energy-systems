# Heat Exchangers

Caldis provides both single-zone lumped models (`SizingHX`, `RatingHX`) for steady-state sizing and rating design, and a full 1D discretized finite-volume model (`HXSim`) for dynamic, transient, and two-phase simulations.

---

## SizingHX (Heat Exchanger Sizing)

`caldis.components.HEX.heat_exchanger.SizingHX` sizes the required heat transfer area and overall thermal conductance for a given duty. It uses a single-zone regularized log-mean temperature difference (LMTD) formulation.

### Physics

**Coupling & Energy Balance**:

$$\dot{Q}_{\text{hot}} = \dot{m}_{\text{hot}} (h_{\text{hot,in}} - h_{\text{hot,out}})$$

$$\dot{Q}_{\text{cold}} = \dot{m}_{\text{cold}} (h_{\text{cold,out}} - h_{\text{cold,in}})$$

$$\dot{Q}_{\text{hot}} + \dot{Q}_{\text{cold}} = 0$$

**LMTD & Conductance ($UA$)**:

$$\Delta T_1 = T_{\text{hot,in}} - T_{\text{cold,out}}, \quad \Delta T_2 = T_{\text{hot,out}} - T_{\text{cold,in}}$$

$$\text{LMTD} = \frac{\Delta T_1 - \Delta T_2}{\ln(\Delta T_1 / \Delta T_2)}$$

$$UA = \frac{|\dot{Q}_{\text{hot}}|}{\text{LMTD}}$$

**Film Resistance & Sizing Area**:

$$U_{\text{overall,hot}} = \left(\frac{1}{h_{\text{hot}}} + \frac{1}{\text{area\_ratio} \cdot h_{\text{cold}}}\right)^{-1}$$

$$A_{\text{hot}} = \frac{UA}{U_{\text{overall,hot}}}, \quad A_{\text{cold}} = \text{area\_ratio} \cdot A_{\text{hot}}, \quad A_{\text{total}} = A_{\text{hot}} + A_{\text{cold}}$$

### Constructor Arguments
```python
SizingHX(
    name,
    backend_hot,
    backend_cold,
    h_hot,
    h_cold,
    area_ratio_cold_to_hot
)
```
- `name` (*str*): Unique component identifier.
- `backend_hot` (*FluidBackend*): Fluid property backend for the hot channel.
- `backend_cold` (*FluidBackend*): Fluid property backend for the cold channel.
- `h_hot` (*float*): Hot-side convective film coefficient [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `h_cold` (*float*): Cold-side convective film coefficient [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `area_ratio_cold_to_hot` (*float*): Ratio of cold-side to hot-side surface area $A_{\text{cold}} / A_{\text{hot}}$ ($\ge 1$ for cold-side finned, $= 1$ for bare plate/tube).

### Ports (Inputs / Boundary Interfaces)
- `hot_in`: Hot stream inlet port (`FluidPort`, backend: `backend_hot`).
- `hot_out`: Hot stream outlet port (`FluidPort`, backend: `backend_hot`).
- `cold_in`: Cold stream inlet port (`FluidPort`, backend: `backend_cold`).
- `cold_out`: Cold stream outlet port (`FluidPort`, backend: `backend_cold`).

### Internal Variables (Solved by System)
- `UA`: Overall thermal conductance [$\text{W}/\text{K}$].
- `A_hot`: Required heat transfer area on the hot side [$\text{m}^2$].

### Outputs (Post-Solve Properties)
- `hx.UA` (*float*): Solved overall conductance [$\text{W}/\text{K}$].
- `hx.A_hot` (*float*): Sized hot-side area [$\text{m}^2$].
- `hx.A_cold` (*float*): Sized cold-side area [$\text{m}^2$].
- `hx.A_total` (*float*): Total heat transfer area $A_{\text{hot}} + A_{\text{cold}}$ [$\text{m}^2$].
- `hx.U_overall_hot` (*float*): Overall heat transfer coefficient referenced to $A_{\text{hot}}$ [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `hx.U_overall_cold` (*float*): Overall heat transfer coefficient referenced to $A_{\text{cold}}$ [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `hx.Qdot` (*float*): Heat transfer rate $\dot{Q}_{\text{hot}}$ [$\text{W}$].
- `hx.DTLM` (*float*): Log-mean temperature difference [$\text{K}$].

### Sanity & Physical Checks
- Checks that the hot stream is warmer than the cold stream ($T_{\text{hot,in}} \ge T_{\text{cold,out}}$ and $T_{\text{hot,out}} \ge T_{\text{cold,in}}$).
- Detects temperature pinches/crosses ($\Delta T_1 \cdot \Delta T_2 > 0$).
- Warns against degenerate inlet/outlet temperature differences.

---

## RatingHX (Heat Exchanger Rating)

`caldis.components.HEX.heat_exchanger.RatingHX` evaluates off-design performance when geometry and heat transfer area (or conductance) are fixed. It employs an explicit effectiveness-NTU ($\varepsilon\text{-NTU}$) closure.

### Physics

**Capacity Rates & NTU**:

$$C_{\text{hot}} = |\dot{m}_{\text{hot}}| \cdot c_{p,\text{hot}}, \quad C_{\text{cold}} = |\dot{m}_{\text{cold}}| \cdot c_{p,\text{cold}}$$

$$C_{\text{min}} = \min(C_{\text{hot}}, C_{\text{cold}}), \quad C_{\text{max}} = \max(C_{\text{hot}}, C_{\text{cold}}), \quad C_r = \frac{C_{\text{min}}}{C_{\text{max}}}$$

$$\text{NTU} = \frac{UA}{C_{\text{min}}}$$

**Effectiveness ($\varepsilon$)**:

- *Counterflow*:
  $$\varepsilon = \frac{1 - \exp(-\text{NTU}(1 - C_r))}{1 - C_r \exp(-\text{NTU}(1 - C_r))} \quad (\text{or } \frac{\text{NTU}}{1 + \text{NTU}} \text{ when } C_r \to 1)$$
- *Coflow (Parallel flow)*:
  $$\varepsilon = \frac{1 - \exp(-\text{NTU}(1 + C_r))}{1 + C_r}$$

**Heat Duty & Energy Balance**:

$$\dot{Q} = \varepsilon \cdot C_{\text{min}} \cdot (T_{\text{hot,in}} - T_{\text{cold,in}})$$

$$\dot{m}_{\text{hot}} (h_{\text{hot,in}} - h_{\text{hot,out}}) = \dot{Q}$$

$$\dot{m}_{\text{cold}} (h_{\text{cold,out}} - h_{\text{cold,in}}) = \dot{Q}$$

### Constructor Arguments
Provide **either** `UA` directly, **or** the complete physical geometry set (`h_hot`, `h_cold`, `area_ratio_cold_to_hot`, `A_hot`):

```python
RatingHX(
    name,
    backend_hot,
    backend_cold,
    UA=None,
    h_hot=None,
    h_cold=None,
    area_ratio_cold_to_hot=None,
    A_hot=None,
    flow_config="counterflow"
)
```
- `name` (*str*): Unique component identifier.
- `backend_hot` (*FluidBackend*): Fluid property backend for the hot channel.
- `backend_cold` (*FluidBackend*): Fluid property backend for the cold channel.
- `UA` (*float*, optional): Direct overall thermal conductance [$\text{W}/\text{K}$].
- `h_hot` (*float*, optional): Hot-side convective film coefficient [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `h_cold` (*float*, optional): Cold-side convective film coefficient [$\text{W}/(\text{m}^2\cdot\text{K})$].
- `area_ratio_cold_to_hot` (*float*, optional): Ratio $A_{\text{cold}} / A_{\text{hot}}$.
- `A_hot` (*float*, optional): Fixed hot-side heat transfer area [$\text{m}^2$].
- `flow_config` (*str*, optional): Flow arrangement, either `"counterflow"` (default) or `"coflow"`.

### Ports (Inputs / Boundary Interfaces)
- `hot_in`: Hot stream inlet port (`FluidPort`, backend: `backend_hot`).
- `hot_out`: Hot stream outlet port (`FluidPort`, backend: `backend_hot`).
- `cold_in`: Cold stream inlet port (`FluidPort`, backend: `backend_cold`).
- `cold_out`: Cold stream outlet port (`FluidPort`, backend: `backend_cold`).

### Outputs (Post-Solve Properties)
- `hx.Qdot` (*float*): Transferred thermal power $\dot{Q}$ [$\text{W}$].
- `hx.effectiveness` (*float*): Heat exchanger thermal effectiveness $\varepsilon \in [0, 1]$.
- `hx.NTU` (*float*): Number of transfer units.
- `hx.Cr` (*float*): Heat capacity rate ratio $C_{\text{min}} / C_{\text{max}}$.
- `hx.C_hot` (*float*): Hot fluid capacity rate $|\dot{m}_{\text{hot}}| \cdot c_{p,\text{hot}}$ [$\text{W}/\text{K}$].
- `hx.C_cold` (*float*): Cold fluid capacity rate $|\dot{m}_{\text{cold}}| \cdot c_{p,\text{cold}}$ [$\text{W}/\text{K}$].
- `hx.UA` (*float*): Conductance applied in rating [$\text{W}/\text{K}$].
- `hx.T_hot_out` (*float*): Computed hot-side discharge temperature [$\text{K}$].
- `hx.T_cold_out` (*float*): Computed cold-side discharge temperature [$\text{K}$].

### Scope & Constraints
- Valid for **single-phase (sensible)** heat exchange (constant $c_p$ evaluated at inlets).
- Pressure drop is neglected ($p_{\text{out}} = p_{\text{in}}$). For condensing, evaporating, or distributed pressure drops, use `SizingHX` or `HXSim`.

---

## HXSim (Discretized Finite-Volume Heat Exchanger)

`caldis.components.HEX.hex_discretized.HXSim` models a 1D discretized counterflow or coflow heat exchanger with $N$ elements for steady-state, transient dynamic, and two-phase simulations.

### Physics & Formulation
- **Staggered finite-volume grid**:
  - Per cell $i \in [0, N-1]$:
    - Mass differential state: $\frac{dM_i}{dt} = \dot{m}_{\text{in}, i} - \dot{m}_{\text{out}, i}$
    - Energy differential state: $\frac{dU_i}{dt} = \dot{m}_{\text{in}, i} h_{\text{in}, i} - \dot{m}_{\text{out}, i} h_{\text{out}, i} + \dot{Q}_i$
    - Algebraic equation of state: $M_i = \rho_{\text{eff}, i} V_i$, and $U_i = V_i (\rho h_{\text{eff}, i} - p_i)$
  - Per element wall:
    - Transient wall temperature: $m_{\text{wall}, i} c_{p,\text{wall}} \frac{dT_{\text{wall}, i}}{dt} = \dot{Q}_{\text{hot}\to\text{wall}, i} + \dot{Q}_{\text{cold}\to\text{wall}, i}$
  - Per internal cell face $k \in [0, N-2]$:
    - Momentum equation: $p_k - p_{k+1} = \left(\frac{dp}{dz}\right)_k \Delta L_k$
- **Replaceable correlation bricks**:
  - Convection, radiation, pressure gradient ($dp/dz$), and two-phase void fraction ($\varepsilon$).

### Constructor Arguments
```python
HXSim(
    name,
    backend_hot,
    backend_cold,
    n_elements=10,
    flow_config="counterflow",
    geometry_params=None,
    m_wall=1.0,
    cp_wall=500.0,
    R_fouling=0.0,
    geometry_fn=None,
    h_conv_hot=None,
    h_conv_cold=None,
    h_rad_hot=None,
    h_rad_cold=None,
    dp_hot=None,
    dp_cold=None,
    void_hot=None,
    void_cold=None
)
```
- `name` (*str*): Unique component identifier.
- `backend_hot` (*FluidBackend*): Fluid property backend for the hot channel.
- `backend_cold` (*FluidBackend*): Fluid property backend for the cold channel.
- `n_elements` (*int*, optional): Number of spatial finite-volume discretization elements along the length. Default is `10`.
- `flow_config` (*str*, optional): Flow configuration, `"counterflow"` (default) or `"coflow"`.
- `geometry_params` (*dict*, optional): Channel and surface geometry dictionary passed to `geometry_fn`. Typical keys for default plate:
  - `plate_width` (*float*): Channel width in meters (default: `0.1` m).
  - `plate_gap` (*float*): Channel plate gap/spacing in meters (default: `0.003` m).
  - `L_total` (*float*): Total heat exchanger length in meters (default: `0.5` m).
- `m_wall` (*float*, optional): Total thermal mass of the separating wall [$\text{kg}$]. Default is `1.0`.
- `cp_wall` (*float*, optional): Specific heat capacity of the wall material [$\text{J}/(\text{kg}\cdot\text{K})$]. Default is `500.0`.
- `R_fouling` (*float*, optional): Thermal fouling resistance [$(\text{m}^2\cdot\text{K})/\text{W}$]. Default is `0.0`.
- `geometry_fn` (*callable*, optional): Function `(element_index, geometry_params) -> dict` returning geometry metrics (`A_exchange`, `A_cross`, `V_internal`, `dh`, `perimeter_wet`, `L_elem`). Defaults to `geometry_plate`.
- `h_conv_hot`, `h_conv_cold` (*callable*, optional): Convective heat transfer brick `brick(ctx) -> h_conv` [$\text{W}/(\text{m}^2\cdot\text{K})$]. Defaults to `h_conv_constant(500.0)`.
- `h_rad_hot`, `h_rad_cold` (*callable*, optional): Radiative equivalent heat transfer brick `brick(ctx) -> h_rad` [$\text{W}/(\text{m}^2\cdot\text{K})$]. Defaults to `h_rad_constant(0.0)`.
- `dp_hot`, `dp_cold` (*callable*, optional): Frictional pressure gradient brick `brick(ctx) -> dp/dz` [$\text{Pa}/\text{m}$]. Defaults to `dp_linear(1000.0)`.
- `void_hot`, `void_cold` (*callable*, optional): Two-phase void fraction brick `brick(ctx) -> eps` $\in [0, 1]$. Defaults to `void_homogeneous()`.

### Ports (Inputs / Boundary Interfaces)
- `hot_in`: Hot channel inlet port (`FluidPort`, backend: `backend_hot`).
- `hot_out`: Hot channel outlet port (`FluidPort`, backend: `backend_hot`).
- `cold_in`: Cold channel inlet port (`FluidPort`, backend: `backend_cold`).
- `cold_out`: Cold channel outlet port (`FluidPort`, backend: `backend_cold`).

### Internal Solved States & Variables
- Hot side per element: mass hold-up $M_{h, i}$, internal energy $U_{h, i}$, pressure $p_{h, i}$, enthalpy $h_{h, i}$.
- Cold side per element: mass hold-up $M_{c, i}$, internal energy $U_{c, i}$, pressure $p_{c, i}$, enthalpy $h_{c, i}$.
- Wall per element: wall temperature $T_{w, i}$.
- Internal face flows: $\dot{m}_{fh, k}$ and $\dot{m}_{fc, k}$ for $k \in [0, N-2]$.

### Outputs (Post-Solve Properties)
- `hx.T_hot` (*list[float]*): Array of temperatures along the hot stream cells [$\text{K}$].
- `hx.T_cold` (*list[float]*): Array of temperatures along the cold stream cells [$\text{K}$].
- `hx.Tw` (*list[float]*): Array of wall temperatures along each element [$\text{K}$].
- `hx.x_hot` (*list[float]*): Array of vapor quality values along the hot stream cells ($-1$ if subcooled liquid, $>1$ if superheated vapor).
- `hx.x_cold` (*list[float]*): Array of vapor quality values along the cold stream cells.
- `hx.charge_hot` (*float*): Total fluid mass inventory inside the hot side [$\text{kg}$].
- `hx.charge_cold` (*float*): Total fluid mass inventory inside the cold side [$\text{kg}$].
- `hx.Qdot_total` (*float*): Total heat transfer rate transferred from the hot stream [$\text{W}$].

### Correlation Brick Reference
Pre-built correlation factories provided under `caldis.components.HEX.correlations`:
- **Convection** (`convection.py`):
  - `h_conv_constant(h=500.0)`
  - `h_conv_dittus_boelter(C=0.023, m=0.8, n=0.4, Nu_lam=4.0, Re_turb=2300.0)`
- **Radiation** (`radiation.py`):
  - `h_rad_constant(h=0.0)`
  - `h_rad_view_factor(emissivity=0.8, F_view=1.0)`
- **Pressure Drop** (`pressure.py`):
  - `dp_linear(K=1000.0)`
  - `dp_quadratic(K=1.0e4)`
- **Void Fraction** (`void.py`):
  - `void_homogeneous()`
  - `void_zivi()`
- **Geometry** (`geometry.py`):
  - `geometry_plate(element_index, geometry_params)`


