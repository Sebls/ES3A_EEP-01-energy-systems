#import "common.typ": bdefinition, bexample, blemma, bnotice, bproposition, btheorem, bexercise

== Physical Foundations of Energy Systems

Energy systems are assemblies of physical components configured to receive, transform, transport, and deliver energy from primary resources (chemical, thermal, solar, nuclear) into useful mechanical work, electricity, heating, or cooling.

At the microscopic level, matter consists of atoms and molecules possessing kinetic energy (translation, rotation, vibration) and potential energy (intermolecular bonding, chemical valence bonds, nuclear forces). Macroscopically, thermodynamics disregards the individual behavior of particles and establishes conservation balances and state relationships over continuum control volumes.

=== Thermodynamic System, Boundary, and Surroundings

To analyze any energy conversion process, we define a domain of interest in space:

1. *System:* The specified quantity of matter or the defined region in space chosen for thermodynamic study.
2. *Surroundings:* Everything external to the system boundary.
3. *Boundary:* The real or imaginary surface separating the system from its surroundings. The boundary may be fixed or movable, real or imaginary, rigid or flexible.

#bdefinition(caption: "Classification of Thermodynamic Systems")[
  - *Closed System (Control Mass):* A system across whose boundary *no mass* can pass ($dot(m)_"in" = dot(m)_"out" = 0$). Energy may cross the boundary as heat ($Q$) or work ($W$). If neither energy nor mass can cross, the system is *isolated*.
  - *Open System (Control Volume):* A system where both mass and energy (heat, work, flow work) can freely cross the control surface. Most industrial energy components—compressors, turbines, heat exchangers, valves—are open systems operating in steady state.
]

=== State, Properties, and Processes

#bdefinition(caption: "Intensive and Extensive Properties")[
  - An *intensive property* is independent of the mass or extent of the system. Examples include temperature $T$ ($"K"$), pressure $P$ ($"Pa"$), density $rho$ ($"kg/m"^3$), specific volume $v = V/m$ ($"m"^3"/kg"$), specific enthalpy $h = H/m$ ($"J/kg"$), and specific entropy $s = S/m$ ($"J/(kg"dot"K)"$).
  - An *extensive property* depends directly on the system's size or total mass. Extensive properties are strictly additive across non-overlapping subsystems: total volume $V$ ($"m"^3$), total internal energy $U$ ($"J"$), total enthalpy $H$ ($"J"$), and total entropy $S$ ($"J/K"$).
]

#bnotice(caption: "The Partition Test")[
  To test whether a property is intensive or extensive, consider an imaginary partition dividing a homogeneous system in equilibrium of mass $m$ and volume $V$ into two equal halves. Each half contains mass $m/2$ and volume $V/2$ (extensive), but retains identical temperature $T$, pressure $P$, and specific enthalpy $h$ (intensive).
]

== Thermophysical Properties of Pure Substances

#bdefinition(caption: "Pure Substance")[
  A *pure substance* is one that has a fixed, homogeneous chemical composition throughout all parts and phases. Pure water ($"H"_2"O"$), gaseous nitrogen ($"N"_2$), and dry air (under conditions where phase change does not occur) behave as pure substances.
]

=== Phases and Phase Transitions

A pure fluid can exist in several distinct thermodynamic phases depending on its thermal and pressure state:
1. *Subcooled (Compressed) Liquid:* The substance is entirely in liquid form at a temperature below the saturation boiling temperature for the given pressure ($T < T_"sat"(P)$).
2. *Saturated Liquid:* The liquid is on the verge of vaporizing; adding an infinitesimal increment of heat causes vapor formation ($x = 0$).
3. *Two-Phase Saturated Liquid-Vapor Mixture:* Liquid and vapor coexist in thermal and mechanical equilibrium at $(P_"sat", T_"sat")$.
4. *Saturated Vapor:* The substance is completely vaporized on the verge of condensation; removing an infinitesimal increment of heat causes liquid droplets to form ($x = 1$).
5. *Superheated Vapor:* The vapor temperature exceeds the saturation temperature at the given pressure ($T > T_"sat"(P)$).
6. *Supercritical Fluid:* Above the critical pintegral.cont $(P_c, T_c)$, the distinct meniscus between liquid and vapor disappears. The fluid exhibits gas-like diffusivity with liquid-like density.

#bdefinition(caption: "Vapor Quality")[
  In a two-phase saturated liquid-vapor mixture, the *vapor quality* $x$ is the ratio of vapor mass to total mixture mass:
  $ x = frac(m_"vap", m_"tot") = frac(m_"vap", m_"liq" + m_"vap") in [0, 1] $
  For any specific property $z in {v, u, h, s}$, the mixture average is given by:
  $ z = (1 - x) z_f + x z_g = z_f + x (z_g - z_f) = z_f + x z_(f g) $
  where subscript $f$ denotes saturated liquid and subscript $g$ denotes saturated vapor.
]

=== Gibbs Phase Rule and State Postulate

#btheorem(caption: "Gibbs Phase Rule")[
  For a non-reacting multi-phase thermodynamic system in equilibrium, the number of independent intensive degrees of freedom $F$ is:
  $ F = C - Phi + 2 $
  where $C$ is the number of distinct chemical components and $Phi$ is the number of coexisting phases.
]

#bexample(caption: "Degrees of Freedom in Pure Substances ($C = 1$)")[
  - *Single-phase region ($Phi = 1$):* $F = 1 - 1 + 2 = 2$. Two independent intensive properties (e.g., $(P, T)$, $(P, h)$, or $(T, s)$) completely determine all other state variables.
  - *Two-phase liquid-vapor mixture ($Phi = 2$):* $F = 1 - 2 + 2 = 1$. Pressure and temperature are no longer independent: $T = T_"sat"(P)$. Specifying pressure automatically fixes temperature. To uniquely fix the state, one must specify one property from $(P, T)$ plus an independent property sensitive to phase proportions, such as quality $x$ or specific enthalpy $h$.
  - *Triple pintegral.cont ($Phi = 3$):* $F = 1 - 3 + 2 = 0$. The state is invariant; for water, this occurs uniquely at $T = 0.01\,degree"C" = 273.16\,"K"$ and $P = 611.65\,"Pa"$.
]

=== Equations of State and Thermophysical Databases

For ideal gases at low density and high temperature relative to the critical pintegral.cont:
$ P v = R_"spec" T = frac(R_u, M) T $
where $R_u = 8.314462\,"J/(mol"dot"K)"$ is the universal gas constant and $M$ is the molar mass.

In real engineering fluids (steam in Rankine cycles, refrigerants in heat pumps, high-pressure combustion flue gases), deviations from ideality are pronounced near the saturation dome. Modern computational engineering relies on high-precision multiparameter Helmholtz energy formulations implemented in open-source engines such as `CoolProp`.

```python
# Direct property calculation using CoolProp
from CoolProp.CoolProp import PropsSI

# Compute specific enthalpy of air at P = 1 bar, T = 293.15 K (20 °C)
p = 1e5       # Pa
T = 293.15    # K
h_air = PropsSI("H", "P", p, "T", T, "Air")  # J/kg
s_air = PropsSI("S", "P", p, "T", T, "Air")  # J/(kg.K)
print(f"Air at 1 bar, 20°C: h = {h_air/1e3:.2f} kJ/kg, s = {s_air/1e3:.3f} kJ/(kg.K)")
```

== First Law of Thermodynamics: Conservation of Energy

The First Law states that energy cannot be created or destroyed; it can only change forms.

=== Closed Systems

For a closed system undergoing a finite process between state 1 and state 2:
$ Delta U + Delta E_k + Delta E_p = Q - W $
where $Q$ is heat transferred *into* the system, and $W$ is work produced *by* the system. Neglecting macroscopic kinetic ($Delta E_k$) and potential ($Delta E_p$) energy changes:
$ Delta U = Q - W $

- *Isochoric process ($V = "const"$):* Boundary work $W_b = integral P d V = 0$, hence:
  $ Q = Delta U = m integral c_v d T $
- *Isobaric process ($P = "const"$):* Boundary work $W_b = P (V_2 - V_1)$, giving:
  $ Q = Delta U + P Delta V = Delta (U + P V) = Delta H = m integral c_p d T $

=== Open Systems: Steady-State Control Volume Analysis

For a control volume with multiple inlets ($i$) and outlets ($e$):

*1. Mass Conservation:*
$ frac(d m_"cv", d t) = sum_i dot(m)_i - sum_e dot(m)_e $
At steady state ($d m_"cv" / d t = 0$), total mass in equals total mass out:
$ sum_i dot(m)_i = sum_e dot(m)_e $

*2. Energy Conservation:*
Mass entering carries internal energy $u$, kinetic energy $c^2/2$, potential energy $g z$, and flow work $P v$ required to push the fluid into the control volume. Combining $u + P v = h$, the First Law for a control volume becomes:
$ frac(d E_"cv", d t) = dot(Q) - dot(W)_"cv" + sum_i dot(m)_i (h_i + frac(c_i^2, 2) + g z_i) - sum_e dot(m)_e (h_e + frac(c_e^2, 2) + g z_e) $

Under standard steady-state assumptions with negligible kinetic and potential variations:
$ 0 = dot(Q) - dot(W)_"cv" + sum_i dot(m)_i h_i - sum_e dot(m)_e h_e $

== Second Law of Thermodynamics and Entropy Generation

The First Law asserts that total energy is conserved, but it cannot predict the direction in which spontaneous processes occur, nor the maximum work obtainable.

#btheorem(caption: "Second Law of Thermodynamics")[
  Heat cannot spontaneously flow from a body at a lower temperature to a body at a higher temperature without external work input (Clausius statement). Furthermore, it is impossible for any device operating on a cycle to produce net work while exchanging heat with a single thermal reservoir (Kelvin-Planck statement).
]

#bdefinition(caption: "Entropy and the Clausius Inequality")[
  For any closed system undergoing a thermodynamic cycle:
  $ integral.cont frac(delta Q, T) <= 0 $
  where the equality holds exclusively for internally reversible cycles. For any reversible path, the quantity $delta Q_"rev" / T$ is an exact differential of a state function called *entropy* $S$:
  $ d S = (frac(delta Q, T))_"rev" $
]

=== Entropy Balance and Irreversibility

For a general control volume, the rate of entropy accumulation is:
$ frac(d S_"cv", d t) = sum_k frac(dot(Q)_k, T_k) + sum_i dot(m)_i s_i - sum_e dot(m)_e s_e + dot(S)_"gen" $
where $T_k$ is the temperature at the control boundary where heat transfer $dot(Q)_k$ occurs, and $dot(S)_"gen"$ is the rate of internal entropy generation.
- $dot(S)_"gen" = 0$: Reversible process (ideal benchmark).
- $dot(S)_"gen" > 0$: Real irreversible process (friction, throttling, finite temperature difference heat transfer, mixing).
- $dot(S)_"gen" < 0$: Physically impossible.

At steady state ($d S_"cv" / d t = 0$):
$ dot(S)_"gen" = sum_e dot(m)_e s_e - sum_i dot(m)_i s_i - sum_k frac(dot(Q)_k, T_k) >= 0 $

== Canonical Component Models

Industrial thermodynamic systems are constructed by interconnecting canonical open-flow components. Each component is modeled by applying the mass, energy, and entropy rate equations subject to specific engineering assumptions.

=== Expansion Valves (Throttling Devices)

An expansion valve is an orifice, capillary tube, or adjustable plug that reduces fluid pressure abruptly without shaft work.

#bdefinition(caption: "Throttling Valve Hypotheses")[
  1. *No shaft work:* $dot(W) = 0$.
  2. *Adiabatic boundary:* Small surface area and short residence time imply $dot(Q) approx 0$.
  3. *Negligible kinetic and potential energy changes:* $Delta (c^2/2) approx 0$, $Delta (g z) approx 0$.
]

Applying the steady-state energy equation for a single inlet and outlet:
$ dot(m) h_1 = dot(m) h_2 quad ==> quad h_1 = h_2 $

#bproposition(caption: "Isenthalpic Throttling")[
  An ideal expansion valve operates *isenthalpically* ($h_2 = h_1$). Because flow friction and turbulence are severe:
  $ dot(S)_"gen" = dot(m) (s_2 - s_1) > 0 $
  Throttling is always intrinsically irreversible.
]

=== Compressors and Pumps

Compressors (handling compressible gases and vapors) and pumps (handling incompressible liquids) consume shaft mechanical work $dot(W)_c > 0$ to raise the pressure of a flowing stream from $P_1$ to $P_2 > P_1$.

*Governing Assumptions:* Steady-state, adiabatic ($dot(Q) = 0$), negligible kinetic and potential energy changes.

*Energy Balance:*
$ dot(W)_c = dot(m) (h_2 - h_1) $

*Entropy Balance:*
$ s_2 = s_1 + frac(dot(S)_"gen", dot(m)) >= s_1 $

#bdefinition(caption: "Isentropic Efficiency of Compression")[
  In an ideal reversible compressor, $dot(S)_"gen" = 0$, leading to an isentropic exit state $s_(2s) = s_1$ at pressure $P_2$. The *isentropic efficiency* $eta_c$ is defined as the ratio of ideal work to actual work required:
  $ eta_c = frac(dot(W)_(c, s), dot(W)_c) = frac(h_(2s) - h_1, h_2 - h_1) $
  Consequently, the actual exit enthalpy is:
  $ h_2 = h_1 + frac(h_(2s) - h_1, eta_c) $
  Because $eta_c < 1$, $h_2 > h_(2s)$ and $T_2 > T_(2s)$: real compressors discharge gas at higher temperatures and consume more mechanical power than ideal machines.
]

=== Turbines (Expanders)

Turbines produce mechanical power $dot(W)_t > 0$ by expanding high-pressure, high-enthalpy fluid from $P_1$ down to lower pressure $P_2 < P_1$.

*Energy Balance:*
$ dot(W)_t = dot(m) (h_1 - h_2) $

#bdefinition(caption: "Isentropic Efficiency of Expansion")[
  The ideal expansion occurs at constant entropy ($s_(2s) = s_1$). The *isentropic efficiency* $eta_t$ is defined as the ratio of actual work output to maximum theoretical isentropic work:
  $ eta_t = frac(dot(W)_t, dot(W)_(t, s)) = frac(h_1 - h_2, h_1 - h_(2s)) $
  The actual exit enthalpy is:
  $ h_2 = h_1 - eta_t (h_1 - h_(2s)) $
]

=== Combustion Chambers

A combustor or furnace transforms chemical enthalpy into thermal enthalpy at near-constant pressure ($P_2 approx P_1 (1 - Delta P_"loss")$).

Let $dot(m)_a$ be the incoming air mass flowrate, $dot(m)_f$ the fuel flowrate, and $"LHV"$ the lower heating value of the fuel ($"J/kg"$). Neglecting external heat losses to the ambient:
$ (dot(m)_a + dot(m)_f) h_"out" = dot(m)_a h_"in" + dot(m)_f (h_f + "LHV") $
Solving for the required fuel flowrate to achieve a target turbine inlet temperature $T_"out"$:
$ dot(m)_f = dot(m)_a frac(h_"out" - h_"in", "LHV" + h_f - h_"out") $

=== Heat Exchangers

Heat exchangers transfer thermal energy between a hot fluid stream (inlet $h_1$, outlet $h_2$) and a cold fluid stream (inlet $c_1$, outlet $c_2$) without direct physical mixing.

*Governing Assumptions:* Steady state, well-insulated outer shell ($dot(Q)_"ext" = 0$), zero shaft work ($dot(W) = 0$).

*Coupled Energy Balance:*
$ dot(Q) = dot(m)_h (h_(h, 1) - h_(h, 2)) = dot(m)_c (h_(c, 2) - h_(c, 1)) $
Defining heat capacity rates $C_h = dot(m)_h c_(p, h)$ and $C_c = dot(m)_c c_(p, c)$:
$ dot(Q) = C_h (T_(h, 1) - T_(h, 2)) = C_c (T_(c, 2) - T_(c, 1)) $

*Logarithmic Mean Temperature Difference (LMTD):*
For counter-flow and parallel-flow heat exchangers with overall heat transfer coefficient $U$ and total surface area $A$:
$ dot(Q) = U A Delta T_"lm" $
where the logarithmic mean temperature difference is:
$ Delta T_"lm" = frac(Delta T_1 - Delta T_2, ln(Delta T_1 / Delta T_2)) $
For counter-flow configuration: $Delta T_1 = T_(h, 1) - T_(c, 2)$ and $Delta T_2 = T_(h, 2) - T_(c, 1)$.

#bdefinition(caption: "Heat Exchanger Pinch Pintegral.cont")[
  The *pinch pintegral.cont* is the minimum temperature difference between the hot and cold temperature profiles across the exchanger:
  $ Delta T_"pinch" = min_x [T_h(x) - T_c(x)] > 0 $
  Thermodynamics requires $Delta T_"pinch" > 0$; as $Delta T_"pinch" -> 0$, the required heat transfer area $A -> oo$, representing infinite capital expenditure.
]

== Comprehensive Practical Case Study: Open Brayton Gas Turbine Cycle

To illustrate the complete synthesis of component models, we analyze an open Brayton cycle gas turbine.

#bexample(caption: "Step-by-Step Gas Turbine Simulation")[
  *Cycle Specifications:*
  - *Ambient Air Inlet:* $P_1 = 1.0\,"bar" = 10^5\,"Pa"$, $T_1 = 20\,degree"C" = 293.15\,"K"$.
  - *Mass Flowrate:* $dot(m)_a = 1.0\,"kg/s"$.
  - *Compressor:* Pressure ratio $r_p = P_2 / P_1 = 15$, isentropic efficiency $eta_c = 0.86$.
  - *Combustor:* Fuel is methane ($"CH"_4$, $"LHV" = 50.0\,"MJ/kg" = 5 times 10^7\,"J/kg"$), inlet at $T_f = 25\,degree"C" = 298.15\,"K"$, $P_f = 15\,"bar"$. Combustor pressure loss $Delta P / P = 4%$, turbine inlet temperature limit $T_3 = 1400\,"K"$.
  - *Turbine:* Expands to ambient back-pressure $P_4 = 1.0\,"bar"$, isentropic efficiency $eta_t = 0.88$.
]

*Step 1: Compression Phase*
At state 1 ($P_1 = 10^5\,"Pa", T_1 = 293.15\,"K"$):
$ h_1 = "PropsSI"("H", "P", 10^5, "T", 293.15, "Air") approx 293.6\,"kJ/kg" $
$ s_1 = "PropsSI"("S", "P", 10^5, "T", 293.15, "Air") approx 6858.7\,"J/(kg"dot"K)" $
At pressure $P_2 = 15 times 10^5\,"Pa"$, the isentropic state $s_(2s) = s_1$ yields:
$ h_(2s) = "PropsSI"("H", "P", 1.5 times 10^6, "S", s_1, "Air") approx 635.8\,"kJ/kg" $
If the compressor were ideal ($eta_c = 1.0$):
$ dot(W)_(c, s) = dot(m)_a (h_(2s) - h_1) = 1.0 times (635.8 - 293.6) = 342.2\,"kW" $
$ T_(2s) = "PropsSI"("T", "P", 1.5 times 10^6, "H", h_(2s), "Air") approx 628.3\,"K" (355.1\,degree"C") $

With real isentropic efficiency $eta_c = 0.86$:
$ h_2 = h_1 + frac(h_(2s) - h_1, 0.86) = 293.6 + frac(342.2, 0.86) = 691.5\,"kJ/kg" $
$ dot(W)_c = dot(m)_a (h_2 - h_1) = 1.0 times (691.5 - 293.6) = 397.9\,"kW" $
$ T_2 = "PropsSI"("T", "P", 1.5 times 10^6, "H", h_2, "Air") approx 678.9\,"K" (405.8\,degree"C") $
The internal aerodynamic irreversibilities create a $50.6\,"K"$ temperature penalty and demand an additional $55.7\,"kW"$ ($+16.3%$) of shaft power.

*Step 2: Combustion Phase*
Combustor outlet pressure accounts for the $4%$ drop:
$ P_3 = P_2 (1 - 0.04) = 15 times (0.96) = 14.4\,"bar" = 1.44 times 10^6\,"Pa" $
At $T_3 = 1400\,"K"$ and $P_3 = 1.44 times 10^6\,"Pa"$:
$ h_3 = "PropsSI"("H", "P", 1.44 times 10^6, "T", 1400, "Air") approx 1515.4\,"kJ/kg" $
For methane fuel at $298.15\,"K"$: $h_f approx 0\,"kJ/kg"$ (reference). Applying the combustor energy balance:
$ dot(m)_f = 1.0 times frac(1515.4 times 10^3 - 691.5 times 10^3, 50 times 10^6 - 1515.4 times 10^3) approx 0.0170\,"kg/s" $
The air-fuel ratio is $"AF" = dot(m)_a / dot(m)_f approx 58.8$, reflecting the substantial excess air required to moderate turbine inlet temperatures below metallurgical limits. Total flue gas mass flowrate entering the expander is:
$ dot(m)_g = dot(m)_a + dot(m)_f = 1.0170\,"kg/s" $

*Step 3: Expansion in the Turbine*
At state 3, entropy is:
$ s_3 = "PropsSI"("S", "P", 1.44 times 10^6, "T", 1400, "Air") approx 7904.3\,"J/(kg"dot"K)" $
Isentropic expansion to exhaust back-pressure $P_4 = 1.0times 10^5\,"Pa"$ gives:
$ h_(4s) = "PropsSI"("H", "P", 10^5, "S", s_3, "Air") approx 736.2\,"kJ/kg" $
$ Delta h_s = h_3 - h_(4s) = 1515.4 - 736.2 = 779.2\,"kJ/kg" $
With turbine isentropic efficiency $eta_t = 0.88$:
$ h_4 = h_3 - 0.88 times (779.2) = 1515.4 - 685.7 = 829.7\,"kJ/kg" $
$ T_4 = "PropsSI"("T", "P", 10^5, "H", h_4, "Air") approx 801.4\,"K" (528.3\,degree"C") $
$ dot(W)_t = dot(m)_g (h_3 - h_4) = 1.0170 times 685.7 = 697.4\,"kW" $

*Step 4: Net Cycle Performance*
The net mechanical shaft power output delivered to the generator is:
$ dot(W)_"net" = dot(W)_t - dot(W)_c = 697.4 - 397.9 = 299.5\,"kW" $
The total thermal heat input provided by fuel combustion is:
$ dot(Q)_"in" = dot(m)_f times "LHV" = 0.0170 times (50 times 10^3) = 850.0\,"kW" $
The first-law thermal efficiency of the simple gas turbine is:
$ eta_"th" = frac(dot(W)_"net", dot(Q)_"in") = frac(299.5, 850.0) approx 35.24% $
Notice the high back-work ratio:
$ r_"bw" = frac(dot(W)_c, dot(W)_t) = frac(397.9, 697.4) approx 57.05% $
Over half of the turbine mechanical output is consumed directly by its own compressor, highlighting why aerodynamic compressor and turbine efficiencies are paramount in gas turbine engineering.

=== Computational Verification with Python and Caldis

The complete system modeled above can be verified programmatically using standard thermodynamic libraries:

```python
import numpy as np
from CoolProp.CoolProp import PropsSI

# 1. State 1: Compressor Inlet
p1 = 1e5       # Pa
T1 = 293.15    # K
m_air = 1.0    # kg/s
h1 = PropsSI("H", "P", p1, "T", T1, "Air")
s1 = PropsSI("S", "P", p1, "T", T1, "Air")

# 2. State 2: Compressor Outlet
p2 = 15e5      # Pa
eta_c = 0.86
h2s = PropsSI("H", "P", p2, "S", s1, "Air")
h2 = h1 + (h2s - h1) / eta_c
W_comp = m_air * (h2 - h1)
T2 = PropsSI("T", "P", p2, "H", h2, "Air")

# 3. State 3: Combustor Outlet
p3 = p2 * (1.0 - 0.04)  # 4% pressure drop
T3 = 1400.0             # K
h3 = PropsSI("H", "P", p3, "T", T3, "Air")
s3 = PropsSI("S", "P", p3, "T", T3, "Air")
LHV = 50e6              # J/kg
m_fuel = m_air * (h3 - h2) / (LHV - h3)
m_gas = m_air + m_fuel

# 4. State 4: Turbine Exhaust
p4 = 1e5                # Pa
eta_t = 0.88
h4s = PropsSI("H", "P", p4, "S", s3, "Air")
h4 = h3 - eta_t * (h3 - h4s)
W_turb = m_gas * (h3 - h4)
T4 = PropsSI("T", "P", p4, "H", h4, "Air")

# 5. Summary Metrics
W_net = W_turb - W_comp
Q_in = m_fuel * LHV
eta_th = W_net / Q_in

print(f"Compressor Power: {W_comp/1e3:.1f} kW | Exit Temp: {T2-273.15:.1f} °C")
print(f"Fuel Mass Flow:  {m_fuel*1e3:.2f} g/s  | Air-Fuel Ratio: {m_air/m_fuel:.1f}")
print(f"Turbine Power:    {W_turb/1e3:.1f} kW | Exit Temp: {T4-273.15:.1f} °C")
print(f"Net Shaft Power:  {W_net/1e3:.1f} kW | Thermal Efficiency: {eta_th*100:.2f}%")
```

#bexercise(caption: "Heat Recovery and Regenerative Brayton Cycle", ref-source: "Gas Turbine Design Lab")[
  Observe that the turbine exhaust temperature ($T_4 approx 528\,degree"C"$) significantly exceeds the compressor discharge temperature ($T_2 approx 406\,degree"C"$).
  1. Determine the maximum theoretical rate of heat transfer that can be recovered from the exhaust gases to preheat the compressed air entering the combustion chamber using a counter-flow regenerator (recuperator).
  2. If the regenerator has an effectiveness of $epsilon = 0.75$, calculate the new air temperature entering the combustor, the reduced fuel consumption $dot(m)_f$, and the enhanced cycle efficiency $eta_"th"$.
]
