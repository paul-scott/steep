within SolarTherm.Media.SolidParticles.FeO_utilities;
function rho_T "Density of FeO as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
protected
	constant Modelica.SIunits.Temperature T_data[122] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00};
	constant Modelica.SIunits.Density rho_data[122] = {5698.97, 5698.60, 5696.58, 5694.55, 5692.50, 5690.45, 5688.38, 5686.30, 5684.21, 5682.12, 5680.02, 5677.91, 5675.80, 5673.68, 5671.57, 5669.44, 5667.32, 5665.19, 5663.06, 5660.93, 5658.81, 5656.68, 5654.55, 5652.42, 5650.29, 5648.16, 5646.04, 5643.91, 5641.79, 5639.67, 5637.54, 5635.42, 5633.30, 5631.18, 5629.06, 5626.93, 5624.81, 5622.69, 5620.56, 5618.43, 5616.30, 5614.17, 5612.03, 5609.88, 5607.73, 5605.57, 5603.41, 5601.23, 5599.05, 5596.86, 5594.65, 5592.43, 5590.20, 5587.95, 5585.69, 5583.41, 5581.10, 5578.79, 5576.47, 5574.13, 5571.78, 5569.41, 5567.02, 5564.61, 5562.18, 5559.73, 5557.25, 5554.75, 5552.22, 5549.67, 5547.09, 5544.48, 5541.84, 5539.17, 5536.47, 5533.73, 5530.97, 5528.17, 5525.33, 5522.47, 5519.56, 5516.62, 5513.65, 5510.64, 5507.59, 5504.51, 5501.39, 5498.23, 5495.04, 5491.81, 5488.54, 5485.23, 5481.89, 5478.51, 5475.09, 5471.63, 5468.14, 5464.61, 5461.05, 5457.45, 5453.81, 5450.14, 5446.43, 5442.69, 5438.92, 5435.11, 5431.27, 5427.40, 5423.50, 5419.57, 5415.61, 5411.62, 5407.61, 5403.56, 5399.49, 5395.40, 5391.28, 5387.14, 5382.98, 5378.80, 5374.60, 5370.38};
algorithm
	rho := Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
end rho_T;