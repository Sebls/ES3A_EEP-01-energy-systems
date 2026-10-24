#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#3b82f6")
#let primary-fill = rgb("#dbeafe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let success-stroke = 1.2pt + rgb("#22c55e")
#let success-fill = rgb("#d1fae5")
#let purple-stroke = 1.2pt + rgb("#a855f7")
#let purple-fill = rgb("#f3e8ff")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Index-1 DAE Implicit Time-Stepping Scheme
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 20mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.1pt + rgb("#64748b"),

  // Step k State
  node((0, 0), [
    *State at $t_k$*\
    #v(1pt)
    #text(size: 8.5pt)[Differential: $bold(x)_(d, k) = (M, U, T_w)^T$\
    Algebraic: $bold(x)_(a, k) = (p, h, dot(m))^T$]
  ], stroke: slate-stroke, fill: slate-fill, width: 56mm),

  // Input Update
  node((1, 0), [
    *Inputs & Boundary at $t_(k+1)$*\
    #v(1pt)
    #text(size: 8.5pt)[`update_inputs(sys, t)`\
    e.g., $dot(Q)_("heater")(t)$, $dot(m)_("in")(t)$]
  ], stroke: accent-stroke, fill: accent-fill, width: 54mm),

  // Implicit Residual
  node((1, 1), [
    *DAE Residual Formulation*\
    #v(1pt)
    #text(size: 8.5pt)[$dot(bold(x))_(d, k+1) approx frac(bold(x)_(d, k+1) - bold(x)_(d, k), Delta t)$\
    $bold(F)(dot(bold(x))_(d, k+1), bold(x)_(d, k+1), bold(x)_(a, k+1)) = bold(0)$]
  ], stroke: purple-stroke, fill: purple-fill, width: 66mm),

  // Newton Solver
  node((0, 1), [
    *Newton-Raphson Solve*\
    #v(1pt)
    #text(size: 8.5pt)[Solve for $[bold(x)_(d, k+1), bold(x)_(a, k+1)]$\
    $bold(J) Delta bold(x) = -bold(F)$\
    until $norm(bold(F)) < epsilon$]
  ], stroke: primary-stroke, fill: primary-fill, width: 56mm),

  // Advance Time Step
  node((0, 2), [
    #text(weight: "bold", fill: rgb("#166534"))[Record Step & Advance]\
    #v(1pt)
    #text(size: 8.5pt, fill: rgb("#15803d"))[Append to `results`, $t_(k+1) -> t_k$, $k <- k+1$\
    Repeat until $t >= t_("end")$]
  ], stroke: success-stroke, fill: success-fill, width: 56mm),

  // Edges
  edge((0, 0), (1, 0), "->", stroke: slate-stroke, label: [time step $Delta t$]),
  edge((1, 0), (1, 1), "->", stroke: accent-stroke, label: [evaluate]),
  edge((1, 1), (0, 1), "->", stroke: purple-stroke, label: [Jacobian step]),
  edge((0, 1), (0, 2), "->", stroke: success-stroke, label: [converged]),
  edge((0, 2), (0, 0), "->", stroke: (paint: rgb("#3b82f6"), thickness: 1pt, dash: "dashed"), label: [next step], bend: 45deg)
)
