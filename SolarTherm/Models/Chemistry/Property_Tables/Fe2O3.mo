within SolarTherm.Models.Chemistry.Property_Tables;

record Fe2O3
  parameter Modelica.SIunits.Temperature T_table[122] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00} "Absolute temperature (K)";
  parameter Modelica.SIunits.SpecificEnthalpy h_table[122] = {0.00, 1224.00, 7926.00, 14757.00, 21709.00, 28771.00, 35935.00, 43195.00, 50544.00, 57976.00, 65487.00, 73072.00, 80728.00, 88451.00, 96237.00, 104085.00, 111993.00, 119957.00, 127977.00, 136051.00, 144177.00, 152355.00, 160583.00, 168861.00, 177188.00, 185564.00, 193989.00, 202461.00, 210982.00, 219551.00, 228168.00, 236834.00, 245549.00, 254314.00, 263128.00, 271994.00, 280911.00, 289880.00, 298903.00, 307981.00, 317115.00, 326306.00, 335557.00, 344868.00, 354241.00, 363680.00, 373185.00, 382760.00, 392407.00, 402129.00, 411929.00, 421811.00, 431778.00, 441836.00, 451988.00, 462239.00, 472596.00, 483064.00, 493650.00, 504362.00, 515208.00, 526197.00, 537340.00, 548647.00, 560131.00, 571807.00, 583689.00, 594799.00, 604574.00, 614228.00, 623780.00, 633243.00, 642628.00, 651946.00, 661204.00, 670409.00, 679566.00, 688681.00, 697758.00, 706800.00, 715810.00, 724791.00, 733746.00, 742676.00, 751584.00, 760472.00, 769340.00, 778190.00, 787023.00, 795841.00, 804645.00, 813435.00, 822212.00, 830977.00, 839732.00, 848475.00, 857209.00, 865934.00, 874650.00, 883357.00, 892057.00, 900750.00, 909435.00, 918114.00, 926787.00, 935454.00, 944115.00, 952771.00, 961422.00, 970068.00, 978710.00, 987347.00, 995981.00, 1004610.00, 1013236.00, 1021858.00, 1030478.00, 1039093.00, 1047706.00, 1056317.00, 1064924.00, 1073529.00} "Specific enthalpy (J/kg)";
  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_table[122] = {660.55, 663.21, 676.83, 689.32, 700.82, 711.46, 721.33, 730.53, 739.14, 747.24, 754.87, 762.09, 768.96, 775.51, 781.78, 787.81, 793.62, 799.24, 804.70, 810.02, 815.22, 820.32, 825.33, 830.28, 835.17, 840.02, 844.85, 849.67, 854.48, 859.31, 864.16, 869.04, 873.96, 878.94, 883.98, 889.10, 894.31, 899.61, 905.03, 910.56, 916.24, 922.06, 928.05, 934.21, 940.57, 947.15, 953.97, 961.04, 968.39, 976.05, 984.04, 992.40, 1001.17, 1010.38, 1020.07, 1030.30, 1041.12, 1052.59, 1064.78, 1077.75, 1091.60, 1106.41, 1122.30, 1139.37, 1157.76, 1177.60, 1199.07, 984.19, 971.17, 960.07, 950.52, 942.24, 935.01, 928.66, 923.04, 918.03, 913.55, 909.51, 905.86, 902.55, 899.53, 896.77, 894.23, 891.89, 889.73, 887.74, 885.88, 884.16, 882.56, 881.06, 879.66, 878.35, 877.12, 875.97, 874.89, 873.87, 872.92, 872.02, 871.17, 870.36, 869.61, 868.89, 868.22, 867.58, 866.97, 866.40, 865.86, 865.34, 864.86, 864.39, 863.95, 863.54, 863.14, 862.77, 862.41, 862.07, 861.75, 861.44, 861.15, 860.88, 860.61, 860.36} "Specific heat capacity at constant pressure (J/kgK)";
  parameter Modelica.SIunits.SpecificEntropy s_table[122] = {549.37, 553.47, 575.44, 597.13, 618.52, 639.60, 660.37, 680.82, 700.95, 720.77, 740.28, 759.49, 778.39, 797.00, 815.32, 833.36, 851.13, 868.64, 885.89, 902.88, 919.64, 936.16, 952.45, 968.53, 984.39, 1000.05, 1015.50, 1030.77, 1045.85, 1060.75, 1075.49, 1090.05, 1104.46, 1118.71, 1132.81, 1146.77, 1160.60, 1174.29, 1187.86, 1201.31, 1214.64, 1227.87, 1240.99, 1254.01, 1266.94, 1279.78, 1292.54, 1305.22, 1317.83, 1330.38, 1342.86, 1355.29, 1367.67, 1380.01, 1392.32, 1404.60, 1416.85, 1429.10, 1441.34, 1453.58, 1465.83, 1478.11, 1490.42, 1502.78, 1515.20, 1527.68, 1540.26, 1551.89, 1562.02, 1571.93, 1581.62, 1591.13, 1600.47, 1609.65, 1618.68, 1627.58, 1636.34, 1644.98, 1653.50, 1661.92, 1670.22, 1678.42, 1686.53, 1694.54, 1702.45, 1710.28, 1718.03, 1725.69, 1733.27, 1740.78, 1748.21, 1755.56, 1762.85, 1770.06, 1777.21, 1784.29, 1791.30, 1798.26, 1805.15, 1811.98, 1818.75, 1825.46, 1832.11, 1838.71, 1845.26, 1851.75, 1858.19, 1864.58, 1870.92, 1877.20, 1883.44, 1889.64, 1895.78, 1901.88, 1907.93, 1913.94, 1919.91, 1925.83, 1931.71, 1937.54, 1943.34, 1949.10} "Specific entropy (J/kgK)";
  parameter Modelica.SIunits.Density rho_table[122] = {5249.25, 5248.98, 5247.51, 5246.02, 5244.52, 5243.00, 5241.47, 5239.92, 5238.36, 5236.78, 5235.19, 5233.59, 5231.97, 5230.34, 5228.70, 5227.04, 5225.37, 5223.69, 5222.00, 5220.29, 5218.57, 5216.84, 5215.10, 5213.35, 5211.58, 5209.80, 5208.02, 5206.22, 5204.41, 5202.59, 5200.76, 5198.92, 5197.07, 5195.20, 5193.33, 5191.45, 5189.56, 5187.66, 5185.74, 5183.82, 5181.89, 5179.95, 5178.00, 5176.05, 5174.08, 5172.10, 5170.12, 5168.12, 5166.12, 5164.11, 5162.09, 5160.06, 5158.02, 5155.98, 5153.92, 5151.86, 5149.79, 5147.72, 5145.63, 5143.54, 5141.44, 5139.33, 5137.21, 5135.09, 5132.96, 5130.82, 5128.67, 5126.54, 5124.42, 5122.32, 5120.24, 5118.18, 5116.14, 5114.11, 5112.11, 5110.11, 5108.14, 5106.17, 5104.23, 5102.29, 5100.37, 5098.46, 5096.57, 5094.68, 5092.81, 5090.95, 5089.10, 5087.26, 5085.43, 5083.61, 5081.80, 5080.00, 5078.20, 5076.42, 5074.64, 5072.88, 5071.11, 5069.36, 5067.62, 5065.88, 5064.15, 5062.42, 5060.70, 5058.99, 5057.28, 5055.58, 5053.89, 5052.20, 5050.51, 5048.83, 5047.16, 5045.49, 5043.82, 5042.16, 5040.51, 5038.85, 5037.21, 5035.56, 5033.93, 5032.29, 5030.66, 5029.03} "Density (kg/m3)";
  parameter Modelica.SIunits.ThermalConductivity k_table[122] = {13.128, 13.044, 12.605, 12.195, 11.811, 11.451, 11.111, 10.792, 10.490, 10.204, 9.934, 9.678, 9.434, 9.203, 8.982, 8.772, 8.572, 8.380, 8.197, 8.021, 7.853, 7.692, 7.538, 7.389, 7.246, 7.109, 6.977, 6.849, 6.727, 6.608, 6.494, 6.383, 6.276, 6.173, 6.073, 5.976, 5.882, 5.792, 5.703, 5.618, 5.535, 5.455, 5.376, 5.300, 5.227, 5.155, 5.085, 5.017, 4.951, 4.886, 4.823, 4.762, 4.702, 4.644, 4.587, 4.532, 4.478, 4.425, 4.373, 4.323, 4.274, 4.225, 4.178, 4.132, 4.087, 4.043, 4.000, 3.990, 3.980, 3.971, 3.961, 3.951, 3.942, 3.932, 3.923, 3.913, 3.904, 3.895, 3.885, 3.876, 3.867, 3.858, 3.848, 3.839, 3.830, 3.821, 3.812, 3.803, 3.795, 3.786, 3.777, 3.768, 3.759, 3.751, 3.742, 3.733, 3.725, 3.716, 3.708, 3.699, 3.691, 3.683, 3.674, 3.666, 3.658, 3.650, 3.641, 3.633, 3.625, 3.617, 3.609, 3.601, 3.593, 3.585, 3.577, 3.569, 3.562, 3.554, 3.546, 3.538, 3.531, 3.523} "Thermal conductivity (W/mK)";
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)), Documentation(info="<html><img src=\"modelica://SolarTherm/Resources/Properties_Fe2O3.png\"></html>"));
end Fe2O3;