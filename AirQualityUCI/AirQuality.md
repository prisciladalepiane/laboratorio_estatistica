---
title: "Laboratório de estatística"
author: "Priscila Dalepiane"
date: "2022"
output:
  html_document:
    code_folding: hide
    keep_md: yes

---


```r
require(forecast)
require(highcharter)
require(tidyverse)
```

<a href="https://archive.ics.uci.edu/ml/datasets/Air+Quality"
target="_blank">Dados fonte</a>

# Descrição dos dados: {-}


# Conjunto de dados {-}



```r
air <- readxl::read_excel("C:/Users/USER/Laboratorio/AirQualityUCI/AirQualityUCI.xlsx")

glimpse(air)
```

```
## Rows: 9,357
## Columns: 15
## $ Date            <dttm> 2004-03-10, 2004-03-10, 2004-03-10, 2004-03-10, 2004-~
## $ Time            <dttm> 1899-12-31 18:00:00, 1899-12-31 19:00:00, 1899-12-31 ~
## $ `CO(GT)`        <dbl> 2.6, 2.0, 2.2, 2.2, 1.6, 1.2, 1.2, 1.0, 0.9, 0.6, -200~
## $ `PT08.S1(CO)`   <dbl> 1360.00, 1292.25, 1402.00, 1375.50, 1272.25, 1197.00, ~
## $ `NMHC(GT)`      <dbl> 150, 112, 88, 80, 51, 38, 31, 31, 24, 19, 14, 8, 16, 2~
## $ `C6H6(GT)`      <dbl> 11.881723, 9.397165, 8.997817, 9.228796, 6.518224, 4.7~
## $ `PT08.S2(NMHC)` <dbl> 1045.50, 954.75, 939.25, 948.25, 835.50, 750.25, 689.5~
## $ `NOx(GT)`       <dbl> 166, 103, 131, 172, 131, 89, 62, 62, 45, -200, 21, 16,~
## $ `PT08.S3(NOx)`  <dbl> 1056.25, 1173.75, 1140.00, 1092.00, 1205.00, 1336.50, ~
## $ `NO2(GT)`       <dbl> 113, 92, 114, 122, 116, 96, 77, 76, 60, -200, 34, 28, ~
## $ `PT08.S4(NO2)`  <dbl> 1692.00, 1558.75, 1554.50, 1583.75, 1490.00, 1393.00, ~
## $ `PT08.S5(O3)`   <dbl> 1267.50, 972.25, 1074.00, 1203.25, 1110.00, 949.25, 73~
## $ T               <dbl> 13.600, 13.300, 11.900, 11.000, 11.150, 11.175, 11.325~
## $ RH              <dbl> 48.875, 47.700, 53.975, 60.000, 59.575, 59.175, 56.775~
## $ AH              <dbl> 0.7577538, 0.7254874, 0.7502391, 0.7867125, 0.7887942,~
```
