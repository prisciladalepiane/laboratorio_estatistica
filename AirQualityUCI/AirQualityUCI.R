require(forecast)
require(highcharter)


air <- readxl::read_excel("AirQualityUCI/AirQualityUCI.xlsx")

glimpse(air)

air <- air %>% mutate(Date = date(Date), Time = hour(Time))


hchart(air,type = "line", hcaes(x = Date, y = `CO(GT)`),
       color = "green", name = "Toneladas")

# %>% 
#   hc_title(text = "Produção de Soja em Mato Grosso") %>% 
#   hc_yAxis(title = list(text = "Produção (em toneladas)"))

ts()

help(ts)
                