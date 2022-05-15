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
require(lubridate)
```


# Descrição dos dados: {-}

O conjunto de dados contém 9358 ocorrências de respostas médias de uma matriz de 5 sensores químicos de óxido de metal incorporados em um dispositivo multisensor químico de qualidade do ar. </br>
O dispositivo estava localizado no campo em uma área significativamente poluída, a nível rodoviário, dentro de uma cidade italiana. Os dados foram registrados de março de 2004 a fevereiro de 2005 (um ano) representando as mais longas gravações disponíveis livremente de em campo implantados gratuitamente de respostas de dispositivos de sensores químicos de qualidade do ar implantados em campo.</br>
 As concentrações médias horárias do Ground Truth para CO, Hidrocarbonetos Não Metânicos, Benzeno, Óxidos de Nitrogênio Total (NOx) e Dióxido de Nitrogênio (NO2) foram fornecidas por um analisador certificado de referência. </br>
 
<a href="https://archive.ics.uci.edu/ml/machine-learning-databases/00360/"
target="_blank">database</a>

# Conjunto de dados {-}



```r
air <- readxl::read_excel("C:/Users/USER/Laboratorio/AirQualityUCI/AirQualityUCI.xlsx")

air <- air %>% mutate(Date = date(Date), Time = hour(Time))

glimpse(air)
```

```
## Rows: 9,357
## Columns: 15
## $ Date            <date> 2004-03-10, 2004-03-10, 2004-03-10, 2004-03-10, 2004-~
## $ Time            <int> 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ~
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

# Variáveis {-}

<strong>Data:</strong> Data (DD/MM/AAAA) </br>

Hora: Hora (HH.MM.SS)
CO(GT): Concentração média horária real CO em mg/m^3 (analisador de referência)

PT08.S1: (óxido de estanho) resposta média horária do sensor (alvo nominalmente de CO)

NMHC(GT): Concentração média horária real de Hidrocarbonetos Não Metânicos em microg/m^3 (analisador de referência)

C6H6(GT): Concentração média horária real de benzeno em microg/m^3 (analisador de referência)

PT08.S2(NMHC): (titânia) resposta média horária do sensor (alvo nominalmente NMHC)

NO2(GT): Concentração média horária real de NOx em ppb (analisador de referência)

PT08.S3(NOx): (óxido de tungstênio) resposta média horária do sensor (nominalmente direcionado ao NOx)

NO2(GT): Concentração média horária real de NO2 em microg/m^3 (analisador de referência)

PT08.S4(NO2): (óxido de tungstênio) resposta média horária do sensor (nominalmente direcionado ao NO2)

PT08.S5(O3): (óxido de índio) resposta média horária do sensor (alvo nominalmente O3)

T: Temperatura em °C

RH: Umidade Relativa (%)

AH: AH Umidade Absoluta



