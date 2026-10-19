# Principles of Energy Systems Modelling

Comprehensive monograph and lecture notes on thermodynamics, energy conversion systems, component modeling, and computational thermophysics.

## Overview

This repository hosts publication-grade lecture notes and reference monographs for Energy Systems Modelling, written in [Typst](https://typst.app/) with standard LaTeX monograph aesthetics (`latexy-book`).

### Topics Covered

1. **Physical & Thermodynamic Foundations**
   - Microscopic vs. macroscopic thermodynamic continuum
   - Closed systems (control mass) vs. open systems (control volume)
   - Intensive vs. extensive state variables, the partition test
   - Pure substances, phase equilibria, saturation dome, vapor quality ($x$)
   - Equations of state: ideal gases, real fluid Helmholtz formulations via `CoolProp`
   - Gibbs phase rule ($F = C - \Phi + 2$) and independent intensive degrees of freedom
2. **First & Second Law Balances**
   - Steady-state mass and energy rate equations for multi-stream control volumes
   - Heat transfer ($Q$), shaft work ($W_{\text{cv}}$), and flow work ($P v$)
   - Clausius inequality, entropy balances, and entropy generation rate ($\dot{S}_{\text{gen}}$)
3. **Canonical Component Modelling**
   - **Expansion Valves:** Isenthalpic throttling, pressure drops, irreversibility
   - **Compressors & Pumps:** Isentropic efficiency ($\eta_c$), power requirements, temperature rise penalties
   - **Turbines / Expanders:** Isentropic efficiency ($\eta_t$), shaft power delivery, exhaust conditions
   - **Combustors:** Fuel lower heating value (LHV), air-fuel ratio ($AF$), thermal heat release
   - **Heat Exchangers:** Counter-flow vs. parallel-flow, Logarithmic Mean Temperature Difference (LMTD), pinch point constraints ($\Delta T_{\text{pinch}}$), $\epsilon$-NTU effectiveness
4. **Computational Verification & Practical Case Studies**
   - Step-by-step Brayton gas turbine cycle with non-ideal compressor and turbine stages
   - Numerical verification scripts using Python and `CoolProp`

## Repository Structure

```text
.
├── notes/                                  # Monograph sources & compilation
│   ├── main.typ                            # Master document entrypoint & configuration
│   ├── main.pdf                            # Compiled PDF monograph (13 pages)
│   ├── refs.bib                            # BibTeX literature references
│   └── chapters/
│       ├── common.typ                      # Environment definitions (definitions, theorems, examples)
│       └── ch01_foundations_and_components.typ # Chapter 1: Foundations & Component Modelling
├── contents/                               # Extracted markdown source summaries
└── sources/                                # Original reference material archives
```

## Compilation

To compile the monograph to PDF:

```bash
typst compile notes/main.typ notes/main.pdf
```

To watch for file changes during drafting:

```bash
typst watch notes/main.typ notes/main.pdf
```
