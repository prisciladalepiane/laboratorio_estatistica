
library(dplyr)
library(lubridate)
library(tidyverse)

dados <- data.table::fread("TraficoSP/urban_traffic.csv")
dados_2 <- data.table::fread("TraficoSP/urbancsv.csv")

glimpse(dados)
glimpse(dados_2)

urban_traffic <- dados_2 %>% mutate(id = 1:nrow(dados_2)) %>% select(id, everything())

dados %>% mutate(Hour = as_date(Hour))



colnames(urban_traffic) <- colnames(dados)

glimpse(urban_traffic1)


glimpse(dados)

dados %>% mutate(a = hm(Hour))

urban_traffic <- urban_traffic %>%
  mutate(Slowness_in_traffic_percent = dados$Slowness_in_traffic_percent)



colSums(urban_traffic)

urban_traffic1 <- 
  urban_traffic %>% select(-c(id, Hour, Slowness_in_traffic_percent)) %>%
  mutate_all(as.factor) %>% 
  bind_cols(select(urban_traffic, c(id, Hour, Slowness_in_traffic_percent)))

esquisse::esquisser(dados)

dados$Hour <- hm(dados$Hour) 


