# Example 03: Dynamic Heated Tank

This example demonstrates dynamic DAE simulation of a rigid water storage tank heated by an electric element while receiving variable inlet flow.

---

## Schematic

```
 [Cold Water Inflow] ──> [Tank: Fluid Volume + Metal Wall] ──> [Hot Water Outflow]
                                      ▲
                                 [Q_heater]
```

---

## Complete Python Script

```python
import numpy as np
import matplotlib.pyplot as plt

from caldis.core.system import System
from caldis.components import TankConstV, FluidBoundary
from caldis.fluids import CoolPropBackend
from caldis.solvers import simulate

# 1. Backend
water = CoolPropBackend("Water")

# 2. Initial state
p_init = 2.0e5       # 2 bar
T_init = 293.15      # 20 °C
h_init = water.h_pt(p_init, T_init)

# 3. Components
# 50-liter tank with steel wall
tank = TankConstV(
    name="tank",
    backend=water,
    V=0.05,                   # 50 L
    p_init=p_init,
    h_init=h_init,
    C_wall=15000.0,           # J/K wall heat capacitance
    T_wall_init=T_init,
    UA_wall=250.0,            # W/K internal wall-fluid conductance
    Q_heater=3000.0           # 3 kW electric heater
)

feed = FluidBoundary("feed", p=p_init, T=T_init, mdot=-0.05, backend=water)
drain = FluidBoundary("drain", p=p_init, backend=water)

sys = System("dynamic_tank")
sys.add(feed, tank, drain)
sys.connect(feed.port, tank.inl)
sys.connect(tank.out, drain.port)

# 4. Dynamic Input Modulation
def modulate_heater(system, t):
    # Turn off electric heater after 120 seconds
    if t > 120.0:
        tank.params["Q_heater"] = 0.0

# 5. Run DAE Simulation (240 s, 1 s timestep)
results = simulate(
    sys,
    t_end=240.0,
    dt=1.0,
    init="steady",
    update_inputs=modulate_heater,
    progress=True
)

# 6. Post-process & Inspect Historical Traces
time = results.time
T_fluid = results.tank.fluid.T - 273.15
T_wall = results.tank.wall.T - 273.15

print(f"Max Fluid Temperature reached: {np.max(T_fluid):.1f} °C")
print(f"Final Fluid Temperature at 240s: {T_fluid[-1]:.1f} °C")
```

