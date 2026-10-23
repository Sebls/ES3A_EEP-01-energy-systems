# Sign Conventions & Port Standards

Consistent sign conventions are essential for modular energy system simulation. Caldis enforces explicit conventions across all components.

---

## Fluid Mass Flow Rates (`mdot`)

Caldis uses the **inlet-positive convention**:

$$\dot{m} > 0 \quad \text{enters the component}$$

$$\dot{m} < 0 \quad \text{leaves the component}$$

```
   Inlet Port                      Outlet Port
   mdot > 0                        mdot < 0
  ───────────> [  Component  ] ───────────>
```

### Consequences
1. **Mass Balance across two-port components**:

    $$\dot{m}_{\text{in}} + \dot{m}_{\text{out}} = 0$$

2. **Sources and Sinks (`FluidBoundary`)**:
    - A **fluid source** (feeding fluid into the system) sends mass *out* of its own port, so `mdot` is **negative**:
      ```python
      src = FluidBoundary("feed", p=3e5, T=293.15, mdot=-1.5, backend=be)
      ```
    - A **fluid sink** (receiving fluid from the system) receives mass into its port, so its resolved `mdot` will be positive.

3. **Connections**:
    When connecting `port_a` to `port_b`:

    $$\dot{m}_a + \dot{m}_b = 0$$

---

## Power and Work Conventions ($\dot{W}$)

Caldis adopts the **power producer positive** convention:

$$\dot{W} > 0 \quad \text{work produced by the system / component}$$

$$\dot{W} < 0 \quad \text{work absorbed by the system / component}$$

**Turbine (`Turbine`)**:

Delivers shaft work ($\dot{W}_{\text{turb}} > 0$):

$$\dot{W}_{\text{turb}} = \eta_{\text{mech}} \cdot \dot{m}_{\text{in}} \cdot (h_{\text{in}} - h_{\text{out}})$$

**Compressor (`Compressor`)**:

Absorbs electrical or shaft work (reported as $\dot{W}_{\text{comp}} < 0$):

$$\dot{W}_{\text{comp}} = - \dot{m}_{\text{in}} \cdot (h_{\text{out}} - h_{\text{in}})$$

**Net Cycle Power**:

$$W_{\text{net}} = \dot{W}_{\text{turbine}} + \dot{W}_{\text{compressor}}$$

---

## Thermal Duties ($\dot{Q}$)

Heat transferred **into the fluid stream** is positive:

$$\dot{Q} > 0 \quad \text{fluid is heated}$$

$$\dot{Q} < 0 \quad \text{fluid is cooled}$$

**In `SimpleHeater`**:

$$\dot{Q} = \dot{m}_{\text{in}} \cdot (h_{\text{out}} - h_{\text{in}})$$

**In `SizingHX` / `RatingHX`**:

$$\dot{Q}_{\text{hot}} = \dot{m}_{\text{hot}} \cdot (h_{\text{hot,in}} - h_{\text{hot,out}}) > 0 \quad (\text{heat lost by hot stream})$$

$$\dot{Q}_{\text{cold}} = \dot{m}_{\text{cold}} \cdot (h_{\text{cold,out}} - h_{\text{cold,in}}) > 0 \quad (\text{heat gained by cold stream})$$

Coupling equation:

$$\dot{Q}_{\text{hot}} - \dot{Q}_{\text{cold}} = 0$$

---

## State Coordinate Standard: $(p, h)$

Caldis models all fluid streams using **pressure ($p$) and specific enthalpy ($h$)**, never $(p, T)$.

### Why $(p, h)$?
Under the two-phase saturation dome, temperature and pressure are not independent ($T = T_{\text{sat}}(p)$). Specifying $(p, T)$ within the dome is ill-posed. In contrast:
- Specific enthalpy $h$ is strictly monotonic across liquid, two-phase, and superheated vapor regions.
- Incompressible and compressible regimes are handled uniformly without switching state variables.

