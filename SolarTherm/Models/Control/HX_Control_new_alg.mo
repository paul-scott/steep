within SolarTherm.Models.Control;

model HX_Control_new_alg
  extends Icons.Control;
  parameter SI.Temperature T_ref_rec = from_degC(570) "Setpoint of temperature";
  parameter SI.Temperature T_ref_hs = from_degC(570) "Setpoint of temperature";
  parameter SI.MassFlowRate m_flow_max_CS = 1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_CS = 0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_CS = 0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_max_Na = 1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_Na = 0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_Na = 0 "Mass flow rate when control off";
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off = 10 "Level of stop discharge";
  parameter Real L_df_on = 99 "Level of start defocus";
  parameter Real L_df_off = 96 "Level of stop defocus";
  parameter SI.HeatFlowRate Q_rec_out;
  parameter SI.Length d_o=1 "Outer Tube diameter";
  parameter Integer N_p=1 "Number of tube-passes";
  parameter Integer N_sp=1 "Number of shell-passes";
  parameter Integer layout=1 "Tube layout";
  parameter Integer N_t=1 "Number of tubes";
  parameter SI.Length L=1 "Tube length";  
  
  
  
  
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{6, -46}, {32, -22}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_input_rec annotation(
    Placement(visible = true, transformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0), iconTransformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_output_cs annotation(
    Placement(visible = true, transformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0), iconTransformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start = Q_rec_out) annotation(
    Placement(visible = true, transformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression T_ref_rec_in(y = T_ref_rec) annotation(
    Placement(visible = true, transformation(extent = {{-68, 56}, {-48, 76}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_ref_hs_in(y = T_ref_hs) annotation(
    Placement(visible = true, transformation(extent = {{-68, 2}, {-48, 22}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea annotation(
    Placement(visible = true, transformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0), iconTransformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec(start = m_flow_start_Na)
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_hs annotation(
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput sf_on annotation(
    Placement(visible = true, transformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0), iconTransformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0)));
  SolarTherm.Models.Control.Level2Logic hotTankLogic(level_max = 30, level_min = L_off) annotation(
    Placement(visible = true, transformation(extent = {{-74, -22}, {-54, -2}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(extent = {{-34, -34}, {-14, -14}}, rotation = 0)));
  SolarTherm.Models.Control.Level2Logic defocus_logic(y(start = false), level_max = L_df_off, level_min = L_df_on) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-12, -10}, {12, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {0, -86}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation(
    Placement(visible = true, transformation(origin = {0, -116}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, -116}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  SolarTherm.Models.Control.Switch2 switch annotation(
    Placement(visible = true, transformation(origin = {68, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.m_flow_calculations_simple_2 m_flow_calculations1(Q_rec_out = Q_rec_out, m_flow_max_Na = m_flow_max_Na, m_flow_max_CS = m_flow_max_CS, m_flow_start_Na = m_flow_start_Na, m_flow_start_CS = m_flow_start_CS, d_o=d_o, N_sp=N_sp, N_p=N_p, layout=layout, L=L, N_t=N_t) annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  // Modelica.Blocks.Nonlinear.Limiter limiter_hs(uMax=m_flow_max_CS, uMin=m_flow_min_CS) annotation(
  //    Placement(visible = true, transformation(origin = {39, 57}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  //  Modelica.Blocks.Nonlinear.Limiter limiter_Na(uMax = m_flow_max_Na, uMin = m_flow_min_Na) annotation(
  //    Placement(visible = true, transformation(origin = {35, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
equation
  connect(m_flow_calculations1.m_flow_rec, switch.in1) annotation(
    Line(points = {{18, 42}, {38, 42}, {38, 4}, {56, 4}, {56, 4}}, color = {0, 0, 127}));
  connect(m_flow_calculations1.m_flow_hs, switch.in2) annotation(
    Line(points = {{18, 56}, {48, 56}, {48, 10}, {56, 10}, {56, 10}}, color = {0, 0, 127}));
//  connect(limiter_Na.y, switch.in1) annotation(
//    Line(points = {{42, 20}, {46, 20}, {46, 4}, {56, 4}, {56, 4}}, color = {0, 0, 127}));
//  connect(m_flow_calculations1.m_flow_rec, limiter_Na.u) annotation(
//    Line(points = {{18, 42}, {22, 42}, {22, 18}, {26, 18}, {26, 20}}, color = {0, 0, 127}));
//  connect(limiter_hs.y, switch.in2) annotation(
//    Line(points = {{46, 58}, {52, 58}, {52, 8}, {56, 8}, {56, 10}}, color = {0, 0, 127}));
//  connect(m_flow_calculations1.m_flow_hs, limiter_hs.u) annotation(
//    Line(points = {{18, 56}, {30, 56}, {30, 58}, {30, 58}}, color = {0, 0, 127}));
  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{34, -34}, {42, -34}, {42, -6}, {56, -6}}, color = {0, 0, 127}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-12, -24}, {-4, -24}, {-4, -1}, {56, -1}}, color = {255, 0, 255}));
  connect(switch.y1, m_flow_rec) annotation(
    Line(points = {{79, -1}, {82, -1}, {82, -50}, {118, -50}}, color = {0, 0, 127}));
  connect(switch.y2, m_flow_hs) annotation(
    Line(points = {{79, 5}, {82, 5}, {82, 48}, {118, 48}}, color = {0, 0, 127}));
  connect(sf_on, m_flow_calculations1.sf_on) annotation(
    Line(points = {{-110, -72}, {-64, -72}, {-64, -32}, {-40, -32}, {-40, 62}, {-16, 62}, {-16, 62}}, color = {255, 0, 255}));
  connect(T_output_cs, m_flow_calculations1.T_output_cs) annotation(
    Line(points = {{-110, 38}, {-18, 38}, {-18, 40}, {-18, 40}}, color = {0, 0, 127}));
  connect(T_ref_hs_in.y, m_flow_calculations1.T_input_hs) annotation(
    Line(points = {{-46, 12}, {-32, 12}, {-32, 46}, {-18, 46}, {-18, 46}}, color = {0, 0, 127}));
  connect(T_ref_rec_in.y, m_flow_calculations1.T_out_rec_ref) annotation(
    Line(points = {{-46, 66}, {-34, 66}, {-34, 52}, {-18, 52}, {-18, 52}}, color = {0, 0, 127}));
  connect(T_input_rec, m_flow_calculations1.T_input_rec) annotation(
    Line(points = {{-112, 92}, {-26, 92}, {-26, 58}, {-18, 58}, {-18, 58}}, color = {0, 0, 127}));
  connect(Q_out_rec, m_flow_calculations1.Q_out_rec) annotation(
    Line(points = {{0, 110}, {0, 89}, {1, 89}, {1, 65.5}}, color = {0, 0, 127}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -92.6}, {0, -116}}, color = {255, 0, 255}));
  connect(L_mea, hotTankLogic.level_ref) annotation(
    Line(points = {{-110, -12}, {-74, -12}}, color = {0, 0, 127}));
  connect(not1.u, defocus_logic.y) annotation(
    Line(points = {{0, -78.8}, {0, -76}, {-1.33227e-15, -76}, {-1.33227e-15, -72.96}}, color = {255, 0, 255}));
  connect(and1.u2, sf_on) annotation(
    Line(points = {{-36, -32}, {-64, -32}, {-64, -72}, {-110, -72}}, color = {255, 0, 255}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    Line(points = {{0, -48}, {0, -42}, {-80, -42}, {-80, -12}, {-74, -12}}, color = {0, 0, 127}));
  connect(hotTankLogic.y, and1.u1) annotation(
    Line(points = {{-53.2, -12}, {-44, -12}, {-44, -24}, {-36, -24}}, color = {255, 0, 255}));

  annotation(
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)),
    Documentation(revisions = "<html> 
  <ul>
  <li>Salvatore Guccione:<br>Released first version. </li>
  </ul>
  </html>"));
end HX_Control_new_alg;
