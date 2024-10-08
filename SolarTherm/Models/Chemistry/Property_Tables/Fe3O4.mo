within SolarTherm.Models.Chemistry.Property_Tables;

record Fe3O4
  parameter Modelica.SIunits.Temperature T_table[122] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00} "Absolute temperature (K)";
  parameter Modelica.SIunits.SpecificEnthalpy h_table[122] = {0.00, 1213.00, 7843.00, 14588.00, 21443.00, 28400.00, 35454.00, 42601.00, 49836.00, 57154.00, 64553.00, 72031.00, 79583.00, 87210.00, 94908.00, 102677.00, 110517.00, 118425.00, 126403.00, 134449.00, 142565.00, 150751.00, 159007.00, 167335.00, 175736.00, 184210.00, 192761.00, 201389.00, 210097.00, 218886.00, 227759.00, 236719.00, 245768.00, 254909.00, 264145.00, 273479.00, 282914.00, 292454.00, 302102.00, 311862.00, 321738.00, 331733.00, 341852.00, 352099.00, 362478.00, 372993.00, 383650.00, 394453.00, 405406.00, 416515.00, 427784.00, 439219.00, 450825.00, 462607.00, 474571.00, 486723.00, 505121.00, 513719.00, 522326.00, 530941.00, 539564.00, 548194.00, 556831.00, 565475.00, 574127.00, 582785.00, 591449.00, 600119.00, 608796.00, 617478.00, 626167.00, 634860.00, 643560.00, 652264.00, 660973.00, 669688.00, 678407.00, 687131.00, 695860.00, 704593.00, 713330.00, 722072.00, 730817.00, 739567.00, 748321.00, 757078.00, 765839.00, 774604.00, 783372.00, 792144.00, 800919.00, 809697.00, 818479.00, 827264.00, 836051.00, 844842.00, 853636.00, 862432.00, 871232.00, 880034.00, 888838.00, 897646.00, 906455.00, 915268.00, 924083.00, 932900.00, 941719.00, 950541.00, 959365.00, 968191.00, 977019.00, 985850.00, 994682.00, 1003517.00, 1012353.00, 1021192.00, 1030032.00, 1038874.00, 1047718.00, 1056564.00, 1065412.00, 1074261.00} "Specific enthalpy (J/kg)";
  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_table[122] = {654.62, 656.92, 668.89, 680.12, 690.69, 700.67, 710.13, 719.12, 727.71, 735.94, 743.87, 751.54, 758.99, 766.27, 773.40, 780.43, 787.39, 794.30, 801.20, 808.12, 815.07, 822.09, 829.19, 836.40, 843.75, 851.24, 858.90, 866.75, 874.81, 883.09, 891.62, 900.40, 909.45, 918.79, 928.44, 938.40, 948.70, 959.34, 970.34, 981.72, 993.48, 1005.64, 1018.21, 1031.21, 1044.65, 1058.54, 1072.89, 1087.71, 1103.01, 1118.82, 1135.13, 1151.96, 1169.33, 1187.24, 1205.70, 1224.72, 859.44, 860.28, 861.09, 861.88, 862.64, 863.38, 864.09, 864.79, 865.46, 866.11, 866.75, 867.36, 867.96, 868.54, 869.10, 869.65, 870.18, 870.70, 871.20, 871.69, 872.17, 872.63, 873.08, 873.52, 873.95, 874.36, 874.77, 875.17, 875.55, 875.93, 876.29, 876.65, 877.00, 877.34, 877.67, 878.00, 878.31, 878.62, 878.93, 879.22, 879.51, 879.79, 880.07, 880.34, 880.60, 880.86, 881.11, 881.36, 881.60, 881.83, 882.06, 882.29, 882.51, 882.73, 882.94, 883.15, 883.35, 883.55, 883.75, 883.94, 884.12, 884.31, 884.49, 884.67, 884.84, 885.01} "Specific heat capacity at constant pressure (J/kgK)";
  parameter Modelica.SIunits.SpecificEntropy s_table[122] = {631.07, 635.13, 656.87, 678.28, 699.38, 720.14, 740.59, 760.72, 780.55, 800.06, 819.28, 838.21, 856.86, 875.24, 893.35, 911.21, 928.83, 946.21, 963.37, 980.31, 997.04, 1013.58, 1029.93, 1046.10, 1062.10, 1077.94, 1093.63, 1109.18, 1124.59, 1139.88, 1155.05, 1170.10, 1185.06, 1199.92, 1214.70, 1229.40, 1244.03, 1258.59, 1273.10, 1287.56, 1301.98, 1316.36, 1330.71, 1345.05, 1359.36, 1373.67, 1387.97, 1402.28, 1416.60, 1430.93, 1445.29, 1459.67, 1474.09, 1488.55, 1503.05, 1517.60, 1539.35, 1549.40, 1559.35, 1569.20, 1578.94, 1588.59, 1598.13, 1607.58, 1616.93, 1626.19, 1635.36, 1644.44, 1653.43, 1662.33, 1671.16, 1679.89, 1688.55, 1697.12, 1705.62, 1714.04, 1722.39, 1730.65, 1738.85, 1746.97, 1755.03, 1763.01, 1770.93, 1778.77, 1786.55, 1794.27, 1801.92, 1809.51, 1817.04, 1824.50, 1831.91, 1839.25, 1846.54, 1853.77, 1860.94, 1868.06, 1875.13, 1882.13, 1889.09, 1895.99, 1902.85, 1909.65, 1916.40, 1923.10, 1929.75, 1936.36, 1942.91, 1949.42, 1955.89, 1962.31, 1968.68, 1975.01, 1981.30, 1987.54, 1993.74, 1999.90, 2006.02, 2012.10, 2018.13, 2024.13, 2030.09, 2036.01} "Specific entropy (J/kgK)";
  parameter Modelica.SIunits.Density rho_table[122] = {5149.32, 5149.08, 5147.75, 5146.39, 5145.02, 5143.62, 5142.19, 5140.75, 5139.28, 5137.79, 5136.28, 5134.75, 5133.19, 5131.61, 5130.01, 5128.39, 5126.75, 5125.08, 5123.39, 5121.68, 5119.94, 5118.18, 5116.39, 5114.58, 5112.75, 5110.89, 5109.00, 5107.09, 5105.15, 5103.18, 5101.18, 5099.16, 5097.10, 5095.01, 5092.89, 5090.74, 5088.55, 5086.32, 5084.06, 5081.76, 5079.43, 5077.05, 5074.63, 5072.16, 5069.65, 5067.09, 5064.48, 5061.83, 5059.11, 5056.35, 5053.52, 5050.64, 5047.69, 5044.68, 5041.59, 5038.44, 5035.23, 5032.09, 5029.10, 5026.24, 5023.50, 5020.87, 5018.34, 5015.90, 5013.54, 5011.26, 5009.05, 5006.90, 5004.81, 5002.76, 5000.77, 4998.81, 4996.89, 4995.00, 4993.13, 4991.30, 4989.49, 4987.69, 4985.91, 4984.15, 4982.40, 4980.66, 4978.92, 4977.20, 4975.48, 4973.76, 4972.04, 4970.33, 4968.61, 4966.90, 4965.18, 4963.46, 4961.74, 4960.01, 4958.27, 4956.54, 4954.79, 4953.04, 4951.28, 4949.51, 4947.74, 4945.96, 4944.17, 4942.37, 4940.56, 4938.74, 4936.91, 4935.08, 4933.23, 4931.38, 4929.51, 4927.64, 4925.75, 4923.85, 4921.95, 4920.03, 4918.10, 4916.17, 4914.22, 4912.26, 4910.29, 4908.31} "Density (kg/m3)";
  parameter Modelica.SIunits.ThermalConductivity k_table[122] = {5.297, 5.282, 5.201, 5.123, 5.047, 4.974, 4.902, 4.833, 4.765, 4.700, 4.636, 4.574, 4.513, 4.454, 4.397, 4.341, 4.286, 4.233, 4.181, 4.131, 4.081, 4.033, 3.986, 3.940, 3.895, 3.851, 3.808, 3.766, 3.725, 3.684, 3.645, 3.606, 3.569, 3.532, 3.496, 3.460, 3.425, 3.391, 3.358, 3.325, 3.293, 3.262, 3.231, 3.200, 3.171, 3.141, 3.113, 3.085, 3.057, 3.030, 3.003, 2.977, 2.951, 2.926, 2.901, 2.876, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857, 2.857} "Thermal conductivity (W/mK)";
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)), Documentation(info="<html><img src=\"modelica://SolarTherm/Resources/Properties_Fe3O4.png\"></html>"));
end Fe3O4;