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
    Component Lifecycle & Mathematical Evaluation Pipeline
  ]
]
#v(6pt)

#diagram(
  spacing: (15mm, 15mm),
  node-corner-radius: 5pt,
  edge-stroke: 1pt + rgb("#64748b"),

  node((0, 0), [
    *`__init__`*\
    #text(size: 8pt, fill: rgb("#64748b"))[Instantiation & params]
  ], stroke: slate-stroke, fill: slate-fill, width: 28mm),

  node((1, 0), [
    *`add_port` / `var`*\
    #text(size: 8pt, fill: rgb("#1d4ed8"))[Unknowns $p, h, dot(m)$]
  ], stroke: primary-stroke, fill: primary-fill, width: 32mm),

  node((2, 0), [
    *`residuals()`*\
    #text(size: 8pt, fill: rgb("#4338ca"))[Balance $F_i (bold(x)) = 0$]
  ], stroke: 1.2pt + rgb("#4f46e5"), fill: rgb("#e0e7ff"), width: 34mm),

  node((3, 0), [
    *`start_sanity()`*\
    #text(size: 8pt, fill: rgb("#b45309"))[Bounds $bold(x)_("min") <= bold(x)_0$]
  ], stroke: accent-stroke, fill: accent-fill, width: 34mm),

  node((4, 0), [
    *Nonlinear Solver*\
    #text(size: 8pt, fill: rgb("#7c3aed"))[$bold(J) Delta bold(x) = -bold(F)$]
  ], stroke: purple-stroke, fill: purple-fill, width: 32mm),

  node((5, 0), [
    *`update_outputs()`*\
    #text(size: 8pt, fill: rgb("#15803d"))[Evaluate $T, s, eta, dot(E)_x$]
  ], stroke: success-stroke, fill: success-fill, width: 34mm),

  edge((0, 0), (1, 0), "->"),
  edge((1, 0), (2, 0), "->", stroke: primary-stroke),
  edge((2, 0), (3, 0), "->"),
  edge((3, 0), (4, 0), "->", stroke: accent-stroke),
  edge((4, 0), (5, 0), "->", stroke: success-stroke)
)
