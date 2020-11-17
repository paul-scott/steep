within examples;

model PhysicalParticleCO21D_1stApproach_MultiTower
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  import Modelica.Math;
  import metadata = SolarTherm.Utilities.Metadata_Optics;
  extends SolarTherm.Media.CO2.PropCO2;
  extends Modelica.Icons.Example;
  parameter Boolean pri_field_wspd_max = true "using wspd_max dependent cost";
  parameter Boolean match_sam_cost = true "tower cost is evaluated to match SAM";
  parameter Boolean detail_field_om = false "true if want to use detail washing and field O&M cost";
  parameter Boolean const_dispatch = true "Constant dispatch of energy";
  parameter Boolean new_storage_calc = true;
  // *********************
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph "Medium props for sCO2";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
  // Weather data
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab");
  parameter Real wdelay[8] = {1800, 1800, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = -116.800 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = 34.850 "Lati1tude (+ve North)";
  parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  // Field, heliostat and tower
  parameter String opt_file_1(fixed = false);
  parameter String opt_file_2(fixed = false);
  parameter String casefolder_1 = "./optics_1";
  parameter String casefolder_2 = "./optics_2";
  parameter Real metadata_list[8] = metadata(opt_file_1);
  parameter Real metadata_list_2[8] = metadata(opt_file_2);
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter String field_type = "polar" "Other options are : surround";
  parameter Real land_mult = 0 "Land area multiplier : will be calculated from Solstice";
  parameter SI.Area A_helio = 144.35 "Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the locus of minimum heliostat cost Fig 8.";
  parameter SI.Length W_helio = sqrt(A_helio) "width of heliostat in m";
  parameter SI.Length H_helio = sqrt(A_helio) "height of heliostat in m";
  parameter SI.Efficiency rho_helio = 0.95 "reflectivity of heliostat max =1, min 0.94";
  parameter SI.Angle slope_error = 2e-3 "slope error of the heliostat in mrad";
  parameter SI.Length H_tower = 200 "Tower height";
  parameter SI.Length R_tower = W_rcv_1 / 2 "Tower radius";
  parameter SI.Length R1 = 80 "distance between the first row heliostat and the tower";
  parameter Real fb = 0.6 "factor to grow the field layout";
  parameter Boolean single_field = true "True for single field, false for multi tower";
  parameter Boolean concrete_tower = true "True for concrete, false for thrust tower";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter SI.Efficiency eff_opt = 0.5454 "Field optical efficiency at design point";
  parameter Real gnd_cvge = 0.3126 "Ground coverage";
  parameter Real excl_fac = 0.97 "Exclusion factor";
  parameter Boolean match_gen3_report_cost = false "PB, receiver+tower cost sub system are evaluated using gen3_cost";
  parameter SI.ThermalInsulance U_value = 0.25 "Desired U_value for the tanks";
  //Design Condition
  parameter String rcv_type = "particle" "other options are : flat, cylindrical, stl";
  parameter SI.Area A_rcv_1(fixed = false) "Receiver aperture area CR= 1200 with DNI_des";
  parameter SI.Area A_rcv_2(fixed = false) "Receiver aperture area CR= 1200 with DNI_des";
  parameter nSI.Angle_deg tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
  parameter Real SM = 2.5 "Solar multiple";
  parameter SI.Power P_net = 100e6 "Power block net rating at design point";
  parameter SI.Power P_gross = P_net / (1 - par_fr) "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";
  parameter SI.Temperature T_in_ref_blk = from_degC(800) "Particle inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_in_rec = from_degC(580.3) "Particle inlet temperature to particle receiver at design";
  parameter SI.Irradiance dni_des = 950 "DNI at design point Equinox";
  parameter SI.Efficiency eta_rcv_assumption = 0.88;
  parameter Real CR = 1200 "Concentration ratio";
  parameter Real n_helios_1 = metadata_list[1] "Number of heliostats";
  parameter Real n_helios_2 = metadata_list_2[1] "Number of heliostats";
  parameter SI.Efficiency eta_opt_des = eff_opt;
  parameter SI.Temperature T_amb_des = from_degC(25) "Design point ambient temp";
  parameter Real alpha_rcv = 1;
  parameter Integer n_H_rcv = 20 "discretization of the height axis of the receiver";
  parameter Integer n_W_rcv = 1 "discretization of the width axis of the receiver";
  parameter SI.HeatFlowRate Q_in_rcv = P_gross / eff_blk / eta_rcv_assumption * SM;
  parameter SI.HeatFlowRate Q_in_rcv_1 = Q_in_rcv / 2;
  parameter SI.HeatFlowRate Q_in_rcv_2 = Q_in_rcv / 2;
  parameter SI.Area A_field = metadata_list[1] * metadata_list[2] "Heliostat field reflective area";
  parameter SI.Area A_field_2 = metadata_list_2[1] * metadata_list_2[2] "Heliostat field reflective area";
  parameter Real A_land = metadata_list[8];
  parameter Real A_land_2 = metadata_list_2[8];
  parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";
  parameter SI.Velocity Wspd_max = 15.65 if use_wind "Wind stow speed DOE suggestionn";
  parameter SI.Efficiency packing_factor = 0.747857 "New High-Density Packings of Similarly Sized Binary SpheresPatrick I. O’Toole and Toby S. Hudson*  https://pubs.acs.org/doi/pdf/10.1021/jp206115p";
  //Optical simulation parameters
  parameter Integer n_rays = 10000 "number of rays for solstice";
  parameter Integer n_procs = 1 "number of processors in soltice";
  //Output of the optical simulation
  parameter Real n_row_oelt = 5 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "number of columns of the lookup table (simulated hours per day)";
  // Receiver
  parameter Real ar_rec = 1 "Height to diameter aspect ratio of receiver aperture";
  parameter SI.Efficiency em_curtain = 0.86 "Emissivity of curtain";
  parameter SI.Efficiency ab_curtain = 0.98 "Absorptivity of curtain";
  parameter Real em_particle = 0.86 "Emissivity of particles";
  parameter Real ab_particle = 0.9 "Absorptivity of curtain";
  parameter SI.CoefficientOfHeatTransfer h_th_rec = 100 "Receiver heat tranfer coefficient";
  //parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false) "Input power to receiver at design point";
  parameter Real rec_fr_1(fixed = false) "Receiver loss fraction of radiance at design point";
  parameter Real rec_fr_2(fixed = false) "Receiver loss fraction of radiance at design point";
  inner parameter SI.Efficiency eta_rec_th_des_1 = 1 - rec_fr_1 "PG Receiver thermal efficiency (Q_pcl / Q_sol)";
  inner parameter SI.Efficiency eta_rec_th_des_2 = 1 - rec_fr_2 "PG Receiver thermal efficiency (Q_pcl / Q_sol)";
  parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real f_loss = 0.000001 "Fraction of particles flow lost in receiver";
  //inner parameter SI.Efficiency eta_rec_th_des = 0.8568 "PG Receiver thermal efficiency (Q_pcl / Q_sol)";
  // Storage
  parameter Real t_storage(unit = "h") = 14 "Hours of storage";
  parameter Real NS_particle = 0.05 "Fraction of additional non-storage particles";
  parameter SI.Temperature T_cold_set = from_degC(550) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = CV.from_degC(800) "Hot tank target temperature";
  parameter SI.Temperature T_cold_start = T_cold_set "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = CV.from_degC(800) "Hot tank starting temperature";
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(500) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(700) "Hot tank auxiliary heater set-point temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold partilces thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot partilces thermodynamic state at design";
  parameter Real tnk_frs = 0.01 "Tank loss fraction of tank in one day at design point";
  parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
  //parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Real split_cold = (100 - hot_tnk_empty_ub + 1) / 100 "Starting medium fraction in cold tank, must be the function of the upper bound trigger level of the hot tank so the simulation wont crash at t=0, since the control logic use t_on - t_start etc. PG";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  parameter SI.Power W_heater_hot = 0 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 0 "Cold tank heater capacity";
  parameter Real tank_ar = 2 "storage aspect ratio";
  // Particle heat exchanger
  parameter SI.CoefficientOfHeatTransfer U_hx = 450 "Particle heat tranfer coefficient of the particle heat exchanger";
  parameter SI.Temperature dT_approach_hx = 15 "Particle heat exchanger approach temperature";
  // Power block
  parameter Real f_fixed_load = 0.0055 "Fixed load constantly consumed by PB when it operates";
  parameter SI.Temperature T_comp_in = 318.15 "Compressor inlet temperature at design";
  parameter SI.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
  parameter SI.ThermodynamicTemperature T_high = 700 + 273.15 "inlet temperature of the turbine";
  parameter Real PR = 25 / 9.17 "Pressure ratio";
  parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
  // main Compressor parameters
  parameter SI.Efficiency eta_comp_main = 0.89 "Maximal isentropic efficiency of the compressors";
  // reCompressor parameters
  parameter SI.Efficiency eta_comp_re = 0.89 "Maximal isentropic efficiency of the compressors";
  //Turbine parameters
  parameter SI.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
  //HTR Heat recuperator parameters use_detail_pri_field
  parameter Integer N_HTR = 15;
  //LTR Heat recuperator parameters
  parameter Integer N_LTR_parameter = 2 "PG";
  //Cooler parameters
  parameter SI.ThermodynamicTemperature T_low = 41 + 273.15 "Inlet temperature of the compressor";
  //Exchanger parameters
  parameter SI.Temperature T_out_ref_blk = T_cold_set "Particle outlet temperature from particle heat exchanger at design";
  parameter SI.Temperature T_in_ref_co2 = CV.from_degC(565.3) "CO2 inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_co2 = T_high "CO2 outlet temperature from particle heat exchanger at design";
  parameter Integer N_exch_parameter = 2 "PG";
  parameter Real par_fix_fr = 0 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "True if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = false "True if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  parameter Medium.ThermodynamicState state_co2_in_set = MedPB.setState_pTX(p_high, T_in_ref_co2) "Cold CO2 thermodynamic state at design";
  parameter Medium.ThermodynamicState state_co2_out_set = MedPB.setState_pTX(p_high, T_out_ref_co2) "Hot CO2 thermodynamic state at design";
  // Lifts
  parameter SI.Height dh_liftRC = H_tower "Vertical displacement in receiver lift";
  parameter SI.Height dh_liftHX = 10 "Vertical displacement in heat exchanger lift";
  parameter SI.Height dh_LiftCold = H_storage "Vertical displacement in cold storage lift";
  parameter SI.Efficiency eff_lift = 0.8 "Lift total efficiency";
  // Control
  parameter SI.Angle ele_min = 0.0872665 "Heliostat stow deploy angle = 5 degree";
  parameter Boolean use_wind = true "True if using wind stopping strategy in the solar field";
  parameter SI.HeatFlowRate Q_flow_defocus_1 = Q_flow_des / (1 - rec_fr_1) "Solar field thermal power at defocused state";
  parameter SI.HeatFlowRate Q_flow_defocus_2 = Q_flow_des / (1 - rec_fr_2) "Solar field thermal power at defocused state";
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which)s to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank trigger to start dispatching";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 93 "Hot tank full trigger lower bound";
  parameter Real hot_tnk_full_ub = 95 "Hot tank full trigger upper bound";
  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real cold_tnk_crit_lb = 1 "Cold tank critically empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  parameter Real Kp = -575 "Gain of proportional component in receiver control";
  // Calculated Parameters
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Heat to power block at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter SI.Length H_rcv_1 = sqrt(A_rcv_1 * ar_rec) "Receiver 1 aperture height";
  parameter SI.Length H_rcv_2 = sqrt(A_rcv_2 * ar_rec) "Receiver 2 aperture height";
  parameter SI.Length W_rcv_1 = A_rcv_1 / H_rcv_1 "Receiver 1 aperture width";
  parameter SI.Length W_rcv_2 = A_rcv_2 / H_rcv_2 "Receiver 2 aperture width";
  parameter SI.Length L_rcv = 1 "Receiver 1 and 2 length(depth)";
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_in_set = MedPB.specificEnthalpy(state_co2_in_set) "Cold CO2 specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_out_set = MedPB.specificEnthalpy(state_co2_out_set) "Hot CO2 specific enthalpy at design";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold particles density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot particles density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max particles mass in tanks";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) / packing_factor "Volume needed to host particles in the tank with certain packing factor value";
  parameter SI.MassFlowRate m_flow_fac_1(fixed = false);
  parameter SI.MassFlowRate m_flow_fac_2(fixed = false);
  parameter SI.MassFlowRate m_flow_rec_min = 0 "Minimum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_max_1 = 1.3 * m_flow_fac_1 "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_max_2 = 1.3 * m_flow_fac_2 "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start_1 = 0.8 * m_flow_fac_1 "Initial https://pubs.acs.org/doi/pdf/10.1021/jp206115por guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_rec_start_2 = 0.8 * m_flow_fac_2 "Initial https://pubs.acs.org/doi/pdf/10.1021/jp206115por guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_blk(fixed = false);
  // = Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank height";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter SI.Area SA_storage = CN.pi * D_storage * H_storage "Storage tank surface area";
  // Cost data in USD (default) or AUD
  parameter Real r_disc = (1 + 0.0701) / (1 + r_i) - 1;
  //(1 + 0.0701) / (1 + r_i) - 1 "Real discount rate";
  parameter Real r_i = 0.025 "Inflation rate";
  parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 2 "Years of construction";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real r_contg = 0.1 "Contingency rate";
  parameter Real r_indirect = 0.13 "Indirect capital costs rate";
  parameter Real r_cons = 0.06 "Construction cost rate";
  parameter FI.AreaPrice pri_field = if pri_field_wspd_max == true then if currency == Currency.USD then FI.heliostat_specific_cost_w_spd(Wspd_max = Wspd_max, A_helio = A_helio) * 0.3716 else FI.heliostat_specific_cost_w_spd(Wspd_max = Wspd_max, A_helio = A_helio) * 0.3716 / r_cur else if currency == Currency.USD then 75 else 75 / r_cur " Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the Fig 8.....75 is taken from Gen3 Roadmap Report";
  parameter FI.AreaPrice pri_site = if currency == Currency.USD then 10 else 10 / r_cur "Site improvements cost per area";
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
  parameter FI.Money pri_tower = if currency == Currency.USD then 157.44 else 157.44 / r_cur "Fixed tower cost";
  parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";
  parameter Real pri_lift = if currency == Currency.USD then 58.37 else 58.37 / r_cur "Lift cost per rated mass flow per height";
  parameter FI.AreaPrice pri_receiver = if match_gen3_report_cost then if currency == Currency.USD then 150 else 150 / r_cur else if currency == Currency.USD then 37400 else 37400 / r_cur "Falling particle receiver cost per design aperture area";
  parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 17.70 / (1e3 * 3600) else 17.70 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
  parameter FI.MassPrice pri_particle = 1.0 "Unit cost of particles per kg";
  parameter Real pri_bin = 1000 "bin specific cost";
  parameter Real pri_bin_linear = 0.3;
  parameter Real pri_bin_multiplier = 1.23;
  //PB specific cost & eta motor
  parameter Real pri_recuperator = 5.2;
  parameter Real pri_turbine = 9923.7;
  parameter Real pri_compressor = 643.15;
  parameter Real pri_cooler = 76.25;
  parameter Real pri_generator = 108900;
  parameter SI.Efficiency eta_motor = 0.9 "electrical generator efficiency";
  parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles  --> value from v.9 EES sandia result c_hx";
  //Heliostat tstart
  parameter SI.Time t_start = 3600 "Start-up traking delay";
  //Receiver convection coefficient
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "Convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  parameter FI.PowerPrice pri_hx = if currency == Currency.USD then 175.90 / 1e3 else 175.90 / 1e3 / r_cur "Heat exchnager cost per energy capacity";
  //parameter FI.PowerPrice pri_bop = if currency==Currency.USD then 340 / 1e3 else (340 / 1e3)/r_cur "Balance of plant cost per gross rated power"; // Based on downselection criteria criteria
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 102 / 1e3 else 102 / 1e3 / r_cur "USD/We Balance of plant cost per gross rated power";
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 900 else 900 / r_cur "sCO2 PB cost per kWe based on the G3P3 Roadmap Report";
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 0.003 / (1e6 * 3600) else 0.003 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
  //Solar Field Sub-System Cost see PARAMETRIC ANALYSIS OF PARTICLE https://pubs.acs.org/doi/pdf/10.1021/jp206115p CSP SYSTEM PERFORMANCE AND COSTTO INTRINSIC PARTICLE PROPERTIES AND OPERATING CONDITIONS (Albrecht et al)
  // Washing cost and parameters
  // Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 138 Table 1
  parameter Real C1 = 98 " % cleanliness of the mirror after 1 cleaning pass for method 1";
  parameter Real C2 = 96.5 " % cleanliness of the mirror after 1 cleaning pass for method 2";
  parameter Real C_target = rho_helio * 100 "annual reflectivity target";
  parameter Real R_soil = 0.49 "% reflectivity loss from the design reflectivity due to soiling";
  parameter Real P_w = 12 "Month(s) in a year that the cleaning will be conducted";
  parameter Real omega_n = 1.5 "Natural washing frequency (rain, snow, etc)";
  parameter Real omega_twister(fixed = false) "Supplementary washing (with machine) frequency per year";
  parameter Real pri_washing_deluge_method = 0.0027 * 1.3 "USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real pri_washing_twister_method = 0.0076 * 1.3 "USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real omega_deluge = 2 * omega_twister "this approach uses KJC cleaning method (1 Twister and 2 Deluge truck in between";
  // Field OnM specific cost
  // Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 121 Table A-8
  parameter Real pri_om_field = 52.8815449319 * A_helio ^ (-1.0359277351) "O&M field based on number of heliostat in USD / unit. The price is multiplied by 1.5 to conver it to USD 2020 from USD 2000";
  // Cost calculation
  parameter FI.Money C_washing = (omega_twister * pri_washing_twister_method + omega_deluge * pri_washing_deluge_method) * A_field "Washing cost [USD/year]";
  parameter FI.Money C_om_field = pri_om_field * A_field "OnM field exclude washing cost [USD/year]";
  parameter FI.Money C_field = A_field * pri_field + A_field_2 * pri_field "Field cost";
  parameter FI.Money C_site = A_field * pri_site + A_field_2 * pri_site "Site improvements cost";
  parameter FI.Money C_land = A_land * pri_land + A_land_2 * pri_land "Land cost";
  parameter FI.Money C_field_total = C_field + C_site "Heliostat field plus site preparation costs";
  //Receiver Sub-system Cost
  parameter FI.Money C_tower = if match_gen3_report_cost then 0 elseif match_sam_cost then 3 * 10 ^ 6 * Modelica.Math.exp(0.0113 * (H_tower + 0.5 * H_helio - H_rcv_1 / 2)) else pri_tower * H_tower ^ idx_pri_tower "Tower cost. SAM cost function is based on DELSOL3 report 1986 but the constants value has been updated according to SAM 2018.11.11";
  parameter FI.Money C_fpr = if match_gen3_report_cost then 0 else pri_receiver * A_rcv_1 + pri_receiver * A_rcv_2 "Falling particle receiver cost";
  parameter FI.Money C_lift_rec = if match_gen3_report_cost then 0 else pri_lift * dh_liftRC * m_flow_fac_1 + pri_lift * dh_liftRC * m_flow_fac_2 "Receiver lift cost";
  parameter FI.Money C_receiver = if match_gen3_report_cost then Q_flow_des * 0.150 else C_fpr + C_tower + C_lift_rec "Total receiver cost";
  //Storage Sub-system cost
  parameter FI.Money C_lift_cold = pri_lift * dh_LiftCold * m_flow_blk "Cold storage tank lift cost";
  parameter FI.Money C_bins = if new_storage_calc then 750 * CN.pi * (D_storage + t_mp + t_tuffcrete47) * H_storage else pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_hot_set - 600) / 400) * SA_storage + pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_cold_set - 600) / 400) * SA_storage "Cost of cold and hot storage bins without insulation, 750 is taken from the email from jeremy stent by Philipe Gunawan";
  parameter FI.Money C_insulation = if U_value == 0 then 0 else 2 * SA_storage * (131.0426 / U_value + 23.18);
  //(131.0426 / U_value + 23.18) ======> cost function insulation of Tuffcrete, Microporous and Concrete
  //(873.11/U_value) - 322.202 ======> cost function insulation of Tuffcrete, Pumplite60 and Concrete
  parameter SI.Length t_mp = 0.32368 / U_value - 0.146096;
  //0.03293006 / U_value + 0.01518 =====> thickness function of Pumplite60;
  //0.32368 / U_value - 0.146096   =====> thickness function of Microporous;
  parameter SI.Length t_tuffcrete47 = 0.01;
  parameter FI.Money C_particles = (1 + NS_particle) * pri_particle * m_max "Cost of particles";
  parameter FI.Money C_storage = C_bins + C_particles + C_lift_hx + C_lift_cold + C_insulation + f_loss * t_life * pri_particle * 1.753e10 "Total storage cost";
  //PB-subsystem cost
  parameter FI.Money C_hx = Q_flow_des * pri_hx "Heat exchanger cost";
  parameter FI.Money C_bop = P_gross * pri_bop "Balance of plant cost";
  parameter FI.Money C_lift_hx = pri_lift * dh_liftHX * m_flow_blk "Heat exchanger lift cost";
  parameter FI.Money C_block(fixed = false) "Power block cost";
  parameter FI.Money C_cap_total(fixed = false) "equipment cost";
  parameter FI.Money C_direct(fixed = false) "Direct capital costs";
  parameter FI.Money C_indirect(fixed = false) "Indirect capital costs";
  parameter FI.Money C_cap(fixed = false) "Capital costs";
  parameter FI.MoneyPerYear C_year = if detail_field_om then P_name * pri_om_name + C_om_field + C_washing else P_name * pri_om_name "Fixed O&M cost per year + OnM field + Cost of washing the field";
  parameter FI.Money C_prod = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-144, -60}, {-114, -32}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(origin = {-127, 70}, extent = {{-13, -10}, {13, 10}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {139, 80}, extent = {{19, -10}, {-19, 10}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  // Wind dir
  Modelica.Blocks.Sources.BooleanExpression always_on(y = true) annotation(
    Placement(visible = true, transformation(origin = {-128, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wind_dir(y = data.Wdir) annotation(
    Placement(visible = true, transformation(origin = {-129, 51}, extent = {{-11, -13}, {11, 13}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(transformation(extent = {{76, 18}, {56, 38}})));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {105, 59}, extent = {{-12, -8}, {12, 8}}, rotation = -90)));
  // Or block for defocusing
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(extent = {{-102, 4}, {-94, 12}})));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolstice_1stApproach heliostatsField(lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, t_start = t_start, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_helio, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus_1, nu_start = nu_start, Q_in_rcv = Q_in_rcv_1, H_rcv = H_rcv_1, W_rcv = W_rcv_1, tilt_rcv = tilt_rcv, W_helio = W_helio, H_helio = H_helio, H_tower = H_tower, R_tower = R_tower, R1 = R1, fb = fb, rho_helio = rho_helio, slope_error = slope_error, n_row_oelt = n_row_oelt, n_col_oelt = n_col_oelt, psave = casefolder_1, wea_file = wea_file) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolstice_1stApproach heliostatsField2(lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, t_start = t_start, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_helio, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus_2, nu_start = nu_start, Q_in_rcv = Q_in_rcv_2, H_rcv = H_rcv_2, W_rcv = W_rcv_2, tilt_rcv = tilt_rcv, W_helio = W_helio, H_helio = H_helio, H_tower = H_tower, R_tower = R_tower, R1 = R1, fb = fb, rho_helio = rho_helio, slope_error = slope_error, n_row_oelt = n_row_oelt, n_col_oelt = n_col_oelt, psave = casefolder_2, wea_file = wea_file) annotation(
    Placement(visible = true, transformation(origin = {-72, -80}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Washing calculator
  SolarTherm.Models.CSP.CRS.HeliostatsField.WashingFrequencyCalculator washingFrequencyCalculator(C_tw = C1, C_dl = C2, R_soil = R_soil, P_w = P_w, omega_n = omega_n, C_target = C_target) annotation(
    Placement(visible = true, transformation(origin = {-130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Receivers
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D(H_drop_design = H_rcv_1, N = 20, fixed_cp = false, test_mode = false, with_detail_h_ambient = false, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, h_conv_curtain = h_conv_curtain, h_conv_backwall = h_conv_backwall) annotation(
    Placement(visible = true, transformation(origin = {-35, 33}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_2(H_drop_design = H_rcv_2, N = 20, fixed_cp = false, test_mode = false, with_detail_h_ambient = false, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, h_conv_curtain = h_conv_curtain, h_conv_backwall = h_conv_backwall) annotation(
    Placement(visible = true, transformation(origin = {-26, -76}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator(Q_in = Q_in_rcv_1, T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des, CR = CR, dni_des = dni_des, eta_opt_des = eta_opt_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain) annotation(
    Placement(visible = true, transformation(origin = {150, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator_2(Q_in = Q_in_rcv_2, T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des, CR = CR, dni_des = dni_des, eta_opt_des = eta_opt_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain) annotation(
    Placement(visible = true, transformation(origin = {150, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Receiver control
  SolarTherm.Models.Control.SimpleReceiverControl simpleReceiverControl(T_ref = T_hot_set, m_flow_min = m_flow_rec_min, m_flow_max = m_flow_rec_max_1, y_start = m_flow_rec_start_1, L_df_on = cold_tnk_defocus_lb, L_df_off = cold_tnk_defocus_ub, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, eta_rec_th_des = eta_rec_th_des_1) annotation(
    Placement(visible = true, transformation(origin = {22, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.SimpleReceiverControl simpleReceiverControl2(T_ref = T_hot_set, m_flow_min = m_flow_rec_min, m_flow_max = m_flow_rec_max_2, y_start = m_flow_rec_start_2, L_df_on = cold_tnk_defocus_lb, L_df_off = cold_tnk_defocus_ub, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, eta_rec_th_des = eta_rec_th_des_2) annotation(
    Placement(visible = true, transformation(origin = {20, -86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_hot_start, L_start = (1 - split_cold) * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_hot, T_set = T_hot_aux_set, U_value = U_value) annotation(
    Placement(transformation(extent = {{16, 54}, {36, 74}})));
  // Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_cold_start, L_start = split_cold * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_cold, T_set = T_cold_aux_set, U_value = U_value) annotation(
    Placement(transformation(extent = {{64, -28}, {44, -8}})));
  // Receiver lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftRC(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftRC, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {-1, -27}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple LiftRC2(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftRC, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {1, -115}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  // Heat exchanger lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftHX(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftHX, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {76, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Cold storage tank lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple LiftCold(redeclare package Medium = Medium, cont_m_flow = false, use_input = false, dh = dh_LiftCold, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {70, -114}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  // PowerBlockControl
  SolarTherm.Models.Control.PowerBlockControl controlHot(m_flow_on = m_flow_blk, L_on = hot_tnk_empty_ub, L_off = hot_tnk_empty_lb, L_df_on = hot_tnk_full_ub, L_df_off = hot_tnk_full_lb) annotation(
    Placement(transformation(extent = {{48, 72}, {60, 58}})));
  // Power block
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerBlock(redeclare package MedRec = Medium, P_gro = P_gross, P_nom = P_net, T_HTF_in_des = T_in_ref_blk, T_amb_des = blk_T_amb_des, T_low = T_comp_in, external_parasities = false, nu_min = nu_min_blk, N_exch = N_exch_parameter "PG", N_LTR = N_LTR_parameter, f_fixed_load = f_fixed_load, PR = PR, pri_recuperator = pri_recuperator, pri_turbine = pri_turbine, pri_compressor = pri_compressor, pri_cooler = pri_cooler, pri_generator = pri_generator, pri_exchanger = pri_exchanger, eta_motor = eta_motor, T_HTF_out = T_cold_set) annotation(
    Placement(transformation(extent = {{88, 4}, {124, 42}})));
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  // Analytics
  SI.Energy E_resource(start = 0);
  SI.Energy E_resource_after_optical_eff(start = 0);
  SI.Energy E_helio_incident(start = 0);
  SI.Energy E_helio_raw(start = 0);
  SI.Energy E_helio_net(start = 0);
  SI.Energy E_recv_incident(start = 0);
  SI.Energy E_recv_net(start = 0);
  SI.Energy E_pb_input(start = 0);
  SI.Energy E_pb_gross(start = 0);
  SI.Energy E_pb_net(start = 0);
  //Analytics All The Losses
  SI.Energy E_losses_curtailment(start = 0);
  SI.Energy E_losses_availability(start = 0);
  SI.Energy E_losses_optical(start = 0);
  SI.Energy E_losses_defocus(start = 0);
  SI.Energy E_check;
  Real eta_curtail_off(start = 0);
  Real eta_optical(start = 0);
  Real eta_he_av(start = 0);
  Real eta_curtail_defocus(start = 0);
  Real eta_recv_abs(start = 0);
  Real eta_recv_thermal(start = 0);
  Real eta_storage(start = 0);
  Real eta_pb_gross(start = 0);
  Real eta_pb_net(start = 0);
  Real eta_solartoelec(start = 0);
algorithm
  if time > 31449600 then
    eta_curtail_off := E_helio_incident / E_resource;
    eta_optical := E_resource_after_optical_eff / E_resource;
    eta_he_av := he_av_design;
    eta_curtail_defocus := E_helio_net / E_helio_raw;
    eta_recv_abs := E_recv_incident / E_helio_net;
    eta_recv_thermal := E_recv_net / E_recv_incident;
    eta_storage := E_pb_input / E_recv_net;
    eta_pb_gross := E_pb_gross / E_pb_input;
    eta_pb_net := E_pb_net / E_pb_input;
    eta_solartoelec := E_pb_net / E_resource;
    E_check := E_resource - E_losses_availability - E_losses_curtailment - E_losses_defocus - E_losses_optical - E_helio_net;
  end if;
initial equation
  opt_file_1 = heliostatsField.optical.tablefile;
  opt_file_2 = heliostatsField2.optical.tablefile;
  omega_twister = ceil(washingFrequencyCalculator.omega);
  m_flow_blk = powerBlock.m_HTF_des;
  A_rcv_1 = particleReceiver1DCalculator.particleReceiver1D.H_drop ^ 2;
  A_rcv_2 = particleReceiver1DCalculator_2.particleReceiver1D.H_drop ^ 2;
  rec_fr_1 = 1 - particleReceiver1DCalculator.particleReceiver1D.eta_rec;
  rec_fr_2 = 1 - particleReceiver1DCalculator_2.particleReceiver1D.eta_rec;
  m_flow_fac_1 = particleReceiver1DCalculator.particleReceiver1D.mdot;
  m_flow_fac_2 = particleReceiver1DCalculator_2.particleReceiver1D.mdot;
  if match_gen3_report_cost then
    C_block = pri_block * P_gross / 1000;
  else
    C_block = powerBlock.C_PB;
  end if;
  C_cap_total = C_field + C_site + C_receiver + C_storage + C_block + C_bop;
  C_direct = (1 + r_contg) * C_cap_total;
  C_indirect = r_cons * C_direct + C_land;
  C_cap = C_direct + C_indirect;
equation
  der(E_resource) = max(sun.dni * n_helios_1 * A_helio + sun.dni * n_helios_2 * A_helio, 0.0);
  der(E_losses_optical) = (1 - heliostatsField.nu) * max(heliostatsField.solar.dni * heliostatsField.n_h * heliostatsField.A_h, 0.0);
  der(E_losses_availability) = (1 - he_av_design) * max(heliostatsField.nu * heliostatsField.solar.dni * heliostatsField.n_h * heliostatsField.A_h, 0.0);
  der(E_losses_curtailment) = if heliostatsField.on_hf == true then 0 else (1 - he_av_design) * max(heliostatsField.nu * heliostatsField.solar.dni * heliostatsField.n_h * heliostatsField.A_h, 0.0);
  der(E_losses_defocus) = if heliostatsField.on_internal then if heliostatsField.defocus_internal then abs(heliostatsField.Q_net - heliostatsField.Q_raw) else 0 else 0;
  der(E_resource_after_optical_eff) = max(sun.dni * n_helios_1 * A_helio + sun.dni * n_helios_2 * A_helio, 0.0) * heliostatsField.nu;
  der(E_helio_incident) = if heliostatsField.on_hf then heliostatsField.n_h * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
  der(E_helio_raw) = heliostatsField.Q_raw;
  der(E_helio_net) = heliostatsField.Q_net;
  der(E_recv_incident) = particleReceiver1D.heat.Q_flow;
  der(E_recv_net) = particleReceiver1D.Qdot_rec;
  if powerBlock.exchanger.m_sup == true then
    der(E_pb_input) = powerBlock.exchanger.Q_HX;
    der(E_pb_gross) = -powerBlock.turbine.W_turb;
  else
    der(E_pb_input) = 0;
    der(E_pb_gross) = 0;
  end if;
  der(E_pb_net) = powerBlock.W_net;
  P_elec = powerBlock.W_net;
  der(E_elec) = P_elec;
  R_spot = market.profit;
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-113, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{55, 28}, {49.5, 28}, {49.5, 20}, {49.5, -8.3}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{55, 28}, {46, 28}, {8, 28}, {8, 78}, {30.5, 78}, {30.5, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{118, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{118, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(tankCold.T_amb, Tamb_input.y) annotation(
    Line(points = {{58.1, -8.3}, {58.1, 20}, {92, 20}, {92, 42}, {118, 42}, {118, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  connect(liftRC.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{5, -25}, {44, -25}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{4, 68}, {9, 68}, {9, 69}, {16, 69}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, liftHX.fluid_a) annotation(
    Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
  connect(liftHX.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, LiftCold.fluid_a) annotation(
    Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -112}, {75, -112}}, color = {0, 127, 255}));
  connect(LiftCold.fluid_b, tankCold.fluid_a) annotation(
    Line(points = {{64, -112}, {64, -13}}, color = {0, 127, 255}));
// controlHot connections
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
  connect(controlHot.m_flow, liftHX.m_flow) annotation(
    Line(points = {{60.72, 65}, {72, 65}, {72, 49.16}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(or1.y, heliostatsField.defocus) annotation(
    Line(points = {{-93.6, 8}, {-92, 8}, {-92, 8.8}, {-87.68, 8.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
//PowerBlock connections
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{105, 46}, {105, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));
  connect(liftRC.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{2, -13}, {2, 42}, {46, 42}, {46, 62}, {48, 62}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(liftRC.fluid_b, particleReceiver1D.fluid_a) annotation(
    Line(points = {{-8, -26}, {-32, -26}, {-32, 18}}, color = {0, 127, 255}));
  connect(temperature.fluid_a, particleReceiver1D.fluid_b) annotation(
    Line(points = {{-16, 68}, {-16, 41}, {-29, 41}}, color = {0, 127, 255}));
  connect(heliostatsField.heat, particleReceiver1D.heat) annotation(
    Line(points = {{-56, 28}, {-52, 28}, {-52, 38}}, color = {191, 0, 0}));
  connect(heliostatsField.on, particleReceiver1D.on) annotation(
    Line(points = {{-72, 2}, {-38, 2}, {-38, 17}}, color = {255, 0, 255}));
  connect(heliostatsField.Q_incident, simpleReceiverControl.Q_in) annotation(
    Line(points = {{-54, 20}, {24, 20}, {24, 10}, {24, 10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankCold.L, simpleReceiverControl.L_mea) annotation(
    Line(points = {{44, -14}, {42, -14}, {42, 0}, {32, 0}, {32, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankCold.T_mea, simpleReceiverControl.T_mea) annotation(
    Line(points = {{42, -18}, {40, -18}, {40, 6}, {34, 6}, {34, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(simpleReceiverControl.defocus, or1.u2) annotation(
    Line(points = {{22, -12}, {22, -12}, {22, -70}, {-104, -70}, {-104, 4}, {-102, 4}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(simpleReceiverControl.m_flow, liftRC.m_flow) annotation(
    Line(points = {{10, 0}, {6, 0}, {6, -12}, {2, -12}, {2, -13}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(heliostatsField.on, simpleReceiverControl.sf_on) annotation(
    Line(points = {{-72, 2}, {-72, -54}, {38, -54}, {38, -6}, {34, -6}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(temperature.T, simpleReceiverControl.T_out_receiver) annotation(
    Line(points = {{-6, 58}, {-6, 58}, {-6, 26}, {22, 26}, {22, 12}, {22, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(always_on.y, heliostatsField.on_hopper) annotation(
    Line(points = {{-116, -4}, {-112, -4}, {-112, 20}, {-88, 20}, {-88, 20}}, color = {255, 0, 255}));
  connect(particleReceiver1D.eta_rec_out, simpleReceiverControl.eta_rec) annotation(
    Line(points = {{-30, 30}, {18, 30}, {18, 12}, {18, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wind_dir.y, particleReceiver1D.Wdir) annotation(
    Line(points = {{-117, 51}, {-38, 51}, {-38, 46}, {-40, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, particleReceiver1D.Tamb) annotation(
    Line(points = {{118, 80}, {-30, 80}, {-30, 46}, {-30, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, particleReceiver1D.Wspd) annotation(
    Line(points = {{-112, 30}, {-100, 30}, {-100, 54}, {-34, 54}, {-34, 46}, {-34, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(controlHot.rampingout, powerBlock.ramping) annotation(
    Line(points = {{60, 68}, {106, 68}, {106, 34}, {106, 34}}, color = {255, 0, 255}));
  connect(sun.solar, heliostatsField2.solar) annotation(
    Line(points = {{-72, 60}, {-72, 60}, {-72, -64}, {-72, -64}}, color = {0, 127, 255}));
  connect(always_on.y, heliostatsField2.on_hopper) annotation(
    Line(points = {{-116, -4}, {-112, -4}, {-112, -80}, {-88, -80}, {-88, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField2.Wspd) annotation(
    Line(points = {{-112, 30}, {-104, 30}, {-104, -70}, {-88, -70}, {-88, -70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(or1.y, heliostatsField2.defocus) annotation(
    Line(points = {{-94, 8}, {-94, 8}, {-94, -90}, {-88, -90}, {-88, -90}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(heliostatsField2.heat, particleReceiver1D_2.heat) annotation(
    Line(points = {{-56, -72}, {-44, -72}, {-44, -70}, {-44, -70}}, color = {191, 0, 0}));
  connect(heliostatsField2.on, particleReceiver1D_2.on) annotation(
    Line(points = {{-72, -96}, {-30, -96}, {-30, -92}, {-30, -92}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(particleReceiver1D_2.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{-20, -68}, {-16, -68}, {-16, 68}, {-16, 68}}, color = {0, 127, 255}));
  connect(Wspd_input.y, particleReceiver1D_2.Wspd) annotation(
    Line(points = {{-112, 30}, {-26, 30}, {-26, -62}, {-26, -62}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wind_dir.y, particleReceiver1D_2.Wdir) annotation(
    Line(points = {{-116, 52}, {-104, 52}, {-104, -56}, {-30, -56}, {-30, -62}, {-30, -62}}, color = {0, 0, 127}, pattern = LinePattern.DashDotDot));
  connect(Tamb_input.y, particleReceiver1D_2.Tamb) annotation(
    Line(points = {{118, 80}, {-22, 80}, {-22, -62}, {-22, -62}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(temperature.T, simpleReceiverControl2.T_out_receiver) annotation(
    Line(points = {{-6, 58}, {-6, -64}, {20, -64}, {20, -75}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(particleReceiver1D_2.eta_rec_out, simpleReceiverControl2.eta_rec) annotation(
    Line(points = {{-20, -80}, {16, -80}, {16, -75}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(LiftRC2.fluid_b, particleReceiver1D_2.fluid_a) annotation(
    Line(points = {{-6, -113}, {-22, -113}, {-22, -92}}, color = {0, 127, 255}));
  connect(LiftRC2.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{7, -113}, {44, -113}, {44, -24}}, color = {0, 127, 255}));
  connect(simpleReceiverControl2.m_flow, LiftRC2.m_flow) annotation(
    Line(points = {{9, -86}, {4, -86}, {4, -101}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(heliostatsField2.Q_incident, simpleReceiverControl2.Q_in) annotation(
    Line(points = {{-54, -80}, {106, -80}, {106, -77}, {32, -77}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(heliostatsField2.on, simpleReceiverControl2.sf_on) annotation(
    Line(points = {{-72, -96}, {-72, -140}, {100, -140}, {100, -92}, {31, -92}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(tankCold.L, simpleReceiverControl2.L_mea) annotation(
    Line(points = {{44, -14}, {32, -14}, {32, -72}, {126, -72}, {126, -86}, {31, -86}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankCold.T_mea, simpleReceiverControl2.T_mea) annotation(
    Line(points = {{42, -18}, {40, -18}, {40, -60}, {112, -60}, {112, -81}, {31, -81}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(origin = {-12, -18}, lineColor = {217, 67, 180}, extent = {{-58, -18}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {4, 30}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {26, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control 1", fontSize = 8, fontName = "CMU Serif"), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-6, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {0, -40}, extent = {{-10, 8}, {10, -8}}, textString = "Lift Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {68, -126}, extent = {{-14, 8}, {14, -8}}, textString = "LiftCold", fontSize = 6, fontName = "CMU Serif"), Text(origin = {85, 59}, extent = {{-19, 11}, {19, -11}}, textString = "LiftHX", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-14, -64}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 2", fontSize = 9), Text(origin = {-18, 34}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 1", fontSize = 9), Text(origin = {142, 138}, extent = {{-58, -18}, {-14, -40}}, textString = "Receiver calculator 2", fontSize = 9), Text(origin = {142, 158}, extent = {{-58, -18}, {-14, -40}}, textString = "Receiver calculator 1", fontSize = 9), Text(origin = {24, -78}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control 2", fontSize = 8, fontName = "CMU Serif"), Text(origin = {-12, -18}, lineColor = {217, 67, 180}, extent = {{-58, -18}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {-14, -64}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 2", fontSize = 9), Text(origin = {-14, -64}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 2", fontSize = 9), Text(origin = {-14, -64}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 2", fontSize = 9), Text(origin = {-18, 34}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 1", fontSize = 9), Text(origin = {-18, 34}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 1", fontSize = 9), Text(origin = {-18, 34}, extent = {{-58, -18}, {-14, -40}}, textString = "Solar Field 1", fontSize = 9)}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 1e-06, Interval = 3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	<li> Philipe Gunawan Gan (Jan 2020) :<br>Released PhysicalParticleCO21D (with 1D particle receiver). </li>
	</ul>

	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end PhysicalParticleCO21D_1stApproach_MultiTower;