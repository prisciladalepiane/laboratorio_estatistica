require(forecast)
require(tidyverse)
require(highcharter)


air <- readxl::read_excel("AirQualityUCI/AirQualityUCI.xlsx")

air <- air %>% mutate(Date = date(Date), Time = hour(Time))

glimpse(air)

air[,3] %>% filter(`CO(GT)` != -200)

hchart(air,type = "line", hcaes(x = Date, y = `CO(GT)`))









                