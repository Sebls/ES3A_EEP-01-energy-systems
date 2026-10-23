# Autostart Engine Reference

The autostart engine (`caldis.solvers.autostart`) handles start-point seeding without requiring manual initial guesses for every port.

---

## Key Functions

### `autostart(sys, T_default=283.15, verbose=False)`

Executes multi-level propagation over the system:
1. **Level 1**: Initializes every port to safe fluid defaults (`default_state(T_default)`).
2. **Level 2**: Iteratively fires direction-agnostic propagation rules from high-provenance nodes (`BOUNDARY`, `HINT`) down into unassigned `DEFAULT` ports.
3. **Level 3**: Seeds internal variables (e.g. cell profiles in `HXSim`).

```python
from caldis.solvers.autostart import autostart

autostart(sys, verbose=True)
```

### `fix_port(system, port, p=None, T=None, h=None, mdot=None)`

Simultaneously adds a system-level constraint and seeds the port start value with `BOUNDARY` provenance.

```python
from caldis.solvers.autostart import fix_port

# Impose pressure constraint and seed start value
fix_port(sys, comp.out, p=8.0e5)

# Impose temperature constraint (converts to h via port backend)
fix_port(sys, hex.cold_out, T=320.0)
```

---

## When to Add Manual Hints

While autostart handles linear pressure drops and flow propagation across series components, highly nonlinear machines (turbines, compressors) or complex counterflow heat exchangers may need an explicit hint:

```python
# Provide an expected discharge temperature for the compressor:
sys.set_start_port(comp.out, T=450.0)

# Set high/low pressure sides of a heat exchanger:
sys.set_start(recuperator, p=10e5, side="cold")
sys.set_start(recuperator, p=1.2e5, side="hot")
```

