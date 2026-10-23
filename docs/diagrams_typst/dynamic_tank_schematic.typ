#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#0284c7")
#let primary-fill = rgb("#e0f2fe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let orange-stroke = 1.2pt + rgb("#ea580c")
#let orange-fill = rgb("#ffedd5")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Dynamic Heated Storage Tank (DAE System)
  ]
]
#v(6pt)

#diagram(
  spacing: (26mm, 20mm),
  node-corner-radius: 5pt,
  edge-stroke: 1.2pt + rgb("#64748b"),

  // Inflow Boundary
  node((0, 0), [
    *Cold Inflow*\
    #text(size: 8pt)[$T_("in")(t), dot(m)_("in")(t)$]
  ], stroke: primary-stroke, fill: primary-fill, width: 36mm),

  // Central Tank
  node((1, 0), [
    *Tank (`TankConstV`)*\
    #v(2pt)
    #text(size: 8.5pt, fill: rgb("#b45309"))[
      Fluid DAE: $frac(d M, d t) = dot(m)_("in") - dot(m)_("out")$\
      Energy DAE: $frac(d U, d t) = dot(m)_("in") h_("in") - dot(m)_("out") h_("out") + dot(Q)_("conv")$\
      Wall DAE: $C_("wall") frac(d T_("wall"), d t) = dot(Q)_("heater") - dot(Q)_("conv")$
    ]
  ], stroke: accent-stroke, fill: accent-fill, width: 88mm),

  // Outflow Boundary
  node((2, 0), [
    *Hot Outflow*\
    #text(size: 8pt)[$T(t), dot(m)_("out")(t)$]
  ], stroke: orange-stroke, fill: orange-fill, width: 36mm),

  // Electrical Heating input
  node((1, 1), [
    *Electric Heater*\
    #text(size: 8.5pt)[Heat input $dot(Q)_("heater")$ to wall thermal mass]
  ], stroke: danger-stroke, fill: danger-fill, width: 68mm),

  // Fluid streams
  edge((0, 0), (1, 0), "->", stroke: primary-stroke, label: [Cold fluid]),
  edge((1, 0), (2, 0), "->", stroke: orange-stroke, label: [Discharge]),

  // Heat input
  edge((1, 1), (1, 0), "->", stroke: danger-stroke, label: [$dot(Q)_("heater")$])
)
