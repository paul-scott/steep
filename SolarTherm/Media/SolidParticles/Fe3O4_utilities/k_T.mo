within SolarTherm.Media.SolidParticles.Fe3O4_utilities;
function k_T "Thermal conductivity of Fe3O4 as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.ThermalConductivity k "Thermal conductivity (W/mK)";
protected
    constant Modelica.SIunits.Temperature T_data[122] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00};
    constant Modelica.SIunits.ThermalConductivity k_data[122] = {5.297, 5.282, 5.201, 5.123, 5.047, 4.974, 4.902, 4.833, 4.765, 4.700, 4.636, 4.574, 4.513, 4.454, 4.397, 4.341, 4.286, 4.233, 4.181, 4.131, 4.081, 4.033, 3.986, 3.940, 3.895, 3.851, 3.808, 3.766, 3.725, 3.684, 3.645, 3.606, 3.569, 3.532, 3.496, 3.460, 3.425, 3.391, 3.358, 3.325, 3.293, 3.262, 3.231, 3.200, 3.171, 3.141, 3.113, 3.085, 3.057, 3.030, 3.003, 2.977, 2.951, 2.926, 2.901, 2.876, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857};
algorithm
	k := Utilities.Interpolation.Interpolate1D(T_data,k_data,T);
end k_T;