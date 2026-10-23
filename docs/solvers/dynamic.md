# Dynamic Integrator Reference

The dynamic solver `caldis.solvers.dynamic.simulate` integrates systems containing differential state variables over time.

---

## Function Signature

```python
def simulate(
    system,
    t_end,
    dt,
    update_inputs=None,
    init="steady",
    tol=1e-8,
    progress=False
)
```

### Parameters
- **`system`** (*System*): The assembled Caldis system.
- **`t_end`** (*float*): End time of the simulation in seconds ($s$).
- **`dt`** (*float*): Time integration step size ($s$).
- **`update_inputs`** (*callable or None*): Function of signature `fn(system, t)` invoked at each timestep to apply dynamic boundary conditions, disturbances, or control signals.
- **`init`** (*str*):
  - `"steady"` (default): Runs an initial steady solve ($\dot{x} = 0$) at $t = 0$.
  - `"current"`: Preserves existing state values and performs consistent initialization on algebraic variables using `_consistent_init`.
- **`tol`** (*float*): Newton solver convergence tolerance at each time step.
- **`progress`** (*bool*): Displays simulation progress bar.

### Return Value
Returns an instance of `caldis.experiments.results.Results`.

---

## Consistent Initialization at $t = 0$

Differential-algebraic systems cannot accept arbitrary initial conditions for algebraic variables. If a user sets $M_0$ and $U_0$ in a tank, the initial pressure $p_0$, enthalpy $h_0$, and flow rates must satisfy all component balance laws.

`_consistent_init(system, states, tol)`:

1. Pins all differential variables to their initial condition: $x_d - x_{d, 0} = 0$.
2. Leaves time derivatives $\dot{x}_d$ free as algebraic unknowns.
3. Solves the combined system:

    $$\begin{pmatrix} F(x_d, x_a, \dot{x}_d, t=0) \\ x_d - x_{d, 0} \end{pmatrix} = 0$$

    ensuring that recorded history at $t = 0$ is physically consistent.

