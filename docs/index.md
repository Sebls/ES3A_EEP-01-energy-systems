# Caldis

!!! note "Educational & AI-Generated Documentation Disclaimer"
    This documentation was generated with the assistance of AI and is intended strictly for educational and learning purposes. We are not the original authors or copyright owners of the underlying Caldis library.

**Caldis** is an acausal, equation-based modeling and simulation platform in Python for thermal and energy systems (such as Brayton gas turbines, Rankine cycles, heat pumps, organic Rankine cycles, cooling loops, and storage vessels).

---

## Key Highlights

- **Acausal Equation-Oriented Modeling**: Components do not compute explicit outputs. Instead, each component defines physical conservation residuals (mass, momentum, energy).
- **Square System Verification (DOF Preflight)**: Automatically counts equations and variables before solving to prevent under- or over-specified models.
- **CoolProp & Equation of State Integration**: Thermodynamic state evaluation keyed on $(p, h)$ across single-phase and two-phase regimes without artificial dome boundaries.
- **Robust Multi-Stage Solvers**: Combines damped global Newton solvers, homotopy/continuation algorithms, and rule-based autostart propagation.
- **Dynamic Simulation**: Native index-1 DAE integrator supporting thermal masses, compressible volumes, and time-dependent boundary conditions.
- **Built-in Exergy & Diagnostics**: Automatic second-law balances ($X_{\text{in}}$, $X_{\text{out}}$, $X_{\text{dest}}$, $\eta_{\text{II}}$) and scaled Jacobian conditioning reports.

---

## Quick Example

```python
from caldis.core.system import System
from caldis.components import Compressor, SimpleHeater, FluidBoundary
from caldis.fluids import CoolPropBackend
from caldis.solvers import solve
from caldis.solvers.autostart import fix_port, autostart

# 1. Initialize fluid backend
air = CoolPropBackend("Air")

# 2. Instantiate components
src = FluidBoundary("src", p=1.0e5, T=288.15, mdot=-2.0, backend=air)
comp = Compressor("comp", backend=air, eta_is=0.85)
cooler = SimpleHeater("cooler", backend=air, Qdot=None, dp=0.0)
sink = FluidBoundary("sink", backend=air)

# 3. Assemble system and connect ports
sys = System("air_compression")
sys.add(src, comp, cooler, sink)
sys.connect(src.port, comp.inl)
sys.connect(comp.out, cooler.inl)
sys.connect(cooler.out, sink.port)

# 4. Impose design constraints
fix_port(sys, comp.out, p=6.0e5)      # Target 6 bar discharge
fix_port(sys, cooler.out, T=303.15)   # Target 30 °C outlet

# 5. Automatically seed start values and solve
autostart(sys)
sol = solve(sys)

# 6. Read results
print(f"Compressor shaft power: {comp.Wdot / 1e3:.2f} kW")
print(f"Cooler duty extracted:  {cooler.Qdot / 1e3:.2f} kW")
```

---

## Documentation Structure

- [Architecture & Concepts](architecture/overview.md)
    - [Overview & Philosophy](architecture/overview.md)
    - [Degrees of Freedom (DOF)](architecture/dof.md)
    - [Sign Conventions & Ports](architecture/sign_conventions.md)
    - [Start Point & Provenance System](architecture/start_system.md)
- [User Guide](guide/getting_started.md)
    - [Getting Started](guide/getting_started.md)
    - [Closing Closed-Loop Cycles](guide/loops.md)
    - [Dynamic DAE Simulation](guide/dynamic_simulation.md)
    - [Second-Law Exergy Analysis](guide/exergy.md)
- [Component Reference](components/index.md)
    - Turbomachinery (`Compressor`, `Turbine`)
    - Heat Exchangers (`SizingHX`, `RatingHX`, `HXSim`)
    - Combustion & Heaters (`CombustionChamber`, `SimpleHeater`)
    - Valves & Fittings (`Valve`, `Mixer`, `Splitter`)
    - Storage & Vessels (`ControlVolume`, `TankConstV`, `TankConstP`, `FlashTank`)
- [Solvers & Numerical Methods](solvers/steady_and_homotopy.md)
    - Damped Newton, Homotopy continuation, and Autostart propagation
- [Troubleshooting & Diagnostics](troubleshooting/errors.md)
    - Interpreting singular Jacobians, non-finite residuals, and temperature crossing

