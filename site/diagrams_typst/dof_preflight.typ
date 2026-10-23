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
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Structural Degree-of-Freedom (DOF) & Preflight Validation
  ]
]
#v(6pt)

#diagram(
  spacing: (26mm, 15mm),
  node-corner-radius: 5pt,
  edge-stroke: 1pt + rgb("#64748b"),

  // Main Pipeline (column 1)
  node((1, 0), [
    *1. Assemble System*\
    #text(size: 8.5pt, fill: rgb("#475569"))[Variables $bold(x) in RR^n$, Residuals $bold(F)(bold(x)) in RR^m$]
  ], stroke: slate-stroke, fill: slate-fill, width: 62mm),

  node((1, 1), [
    *2. Degree-of-Freedom Check*\
    #text(size: 8.5pt)[$text("DOF") = N_("unknowns") - N_("equations")$]
  ], stroke: primary-stroke, fill: primary-fill, width: 62mm),

  node((1, 2), [
    *3. Start Point Evaluability*\
    #text(size: 8.5pt)[Check $norm(bold(F)(bold(x)_0)) < oo$ & backend stability]
  ], stroke: accent-stroke, fill: accent-fill, width: 62mm),

  node((1, 3), [
    *4. Physical Sanity Bounds*\
    #text(size: 8.5pt)[$T_("min") <= T(bold(x)_0) <= T_("max"), quad p > 0$]
  ], stroke: 1.2pt + rgb("#6366f1"), fill: rgb("#e0e7ff"), width: 62mm),

  node((1, 4), [
    #text(weight: "bold", fill: rgb("#166534"))[System Ready for Solvers]\
    #text(size: 8.5pt, fill: rgb("#15803d"))[Square, finite $bold(F)(bold(x)_0)$, and bounded]
  ], stroke: success-stroke, fill: success-fill, width: 62mm),

  // Error Branch Left (column 0)
  node((0, 1), [
    *DOFReport Error: STOP*\
    #text(size: 8pt, fill: rgb("#991b1b"))[$N_("unknowns") != N_("equations")$ (singular)]
  ], stroke: danger-stroke, fill: danger-fill, width: 44mm),

  node((0, 2), [
    *Evaluability Error: STOP*\
    #text(size: 8pt, fill: rgb("#991b1b"))[NaN / Inf residual or fluid crash]
  ], stroke: danger-stroke, fill: danger-fill, width: 44mm),

  // Warning Branch Right (column 2)
  node((2, 3), [
    *Non-blocking Warnings*\
    #text(size: 8pt, fill: rgb("#b45309"))[Unphysical $bold(x)_0$ logged; solver proceeds]
  ], stroke: accent-stroke, fill: rgb("#fffbeb"), width: 44mm),

  // Edges
  edge((1, 0), (1, 1), "->"),
  edge((1, 1), (0, 1), "->", stroke: danger-stroke, label: [$text("DOF") != 0$]),
  edge((1, 1), (1, 2), "->", stroke: primary-stroke, label: [$text("Square") (text("DOF") = 0)$]),
  edge((1, 2), (0, 2), "->", stroke: danger-stroke, label: [Non-finite / Crash]),
  edge((1, 2), (1, 3), "->", stroke: accent-stroke, label: [Finite residuals]),
  edge((1, 3), (2, 3), "->", stroke: (paint: rgb("#f59e0b"), thickness: 1pt, dash: "dashed")),
  edge((1, 3), (1, 4), "->", stroke: success-stroke, label: [Clean])
)
