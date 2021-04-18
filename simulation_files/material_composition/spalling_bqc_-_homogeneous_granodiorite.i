##
## Thermal property sources
##
## thermal expansion from rauenzahn and tester and walsh and lomov
## thermal conductivity from walsh and lomov
## a) quartz (7.7)
## b) placioglas
## c) k-spar

##
## System geometry
##
## (1) Height of specimens you drill into: 150mm
## (2) Inner radius of opening of the top plate for the flame: 23mm
## (3) Outer radius of the top plate. (it is a square plate, see attached sketch) the edge is 200mm
## (4) Specimen diameter 84mm

###
### VARIABLES
###
### Damage values
damage_threshold = 0.002
damageSwitch = 20000001.1
HBSigmaC = 122.0 # Kazerani 2013
HBM = 25.0 # JAeger et al. 2009
tensileStrength = 10.0 # in MPA Vogler et al. 2017
heatTransferCoefficient = 10.0e3
###
### STRESS
###
### Granite overburden
stressHundredM = 2.65 #MPA
stressThousandM = 26.487 #MPA
stressFiveThousandM = 132.435 #MPA
### borehole water pillar
boreholePressureHundredM = 0.98 #MPA
boreholePressureThousandM = 9.81 #MPA
boreholePressureFiveThousandM = 49.05 #MPA
### used loads
load_vertical =   ${stressHundredM}
load_horizontal = ${stressHundredM}
borehole_pressure = ${boreholePressureHundredM}
##
## Phase maps
##
## A number of different phases (a, b, c, d, and so on) are defined
## to map material (mineral) properties for mechanical and thermal properties
## The phases are mapped according to loaded image functions (e.g., thin sections)
### phase ranges
it_a_lo = -1.0e3
it_a_hi = -942.0
it_b_lo = -942.0
it_b_hi = -8106.0
it_c_lo = -8106.0
it_c_hi = -7191.0
it_d_lo = -7191.0
it_d_hi = -6000.0
it_e_lo = -6000.0
it_e_hi = -1.0
it_f_lo = -1.0
it_f_hi = 9360.0
it_z_lo = 9360.0
it_z_hi = 9390.0
###
### TEMPERATURE [K]
###
# T_SURFACE = 285.0
# 100m depth = 288.0
# 1000m depth = 315.0
# 5000m depth = 435.0
tempSurface = 285.0
tempHundredM = 288.0
tempThousandM = 315.0
tempFiveThousandM = 435.0

tempInitialVal = ${tempHundredM}
tempIntermVal  = 303.0
tempPeakOneVal = 800.0
###
### material properties
###
# density - rho
# specific heat - cp
# thermal conductivity - k
### GRANITE
# a - K-Feldspar
# b - Plagioclase
# c - Quartz
# d - Biotite
# e - averaged granite eberhardt 1999
# f - averaged granodiorite eberhardt 1999
## density
GR_rho_a = 2560.0
GR_rho_b = 2630.0
GR_rho_c = 2650.0
GR_rho_d = 3005.0
GR_rho_e = 2620.0
GR_rho_f = 2650.0
GR_rho_z = 2603.0
## bulk modulus
GR_E_a = 53.7e3
GR_E_b = 50.8e3
GR_E_c = 37.0e3
GR_E_d = 59.7e3
GR_E_e = 47.7e3
GR_E_f = 47.8e3
GR_E_z = 99.0e3
## poisson ratio
GR_eps_a = 0.26
GR_eps_b = 0.28
GR_eps_c = 0.21
GR_eps_d = 0.21
GR_eps_e = 0.24
GR_eps_f = 0.24
GR_eps_z = 0.3
### strain
GR_e_a = 0.37e-6
GR_e_b = 0.42e-6
GR_e_c = 1.67e-6
GR_e_d = 1.21e-6
GR_e_e = 0.67e-6
GR_e_f = 0.71e-6
GR_e_z = 9.0e-5
## specific heat
GR_cp_a = 930.0
GR_cp_b = 930.0
GR_cp_c = 930.0
GR_cp_d = 1000.0
GR_cp_e = 933.4
GR_cp_f = 936.8
GR_cp_z = 930.0
## thermal conductivity
GR_thK_a = 2.31
GR_thK_b = 2.14
GR_thK_c = 7.69
GR_thK_d = 2.02
GR_thK_e = 3.36
GR_thK_f = 3.32
GR_thK_z = 9.0
### WATER (damaged material - drilling fluid)
WA_rho_z = 1000.0
WA_cp_z  = 4181.0
WA_thK_z = 0.591 # 0.591
WA_E_z = 2.0e3
WA_e_z = 1.0e-8



[Mesh]
  # Comment
  type = FileMesh
  file = '../../mesh_files/bqc_nodes322360.e'
[]


[GlobalParams]
  displacements = 'disp_x disp_y'
[]


[Problem]
  coord_type = RZ
  rz_coord_axis = Y # Which axis the symmetry is around
[]


[Modules/TensorMechanics/Master]
  [./tm]
    incremental = false
    add_variables = true
    eigenstrain_names = 'thermal_expansion ini_stress'
    temperature = T
    generate_output = 'stress_xx stress_yy stress_zz max_principal_stress min_principal_stress'
    use_displaced_mesh = false
  [../]
[]


[Variables]
  [./T]
    initial_condition = ${tempInitialVal}
  [../]
[]


[Kernels]
  [./htcond]
    type = HeatConduction
    variable = T
    use_displaced_mesh = false
  [../]
  [./time_deriv_T]
    type = SpecificHeatConductionTimeDerivative
    specific_heat = specific_heat
    variable = T
    use_displaced_mesh = false
  [../]
[]


[AuxVariables]
  ###
  ### STRAIN
  ###
  [./strain_xx]   order = CONSTANT   family = MONOMIAL
  [../]
  [./strain_yy]   order = CONSTANT   family = MONOMIAL
  [../]
  [./strain_xy]   order = CONSTANT   family = MONOMIAL
  [../]
  [./volumetric_strain]   order = CONSTANT   family = MONOMIAL
  [../]
  [./deviatoric_strain]   order = CONSTANT   family = MONOMIAL
  [../]
  ###
  ### PARAMETER FIELD
  ###
  [./map]   order = CONSTANT   family = MONOMIAL
  [../]
  [./mapUp]   order = CONSTANT   family = MONOMIAL
  [../]
  ###
  ### DAMAGE
  ###
  [./damagedMain]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedMainEight]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedMainFourteen]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedMainTwenty]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedVolumetricStrain]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedDeviatoricStrain]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedHB]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedMogi]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedTensile]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedSpallingEight]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedSpallingFourteen]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedSpallingTwenty]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedOne]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedTwo]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedThree]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedFour]   order = CONSTANT   family = MONOMIAL
  [../]
  [./damagedFive]   order = CONSTANT   family = MONOMIAL
  [../]
[]


[AuxKernels]
  ###
  ### STRAIN
  ###
  [./strain_xx]   type = RankTwoAux   variable = strain_xx   rank_two_tensor = total_strain   index_j = 0   index_i = 0
  [../]
  [./strain_yy]   type = RankTwoAux   variable = strain_yy   rank_two_tensor = total_strain   index_j = 1   index_i = 1
  [../]
  [./strain_xy]   type = RankTwoAux   variable = strain_xy   rank_two_tensor = total_strain   index_j = 0   index_i = 1
  [../]
  ### compute volumetric strain
  [./volumetric_strain]   type = ParsedAux   args = 'strain_xx strain_yy'   execute_on = timestep_end
    variable = volumetric_strain   function = 'strain_xx + strain_yy' [../]
  ### compute deviatoric strain
  [./deviatoric_strain]   type = ParsedAux   args = 'strain_xx strain_yy'   execute_on = timestep_end
    variable = deviatoric_strain   function = 'strain_yy - strain_xx' [../]
  ###
  ### DAMAGE
  ###
  [./damagedMain]   type = MaterialRealAux   property = damageCriteria_main   variable = damagedMain
  [../]
  [./damagedMainEight]   type = MaterialRealAux   property = damageCriteria_mainEight   variable = damagedMainEight
  [../]
  [./damagedMainFourteen]   type = MaterialRealAux   property = damageCriteria_mainFourteen   variable = damagedMainFourteen
  [../]
  [./damagedMainTwenty]   type = MaterialRealAux   property = damageCriteria_mainTwenty   variable = damagedMainTwenty
  [../]
  [./damagedVolumetricStrain]   type = MaterialRealAux   property = damageCriteria_volumetricStrain
    variable = damagedVolumetricStrain [../]
  [./damagedDeviatoricStrain]   type = MaterialRealAux   property = damageCriteria_deviatoricStrain
    variable = damagedDeviatoricStrain [../]
  [./damagedHB]   type = MaterialRealAux   property = damageCriteria_HB
    variable = damagedHB [../]
  [./damagedMogi]   type = MaterialRealAux   property = damageCriteria_mogi
    variable = damagedMogi [../]
  [./damagedTensile]   type = MaterialRealAux   property = damageCriteria_tensile
    variable = damagedTensile [../]
  [./damagedSpallingEight]   type = MaterialRealAux   property = damageCriteria_spallingEight
    variable = damagedSpallingEight [../]
  [./damagedSpallingFourteen]   type = MaterialRealAux   property = damageCriteria_spallingFourteen
    variable = damagedSpallingFourteen [../]
  [./damagedSpallingTwenty]   type = MaterialRealAux   property = damageCriteria_spallingTwenty
    variable = damagedSpallingTwenty [../]
  [./damagedOne]
    type = ParsedAux
    args = 'damagedMain'
    execute_on = timestep_end
    variable = damagedOne
    function = 'if(damagedMain = 1.0,1.0,0.0)'
  [../]
  [./damagedTwo]
    type = ParsedAux
    args = 'damagedMain'
    execute_on = timestep_end
    variable = damagedTwo
    function = 'if(damagedMain = 2.0,1.0,0.0)'
  [../]
  [./damagedThree]
    type = ParsedAux
    args = 'damagedMain'
    execute_on = timestep_end
    variable = damagedThree
    function = 'if(damagedMain = 3.0,1.0,0.0)'
  [../]
  [./damagedFour]
    type = ParsedAux
    args = 'damagedMain'
    execute_on = timestep_end
    variable = damagedFour
    function = 'if(damagedMain = 4.0,1.0,0.0)'
  [../]
  [./damagedFive]
    type = ParsedAux
    args = 'damagedMain'
    execute_on = timestep_end
    variable = damagedFive
    function = 'if(damagedMain = 5.0,1.0,0.0)'
  [../]
  ### put field map together based on original field and damage
  [./mapUp]
    type = ParsedAux
    args = 'damagedMain map'
    execute_on = timestep_end
    variable = mapUp
    function = 'if(damagedMain > ${damageSwitch},321.0,map)'
  [../]
[]


[Functions]
  ###
  ### IMAGE FUNCTION
  ###
  [./my_image]
    type = ImageFunction
    file_base = ../../input_files/voronoi_diagrams/voronoi_lacDuBonnetGranodiorite_EberhardEtAl1999noBounds0_noBoundaries_full_
    file_suffix = png
    file_range = '00'
  [../]
  ###
  ### TEMPERATURE Functions
  ###
  [./T_bc_top_func]
    type = PiecewiseMultilinear
    data_file = ../../input_files/temperature_distributions/temperature_profile_gaussian_TMax1000K.txt
  [../]
[]


[ICs]
  ###
  ### FIELD MAP (initialize read in image)
  ###
  [./map_ic]
    type = FunctionIC
    function = my_image
    variable = map
  [../]
[]


[BCs]
  ### MECH - DIRICHLET
  [./disp_x_on_y_axis]
    type = PresetBC
    boundary = '1'
    variable = disp_x
    value = 0
    use_displaced_mesh = false
  [../]
  [./disp_y_bottom]
    type = PresetBC
    boundary = '6'
    variable = disp_y
    value = 0
    use_displaced_mesh = false
  [../]
  ### MECH - NEUMANN
  [./stress_horizontal]
    type = Pressure
    boundary = '5'
    variable = disp_x
    component = 0
    factor = ${load_horizontal} # horizontal load, corresponding to initial horizontal stress
    use_displaced_mesh = false
  [../]
  [./stress_vertical]
    type = Pressure
    boundary = '4'
    variable = disp_y
    component = 1
    factor = ${load_vertical} # vertical load, corresponding to initial horizontal stress
    use_displaced_mesh = false
  [../]
  [./borehole_stress_x]
    type = Pressure
    boundary = '2 3'
    variable = 'disp_x'
    component = 0
    factor = ${borehole_pressure} # vertical load, corresponding to initial horizontal stress
    use_displaced_mesh = false
  [../]
  [./borehole_stress_y]
    type = Pressure
    boundary = '2 3'
    variable = 'disp_y'
    component = 1
    factor = ${borehole_pressure} # vertical load, corresponding to initial horizontal stress
    use_displaced_mesh = false
  [../]


  ### TEMPERATURE
  # [./T_top_function]
  #   type = FunctionPresetBC
  #   variable = T
  #   boundary = '2'
  #   function = T_bc_top_func
  # [../]
  [./T_top_convectiveHeatFLuxFunction]
    type = ConvectiveFluxFunction  # Convective flux, e.g. q'' = h*(Tw - Tf)
    boundary = '2'
    variable = T
    coefficient = ${heatTransferCoefficient}   # convective heat transfer coefficient (w/m^2-K)[50 BTU/hr-ft^2-F]
    T_infinity = T_bc_top_func
  [../]
  # [./T_top_dirichlet]
  #   type = FunctionDirichletBC
  #   boundary = '2'
  #   variable = T
  #   # apply slowly to avoid overshoots and undershoots in the non-lumped and non-upwinded Temperature Kernels
  # function = 'max(min(${tempInitialVal}+(${tempPeakOneVal}-${tempInitialVal})*t/80,${tempPeakOneVal}),${tempInitialVal})'
  #   use_displaced_mesh = false
  # [../]
  [./T_bottom_dirichlet]
    type = PresetBC
    boundary = '4 5 6'
    variable = T
    value = ${tempInitialVal}
    use_displaced_mesh = false
  [../]
[]


[Materials]
# [Materials]
#   ###
#   ### STRESS
#   ###
#   ### Define elasticity tensors for individual phases
  [./C_a]
    type = ComputeIsotropicElasticityTensor
    base_name = C_a
    poissons_ratio = '${GR_eps_a}'
    youngs_modulus = '${GR_E_a}'
  [../]
  [./C_b]
    type = ComputeIsotropicElasticityTensor
    base_name = C_b
    poissons_ratio = '${GR_eps_b}'
    youngs_modulus = '${GR_E_b}'
  [../]
  [./C_c]
    type = ComputeIsotropicElasticityTensor
    base_name = C_c
    poissons_ratio = '${GR_eps_c}'
    youngs_modulus = '${GR_E_c}'
  [../]
  [./C_d]
    type = ComputeIsotropicElasticityTensor
    base_name = C_d
    poissons_ratio = '${GR_eps_d}'
    youngs_modulus = '${GR_E_d}'
  [../]
  [./C_e]
    type = ComputeIsotropicElasticityTensor
    base_name = C_e
    poissons_ratio = '${GR_eps_e}'
    youngs_modulus = '${GR_E_e}'
  [../]
  [./C_f]
    type = ComputeIsotropicElasticityTensor
    base_name = C_f
    poissons_ratio = '${GR_eps_f}'
    youngs_modulus = '${GR_E_f}'
  [../]
  [./C_damaged]
    type = ComputeIsotropicElasticityTensor
    base_name = C_damaged
    poissons_ratio = '${GR_eps_z}'
    youngs_modulus = '${GR_E_z}'
  [../]
  ### define material class based on material phases
  [./F_a]
    type = DerivativeParsedMaterial
    f_name = F_a
    function = 'if(${it_a_lo}<mapUp,if(mapUp<=${it_a_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_b]
    type = DerivativeParsedMaterial
    f_name = F_b
    function = 'if(${it_b_lo}<mapUp,if(mapUp<=${it_b_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_c]
    type = DerivativeParsedMaterial
    f_name = F_c
    function = 'if(${it_c_lo}<mapUp,if(mapUp<=${it_c_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_d]
    type = DerivativeParsedMaterial
    f_name = F_d
    function = 'if(${it_d_lo}<mapUp,if(mapUp<=${it_d_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_e]
    type = DerivativeParsedMaterial
    f_name = F_e
    function = 'if(${it_e_lo}<mapUp,if(mapUp<=${it_e_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_f]
    type = DerivativeParsedMaterial
    f_name = F_f
    function = 'if(${it_f_lo}<mapUp,if(mapUp<=${it_f_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  [./F_damaged]
    type = DerivativeParsedMaterial
    f_name = F_damaged
    function = 'if(${it_z_lo}<mapUp,if(mapUp<=${it_z_hi},1,0),0)'
    args = mapUp
    outputs = exodus
  [../]
  ### M - HETEROGENEOUS
  ### sort elasticity tensors to respective material class
  [./elasticity_tensor]
    type = CompositeElasticityTensor
    args = map
    tensors = 'C_a C_b C_c C_d C_e C_f C_damaged'
    weights = 'F_a F_b F_c F_d F_e F_f F_damaged'
  [../]
  ### M - HOMOGENEOUS
  # [./elasticity_tensor]
  #   type = ComputeIsotropicElasticityTensor
  #   youngs_modulus = 50E3
  #   poissons_ratio = 0.3
  # [../]
  ### M - GENERAL
  ### compute linear elastic stress in domain
  [./elastic_stress]
    type = ComputeLinearElasticStress
  [../]
  [./ini_strain]
    type = ComputeEigenstrainFromInitialStress
    initial_stress = '-${load_horizontal} 0.0 0.0  0.0 -${load_vertical} 0.0  0.0 0.0 -${load_horizontal}' # radial, vertical, hoop
    eigenstrain_name = ini_stress
  [../]

  ###
  ### TM COUPLING
  ###
  ### HETEROGENEOUS
  ### define eigenstrains per Kelvin temperature change
  [./e_1] # eigenstrain per Kelvin for phase 1
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_a} 0.0 0.0   0.0 ${GR_e_a} 0.0   0.0 0.0 ${GR_e_a}'
    tensor_name = e_1
  [../]
  [./e_2] # eigenstrain per Kelvin for phase 2
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_b} 0.0 0.0   0.0 ${GR_e_b} 0.0   0.0 0.0 ${GR_e_b}'
    tensor_name = e_2
  [../]
  [./e_3] # eigenstrain per Kelvin for phase 3
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_c} 0.0 0.0   0.0 ${GR_e_c} 0.0   0.0 0.0 ${GR_e_c}'
    tensor_name = e_3
  [../]
  [./e_4] # eigenstrain per Kelvin for phase 4
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_d} 0.0 0.0   0.0 ${GR_e_d} 0.0   0.0 0.0 ${GR_e_d}'
    tensor_name = e_4
  [../]
  [./e_5] # eigenstrain per Kelvin for phase 5
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_e} 0.0 0.0   0.0 ${GR_e_e} 0.0   0.0 0.0 ${GR_e_e}'
    tensor_name = e_5
  [../]
  [./e_6] # eigenstrain per Kelvin for phase 6
    type = GenericConstantRankTwoTensor
    tensor_values = '${GR_e_f} 0.0 0.0   0.0 ${GR_e_f} 0.0   0.0 0.0 ${GR_e_f}'
    tensor_name = e_6
  [../]
  [./e_damaged] # eigenstrain per Kelvin for phase 2
    type = GenericConstantRankTwoTensor
    tensor_values = '${WA_e_z} 0.0 0.0   0.0 ${WA_e_z} 0.0   0.0 0.0 ${WA_e_z}'
    tensor_name = e_damaged
  [../]
  ### materials for factors multiplied onto the "per Kelvin tensors"
  [./func_a]
    type = DerivativeParsedMaterial
    function = 'if(${it_a_lo}<mapUp,if(mapUp<=${it_a_hi},T-${tempInitialVal},0),0)'
    f_name = f_a
    args = 'mapUp T'
  [../]
  [./func_b]
    type = DerivativeParsedMaterial
    function = 'if(${it_b_lo}<mapUp,if(mapUp<=${it_b_hi},T-${tempInitialVal},0),0)'
    f_name = f_b
    args = 'mapUp T'
  [../]
  [./func_c]
    type = DerivativeParsedMaterial
    function = 'if(${it_c_lo}<mapUp,if(mapUp<=${it_c_hi},T-${tempInitialVal},0),0)'
    f_name = f_c
    args = 'mapUp T'
  [../]
  [./func_d]
    type = DerivativeParsedMaterial
    function = 'if(${it_d_lo}<mapUp,if(mapUp<=${it_d_hi},T-${tempInitialVal},0),0)'
    f_name = f_d
    args = 'mapUp T'
  [../]
  [./func_e]
    type = DerivativeParsedMaterial
    function = 'if(${it_e_lo}<mapUp,if(mapUp<=${it_e_hi},T-${tempInitialVal},0),0)'
    f_name = f_e
    args = 'mapUp T'
  [../]
  [./func_f]
    type = DerivativeParsedMaterial
    function = 'if(${it_f_lo}<mapUp,if(mapUp<=${it_f_hi},T-${tempInitialVal},0),0)'
    f_name = f_f
    args = 'mapUp T'
  [../]
  [./func_damaged]
    type = DerivativeParsedMaterial
    function = 'if(${it_z_lo}<mapUp,if(mapUp<=${it_z_hi},T-${tempInitialVal},0),0)'
    f_name = f_damaged
    args = 'mapUp T'
  [../]
  ### HOMOGENEOUS
  # [./thermal_expansion_strain]
  #   type = ComputeThermalExpansionEigenstrain
  #   stress_free_temperature = 300.0
  #   thermal_expansion_coeff = 2E-5
  #   temperature = T
  #   eigenstrain_name = thermal_expansion
  # [../]
  ### HETEROGENEOUS
  ### compute strains based on reference T and current T and strain properties
  [./eigenstrain]
    type = CompositeEigenstrain
    tensors = 'e_1 e_2 e_3 e_4 e_5 e_6 e_damaged'
    weights = 'f_a f_b f_c f_d f_e f_f f_damaged'
    args = 'mapUp T'
    eigenstrain_name = thermal_expansion
  [../]

  ###
  ### THERMAL PROPERTIES
  ###
  ### phase field based thermal conductivity
  [./phasemap_k]
    type = ParsedMaterial
    f_name = thermal_conductivity
    args = 'mapUp'
    function = 'if(mapUp>${it_z_lo},${WA_thK_z},if(mapUp>${it_f_lo},${GR_thK_f},if(mapUp>${it_e_lo},
    ${GR_thK_e},if(mapUp>${it_d_lo},${GR_thK_d},if(mapUp>${it_c_lo},${GR_thK_c},if(mapUp>${it_b_lo},
    ${GR_thK_b},if(mapUp>${it_a_lo},${GR_thK_a},${WA_thK_z})))))))'
    outputs = exodus
  [../]
  ### phase field based specific heat
  [./phasemap_cp]
    type = ParsedMaterial
    f_name = specific_heat
    args = 'mapUp'
    function = 'if(mapUp>${it_z_lo},${WA_cp_z},if(mapUp>${it_f_lo},${GR_cp_f},if(mapUp>${it_e_lo},
    ${GR_cp_e},if(mapUp>${it_d_lo},${GR_cp_d},if(mapUp>${it_c_lo},${GR_cp_c},if(mapUp>${it_b_lo},
    ${GR_cp_b},if(mapUp>${it_a_lo},${GR_cp_a},${WA_cp_z})))))))'
    outputs = exodus
  [../]
  ### phase field based density
  [./phasemap_rho]
    type = ParsedMaterial
    f_name = density
    args = 'mapUp'
    function = 'if(mapUp>${it_z_lo},${WA_rho_z},if(mapUp>${it_f_lo},${GR_rho_f},if(mapUp>${it_e_lo},
    ${GR_rho_e},if(mapUp>${it_d_lo},${GR_rho_d},if(mapUp>${it_c_lo},${GR_rho_c},if(mapUp>${it_b_lo},
    ${GR_rho_b},if(mapUp>${it_a_lo},${GR_rho_a},${WA_rho_z})))))))'
    outputs = exodus
  [../]

  ###
  ### DAMAGE
  ###
  ### VOLUMETRIC STRAIN
  [./mat_damage_criteria_volStrain]
    type = ParsedMaterial
    f_name = damageCriteria_volumetricStrain
    args = 'strain_xx strain_yy damagedVolumetricStrain'
    function = 'if(strain_xx + strain_yy > ${damage_threshold},strain_xx + strain_yy,if(damagedVolumetricStrain>0,1,0))'
    outputs = exodus
  [../]
  ### DEVIATORIC STRAIN
  [./mat_damage_criteria_devStrain]
    type = ParsedMaterial
    f_name = damageCriteria_deviatoricStrain
    args = 'strain_xx strain_yy damagedDeviatoricStrain'
    function = 'if(strain_yy - strain_xx > ${damage_threshold},strain_yy - strain_xx,if(damagedDeviatoricStrain>0,1,0))'
    outputs = exodus
  [../]
  ### HOEK BROWN
  [./mat_damage_criteria_HB]
   type = ParsedMaterial
   f_name = damageCriteria_HB
   args = 'min_principal_stress max_principal_stress damagedHB'
   function = 'if(-min_principal_stress > -max_principal_stress+(-max_principal_stress*${HBM}*${HBSigmaC}+${HBSigmaC}^2)^(0.5),1,
   if(damagedHB>0,1,0))'
   outputs = exodus
  [../]
  ### MOGI
  [./mat_damage_criteria_mogi]
   type = ParsedMaterial
   f_name = damageCriteria_mogi
   args = 'min_principal_stress max_principal_stress damagedMogi'
   function = 'if(-min_principal_stress > 192.0 - max_principal_stress*11.3,1,if(damagedMogi>0,1,0))'
   outputs = exodus
   ### 14.6+0.79*(sigma_1+sigma_2)/2
  [../]
  ### DAMAGE
  [./mat_damage_criteria_main]
   type = ParsedMaterial
   f_name = damageCriteria_main
   args = 'min_principal_stress max_principal_stress damagedMain'
   function = 'if(damagedMain>0.1,damagedMain,
   if(-min_principal_stress > -max_principal_stress+( -max_principal_stress*${HBM}*${HBSigmaC}+${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,5,4),
   if(-min_principal_stress > -max_principal_stress+(0.11*${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,
   if(min_principal_stress/max_principal_stress > 8.0,3,if(damagedMain>0,damagedMain,0)),2),
   if(max_principal_stress > ${tensileStrength},1,if(damagedMain>0,damagedMain,0)))))'
   outputs = exodus
  [../]
  [./mat_damage_criteria_mainEight]
   type = ParsedMaterial
   f_name = damageCriteria_mainEight
   args = 'min_principal_stress max_principal_stress damagedMainEight'
   function = 'if(damagedMainEight>0.1,damagedMainEight,
   if(-min_principal_stress > -max_principal_stress+( -max_principal_stress*${HBM}*${HBSigmaC}+${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,5,4),
   if(-min_principal_stress > -max_principal_stress+(0.11*${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,
   if(min_principal_stress/max_principal_stress > 14.0,3,if(damagedMainEight>0,damagedMainEight,0)),2),
   if(max_principal_stress > ${tensileStrength},1,if(damagedMainEight>0,damagedMainEight,0)))))'
   outputs = exodus
  [../]
  [./mat_damage_criteria_mainFourteen]
   type = ParsedMaterial
   f_name = damageCriteria_mainFourteen
   args = 'min_principal_stress max_principal_stress damagedMainFourteen'
   function = 'if(damagedMainFourteen>0.1,damagedMainFourteen,
   if(-min_principal_stress > -max_principal_stress+( -max_principal_stress*${HBM}*${HBSigmaC}+${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,5,4),
   if(-min_principal_stress > -max_principal_stress+(0.11*${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,
   if(min_principal_stress/max_principal_stress > 14.0,3,if(damagedMainFourteen>0,damagedMainFourteen,0)),2),
   if(max_principal_stress > ${tensileStrength},1,if(damagedMainFourteen>0,damagedMainFourteen,0)))))'
   outputs = exodus
  [../]
  [./mat_damage_criteria_mainTwenty]
   type = ParsedMaterial
   f_name = damageCriteria_mainTwenty
   args = 'min_principal_stress max_principal_stress damagedMainTwenty'
   function = 'if(damagedMainTwenty>0.1,damagedMainTwenty,
   if(-min_principal_stress > -max_principal_stress+( -max_principal_stress*${HBM}*${HBSigmaC}+${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,5,4),
   if(-min_principal_stress > -max_principal_stress+(0.11*${HBSigmaC}^2)^(0.5),
   if(-max_principal_stress > 0.0,
   if(min_principal_stress/max_principal_stress > 20.0,3,if(damagedMainTwenty>0,damagedMainTwenty,0)),2),
   if(max_principal_stress > ${tensileStrength},1,if(damagedMainTwenty>0,damagedMainTwenty,0)))))'
   outputs = exodus
  [../]
  [./mat_damage_criteria_tensile]
   type = ParsedMaterial
   f_name = damageCriteria_tensile
   args = 'min_principal_stress max_principal_stress damagedTensile'
   function = 'if(damagedTensile>0,damagedTensile,if(max_principal_stress > ${tensileStrength},max_principal_stress,0) )'
   outputs = exodus
  [../]
  [./mat_damage_criteria_spallingEight]
   type = ParsedMaterial
   f_name = damageCriteria_spallingEight
   args = 'min_principal_stress max_principal_stress damagedSpallingEight'
   function = 'if( min_principal_stress/max_principal_stress > 8.0, min_principal_stress/max_principal_stress,0)'
   outputs = exodus
  [../]
  [./mat_damage_criteria_spallingFourteen]
   type = ParsedMaterial
   f_name = damageCriteria_spallingFourteen
   args = 'min_principal_stress max_principal_stress damagedSpallingFourteen'
   function = 'if( min_principal_stress/max_principal_stress > 14.0, min_principal_stress/max_principal_stress,0)'
   outputs = exodus
  [../]
  [./mat_damage_criteria_spallingTwenty]
   type = ParsedMaterial
   f_name = damageCriteria_spallingTwenty
   args = 'min_principal_stress max_principal_stress damagedSpallingTwenty'
   function = 'if( min_principal_stress/max_principal_stress > 20.0, min_principal_stress/max_principal_stress,0)'
   outputs = exodus
  [../]
[]


#[Adaptivity]
#  marker = errorfrac
#  steps = 1
#  max_h_level = 4
#  initial_steps = 3
#  initial_marker = initial_box
#  [./Indicators]
#    [./error]
#      type = GradientJumpIndicator
#      variable = T
#    [../]
#  [../]
#  [./Markers]
#    [./errorfrac]
#      type = ValueThresholdMarker
#      refine = 300.0
#      coarsen = 0.1
#      variable = T
#      indicator = error
#    [../]
#    [./initial_box]
#      bottom_left = '-0.1 0.225 0'
#      inside = refine
#      top_right = '0.1 0.325 0'
#      outside = dont_mark
#      type = BoxMarker
#    [../]
#  [../]
#[]


# [VectorPostprocessors]
#   [./element_damagedMain]
#     type = ElementValueSampler
#     variable = 'damagedMain'
#     sort_by = id
#     execute_on = 'timestep_end'
#   [../]
# [../]


[Postprocessors]
  [./element_damaged1Area]
    type = ElementIntegralVariablePostprocessor
    variable = damagedOne
    execute_on = 'timestep_end'
  [../]
  [./element_damaged2Area]
    type = ElementIntegralVariablePostprocessor
    variable = damagedTwo
    execute_on = 'timestep_end'
  [../]
  [./element_damaged3Area]
    type = ElementIntegralVariablePostprocessor
    variable = damagedThree
    execute_on = 'timestep_end'
  [../]
  [./element_damaged4Area]
    type = ElementIntegralVariablePostprocessor
    variable = damagedFour
    execute_on = 'timestep_end'
  [../]
  [./element_damaged5Area]
    type = ElementIntegralVariablePostprocessor
    variable = damagedFive
    execute_on = 'timestep_end'
  [../]
[]


[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]


[Executioner]
  type = Transient
  solve_type = NEWTON

  petsc_options = ksp_monitor
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu mumps'

  nl_rel_tol = 1e-5
  nl_abs_tol = 1E-10

  dt = 0.2
  start_time = -1
  end_time = 10.0
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  csv = true
  exodus = true
  execute_on = 'timestep_end'
  interval = 2
  perf_graph = true
  file_base = ./lacDuBonnetHomogenizedGranodioriteEberhardEtAl1999_depth100m
[]
