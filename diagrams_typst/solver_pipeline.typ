#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#3b82f6")
#let primary-fill = rgb("#dbeafe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let success-stroke = 1.2pt + rgb("#22c55e")
#let success-fill = rgb("#d1fae5")
#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let purple-stroke = 1.2pt + rgb("#a855f7")
#let purple-fill = rgb("#f3e8ff")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Nonlinear Solver Pipeline: Damped Newton & Homotopy Continuation
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 15mm),
  node-corner-radius: 5pt,
  edge-stroke: 1pt + rgb("#64748b"),

  // Top: Start & Preflight
  node((1, 0), [
    *Start Solve Execution*\
    #text(size: 8.5pt)[Initial guess $bold(x)_0 in RR^n$, tolerances $epsilon_("rel"), epsilon_("abs")$]
  ], stroke: slate-stroke, fill: slate-fill, width: 70mm),

  node((1, 0.9), [
    *Preflight: DOF & Evaluability*\
    #text(size: 8.5pt)[Ensure square dimension & finite $norm(bold(F)(bold(x)_0)) < oo$]
  ], stroke: 1.2pt + rgb("#4f46e5"), fill: rgb("#e0e7ff"), width: 70mm),

  // Branch Left: Direct Damped Newton
  node((0.3, 1.9), [
    *Global Damped Newton*\
    #v(2pt)
    Normalized finite differences:\
    $bold(J) Delta bold(x) = -bold(F)(bold(x))$\
    #text(size: 8pt, fill: rgb("#1d4ed8"))[Backtracking line search for $norm(bold(F)(bold(x) + alpha Delta bold(x)))$]
  ], stroke: primary-stroke, fill: primary-fill, width: 68mm),

  // Branch Right: Homotopy Continuation
  node((1.7, 1.9), [
    *Homotopy Continuation*\
    #v(2pt)
    Deformation equation ($lambda in [0, 1]$):\
    $bold(H)(bold(x), lambda) = bold(F)(bold(x)) - (1 - lambda) bold(F)(bold(x)_0) = 0$\
    #text(size: 8pt, fill: rgb("#7c3aed"))[Step-by-step predictor-corrector continuation]
  ], stroke: purple-stroke, fill: purple-fill, width: 72mm),

  // SVD Diagnostics (Right error)
  node((1.7, 3), [
    *Diagnostics & SVD Report*\
    #text(size: 8pt, fill: rgb("#991b1b"))[Singular values $sigma_i$, pinch analysis & rank report]
  ], stroke: danger-stroke, fill: danger-fill, width: 56mm),

  // Physical Validity Check
  node((0.3, 3), [
    *Physical Validity Check*\
    #text(size: 8.5pt)[Verify $T_("cold,out") < T_("hot,in")$, $p > 0$, $rho > 0$]
  ], stroke: accent-stroke, fill: accent-fill, width: 68mm),

  // Output Solution
  node((0.3, 4), [
    #text(weight: "bold", fill: rgb("#166534"))[Update Outputs & Return Solution]\
    #text(size: 8.5pt, fill: rgb("#15803d"))[Populate $bold(x)^*$, `update_outputs()` & calculate exergy]
  ], stroke: success-stroke, fill: success-fill, width: 68mm),

  // Edges
  edge((1, 0), (1, 0.9), "->"),
  edge((1, 0.9), (0.3, 1.9), "->", stroke: primary-stroke, label: [try newton first]),
  edge((1, 0.9), (1.7, 1.9), "->", stroke: purple-stroke, label: [direct homotopy], bend: 15deg),
  edge((0.3, 1.9), (1.7, 1.9), "->", stroke: (paint: rgb("#a855f7"), thickness: 1.1pt, dash: "dashed"), label: [fallback on divergence]),
  edge((0.3, 1.9), (0.3, 3), "->", stroke: success-stroke, label: [converged: $norm(bold(F)) < epsilon$]),
  edge((1.7, 1.9), (0.3, 3), "->", stroke: success-stroke, label: [converged at $lambda = 1$]),
  edge((1.7, 1.9), (1.7, 3), "->", stroke: danger-stroke, label: [failed continuation]),
  edge((0.3, 3), (0.3, 4), "->", stroke: success-stroke, label: [physically valid])
)
