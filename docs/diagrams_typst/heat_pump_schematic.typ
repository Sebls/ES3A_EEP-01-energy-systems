#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#3b82f6")
#let primary-fill = rgb("#dbeafe")
#let accent-stroke = 1.2pt + rgb("#f59e0b")
#let accent-fill = rgb("#fef3c7")
#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let cyan-stroke = 1.2pt + rgb("#06b6d4")
#let cyan-fill = rgb("#cffafe")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Vapor-Compression Heat Pump Thermodynamic Closed Loop
  ]
]
#v(6pt)

#diagram(
  spacing: (38mm, 28mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.2pt + rgb("#64748b"),

  // Top: Condenser (HP heat rejection)
  node((1, 0), [
    *Condenser (`SizingHX`)*\
    #v(1pt)
    $dot(Q)_h = dot(m) (h_2 - h_3)$\
    #text(size: 8pt, fill: rgb("#991b1b"))[Desuperheating & condensation at $p_("cond")$]
  ], stroke: danger-stroke, fill: danger-fill, width: 68mm),

  // Right: Compressor (Work input)
  node((2, 1), [
    *Compressor*\
    #v(1pt)
    $dot(W)_c = dot(m) (h_2 - h_1) / eta_("is")$\
    #text(size: 8pt, fill: rgb("#1d4ed8"))[Vapor compression $p_("evap") -> p_("cond")$]
  ], stroke: primary-stroke, fill: primary-fill, width: 58mm),

  // Bottom: Evaporator (LP heat absorption)
  node((1, 2), [
    *Evaporator (`SizingHX`)*\
    #v(1pt)
    $dot(Q)_c = dot(m) (h_1 - h_4)$\
    #text(size: 8pt, fill: rgb("#0e7490"))[Refrigerant boiling at $p_("evap")$]
  ], stroke: cyan-stroke, fill: cyan-fill, width: 68mm),

  // Left: Expansion Valve
  node((0, 1), [
    *Expansion Valve*\
    #v(1pt)
    $h_4 = h_3 quad text("(isenthalpic)")\
    Delta p = p_("cond") - p_("evap")$
  ], stroke: accent-stroke, fill: accent-fill, width: 58mm),

  // Center Info Box
  node((1, 1), [
    *Working Fluid: R134a*\
    #v(2pt)
    #text(size: 9pt)[$text("COP")_("heating") = dot(Q)_h / dot(W)_c$]\
    #text(size: 8pt, fill: rgb("#64748b"))[Closed mass loop: $dot(m) = text("const")$]
  ], stroke: 0.8pt + rgb("#94a3b8"), fill: rgb("#ffffff"), width: 50mm),

  // Cycle Connections
  // 1. Compressor to Condenser (Hot high-pressure gas)
  edge((2, 1), (1, 0), "->",
    stroke: danger-stroke,
    label: [State 2: $p_("cond"), T_2$],
    bend: 22deg
  ),

  // 2. Condenser to Valve (High-pressure liquid)
  edge((1, 0), (0, 1), "->",
    stroke: accent-stroke,
    label: [State 3: subcooled],
    bend: 22deg
  ),

  // 3. Valve to Evaporator (Low-pressure two-phase)
  edge((0, 1), (1, 2), "->",
    stroke: cyan-stroke,
    label: [State 4: $x_4 > 0$],
    bend: 22deg
  ),

  // 4. Evaporator to Compressor (Low-pressure saturated/superheated vapor)
  edge((1, 2), (2, 1), "->",
    stroke: primary-stroke,
    label: [State 1: $p_("evap")$],
    bend: 22deg
  )
)
