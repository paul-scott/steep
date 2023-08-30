within SolarTherm.Media.Air.Air_amb_p_utilities;
function cp_T "Specific heat capacity (J/kgK) of air at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
protected
    Real T_data[35] = {100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000};
    Real cp_data[35] = {1032,1012,1007,1006,1007,1009,1014,1021,1030,1040,1051,1063,1075,1087,1099,1110,1121,1131,1141,1159,1175,1189,1207,1230,1248,1267,1286,1307,1337,1372,1417,1478,1558,1665,2726};
algorithm
    cp := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,cp_data,T);
end cp_T;
