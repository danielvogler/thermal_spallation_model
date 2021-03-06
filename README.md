# Thermal Spallation Model
Thermal spallation modeling with [MOOSE](www.github.com/idaholab/moose). 

### Last updates: 
The model updated to work proberly using the MOOSE version updated on 24.09.2021. 

### Pre-requests:
The following two physical models must be activated. 
1. [Heat Conduction Module](https://mooseframework.inl.gov/modules/heat_conduction/index.html).
2. [Tensor Mechanics Module](https://mooseframework.inl.gov/modules/tensor_mechanics/index.html). 
 

### Files
- simulation files: input files for [MOOSE simulator](www.github.com/idaholab/moose). Investigated are maximum jet flame temperature, solid structure type and heating rate impact.
- input files:
  - pressure_distributions: Stress field
  - temperature_distributions: Temperature distribution along the borehole surface, including heating rate.
  - voronoi_diagrams: Input images for the background matrix and heterogeneous parameters.
- mesh files: .jou file for Trelis/Cubit and smoothed input mesh for simulation files.
- scripts: Generate temperature distributions or voronoi diagrams.

### Publications
- Vogler, D., S.D.C. Walsh, Ph. Rudolf von Rohr, and M.O. Saar, Simulation of rock failure modes in thermal spallation drilling, Acta Geotechnica, 15/8, pp. 2327-2340, 2020.  [https://doi.org/10.1007/s11440-020-00927-7](https://doi.org/10.1007/s11440-020-00927-7)

### Figures
<img src="./images/example_material_composition.png" width="400">
Example material composition


<img src="./images/final_system_mesh.png" width="400">
Simulation domain


<img src="./images/final_granite_D100m_T1000_stresses.png" width="400">
Grain composition and damage (in red), maximum principal stress, minimum principal stress and heating-induced displacement field (from top to bottom). 
