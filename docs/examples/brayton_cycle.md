# Example 01: Open Brayton Gas Turbine

This complete example models an open-cycle gas turbine consisting of an ambient air compressor, a combustion chamber burning methane fuel, and an expansion turbine driving the compressor and net shaft load.

---

## Schematic

```
 [Air Inflow] ──> [Compressor] ──> [Combustion Chamber] ──> [Turbine] ──> [Exhaust]
                                           ^
                                     [Fuel Inflow]
```

---

## Complete Python Script

```python
import numpy as np
from caldis.core.system import System
from caldis.components import Compressor, Turbine, CombustionChamber, FluidBoundary
from caldis.fluids import CoolPropBackend
from caldis.solvers import solve
from caldis.solvers.autostart import fix_port, autostart

# 1. Backends for working fluid and fuel
air = CoolPropBackend("Air")
methane = CoolPropBackend("Methane")

# 2. Operating conditions
p_amb = 1.01325e5    # 1 atm
T_amb = 288.15       # 15 °C
m_air = 25.0         # 25 kg/s air
p_ratio = 10.0       # Pressure ratio = 10
T_tit = 1350.0       # Turbine Inlet Temperature (TIT) = 1350 K

# 3. Instantiate components
air_in = FluidBoundary("air_in", p=p_amb, T=T_amb, mdot=-m_air, backend=air)
comp = Compressor("comp", backend=air, eta_is=0.86)

comb = CombustionChamber(
    "combustor",
    backend_air=air,
    backend_fuel=methane,
    LHV=50.0e6,      # 50 MJ/kg
    eta_comb=0.99,
    dp_rel=0.03      # 3% combustor pressure drop
)

fuel_in = FluidBoundary("fuel_in", p=p_amb * p_ratio, T=298.15, backend=methane)
turb = Turbine("turb", backend=air, eta_is=0.88, eta_mech=0.99)
exhaust = FluidBoundary("exhaust", p=p_amb, backend=air)

# 4. Assemble system and connect streams
sys = System("open_brayton")
sys.add(air_in, comp, comb, fuel_in, turb, exhaust)

sys.connect(air_in.port, comp.inl)
sys.connect(comp.out, comb.air_in)
sys.connect(fuel_in.port, comb.fuel_in)
sys.connect(comb.gas_out, turb.inl)
sys.connect(turb.out, exhaust.port)

# 5. Fix design constraints
# Impose compressor discharge pressure
fix_port(sys, comp.out, p=p_amb * p_ratio)

# Impose Turbine Inlet Temperature (TIT)
fix_port(sys, comb.gas_out, T=T_tit)

# 6. Seed starts and solve
autostart(sys)
# Provide hot start hint for turbine expansion
sys.set_start_port(turb.out, p=p_amb, T=800.0)

sol = solve(sys, verbose=True)

# 7. Post-process power and efficiency
W_comp = abs(comp.Wdot)
W_turb = turb.Wdot
W_net = W_turb - W_comp
Q_fuel = comb.Qdot_fuel
eta_th = W_net / Q_fuel

print("\n=== BRAYTON CYCLE RESULTS ===")
print(f"Compressor Power:   {W_comp / 1e6:.2f} MW")
print(f"Turbine Power:      {W_turb / 1e6:.2f} MW")
print(f"Net Shaft Power:    {W_net / 1e6:.2f} MW")
print(f"Fuel Heat Input:    {Q_fuel / 1e6:.2f} MW")
print(f"Thermal Efficiency: {eta_th * 100:.2f} %")
print(f"Air-Fuel Ratio:     {comb.AFR:.1f} (excess air: {comb.excess_air:.2f})")
```

