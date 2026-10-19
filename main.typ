#import "@preview/latexy-book:0.0.1": (
  appendix, backmatter, book, code, corollary, definition, example, exercise, frontmatter, lemma, mainmatter, notice,
  proposition, theorem,
)

// Document metadata and latexy-book initial setup
#show: book.with(
  title: "Principles of Energy Systems Modelling",
  subtitle: "Thermodynamic Foundations, Component Balances, Cycle Analysis, and Numerical Simulation",
  author: "",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  titlepage: true,
)

// =============================================================================
// TYPOGRAPHY & VISUAL AESTHETICS (Monograph LaTeX Style)
// =============================================================================

// Page layout: Standard US-Letter
#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
  header: context {
    let page-num = counter(page).get().first()
    if page-num > 2 [
      #set text(font: "New Computer Modern", size: 8.5pt)
      #grid(
        columns: (1fr, auto),
        text(style: "italic")[Principles of Energy Systems Modelling], str(page-num),
      )
      #v(-0.4em)
      #line(length: 100%, stroke: 0.4pt + luma(130))
    ]
  },
  footer: none,
)

// Font setup: Knuth's Computer Modern Roman & Math
#set text(
  font: "New Computer Modern",
  size: 10pt,
  lang: "en",
)
#set par(
  justify: true,
  leading: 0.58em,
  first-line-indent: 1.5em,
)
#show raw: set text(font: ("DejaVu Sans Mono", "Courier New"), size: 8.2pt)
#show math.equation: set text(font: "New Computer Modern Math")

// Enhanced code presentation: distinct container, left accent border, and language badge
#show raw.where(block: false): it => box(
  fill: rgb("#f3f4f6"),
  inset: (x: 3.5pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2.5pt,
  baseline: 0%,
  text(fill: rgb("#1f2937"), style: "normal", weight: "regular", it)
)

#show raw.where(block: true): it => block(
  fill: rgb("#f8fafc"),
  inset: 10pt,
  radius: 4pt,
  stroke: (left: 2.5pt + rgb("#3b82f6"), rest: 0.5pt + rgb("#e2e8f0")),
  width: 100%,
  it
)

// Heading styling
#show heading.where(level: 1): it => block(above: 2.2em, below: 1.4em)[
  #text(weight: "bold", size: 1.6em)[#it.body]
]
#show heading.where(level: 2): it => block(above: 1.8em, below: 1.1em)[
  #text(weight: "bold", size: 1.3em)[#it.body]
]
#show heading.where(level: 3): it => block(above: 1.5em, below: 0.9em)[
  #text(weight: "bold", size: 1.08em)[#it.body]
]

// ==========================================
// FRONT MATTER
// ==========================================
#frontmatter()

= Preface
Energy systems stand at the epicenter of modern civilization and the global transition toward decarbonization. From high-efficiency combined cycles and cogeneration plants to industrial heat pumps, refrigeration loops, and advanced thermal storage, the rigorous engineering of these systems requires a sound grasp of classical physics, continuum thermodynamics, and modern computational thermophysics.

This monograph provides a rigorous, self-contained theoretical and computational foundation for thermodynamic energy systems modelling. Rather than treating individual components as disconnected empirical black boxes, we develop a unified formulation grounded in continuum mass, energy, and entropy conservation balances, non-ideal equations of state, and realistic isentropic/exergetic performance metrics.

#outline(indent: auto)

// ==========================================
// MAIN MATTER
// ==========================================
#mainmatter()

#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
)

= Part I: Fundamental Principles & Component Modelling
#include "chapters/ch01_foundations_and_components.typ"

// ==========================================
// BACK MATTER
// ==========================================
#backmatter()

#bibliography("refs.bib", full: true)
