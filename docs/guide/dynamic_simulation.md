# Dynamic DAE Simulation

In addition to steady-state cycle analysis, Caldis features a native differential-algebraic equation (DAE) simulator: `caldis.solvers.simulate`.

---

## Index-1 DAE Formulation

A dynamic model in Caldis combines:
- **Differential equations**: $\dot{x}_d = f(x_d, x_a, t)$ for accumulated quantities (mass $M$, internal energy $U$, wall temperature $T_{\text{wall}}$).
- **Algebraic constraints**: $0 = g(x_d, x_a, t)$ for instantaneous balances (momentum, valve flow laws, algebraic port connections).

The integrated system solves the implicit residual form:

$$F(\dot{x}_d, x_d, x_a, t) = 0$$

Using an implicit backward differentiation (BDF / implicit Euler) scheme:

$$\dot{x}_{d, k+1} \approx \frac{x_{d, k+1} - x_{d, k}}{\Delta t}$$

---

## The Simulation Workflow

```python
from caldis.solvers import simulate

# Run dynamic simulation for 60 seconds with 0.5 s timestep
results = simulate(
    sys,
    t_end=60.0,
    dt=0.5,
    init="steady",             # or "current"
    update_inputs=my_input_fn, # optional time-dependent forcing
    progress=True
)
```

### Initial State (`init`)
- `init="steady"`: Solves a steady-state problem at $t = 0$ with all differential derivatives set to zero ($\dot{x}_d = 0$), providing physically consistent initial algebraic states.
- `init="current"`: Uses `_consistent_init()` to hold differential states fixed at their current initial conditions while resolving the algebraic variables to satisfy all residuals.

### Dynamic Input Driving (`update_inputs`)
To drive the simulation with time-varying parameters (e.g., ramping thermal duty, closing a valve):

```python
def update_inputs(system, t):
    # Ramp heater power from 1 kW to 5 kW over 30 seconds
    if t < 30.0:
        heater.params["Qdot"] = 1000.0 + (4000.0 / 30.0) * t
    else:
        heater.params["Qdot"] = 5000.0
```

---

## Navigating Results (`Results`)

The returned `results` object provides hierarchical attribute navigation over the simulation history:

```python
# Access time vector
t = results.time

# Access nested variables
T_wall = results.tank.wall.T        # NumPy 1D array of length N
p_fluid = results.tank.fluid.p

# Port access (with Python keyword handling)
m_in = results.tank.fluid["in"].mdot

# Convert entire history to pandas DataFrame
df = results.to_dataframe()
```

