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
    Autostart Priority Fixpoint & Provenance Hierarchy
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 20mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.1pt + rgb("#64748b"),

  // Level 1: Boundary
  node((0, 0), [
    *Level 1: Boundary & Fix*\
    #text(size: 8.5pt)[`BOUNDARY (3)` & `HINT (2)`]\
    #text(size: 7.5pt, fill: rgb("#4338ca"))[FluidBoundary & user hints]
  ], stroke: 1.2pt + rgb("#4f46e5"), fill: rgb("#e0e7ff"), width: 52mm),

  // Level 2: Queue
  node((1, 0), [
    *Level 2: Priority Rules Queue*\
    #text(size: 8.5pt)[Connections, Valves, Mixers]\
    #text(size: 7.5pt, fill: rgb("#b45309"))[Ordered by topological certainty]
  ], stroke: accent-stroke, fill: accent-fill, width: 56mm),

  // Level 2: Action
  node((1, 1), [
    *Compute Target `.start`*\
    #text(size: 8.5pt)[Condition: Target is `DEFAULT (0)`]\
    #text(size: 7.5pt, fill: rgb("#1d4ed8"))[Assign Provenance = `PROPAGATED (1)`]
  ], stroke: primary-stroke, fill: primary-fill, width: 56mm),

  // Level 3: Internal Seeding
  node((2, 0), [
    *Level 3: Component Seeding*\
    #text(size: 8.5pt)[Internal component rules]\
    #text(size: 7.5pt, fill: rgb("#7c3aed"))[Heat exchanger sizing, volume $T, p$]
  ], stroke: purple-stroke, fill: purple-fill, width: 52mm),

  // Solved State
  node((2, 1), [
    #text(weight: "bold", fill: rgb("#166534"))[System Ready to Solve]\
    #text(size: 8.5pt, fill: rgb("#15803d"))[Consistent guess $bold(x)_0 in RR^n$ ready]
  ], stroke: success-stroke, fill: success-fill, width: 52mm),

  // Provenance Hierarchy Box
  node((1, 2.3), [
    *Start Provenance Hierarchy (Fixed Priority)*\
    #v(2pt)
    #text(size: 9pt)[
      `BOUNDARY (3)` $>$ `HINT (2)` $>$ `PROPAGATED (1)` $>$ `DEFAULT (0)`
    ]\
    #text(size: 8pt, fill: rgb("#64748b"))[
      Higher provenance levels are protected and never overwritten during propagation.
    ]
  ], stroke: slate-stroke, fill: slate-fill, width: 140mm),

  // Edges
  edge((0, 0), (1, 0), "->", stroke: 1.2pt + rgb("#4f46e5"), label: [seed queue]),
  edge((1, 0), (1, 1), "->", stroke: accent-stroke, label: [rule match]),
  edge((1, 1), (1, 0), "->", stroke: (paint: rgb("#3b82f6"), thickness: 1.1pt, dash: "dashed"), label: [iterate], bend: 48deg),
  edge((1, 0), (2, 0), "->", stroke: slate-stroke, label: [no more rules]),
  edge((2, 0), (2, 1), "->", stroke: purple-stroke, label: [complete])
)
