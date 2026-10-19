# Day 1_Component modelling

> Source: `sources/Dossier partage SE/Cours/Seance 1 Bilan energie/Day 1_Component modelling.pptx`


---

## Slide 1

### Component modeling


### 2019


### 1


### Cong-Toan TRAN


---

## Slide 2

### 1er principe de la thermodynamique


### Système fermé:  pas de flux de matière au travers de la frontière


### Bilan d’énergie (énergies macroscopiques négligées)

  - Par convention:
    - Chaleur absorbée par le system:		positif
    - Travail produit par le system: 	   		positif
  - 2 types de travail:
    - Travail externe donné par un moyen extérieur
    - Travail de frontière lié à la dilatation du système

### Pour une évolution à volume constant (isochore):


### Pour une évolution à pression constant (isobar):


### 2


### (cv: chaleur spécifique à volume constant )


### (cp: chaleur spécifique à pression constant )


---

## Slide 3

### 1er principe de la thermodynamique


### Système ouvert: échange de matière possible au travers de la frontière


### Conservation de masse (ou bilan de masse)

  - Par convention: 		positif, 		négatif

### Travail d’écoulement d’un fluide entrant ou sortant d’un système:


### Conservation d’énergie (ou bilan d’énergie)


### 3


### (les énergies potentielles et cinétiques souvent négligées)


---

## Slide 4

### 2ème principe de la thermodynamique


### « La chaleur ne passe pas spontanément d’un corps froid sur un corps chaud »


### Inégalité de Clausius:

  - L’égalité  procédé réversible
  - Sinon, irréversible

### Définition de l’entropie:

  - s est aussi une variable d’état

### Principe de la génération d’entropie:

  - En condition stabilisée:

### 4


---

## Slide 5

### Expansion valve modeling


### Modeling assumptions:

  - No mechanical work  W=0
  - Small external surface  Q=0
  - Small control volume  Esystem, msystem neglicted
  - Kinetic energy neglected

### Model:

  - Flow rate controlled by the opening level of the valve
    - k: parameter of the valve, generally determined thanks to nominal working points
    - opening : between 0 (closed) and 1 (completely opened)
  - Quasi-isenthalpic expansion process:

### 5


---

## Slide 6

### Closed tank


### Modeling assumptions:

  - No mechanical work  W=0
  - Kinetic and potential energies neglected
  - Small control volume ?
  - Small external surface ?

### Mass balance:


### Energy balance:


### 6


---

## Slide 7

### Compression modeling (1)


### Ideal and real processes


### 7


---

## Slide 8

### Compression modeling (2)


### Isentropic efficiency


### Modeling assumptions:

  - Small external surface  Q=0
  - Small internal volume  Esystem, msystem neglected
  - Kinetic energy neglected

### Model:

  - Isentropic efficiency (also called adiabatic efficiency) supposed to be known:
  - Adiabatic process:

### Isentropic efficiency:

  - For a (liquid) pump : close to 1 (quasi-isentropic)
  - For a (vapor) compressor: h depend essentially on working conditions  h(T,p) needs to be known (via experimental tests)

### 8


---

## Slide 9

### Compression modeling (3)


### How to calculate the flow rate ?


### Volume metric type :

  - Ex: reciprocating and rotary compressors
  - Rotational speed : number of turns of the rotor per second
  - Flowrate depends on swept volume Vs, rotational speed and the inlet condition:

### Dynamic type :

  - Ex: Centrifugal compressor
  - A specific correlation between the flowrate and working conditions is required

### Expansion (turbine) modeling can be done using the similar method:

  - Example of correlation for a centrifuge turbine

### 9


### (K: characteristic constant of the component)


---

## Slide 10

### Analysis of heat exchanger


### Simplified case

- Heat exchanger allow to exchange heat between 2 fluids of different temperatures without mixing them

### 10


### Assumptions:


### Thermodynamics properties being constant


### Wall thickness neglected


### Exchange surfaces with the wall being the same


### temperature difference


### log mean


### temperature difference


### C, c : heat capacity rates (J/K)


---

## Slide 11

### Analysis of heat exchanger (2)


### Parallel-flow and counter-flow types


### These results are still correct in the following conditions:

  - The exchange surfaces are different
  - The wall conduction is considerable
  - Counter-flow (a=-1) or parallel-flow (a=1)

### 11


### a = circulation indicator


---

## Slide 12

### Heat exchanger modeling


### Objective of design


### Modeling a heat exchanger depends on the objectives:

  - Objective of simulation (the system is already existed)
  - Objective of design (the system is to be sized)

### 12


### 1b


### 1a


### 2a


### 2b


---

## Slide 13

### Heat exchanger modeling for design


### 13


### UA calculated


### A, a calculated


### For given U, u


### and surface ratio A/a


### 1b


### 1a


### 2a


### 2b


---

## Slide 14

### Pinch of a heat exchanger

- Pinch is defined as the minimum difference of the 2 fluid temperatures along the HEX
  - In the case of no phase change, the pinch location is at one of two sides of the HEX

### Pinch value results from the HEX surface (i.e. the HEX cost)

  - In practice, a HEX is sized by fixing a pinch value

### 14


---

## Slide 15

### Heat exchanger modeling for simulation


### The method NUT calculateT_out with sequential calculs


### 15


### T_out calculated,


### but require solving log function


### T_out


---

## Slide 16

### Effectiveness of heat exchanger

- Effectiveness = the ratio of actual heat transferred to the maximum possible heat transfer

### Effectiveness result from the HEX surface (i.e. the HEX cost)


### Effectiveness of counter flow > Effectiveness of parallel flow


### 16


---

## Slide 17

### Thank you !


### 17
