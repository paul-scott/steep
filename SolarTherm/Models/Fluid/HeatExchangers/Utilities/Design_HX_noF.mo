within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Design_HX_noF
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Currency;
  
  input SI.HeatFlowRate Q_d "Design Heat Flow Rate";
  input SI.Temperature T_Na1 "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1 "Desing Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2 "Desing Molten Salt Hot Fluid Temperature";
  input SI.Length d_o "Outer Tube diameter";
  input SI.Length L "Tube length";
  input Integer N_p "Number of passes";
  input Integer N_sp "Number of passes";
  input Integer layout "Tube layout"; // if layout=1(one) is square, while if layout=2(two) it is triangular //
  input SI.Temperature T_Na2 "Sodium Cold Fluid Temperature";
  input SI.Pressure p_Na1 "Sodium Inlet Pressure";
  input SI.Pressure p_MS1 "Molten Salt Inlet Pressure";
  input FI.EnergyPrice_kWh c_e "Power cost";
  input Real r "Real interest rate";
  input Real H_y(unit= "h") "Operating hours";
  input Integer n(unit= "h") "Operating years";

  output SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  output SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  output Real F(unit = "") "Temperature correction factor";
  output SI.ThermalConductance UA "UA";
  output Integer N_t "Number of tubes";
  output SI.CoefficientOfHeatTransfer U_calc "Heat tranfer coefficient";
  output SI.Area A_tot "Exchange Area";
  output SI.Pressure Dp_tube "Tube-side pressure drop";
  output SI.Pressure Dp_shell "Shell-side pressure drop";
  output FI.MoneyPerYear TAC "Total Annualized Cost";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  output SI.Length D_s "Shell Diameter";
  output Integer N_baffles "Number of baffles";
  output SI.Length l_b "Baffle spacing";
  output SI.Velocity v_Na "Sodium velocity in tubes";
  output SI.Velocity v_max_MS "Molten Salt velocity in shell";
  output SI.Volume V_HX "Heat-Exchanger Total Volume";
  output SI.Mass m_HX "Heat-Exchanger Total Mass";
  output SI.Mass m_material "Heat-Exchanger Material Mass";
  output FI.Money_USD C_BEC  "Bare cost @2018";
  output FI.MoneyPerYear C_pump  "Annual pumping cost";
  output Real ex_eff(unit="") "HX Exergetic Efficiency";
  output Real en_eff(unit="") "HX Energetic Efficiency";
  
  protected
  parameter SI.CoefficientOfHeatTransfer U_guess=1200 "Heat tranfer coefficient guess";
  parameter Real tol=0.01 "Heat transfer coefficient tollerance";
  Real condition "When condition";
  parameter Real iter_max=1000;
  Real iter_1;
  Real iter_2;
  Real error_l_b;
  Real error_l_b2;
  Real error_area;
  parameter Real tol2=0.1 "Heat transfer coefficient tollerance";
  Real geom_error;
  SI.CoefficientOfHeatTransfer U_calc_prev "Heat tranfer coefficient guess";
  SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  SI.Density rho_wall "HX material density";
  SI.Temperature Tm_wall "Mean Wall Temperature";
  parameter SI.Length t_tube=TubeThickness(d_o) "Tube thickness";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  
  //Tube Side  
  SI.Area A_st/*=CN.pi*d_o*L*/ "Single tube exchange area";
  parameter SI.Length d_i=d_o-2*t_tube "Inner Tube diameter";
  Integer Tep(start=7962) "Tubes for each pass";
  parameter SI.Area A_cs=CN.pi*(d_i^2)/4;
  SI.Length L_calc;
  SI.Area A_tot_prev;
  
  //Shell Side
  SI.Length L_bb(start=0.0342502444061721) "Bundle-to-shell diametral clearance";
  SI.Length D_b(start=4.42) "Bundle diameter";
  SI.Length t_baffle "Baffle thickness";
  SI.Length t_shell "Shell thickness";
  SI.Length D_s_out "Shell Outer Diameter";
  parameter Real B=0.25 "Baffle cut";
  Integer N_calc "Number of Baffles calculated";
  SI.Length l_b_prev "Baffle spacing";
  SI.Area S_m(start=1.62588760919663) "Minimal crossflow area at bundle centerline";
  parameter SI.Length P_t=1.25*d_o "Tube pitch";
  
  //Minimum Velocities
  parameter SI.Velocity v_max_MS_lim_min=0.50;
  parameter SI.Velocity v_max_MS_lim_max=1.50;
  parameter SI.Velocity v_Na_lim_min=1.2;
  parameter SI.Velocity v_Na_lim_max=2.5;
  Integer N_t_min "Number of tubes";
  Integer N_t_max "Number of tubes";
  SI.Area S_m_min "Minimal crossflow area at bundle centerline";
  SI.Area S_m_max "Minimal crossflow area at bundle centerline";
  
  //Volume_and_Weight
  SI.Mass m_Na "Mass of Sodium";
  SI.Mass m_MS "Mass of Molten Salts";
  SI.Volume V_Na "Volume of Sodium";
  SI.Volume V_MS "Volume of Molten Salt";
  SI.Volume V_material "Volume of HX material";
  SI.Volume V_tubes "Tube Material Volume";
  SI.Volume V_baffles "Baffles Material Volume";
  SI.Volume V_ShellThickness "External Material Volume HX";  
  
//  //Turton Cost Function
//  parameter Real CEPCI_01=397 "CEPCI 2001";
//  parameter Real CEPCI_18=603.1 "CEPCI 2018";
//  Real k1(unit= "") "Non dimensional factor";
//  Real k2(unit= "") "Non dimensional factor";
//  Real k3(unit= "") "Non dimensional factor";
//  SI.Area A_cost "Area for cost function";
//  FI.Money_USD C_BM  "Bare module cost @operating pressure and with material";
//  FI.Money_USD C_p0  "Bare module cost @2001";
//  Real C1(unit= "") "Non dimensional factor";
//  Real C2(unit= "") "Non dimensional factor";
//  Real C3(unit= "") "Non dimensional factor";
//  Real B1(unit= "") "Non dimensional factor";
//  Real B2(unit= "") "Non dimensional factor";
//  Real Fp(unit= "") "Cost pressure factor";
//  Real Fm(unit= "") "Cost material factor";
//  Boolean both "Condition for pressure factor correlation";
//  SI.Pressure P_shell "Shell-side pressure";
//  SI.Pressure P_tubes "Tube-side pressure";
//  Real P_tube_cost(unit= "barg") "Tube pressure in barg";
//  Real P_shell_cost(unit= "barg") "Shell pressure in barg";
//  Real P_cost(unit= "barg") "HX pressure in barg";
//  parameter SI.Mass m_material_HX_ref=/*121857*//*248330*/209781 "Reference Heat-Exchanger Material Mass";
//  parameter SI.Area A_ref=/*11914.5*//*22530.8*/21947.3 "Reference Heat-Exchanger Area";
//  FI.Money_USD C_BEC_ref  "Bare cost @2018";
  
  //Cost Function
  parameter FI.MassPrice material_sc=84 "Material HX Specific Cost";
  parameter Real mmm=0.37;
  parameter Real c2=11;
  parameter Real M_conv = if currency == Currency.USD then 1 else 0.9175 "Conversion factor";
  parameter Real eta_pump=0.75 "Pump efficiency";
  Real F_ma "Manufacturing Factor";
  parameter Real F_ma_min=1.65 "Manufacturing Factor";
  Real f(unit= "") "Annualization factor";
  
  //Fluid properties
  SI.Temperature Tm_Na "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  SI.SpecificEnthalpy h_Na1 "Sodium specific enthalpy @inlet temperature";
  SI.SpecificEnthalpy h_Na2 "Sodium specific enthalpy @outlet temperature";
  SI.SpecificEntropy s_Na1 "Sodium specific entropy @inlet temperature";
  SI.SpecificEntropy s_Na2 "Sodium specific entropy @outlet temperature";
  SI.SpecificEnthalpy h_MS1 "Molten Salt specific enthalpy @inlet temperature";
  SI.SpecificEnthalpy h_MS2 "Molten Salt specific enthalpy @outlet temperature";
  SI.SpecificEntropy s_MS1 "Molten Salt specific entropy @inlet temperature";
  SI.SpecificEntropy s_MS2 "Molten Salt specific entropy @outlet temperature";
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
  //Temperature differences
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";

  
algorithm
  Tm_Na:=(T_Na1+T_Na2)/2;
  Tm_MS:=(T_MS1+T_MS2)/2;
  Tm_wall:=(Tm_MS+Tm_Na)/2;
  
  //Sodium properties
  state_mean_Na:=Medium1.setState_pTX(p_Na1, Tm_Na);
  state_input_Na:=Medium1.setState_pTX(p_Na1, T_Na1);
  state_output_Na:=Medium1.setState_pTX(p_Na1, T_Na2);
  rho_Na:=Medium1.density(state_mean_Na);
  cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall:=mu_Na;
  k_Na:=Medium1.thermalConductivity(state_mean_Na);
  h_Na1:=Medium1.specificEnthalpy(state_input_Na);
  h_Na2:=Medium1.specificEnthalpy(state_output_Na);
  s_Na1:=Medium1.specificEntropy(state_input_Na);
  s_Na2:=Medium1.specificEntropy(state_output_Na);
  
  //Chloride Salt properties
  state_mean_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  state_wall_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  state_input_MS:=Medium2.setState_pTX(p_Na1, T_MS1);
  state_output_MS:=Medium2.setState_pTX(p_Na1, T_MS2);
  rho_MS:=Medium2.density(state_mean_MS);
  cp_MS:=Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS:=Medium2.dynamicViscosity(state_mean_MS);
  mu_MS_wall:=Medium2.dynamicViscosity(state_wall_MS);
  k_MS:=Medium2.thermalConductivity(state_mean_MS);
  h_MS1:=Medium2.specificEnthalpy(state_input_MS);
  h_MS2:=Medium2.specificEnthalpy(state_output_MS);
  s_MS1:=Medium2.specificEntropy(state_input_MS);
  s_MS2:=Medium2.specificEntropy(state_output_MS); 
  
  DT1:=T_Na1-T_MS2;
  DT2:=T_Na2-T_MS1;
  if abs(DT1-DT2)<1e-6 then
    LMTD:=DT1;
  else
    LMTD:=(DT1-DT2)/MA.log(DT1 / DT2);
  end if;
  m_flow_Na:=Q_d/(cp_Na*(T_Na1-T_Na2));
  m_flow_MS:=Q_d/(cp_MS*(T_MS2 - T_MS1));
  F:=1;
  UA:=Q_d/(F*LMTD);
  ex_eff:=(m_flow_MS*((h_MS2-h_MS1)-(25+273.15)*cp_MS*(MA.log(T_MS2/T_MS1))))/(m_flow_Na*((h_Na1-h_Na2)-(25+273.15)*cp_Na*(MA.log(T_Na1/T_Na2))));
  if (cp_Na*m_flow_Na)>(cp_MS*m_flow_MS) then
    en_eff:=(T_MS2-T_MS1)./(T_Na1-T_MS1);
  else
    en_eff:=(T_Na1-T_Na2)./(T_Na1-T_MS1);
  end if;
  
  N_t_min:=integer(ceil(m_flow_Na/(rho_Na*A_cs*v_Na_lim_max*0.98)));
  N_t_max:=integer(floor(m_flow_Na/(rho_Na*A_cs*v_Na_lim_min*1.02)));
  S_m_min:=m_flow_MS/(rho_MS*v_max_MS_lim_max*0.98);
  S_m_max:=m_flow_MS/(rho_MS*v_max_MS_lim_min*1.02);  
  
  U_calc_prev:=U_guess;
  condition:=10;
  iter_1:=0;
  L_calc:=L;
while noEvent(condition>0.01) and iter_1<iter_max loop
//  L_calc:=L;
  A_tot_prev:=UA/U_calc_prev;
  A_st:=CN.pi*d_o*L_calc;
  N_t:=integer(ceil(A_tot_prev/A_st));
  Tep:=integer(ceil(N_t/N_p));
  N_t:=Tep*N_p;
  error_area:=10;
  while error_area>tol loop
    L_calc:=A_tot_prev/(CN.pi*d_o*N_t);
    A_st:=CN.pi*d_o*L_calc;
    N_t:=integer(ceil(A_tot_prev/A_st));
    if N_t<N_t_min then
      N_t:=N_t_min;
    elseif N_t>N_t_max then
      N_t:=N_t_max;
    end if;
    A_tot:=A_st*N_t;
    error_area:=abs(A_tot_prev-A_tot)/A_tot_prev;
    A_tot_prev:=A_tot;
  end while;
  (L_bb, D_b, D_s):=ShellDiameter(d_o=d_o, N_t=N_t, layout=layout, N_p=N_p);
  iter_2:=0;
  error_l_b:=10;
  l_b_prev:=D_s;
  while error_l_b>tol2 and iter_2<iter_max loop
    error_l_b2:=10;
    while error_l_b2>tol loop
        t_baffle:= BaffleThickness(D_s=D_s,l_b=l_b_prev);
        N_baffles:=integer(ceil((L_calc/(l_b_prev+t_baffle)-1)*N_sp));
        l_b:=L_calc/(N_baffles/N_sp+1)-t_baffle;
        error_l_b2:=abs(l_b_prev-l_b)/l_b_prev;
        l_b_prev:=l_b;
    end while;
    S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
    if S_m<S_m_min then
        S_m:=S_m_min;
    elseif S_m>S_m_max then
        S_m:=S_m_max;
    end if;
    l_b:=S_m*N_sp/(L_bb+(D_b/P_t)*(P_t-d_o));
    t_baffle:= BaffleThickness(D_s=D_s,l_b=l_b);
    N_baffles:=integer(ceil((L_calc/(l_b+t_baffle)-1)*N_sp));
    error_l_b:=abs(l_b_prev-l_b)/l_b_prev;
    l_b_prev:=l_b;
    iter_2:=iter_2+1;
  end while;
  geom_error:=abs(L_calc-(t_baffle+l_b)*(N_baffles+1))/L_calc;
  (U_calc, h_s, h_t):=HTCs(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_MS, state_wall_MS=state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS, L=L_calc, l_b=l_b);
  condition:=abs(U_calc*A_tot-UA)/UA;
  U_calc_prev:=U_calc;
  iter_1:=iter_1+1;
end while;
  
  (Dp_tube, Dp_shell, v_Na, v_max_MS):=Dp_losses(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, L=L_calc, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_MS, state_wall_MS=state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS, l_b=l_b, N=N_baffles);
  
  t_shell:=ShellThickness(D_s);
  D_s_out:=D_s+2*t_shell;
  V_ShellThickness:=(D_s_out^2-(D_s^2))*CN.pi/4*L;
  V_tubes:=CN.pi*(d_o^2-d_i^2)/4*L*N_t;
  V_baffles:=(CN.pi*D_s^2)/4*(1-B)*N_baffles*t_baffle+t_baffle*D_s*L*(N_sp-1);
  V_material:=V_ShellThickness+V_tubes+V_baffles;
  V_Na:=CN.pi/4*(d_i^2)*L*N_t;
  V_MS:=(D_s^2-(d_o^2)*N_t)*CN.pi/4*L-V_baffles;
  V_HX:=V_material+V_MS+V_Na;
  (k_wall, rho_wall):=Haynes230_BaseProperties(Tm_wall);
  m_Na:=V_Na*rho_Na;
  m_MS:=V_MS*rho_MS;
  m_material:=V_material*rho_wall;
  m_HX:=m_material+m_MS+m_Na;
  
//Turton Cost function
//  P_shell:=p_MS1;
//  P_tubes:=p_Na1;
//  P_tube_cost:=(P_tubes/10^5)-1;
//  P_shell_cost:=(P_shell/10^5)-1;
//  if ((P_tube_cost>5 and P_shell_cost>5)or(P_tube_cost<5 and P_shell_cost>5)) then
//    both:=true;
//    P_cost:=max(P_tube_cost,P_shell_cost);
//    else
//    both:=false;
//    P_cost:=P_tube_cost;
//  end if;
//  k1:=4.3247;
//  k2:=-0.3030;
//  k3:=0.1634;
//  if both then
//        C1:=0.03881;
//        C2:=-0.11272;
//        C3:=0.08183;
//    else
//    if P_cost<5 then
//      C1:=0;
//      C2:=0;
//      C3:=0;
//      else
//        C1:=-0.00164;
//        C2:=-0.00627;
//        C3:=0.0123;
//    end if;
//  end if;
//  Fp:=10^(C1+C2*log10(P_cost)+C3*(log10(P_cost))^2);
//  Fm:=3.7;
//  B1:=1.63;
//  B2:=1.66;
//  if noEvent(A_tot>1000) then
//    A_cost:=1000;
//    elseif noEvent(A_tot<10) then
//    A_cost:=10;    
//    else
//    A_cost:=A_tot;    
//  end if;
//  C_p0:=10^(k1+k2*log10(A_cost)+k3*(log10(A_cost))^2);
//  C_BM:=C_p0*(CEPCI_18/CEPCI_01)*(B1+B2*Fm*Fp);
//  C_BEC_ref:=material_sc*m_material_HX_ref;
//  C_BEC:=C_BEC_ref*(A_tot/A_ref)^0.8;
  
  //Cost Fucntion
  F_ma:=F_ma_min+c2.*A_tot.^(-mmm);
  C_BEC:=material_sc*9.5*A_tot*F_ma;
  C_pump:=c_e*H_y/eta_pump*(m_flow_MS*Dp_shell/rho_MS+m_flow_Na*Dp_tube/rho_Na)/(1000);
  f:=(r*(1+r)^n)/((1+r)^n-1);
  if (v_max_MS<v_max_MS_lim_min or v_max_MS>v_max_MS_lim_max or v_Na<v_Na_lim_min or v_Na>v_Na_lim_max or L_calc/D_s_out>10.1 or geom_error>tol or condition>0.01) then
    TAC:=10e10;
    C_BEC:=10e10;
  else
    if noEvent(C_BEC>0) and noEvent(C_pump>0) then
      C_BEC:=material_sc*9.5*A_tot*F_ma;
      TAC:=f*C_BEC+C_pump;
    else
      TAC:=10e10;
      C_BEC:=10e10;
    end if;
  end if;
  
end Design_HX_noF;
