# Network Fittings: Mixer & Splitter

Network junctions manage flow recombination and stream branching in multi-stream cycles.

---

## Mixer

`caldis.components.fittings.mixer.Mixer` models an adiabatic mixing junction where two inlet streams merge into one outlet.

### Residuals
**Total mass balance**:

$$\dot{m}_{\text{in1}} + \dot{m}_{\text{in2}} + \dot{m}_{\text{out}} = 0$$

**Energy balance (signed mass flows)**:

$$\dot{m}_{\text{in1}} h_{\text{in1}} + \dot{m}_{\text{in2}} h_{\text{in2}} + \dot{m}_{\text{out}} h_{\text{out}} = 0$$

**Constant-pressure mixing**:

$$p_{\text{in2}} - p_{\text{in1}} = 0$$

$$p_{\text{out}} - p_{\text{in1}} = 0$$

### Constructor Arguments
```python
Mixer(name, backend)
```
- Ports: `in1`, `in2`, `out`.
- Output: `mixer.mdot_out` ($-\dot{m}_{\text{out}} > 0$).

---

## Splitter

`caldis.components.fittings.splitter.Splitter` models a flow splitter where one inlet divides into two outlet streams at identical thermodynamic states.

### Residuals
**Mass conservation**:

$$\dot{m}_{\text{inl}} + \dot{m}_{\text{out1}} + \dot{m}_{\text{out2}} = 0$$

**Equal enthalpy**:

$$h_{\text{out1}} - h_{\text{inl}} = 0$$

$$h_{\text{out2}} - h_{\text{inl}} = 0$$

**Equal pressure**:

$$p_{\text{out1}} - p_{\text{inl}} = 0$$

$$p_{\text{out2}} - p_{\text{inl}} = 0$$

### Flow Split Determination
The splitter itself does not fix the fraction of mass entering each branch. The flow split is naturally determined by the downstream hydraulic impedance (e.g., valves, heat exchangers) of each branch.

### Constructor Arguments
```python
Splitter(name, backend)
```
- Ports: `inl`, `out1`, `out2`.
- Output: `splitter.mdot_in` ($\dot{m}_{\text{inl}} > 0$).

