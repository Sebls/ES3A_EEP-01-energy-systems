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
    Caldis Architecture & System Assembly
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 14mm),
  node-corner-radius: 5pt,
  edge-stroke: 1pt + rgb("#64748b"),

  // Components Column
  node((0, 0), [
    *FluidBoundary*\
    #text(size: 8pt, fill: rgb("#2563eb"))[Sources, sinks & imposed states]
  ], stroke: primary-stroke, fill: primary-fill, width: 44mm),

  node((0, 1), [
    *Compressor / Turbine*\
    #text(size: 8pt, fill: rgb("#7c3aed"))[Isentropic: $h = h(p, s_("in"), eta)$]
  ], stroke: purple-stroke, fill: purple-fill, width: 44mm),

  node((0, 2), [
    *HeatExchanger*\
    #text(size: 8pt, fill: rgb("#b45309"))[Energy: $sum dot(m) h + dot(Q) = 0$]
  ], stroke: accent-stroke, fill: accent-fill, width: 44mm),

  node((0, 3), [
    *Valves & Vessels*\
    #text(size: 8pt, fill: rgb("#475569"))[Isenthalpic / dynamic $dot(M), dot(U)$]
  ], stroke: slate-stroke, fill: slate-fill, width: 44mm),

  // Connections and Constraints
  node((1, -0.6), [
    *Connections & Design Specs*\
    #text(size: 8.5pt)[$p_a = p_b, quad h_a = h_b, quad dot(m)_a = -dot(m)_b$]
  ], stroke: slate-stroke, fill: slate-fill, width: 56mm),

  // System Core Assembly
  node((1, 1.5), [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[System Instance]\
    #v(2pt)
    State: $bold(x) in RR^n$\
    Residuals: $bold(F)(bold(x)) in RR^m$\
    #text(size: 8.5pt, fill: rgb("#1d4ed8"))[Autostart & Topological Seeding]
  ], stroke: 1.5pt + rgb("#2563eb"), fill: rgb("#eff6ff"), width: 56mm),

  // Preflight & Solvers
  node((2, 0), [
    *1. DOF Preflight*\
    #text(size: 8.5pt)[Check $dim(bold(x)) == dim(bold(F))$]
  ], stroke: 1.2pt + rgb("#4f46e5"), fill: rgb("#e0e7ff"), width: 48mm),

  node((2, 1), [
    *2. Evaluability Check*\
    #text(size: 8.5pt)[Verify $norm(bold(F)(bold(x)_0)) < oo$]
  ], stroke: accent-stroke, fill: accent-fill, width: 48mm),

  node((2, 2), [
    *3. Global Damped Newton*\
    #text(size: 8.5pt)[$bold(J) Delta bold(x) = -bold(F)(bold(x))$ with line search]
  ], stroke: primary-stroke, fill: primary-fill, width: 48mm),

  node((2, 2.9), [
    *Homotopy Fallback*\
    #text(size: 8pt)[$bold(H)(bold(x), lambda) = bold(F)(bold(x)) - (1-lambda) bold(F)(bold(x)_0) = 0$]
  ], stroke: purple-stroke, fill: purple-fill, width: 48mm),

  node((2, 3.8), [
    #text(weight: "bold", fill: rgb("#166534"))[Solved State $bold(x)^* in RR^n$]\
    #text(size: 8pt, fill: rgb("#15803d"))[$bold(F)(bold(x)^*) approx 0$, Outputs & Exergy updated]
  ], stroke: success-stroke, fill: success-fill, width: 48mm),

  // Edges from Components to System
  edge((0, 0), (1, 1.5), "->", stroke: primary-stroke),
  edge((0, 1), (1, 1.5), "->", stroke: purple-stroke),
  edge((0, 2), (1, 1.5), "->", stroke: accent-stroke),
  edge((0, 3), (1, 1.5), "->", stroke: slate-stroke),

  // Top to System
  edge((1, -0.6), (1, 1.5), "->", stroke: slate-stroke),

  // System to Preflight
  edge((1, 1.5), (2, 0), "->", stroke: 1.3pt + rgb("#2563eb"), label: [assemble]),
  edge((2, 0), (2, 1), "->", label: [$text("DOF") = 0$]),
  edge((2, 1), (2, 2), "->", label: [finite $bold(F)$]),
  edge((2, 2), (2, 2.9), "->", stroke: 1pt + rgb("#a855f7"), label: [diverged]),
  edge((2, 2), (2, 3.8), "->", stroke: success-stroke, label: [converged], bend: -25deg),
  edge((2, 2.9), (2, 3.8), "->", stroke: success-stroke, label: [$lambda = 1$])
)
