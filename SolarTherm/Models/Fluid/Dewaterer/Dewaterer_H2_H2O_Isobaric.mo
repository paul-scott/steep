within SolarTherm.Models.Fluid.Dewaterer;

model Dewaterer_H2_H2O_Isobaric "Total pressure is preserved, this considers possibility of subcooled, mixed and superheated regions for water."
  extends SolarTherm.Icons.Dehumidifier;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  Modelica.Media.Water.WaterIF97_ph.BaseProperties Water_Out "Model for the outlet water properties";
  //final SI.MolarInternalEnergy R = CN.R "Molar gas constant (J/molK)";
  //Fluid Ports
  Modelica.Fluid.Interfaces.FluidPort_a fluid_H2_in(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2) annotation (Placement(
        visible = true,transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(origin = {-94, 64}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
        //Fluid Outlet Ports
  Modelica.Fluid.Interfaces.FluidPort_b fluid_H2_out(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2) annotation (Placement(
        visible = true,transformation(extent = {{-110, -80}, {-90, -60}}, rotation = 0), iconTransformation(origin = {94, 64}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_H2O_in(redeclare package Medium = Modelica.Media.Water.WaterIF97_ph) annotation (Placement(
        visible = true,transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(origin = {-94, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
        //Fluid Outlet Ports
  Modelica.Fluid.Interfaces.FluidPort_b fluid_H2O_gas_out(redeclare package Medium = Modelica.Media.Water.WaterIF97_ph) annotation (Placement(
        visible = true,transformation(extent = {{-110, -80}, {-90, -60}}, rotation = 0), iconTransformation(origin = {94, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_H2O_liq_out(redeclare package Medium = Modelica.Media.Water.WaterIF97_ph) annotation (Placement(
        visible = true,transformation(extent = {{-110, -80}, {-90, -60}}, rotation = 0), iconTransformation(origin = {0, -94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow_removed annotation(
		Placement(visible = true, 
		transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {1, 81}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));


  SI.SpecificEnthalpy h_H2_in "Specific enthalpy of inlet hydrogen gas stream (J/kg)";
  SI.SpecificEnthalpy h_H2O_in "Specific enthalpy of inlet steam stream (J/kg)";
  
  SI.MassFlowRate m_flow_H2_in "Mass flow rate of hydrogen gas stream (kg/s)";
  SI.MassFlowRate m_flow_H2O_in "Mass flow rate of inlet steam stream (kg/s)";
  
  SI.MassFlowRate m_flow_H2O_gas_out "Outlet mass flow rate of water vapour (kg/s)";
  SI.MassFlowRate m_flow_H2O_liq_out "Mass flow rate of water liquid removed (kg/s)";
  
  
  SI.MolarFlowRate n_flow_H2_in "Inlet molar flow rate of Hydrogen gas (mol/s)";
  SI.MolarFlowRate n_flow_H2O_in "Inlet molar flow rate of Water vapour (mol/s)";
  
  SI.MolarFlowRate n_flow_H2_out "Outlet molar flow rate of Hydrogen gas (mol/s)";
  SI.MolarFlowRate n_flow_H2O_gas_out "Outlet molar flow rate of water vapour (mol/s)";
  SI.MolarFlowRate n_flow_H2O_liq_out "Outlet molar flow rate of water liwuid removed from the gas phase";
  
  //SI.HeatFlowRate Q_flow_removed "Rate of heat removed from the component (J/s)";
  
  //SI.SpecificEnthalpy h_H2O_out "Specific enthalpy of outlet mixed stream (J/kg)";
  
  SI.Pressure p_H2 "Partial pressure of H2 (Pa)";
  SI.Pressure p_H2O "Partial pressure of H2O vapour (Pa)";

  //Initial calculated values assuming Mixed region (MIX)
  SI.SpecificEnthalpy h_H2_out "Specific enthalpy of outlet hydrogen gas stream assuming non-subcooled water (J/kg)";
  SI.SpecificEnthalpy h_sat_v "Enthalpy of saturated water vapour at pressure p_fixed (J/kg)";
  SI.SpecificEnthalpy h_sat_l "Enthalpy of saturated water liquid at pressure p_fixed (J/kg)";
  Real x_calc "Vapour quality of water outlet before correction(-)";
  SI.Temperature T_out "Outlet temperature of everything";
  
  //Final Values
  Real x "Vapour quality of water outlet after correction(-)";
  //SI.Temperature T_out(start=273.15+200.0) "Outlet temperature of everything";
  //SI.SpecificEnthalpy h_H2_out "Specific enthalpy of outlet hydrogen gas stream assuming non-subcooled water (J/kg)";
  SI.SpecificEnthalpy h_H2O_out(start = 3.6e6) "Specific enthalpy of outlet hydrogen gas stream assuming non-subcooled water (J/kg)";
  //Control parameters
  //Real X_H2O_gas_target "Target molar ratio of steam in the outlet gas stream (-)";
  //Real x_H2O_out_target "Target water vapour quality of the outlet water stream before the liquid is drained (-)";
  //Real h_H2O_out_target "Target specific enthalpy of the outlet water stream";
  //SI.HeatFlowRate Q_flow_removed_target "Target rate of heat removed from the component (J/s)";
  
  //Analytics
  Real inlet_H2O_molar_fraction "Inlet Molar ratio of H2O to (H2 + H2O)";
  Real outlet_H2O_molar_fraction "Outlet Molar ratio of H2O to (H2 + H2O)";

equation
  Water_Out.p = p_H2O;
  Water_Out.h = h_H2O_out;
  Water_Out.T = T_out;
  //h_H2_in = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2,T_H2_in); Port Value
  h_H2_out = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2,T_out);
  //h_H2O_out = Modelica.Media.Water.IF97_Utilities.h_pT(p_H2O,T_out);
  
  h_sat_l = Modelica.Media.Water.IF97_Utilities.hl_p(p_H2O);
  h_sat_v = Modelica.Media.Water.IF97_Utilities.hv_p(p_H2O);
  //p_H2O = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T_out);
  
  //
  
  //T_out = Modelica.Media.Water.IF97_Utilities.T_ph(p_H2O,h_H2O_out);
  //Energy balance assuming mixed region (MIX)
  m_flow_H2_in*h_H2_in + m_flow_H2O_in*h_H2O_in = Q_flow_removed + m_flow_H2_in*h_H2_out + m_flow_H2O_in*h_H2O_out;
  
  x_calc = (h_H2O_out - h_sat_l)/(h_sat_v - h_sat_l);
  x = min(1.0,max(0.0,x_calc));
  

  m_flow_H2O_gas_out = x*m_flow_H2O_in;
  m_flow_H2O_liq_out = (1.0-x)*m_flow_H2O_in;
  
  //Control
  //x = 0.01; //try setting this
  
  //Ports
  //--Mass Flow
  m_flow_H2_in = fluid_H2_in.m_flow;
  fluid_H2_out.m_flow = -1.0*fluid_H2_in.m_flow;
  
  m_flow_H2O_in = fluid_H2O_in.m_flow;
  fluid_H2O_gas_out.m_flow = -1.0*m_flow_H2O_gas_out;
  fluid_H2O_liq_out.m_flow = -1.0*m_flow_H2O_liq_out;
  
  //--Enthalpy
  h_H2_in = inStream(fluid_H2_in.h_outflow);
  h_H2O_in = inStream(fluid_H2O_in.h_outflow);
  fluid_H2_in.h_outflow = inStream(fluid_H2_in.h_outflow);
  fluid_H2O_in.h_outflow = inStream(fluid_H2O_in.h_outflow);
  
  fluid_H2_out.h_outflow = h_H2_out;
  
  if x_calc > 1.0 then
    fluid_H2O_liq_out.h_outflow = h_sat_l;//mass is zero
    fluid_H2O_gas_out.h_outflow = h_H2O_out;
  elseif x_calc < 0.0 then
    fluid_H2O_liq_out.h_outflow = h_H2O_out;
    fluid_H2O_gas_out.h_outflow = h_sat_v;//mass is zero
  else
    fluid_H2O_liq_out.h_outflow = h_sat_l;
    fluid_H2O_gas_out.h_outflow = h_sat_v;
  end if;
  
  //Very dangerous
  
  //--Pressure
  p_H2 = fluid_H2_in.p;
  p_H2O = fluid_H2O_in.p;
  fluid_H2_out.p = p_H2;
  fluid_H2O_gas_out.p = p_H2O;
  fluid_H2O_liq_out.p = p_H2O;
  
  //Molar Units
  n_flow_H2_in = m_flow_H2_in/2.01588e-3;
  n_flow_H2O_in = m_flow_H2O_in/18.01528e-3;
  
  n_flow_H2_out = m_flow_H2_in/2.01588e-3;
  n_flow_H2O_gas_out = m_flow_H2O_gas_out/18.01528e-3;
  n_flow_H2O_liq_out = m_flow_H2O_liq_out/18.01528e-3;
  
  inlet_H2O_molar_fraction = n_flow_H2O_in/(n_flow_H2O_in+n_flow_H2_in);
  outlet_H2O_molar_fraction = n_flow_H2O_gas_out/(n_flow_H2O_gas_out+n_flow_H2_out);

annotation(
    Diagram(coordinateSystem(extent = {{-125, -125}, {125, 125}})),
    Icon(graphics = {Line(origin = {-74, 64}, points = {{-14, 0}, {14, 0}}, thickness = 1), Line(origin = {15.2616, 64}, points = {{45, 0}, {73, 0}}, thickness = 1), Line(origin = {-74, 40}, points = {{-14, 0}, {14, 0}}, thickness = 1), Line(origin = {15.2616, 40}, points = {{45, 0}, {73, 0}}, thickness = 1), Line(origin = {0, -82}, points = {{0, 6}, {0, -6}}, thickness = 1), Text(origin = {-77, 81}, extent = {{-11, 1}, {13, -13}}, textString = "H2"), Text(origin = {75, 81}, extent = {{-11, 1}, {13, -13}}, textString = "H2"), Text(origin = {75, 35}, extent = {{-11, 1}, {13, -13}}, textString = "H2O"), Text(origin = {-77, 35}, extent = {{-11, 1}, {13, -13}}, textString = "H2O"), Text(origin = {19, -89}, extent = {{-11, 1}, {13, -13}}, textString = "H2O"), Text(origin = {21, 95}, extent = {{-11, 1}, {35, -27}}, textString = "Cooling")}, coordinateSystem(extent = {{-125, -125}, {125, 125}})));
end Dewaterer_H2_H2O_Isobaric;