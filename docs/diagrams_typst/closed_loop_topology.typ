#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let success-stroke = 1.2pt + rgb("#22c55e")
#let success-fill = rgb("#d1fae5")
#let primary-stroke = 1.2pt + rgb("#3b82f6")
#let primary-fill = rgb("#dbeafe")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Closed-Loop Mass Redundancy & Topological Closure
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 22mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.1pt + rgb("#64748b"),

  // Top Left: Problem Description
  node((0, 0), [
    *Standard Connection*\
    #v(1pt)
    #text(size: 8.5pt)[Adds 3 equations:\
    $p_a - p_b = 0$\
    $h_a - h_b = 0$\
    $dot(m)_a + dot(m)_b = 0$]
  ], stroke: slate-stroke, fill: slate-fill, width: 56mm),

  // Top Right: Over-specification
  node((1, 0), [
    *The Redundancy Issue*\
    #v(1pt)
    #text(size: 8.5pt)[Summing loop mass equations:\
    $sum_("loop") (dot(m)_("in") + dot(m)_("out")) equiv 0$\
    $N$-th connection is linearly dependent!]
  ], stroke: danger-stroke, fill: danger-fill, width: 62mm),

  // Bottom Left: The Solution
  node((0, 1), [
    *Closing Connection: `close_loop=True`*\
    #v(1pt)
    #text(size: 8.5pt)[Enforces only:\
    $p_a - p_b = 0$\
    $h_a - h_b = 0$\
    #text(fill: rgb("#166534"))[*Drops redundant mass equation!*]]
  ], stroke: success-stroke, fill: success-fill, width: 56mm),

  // Bottom Right: Flow Rate Specification
  node((1, 1), [
    *Determining Cycle Mass Flow*\
    #v(1pt)
    #text(size: 8.5pt)[Mass flow is pinned via:\
    • `fix_port(sys, comp.inl, mdot=...)`\
    • Machine / valve flow characteristic\
    • Total cycle mass inventory]
  ], stroke: primary-stroke, fill: primary-fill, width: 62mm),

  // Edges connecting the reasoning
  edge((0, 0), (1, 0), "->", stroke: danger-stroke, label: [if repeated in cycle]),
  edge((1, 0), (0, 1), "->", stroke: slate-stroke, label: [fix with `close_loop=True`], bend: 25deg),
  edge((0, 1), (1, 1), "->", stroke: success-stroke, label: [preserves $text("DOF") = 0$])
)
