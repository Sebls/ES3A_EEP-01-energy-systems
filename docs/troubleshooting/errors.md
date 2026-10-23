# Common Errors & Troubleshooting

A guide to diagnosing and fixing the most frequent modeling and numerical errors in Caldis.

---

## 1. `DOFReport: [DOF sous-spécifié]` (Under-specified System)

### Symptoms
```text
ValueError: [DOF sous-spécifié] 14 inconnues, 12 équations : il manque 2 condition(s) aux limites (variables non déterminées).
```

### Cause
The system has more unknowns than equations. Some boundary pressures, temperatures, or design targets are missing.

### Solution
Use `fix_port` or add a `FluidBoundary` spec to close the missing degrees of freedom. Common culprits:
- A compressor or turbine without a specified outlet pressure or pressure ratio.
- A heat exchanger or heater without a specified duty or target temperature.
- An unconstrained recirculating mass flow in a closed cycle.

---

## 2. `DOFReport: [DOF sur-spécifié]` (Over-specified System)

### Symptoms
```text
ValueError: [DOF sur-spécifié] 12 inconnues, 13 équations : 1 équation(s) de trop (condition imposée en double ?).
```

### Cause
More equations exist than unknowns.

### Solution
- Check if you wired a closed loop without setting `close_loop=True` on the final connection.
- Check if both pressure and temperature are imposed on both ends of a component with fixed pressure drop.

---

## 3. `Start point not evaluable: non-finite residual`

### Symptoms
```text
ValueError: Start point not evaluable:
  - component hex: residual[4] is non-finite (value=nan)
```

### Cause
When the solver evaluated residuals at $x_0$, a mathematical or CoolProp error occurred (e.g. division by zero in LMTD due to identical temperatures, or out-of-domain $(p, h)$ inputs).

### Solution
Run `autostart(sys)` before solving, or supply an explicit initial guess using `sys.set_start_port(port, p=..., T=...)`.

---

## 4. `RANK DEFICIENT Jacobian` / Singular Matrix

### Symptoms
```text
=== Jacobian structure report ===
shape (18, 18) | rank 17 (full = 18)
  -> RANK DEFICIENT by 1.
  >> VARIABLES to re-anchor (start likely wrong):
     weight 0.89   comp.out.h   (current start=3.1e5)
```

### Cause
The derivative with respect to one or more variables is zero at the current operating point. For instance, evaluating an isentropic efficiency across zero pressure difference ($\Delta p = 0$) makes the enthalpy derivative vanish.

### Solution
Re-anchor the starting values of the variables flagged by the SVD null-space report using `sys.set_start_port(...)`.

---

## 5. `PHYSICAL-VALIDITY WARNING: Temperature cross`

### Symptoms
```text
PHYSICAL-VALIDITY WARNINGS (converged, but the solution may be non-physical):
  /!\ hex: temperature cross (hot_out 45.2°C < cold_out 60.1°C)
```

### Cause
The solver found a mathematical solution, but heat is transferring from cold fluid to hot fluid (violating the Second Law).

### Solution
- The specified heat exchanger area ($A$) or conductance ($UA$) may be too small for the requested duty.
- The mass flow rate on the cold or hot side is insufficient to absorb or provide the required heat.

