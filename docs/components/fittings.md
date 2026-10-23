# Network Fittings: Mixer & Splitter

Junction components for adiabatic stream merging, flow branching, and manifold piping.

---

## Mixer

`caldis.components.fittings.mixer.Mixer` models an adiabatic mixing junction where two inlet streams merge into a single outlet under isobaric conditions.

### Constructor & Parameters

```python
Mixer(name, backend)
```

| Parameter | Type | Default | Description & Constraints |
| :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | Component identifier string. |
| `backend` | `FluidBackend` | *required* | Fluid thermodynamic properties backend. |

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `in1` | Inlet | `FluidPort` | First inlet stream ($\dot{m}_{\text{in1}} > 0$). |
| `in2` | Inlet | `FluidPort` | Second inlet stream ($\dot{m}_{\text{in2}} > 0$). |
| `out` | Outlet | `FluidPort` | Combined mixed discharge stream ($\dot{m}_{\text{out}} < 0$). |

### Governing Equations & Residuals

The component contributes 4 algebraic residuals (`residuals()`):

1. **Total mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{in1}} + \dot{m}_{\text{in2}} + \dot{m}_{\text{out}} = 0$$
2. **Energy conservation (`"energy"`)**:
   $$\dot{m}_{\text{in1}} h_{\text{in1}} + \dot{m}_{\text{in2}} h_{\text{in2}} + \dot{m}_{\text{out}} h_{\text{out}} = 0$$
3. **Inlet pressure equalization (`"p_in2"`)**:
   $$p_{\text{in2}} - p_{\text{in1}} = 0$$
4. **Outlet pressure equalization (`"p_out"`)**:
   $$p_{\text{out}} - p_{\text{in1}} = 0$$

### Post-Solve Outputs

Updated upon solver convergence via `update_outputs()`:

| Property | Symbol | Type / Units | Description |
| :--- | :--- | :--- | :--- |
| `mixer.mdot_out` | $\dot{m}_{\text{mixed}}$ | `float` ($\text{kg/s}$) | Total discharged mass flow rate: $-\dot{m}_{\text{out}} > 0$. |

### Pre-Solve Sanity Checks (`_own_start_sanity`)

- $\dot{m}_{\text{in1}} > 0$ and $\dot{m}_{\text{in2}} > 0$ (must both be entering streams).
- $\dot{m}_{\text{out}} < 0$ (must be a leaving stream).

---

## Splitter

`caldis.components.fittings.splitter.Splitter` models a pipe manifold or tee dividing one inlet stream into two distinct outlet streams at identical thermodynamic states.

### Constructor & Parameters

```python
Splitter(name, backend)
```

| Parameter | Type | Default | Description & Constraints |
| :--- | :--- | :--- | :--- |
| `name` | `str` | *required* | Component identifier string. |
| `backend` | `FluidBackend` | *required* | Fluid thermodynamic properties backend. |

### Ports

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `inl` | Inlet | `FluidPort` | Main inflow port ($\dot{m}_{\text{inl}} > 0$). |
| `out1` | Outlet | `FluidPort` | First branch outlet port ($\dot{m}_{\text{out1}} < 0$). |
| `out2` | Outlet | `FluidPort` | Second branch outlet port ($\dot{m}_{\text{out2}} < 0$). |

### Governing Equations & Residuals

The component contributes 5 algebraic residuals (`residuals()`):

1. **Total mass conservation (`"mass"`)**:
   $$\dot{m}_{\text{inl}} + \dot{m}_{\text{out1}} + \dot{m}_{\text{out2}} = 0$$
2. **First branch isenthalpic split (`"h_out1"`)**:
   $$h_{\text{out1}} - h_{\text{inl}} = 0$$
3. **Second branch isenthalpic split (`"h_out2"`)**:
   $$h_{\text{out2}} - h_{\text{inl}} = 0$$
4. **First branch isobaric split (`"p_out1"`)**:
   $$p_{\text{out1}} - p_{\text{inl}} = 0$$
5. **Second branch isobaric split (`"p_out2"`)**:
   $$p_{\text{out2}} - p_{\text{inl}} = 0$$

### Branch Split Determinacy
`Splitter` does not fix the distribution ratio between `out1` and `out2`. The split ratio is a degree of freedom determined globally by the relative hydraulic impedances (valves, pressure drops) of the downstream subnetworks connected to each branch.

### Post-Solve Outputs

Updated upon solver convergence via `update_outputs()`:

| Property | Symbol | Type / Units | Description |
| :--- | :--- | :--- | :--- |
| `splitter.mdot_in` | $\dot{m}_{\text{total}}$ | `float` ($\text{kg/s}$) | Total inlet mass flow entering the splitter: $\dot{m}_{\text{inl}} > 0$. |

### Pre-Solve Sanity Checks (`_own_start_sanity`)

- $\dot{m}_{\text{inl}} > 0$ (must be an inflow).
- $\dot{m}_{\text{out1}} < 0$ and $\dot{m}_{\text{out2}} < 0$ (must both be outflows).


