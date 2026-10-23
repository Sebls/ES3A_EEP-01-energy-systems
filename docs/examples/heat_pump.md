# Example 02: Vapor Compression Heat Pump

This example models a subcritical vapor-compression heat pump loop operating on R134a with a compressor, condenser (sizing), expansion valve, and evaporator (sizing).

---

## Schematic

```
          ┌──────── [Condenser (SizingHX)] ◄────────┐
          │                                         │
          ▼                                         │
  [Expansion Valve]                           [Compressor]
          │                                         ▲
          ▼                                         │
          └────────► [Evaporator (SizingHX)] ───────┘
```

---

## Complete Python Script

```python
import numpy as np
from caldis.core.system import System
from caldis.components import Compressor, Valve, SizingHX, FluidBoundary
from caldis.fluids import CoolPropBackend
from caldis.solvers import solve
from caldis.solvers.autostart import fix_port, autostart

# 1. Backends
r134a = CoolPropBackend("R134a")
water = CoolPropBackend("Water")

# 2. Operating specs
m_ref = 0.08       # 80 g/s refrigerant
p_evap = 2.5e5     # Evaporator pressure (2.5 bar, ~ -4 °C)
p_cond = 12.0e5    # Condenser pressure (12.0 bar, ~ 46 °C)

# 3. Components
comp = Compressor("comp", backend=r134a, eta_is=0.82)
valve = Valve("valve", Kv=None, backend=r134a)   # Kv sized to match flow

# Condenser: R134a heats water loop (water in 30 °C, out 35 °C)
cond = SizingHX("cond", backend_hot=r134a, backend_cold=water,
                h_hot=2500.0, h_cold=3500.0, area_ratio_cold_to_hot=1.0)

# Evaporator: R134a cools water loop (water in 12 °C, out 7 °C)
evap = SizingHX("evap", backend_hot=water, backend_cold=r134a,
                h_hot=3000.0, h_cold=2500.0, area_ratio_cold_to_hot=1.0)

# External water sources/sinks
w_cond_in = FluidBoundary("w_cond_in", p=2e5, T=30 + 273.15, mdot=-1.2, backend=water)
w_cond_out = FluidBoundary("w_cond_out", p=2e5, backend=water)

w_evap_in = FluidBoundary("w_evap_in", p=2e5, T=12 + 273.15, mdot=-1.0, backend=water)
w_evap_out = FluidBoundary("w_evap_out", p=2e5, backend=water)

# 4. System Assembly
sys = System("heat_pump")
sys.add(comp, cond, valve, evap, w_cond_in, w_cond_out, w_evap_in, w_evap_out)

# Refrigerant loop connections
sys.connect(comp.out, cond.hot_in)
sys.connect(cond.hot_out, valve.inl)
sys.connect(valve.out, evap.cold_in)
# Close loop on evaporator to compressor suction!
sys.connect(evap.cold_out, comp.inl, close_loop=True)

# Water loop connections
sys.connect(w_cond_in.port, cond.cold_in)
sys.connect(cond.cold_out, w_cond_out.port)

sys.connect(w_evap_in.port, evap.hot_in)
sys.connect(evap.hot_out, w_evap_out.port)

# 5. Constraints
fix_port(sys, comp.inl, p=p_evap, mdot=m_ref)   # Low side p and loop flow
fix_port(sys, comp.out, p=p_cond)               # High side p
# Superheat at compressor suction: 5 K superheat
T_sat_evap = r134a.T(p_evap, r134a.h_pq(p_evap, 1.0))
fix_port(sys, comp.inl, T=T_sat_evap + 5.0)

# 6. Start Hints & Solve
autostart(sys)
sys.set_start(comp, p=p_cond, side=None)
sys.set_start_port(comp.out, T=340.0)

sol = solve(sys, verbose=True)

# 7. Coefficient of Performance (COP)
W_in = abs(comp.Wdot)
Q_heating = cond.Qdot
COP = Q_heating / W_in

print("\n=== HEAT PUMP RESULTS ===")
print(f"Compressor Power: {W_in:.1f} W")
print(f"Heating Duty:     {Q_heating:.1f} W")
print(f"COP (Heating):    {COP:.2f}")
print(f"Condenser Area:   {cond.A_hot:.2f} m²")
print(f"Evaporator Area:  {evap.A_hot:.2f} m²")
print(f"Sized Valve Kv:   {valve.Kv:.3e}")
```

