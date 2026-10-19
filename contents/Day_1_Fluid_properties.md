# Day 1_Fluid properties

> Source: `sources/Dossier partage SE/Cours/Seance 1 Bilan energie/Day 1_Fluid properties.pptx`


---

## Slide 1

### Themodynamics fluid properties - Course TESM


### 2022


### 1


### Cong Toan TRAN


---

## Slide 2

### Rappels

- An intensive property does not depend on the system size or the amount of material in the system

### Extensive properties are additive for subsystems


### 2



| Col 1 | Col 2 | Col 3 |
| --- | --- | --- |
| Variable | Symbol | Unit |
| Temperature | T | K |
| Pressure | P | Pa |
| Volume | V | m3 |
| Enthalpy | H | J |
| Entropy | S | J/K |
| Internal energy | U | J |
| Specific heat capacity | cp | J/(K.kg) |
| Specific Enthalpy | h | J/kg |



---

## Slide 3

### Properties of a pure fluid


### 2 common phases:

  - Subcooling liquid
  - Overheating liquid
    - Diphasic
  - (Supercritical phase)

### In a saturated mixture, vapor quality is:


### For a given intensive variable z (such as specific enthalpy)


### State equation = relation between state variables

  - Perfect gas:
  - Real gas:

### 3


---

## Slide 4

### Degree of freedom

- The number of degrees of freedom (F) is the number of intensive variables which are independent of each other.

### Gibbs phase rule:

  - F degree of freedom
  - N number of components
  - F number of phases

### 4


### F = N – F + 2


---

## Slide 5

### Degree of freedom


### Example:

  - Single component / single phase : F = 2
  - Single component / two phase : F = 1
  - Single component / three phase : F = 0
  - Binary system / single phase: F = 3

### 5


---

## Slide 6

### How to calculate a thermodynamic property


### Calculate the degree of freedom


### Identify the appropriate state variables which are known


### Use one of the two following options:

  - Property diagrams (P-T diagram, P-v diagram …)
  - Programs which calculate the property

### 6


---

## Slide 7

### Example of p-h diagram


### 7


---

## Slide 8

### Example of Refprop


### 8


### Estimate the cost of gas to heat the water used during a shower !


---

## Slide 9

### Example of a free tool on Internet


### 9


---

## Slide 10

### Example of CoolProp in Python


### Directly from CoolProp:


### from CoolProp.CoolProp import PropsSI


### p = 1e5


### T= 10+273,15h = PropsSI("H", "P", p, ‘’T", T, ‘air’)


### Or from Caldis (only availlable for certain functions):


### from caldis.fluids.coolprop_backend import CoolPropBackend


### be_air = CoolPropBackend("Air")


### p = 1e5


### T= 10+273,15


### be_air.h_pt(p, T)


### 10


---

## Slide 11

### Thank you !


### 11
