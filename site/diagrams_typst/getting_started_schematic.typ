#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#0284c7")
#let primary-fill = rgb("#e0f2fe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let purple-stroke = 1.2pt + rgb("#a855f7")
#let purple-fill = rgb("#f3e8ff")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Tutorial: Open-Loop Compression & Cooling Workflow
  ]
]
#v(6pt)

#diagram(
  spacing: (24mm, 20mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.2pt + rgb("#64748b"),

  // Node 1: Source
  node((0, 0), [
    *FluidBoundary (Source)*\
    #v(1pt)
    #text(size: 8pt)[$p_1 = 1.0 "bar"$\ $T_1 = 288.15 "K"$\ $dot(m) = -2.5 "kg/s"$]\
    #text(size: 7.5pt, fill: rgb("#0369a1"))[`fix_port(sys, src.out, ...)`]
  ], stroke: primary-stroke, fill: primary-fill, width: 48mm),

  // Node 2: Compressor
  node((1, 0), [
    *Compressor*\
    #v(1pt)
    #text(size: 8pt)[$eta_("is") = 0.82$\ $r_p = 5.0 -> p_2 = 5.0 "bar"$]\
    #text(size: 7.5pt, fill: rgb("#7c3aed"))[$dot(W)_c = dot(m)(h_2 - h_1)$]
  ], stroke: purple-stroke, fill: purple-fill, width: 44mm),

  // Node 3: Cooler
  node((2, 0), [
    *SimpleHeater (Cooler)*\
    #v(1pt)
    #text(size: 8pt)[$p_3 = p_2 quad (Delta p = 0)$\ $T_3 = 310.15 "K"$]\
    #text(size: 7.5pt, fill: rgb("#b45309"))[`fix_port(..., T=310.15)`]
  ], stroke: accent-stroke, fill: accent-fill, width: 48mm),

  // Node 4: Sink
  node((3, 0), [
    *FluidBoundary (Sink)*\
    #v(1pt)
    #text(size: 8pt)[$p_4 = p_3$\ $h_4 = h_3$\ $dot(m) = +2.5 "kg/s"$]\
    #text(size: 7.5pt, fill: rgb("#475569"))[Exhaust discharge]
  ], stroke: slate-stroke, fill: slate-fill, width: 40mm),

  // Connections
  edge((0, 0), (1, 0), "->", stroke: primary-stroke, label: [state 1: suction]),
  edge((1, 0), (2, 0), "->", stroke: purple-stroke, label: [state 2: hot gas]),
  edge((2, 0), (3, 0), "->", stroke: accent-stroke, label: [state 3: cooled gas])
)
