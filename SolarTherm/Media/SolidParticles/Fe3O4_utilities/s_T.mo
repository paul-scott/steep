within SolarTherm.Media.SolidParticles.Fe3O4_utilities;
function s_T "Specific absolute entropy of Fe3O4 obtained from NIST JANAF tables."
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificEntropy s "Specific absolute entropy (J/kgK)";
protected
	constant Modelica.SIunits.Temperature T_data[122] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00};
	constant Modelica.SIunits.SpecificEntropy s_data[122] = {631.07, 635.13, 656.87, 678.28, 699.38, 720.14, 740.59, 760.72, 780.55, 800.06, 819.28, 838.21, 856.86, 875.24, 893.35, 911.21, 928.83, 946.21, 963.37, 980.31, 997.04, 1013.58, 1029.93, 1046.10, 1062.10, 1077.94, 1093.63, 1109.18, 1124.59, 1139.88, 1155.05, 1170.10, 1185.06, 1199.92, 1214.70, 1229.40, 1244.03, 1258.59, 1273.10, 1287.56, 1301.98, 1316.36, 1330.71, 1345.05, 1359.36, 1373.67, 1387.97, 1402.28, 1416.60, 1430.93, 1445.29, 1459.67, 1474.09, 1488.55, 1503.05, 1517.60, 1539.35, 1549.40, 1559.35, 1569.20, 1578.94, 1588.59, 1598.13, 1607.58, 1616.93, 1626.19, 1635.36, 1644.44, 1653.43, 1662.33, 1671.16, 1679.89, 1688.55, 1697.12, 1705.62, 1714.04, 1722.39, 1730.65, 1738.85, 1746.97, 1755.03, 1763.01, 1770.93, 1778.77, 1786.55, 1794.27, 1801.92, 1809.51, 1817.04, 1824.50, 1831.91, 1839.25, 1846.54, 1853.77, 1860.94, 1868.06, 1875.13, 1882.13, 1889.09, 1895.99, 1902.85, 1909.65, 1916.40, 1923.10, 1929.75, 1936.36, 1942.91, 1949.42, 1955.89, 1962.31, 1968.68, 1975.01, 1981.30, 1987.54, 1993.74, 1999.90, 2006.02, 2012.10, 2018.13, 2024.13, 2030.09, 2036.01};

algorithm
	s := Utilities.Interpolation.Interpolate1D(T_data,s_data,T);
end s_T;