#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set page(width: auto, height: auto, margin: 15pt, fill: none)
#set text(font: "Helvetica Neue", size: 10pt, fill: rgb("#1e293b"))

#let primary-stroke = 1.2pt + rgb("#0284c7")
#let primary-fill = rgb("#e0f2fe")
#let success-stroke = 1.2pt + rgb("#22c55e")
#let success-fill = rgb("#d1fae5")
#let danger-stroke = 1.2pt + rgb("#ef4444")
#let danger-fill = rgb("#fee2e2")
#let slate-stroke = 1.2pt + rgb("#64748b")
#let slate-fill = rgb("#f1f5f9")

#align(center)[
  #text(size: 13pt, weight: "bold", fill: rgb("#0f172a"))[
    Control Volume Exergy Balance & Destruction
  ]
]
#v(6pt)

#diagram(
  spacing: (28mm, 20mm),
  node-corner-radius: 6pt,
  edge-stroke: 1.1pt + rgb("#64748b"),

  // Fuel Exergy (Inlet stream / Work)
  node((0, 0), [
    *Fuel Exergy ($dot(E)_(x, "fuel")$)*\
    #v(1pt)
    #text(size: 8.5pt)[Supplied driving exergy:\
    • Inflow exergy $dot(m)_("in") e_(x, "in")$\
    • Input mechanical work $dot(W)_c$\
    • High-temp heat $(1 - T_0/T_H) dot(Q)_H$]
  ], stroke: primary-stroke, fill: primary-fill, width: 56mm),

  // Control Volume
  node((1, 0), [
    *Component Control Volume*\
    #v(1pt)
    #text(size: 9pt, weight: "bold")[Steady Balance Law]\
    #v(1pt)
    #text(size: 8.5pt)[$dot(E)_(x, "fuel") = dot(E)_(x, "product") + dot(E)_(x, "dest")$\
    #v(2pt)
    $eta_("ex") = frac(dot(E)_(x, "product"), dot(E)_(x, "fuel"))$]
  ], stroke: slate-stroke, fill: slate-fill, width: 62mm),

  // Product Exergy (Useful effect)
  node((2, 0), [
    *Product Exergy ($dot(E)_(x, "product")$)*\
    #v(1pt)
    #text(size: 8.5pt)[Desired useful output:\
    • Turbine shaft power $dot(W)_t$\
    • Heated stream exergy gain\
    • Chilled fluid temperature drop]
  ], stroke: success-stroke, fill: success-fill, width: 56mm),

  // Exergy Destruction (Below CV)
  node((1, 1), [
    *Exergy Destruction ($dot(E)_(x, "dest")$)*\
    #v(1pt)
    #text(size: 8.5pt, fill: rgb("#991b1b"))[Gouy-Stodola Theorem:\
    $dot(E)_(x, "dest") = T_0 dot(S)_("gen") >= 0$\
    Irreversibilities: friction $Delta p$, finite $Delta T$]
  ], stroke: danger-stroke, fill: danger-fill, width: 66mm),

  // Edges
  edge((0, 0), (1, 0), "->", stroke: primary-stroke, label: [Supplied]),
  edge((1, 0), (2, 0), "->", stroke: success-stroke, label: [Produced]),
  edge((1, 0), (1, 1), "->", stroke: danger-stroke, label: [Irreversibility loss])
)
