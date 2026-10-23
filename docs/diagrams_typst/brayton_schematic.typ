#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#3b82f6")
#let primary-fill = rgb("#dbeafe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Open-Cycle Brayton Gas Turbine Thermodynamic Circuit
  ]
]
#v(6pt)

#diagram(
  spacing: (20mm, 18mm),
  node-corner-radius: 5pt,
  edge-stroke: 1.2pt + rgb("#64748b"),

  // Main flow line
  node((0, 0), [
    *Air Inflow*\
    #text(size: 8pt)[$p_("amb"), T_("amb"), dot(m)_("air")$]
  ], stroke: 1.2pt + rgb("#0284c7"), fill: rgb("#e0f2fe"), width: 34mm),

  node((1, 0), [
    *Compressor*\
    #text(size: 8pt)[$r_p = p_2 / p_1, quad eta_("is")$]\
    #text(size: 8pt, fill: rgb("#1d4ed8"))[$dot(W)_c = dot(m) (h_2 - h_1)$]
  ], stroke: primary-stroke, fill: primary-fill, width: 38mm),

  node((2, 0), [
    *Combustor*\
    #text(size: 8pt)[$dot(Q)_("in") = dot(m)_f "LHV"$]\
    #text(size: 8pt, fill: rgb("#b45309"))[$sum dot(m)_i h_i = 0$]
  ], stroke: accent-stroke, fill: accent-fill, width: 38mm),

  node((2, 1), [
    *Fuel Inflow*\
    #text(size: 8pt)[$p_f, T_f, dot(m)_f$ (Methane)]
  ], stroke: 1.2pt + rgb("#f97316"), fill: rgb("#ffedd5"), width: 38mm),

  node((3, 0), [
    *Turbine*\
    #text(size: 8pt)[Expands to $p_("amb")$]\
    #text(size: 8pt, fill: rgb("#991b1b"))[$dot(W)_t = dot(m) (h_3 - h_4)$]
  ], stroke: danger-stroke, fill: danger-fill, width: 38mm),

  node((4, 0), [
    *Exhaust*\
    #text(size: 8pt)[Flue gas sink at $p_("amb")$]
  ], stroke: slate-stroke, fill: slate-fill, width: 32mm),

  // Fluid stream connections
  edge((0, 0), (1, 0), "->", stroke: 1.2pt + rgb("#0284c7"), label: [state 1]),
  edge((1, 0), (2, 0), "->", stroke: primary-stroke, label: [state 2]),
  edge((2, 1), (2, 0), "->", stroke: 1.2pt + rgb("#f97316"), label: [fuel]),
  edge((2, 0), (3, 0), "->", stroke: danger-stroke, label: [state 3]),
  edge((3, 0), (4, 0), "->", stroke: slate-stroke, label: [state 4]),

  // Mechanical Shaft power coupling (Turbine drives compressor + net work)
  edge((3, 0), (1, 0), "->",
    stroke: (paint: rgb("#a855f7"), thickness: 1.2pt, dash: "dashed"),
    label: [Shaft load: $dot(W)_("net") = dot(W)_t - dot(W)_c$],
    bend: 35deg
  )
)
