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
# Pacotes
#devtools::install_github("renkun-ken/formattable")

library(tidyverse)
library(formattable)
```


# Introdução: {-}

A Covid-19 é uma infecão respiratória aguda causada pelo coronavírus
SARS-CoV-2, potencialmente grave, de elevada transmissibilidade e de distribuição global.
No ano de 2021 foram registrados 579.663 casos de covid-19 em Mato
Grosso, com 13.892 casos de mortes.

## Descrição dos dados: {-}

Dados referentes a casos notificados de covid-19 em Mato Grosso, no ano de 2021.

 
Fonte: <a href="http://www.saude.mt.gov.br/painelcovidmt2/"
target="_blank">Secretaria de Estado de Saúde de Mato Grosso </a>

# Conjunto de dados {-}



```r
dados_corona_total <- readxl::read_excel("C:/Users/USER/Laboratorio/Corona/dados_corona.xlsx")

glimpse(dados_corona_total)
```

```
## Rows: 579,663
## Columns: 25
## $ CodigoIBGERegiao      <chr> "5101", "5101", "5101", "5101", "5101", "5101", ~
## $ RegiaoSaude           <chr> "Médio Araguaia", "Médio Araguaia", "Médio Aragu~
## $ CodigoIBGE            <chr> "510706", "510706", "510706", "510706", "510706"~
## $ Municipio             <chr> "Querência", "Querência", "Querência", "Querênci~
## $ DataNotificacao       <chr> "08/07/2020 00:00:00", "07/06/2020 00:00:00", "0~
## $ idade                 <chr> "68", "42", "67", "38", "7", "40", "7", "26", "3~
## $ Sexo                  <chr> "Masculino", "Masculino", "Masculino", "Feminino~
## $ RacaCor               <chr> "Branca", NA, NA, "Parda", "Parda", "Parda", "Br~
## $ ProfissionalSaude     <chr> "Não", NA, NA, "Não", "Não", "Não", "Não", NA, N~
## $ ProfissionalSeguranca <chr> "Não", NA, NA, "Não", "Não", "Não", "Não", NA, N~
## $ DataInicioSintomas    <chr> "29/06/2020 00:00:00", "02/06/2020 00:00:00", "0~
## $ Comorbidade           <chr> "Sim", "Não", "Sim", "Não", "Sim", "Não", "Não",~
## $ Cardiovascular        <chr> NA, "Não", "Sim", "Não", "Sim", "Não", "Não", "N~
## $ Diabetes              <chr> "Sim", "Não", "Não", "Não", "Não", "Não", "Não",~
## $ Hipertensao           <chr> "Sim", "Não", "Não", "Não", "Não", "Não", "Não",~
## $ Neoplasia             <chr> NA, "Não", "Não", "Não", "Não", "Não", "Não", "N~
## $ Obesidade             <chr> NA, "Não", "Não", "Não", "Não", "Não", "Não", "N~
## $ Pulmonar              <chr> NA, "Não", "Não", "Não", "Não", "Não", "Não", "N~
## $ Situacao              <chr> "Óbito", "Recuperado", "Recuperado", "Recuperado~
## $ Hospitalizado         <chr> "Não", "Não", "Não", "Não", "Não", "Não", "Não",~
## $ FechamentoCaso        <chr> "Confirmado Clínico", "Confirmado Laboratorial",~
## $ DataModificacaoObito  <chr> "25/07/2020 10:19:41", NA, NA, NA, NA, NA, NA, N~
## $ DataEncerramentoCaso  <chr> "21/07/2020 00:00:00", "19/06/2020 00:00:00", "2~
## $ Gestante              <chr> "Não", NA, NA, "Não", "Não", "Não", "Não", NA, N~
## $ Seq_Row_Number        <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10~
```



```r
# Ajuste dos dados
dados_corona_total <- dados_corona_total %>% 
  mutate(idade = as.numeric(idade),
         ProfissionalSeguranca = ifelse(ProfissionalSeguranca == 'N?o', 'Não',ProfissionalSeguranca),
         ProfissionalSaude = ifelse(ProfissionalSaude == 'N?o', 'Não',ProfissionalSaude))
```

# Análises:


```r
# Situação, total de obitos
a <- dados_corona_total %>% group_by(Situacao) %>%  count() 

DT::datatable(a, options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-7d37ab8ed832f596730e" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-7d37ab8ed832f596730e">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["Em Monitoramento","Óbito","Óbito por Outras Causas","Recuperado",null],[17516,13892,95,548093,67]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Situacao<\/th>\n      <th>n<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```




```r
# Removido os dados faltantes
dados_corona <- dados_corona_total %>%
  drop_na(-DataModificacaoObito)

# Calculo de dados faltantes
a <- dados_corona_total %>% nrow() # Quantidade de casos registrados

b <- dados_corona %>% nrow() # Quantidade sem dados faltantes

b/a*100 # calculo da porcentagem
```

```
## [1] 80.47331
```

O conjunto de dados possui 579.663 registros de casos de covid, ao remover os registros
com informações incompletas, o total é 466.474, que representa 80.47% do total.



```r
######## Analise por idade  ########

Idade <- 
  dados_corona %>% 
  select(idade) %>% 
  mutate(FaixaEtaria = ifelse(idade <= 20, "0 a 20",
                       ifelse(idade > 20 & idade <= 40, "21 a 40",
                       ifelse(idade > 40 & idade <= 60, "41 a 60",
                       ifelse(idade > 60 & idade <= 80, "61 a 80", 
                       ifelse(idade > 80, "mais de 80", " ")))))) %>% 
            group_by(FaixaEtaria) %>% 
            summarise(porcentagem = n()/nrow(dados_corona)*100)
DT::datatable(Idade, options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-a6620e45b75db648be1c" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-a6620e45b75db648be1c">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["0 a 20","21 a 40","41 a 60","61 a 80","mais de 80"],[12.93619794458,44.7120311099868,31.7432482839344,9.48262925693608,1.12589340456274]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>FaixaEtaria<\/th>\n      <th>porcentagem<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```



```r
# Histograma de idade
hist(dados_corona_total$idade, 
     xlim = c(0,100),
     xlab = "Idade", 
     ylab = "Frequencia",
     main = "Histograma de Casos por Idade")
```

![](corona_files/figure-html/unnamed-chunk-7-1.png)<!-- -->




```r
######## Analise por comorbidade #######

# Porcentagem de comorbidade por sexo

dados_corona %>%
  group_by(Sexo, Comorbidade) %>% 
  count() %>% spread(Sexo,n) %>% 
  arrange(desc(Comorbidade))
```

```
## # A tibble: 2 x 3
## # Groups:   Comorbidade [2]
##   Comorbidade Feminino Masculino
##   <chr>          <int>     <int>
## 1 Sim            41898     32856
## 2 Não           204751    186969
```

```r
# Numero de casos registrados para cada tipo de comorbidade

names(dados_corona)[13:18] #Comorbidades
```

```
## [1] "Cardiovascular" "Diabetes"       "Hipertensao"    "Neoplasia"     
## [5] "Obesidade"      "Pulmonar"
```

```r
comorbidade <- 
  dados_corona_total %>%
  filter(Cardiovascular == 'Sim') %>% 
  group_by(Sexo, Cardiovascular) %>% 
  count() %>% 
  spread(Cardiovascular, n) %>% 
  rename(Cardiovascular = Sim) 


comorbidade <- 
dados_corona_total %>%
  filter(Hipertensao == 'Sim') %>% 
  group_by(Sexo, Hipertensao) %>% 
  count() %>% 
  spread(Hipertensao, n) %>% 
  rename(Hipertensao = Sim) %>% 
  left_join(comorbidade)

comorbidade <- 
dados_corona_total %>%
  filter(Diabetes == 'Sim') %>% 
  group_by(Sexo, Diabetes) %>% 
  count() %>% 
  spread(Diabetes, n) %>% 
  rename(Diabetes = Sim) %>% 
  left_join(comorbidade) 

comorbidade <- 
dados_corona_total %>%
  filter(Neoplasia == 'Sim') %>% 
  group_by(Sexo, Neoplasia) %>%
  count()  %>% 
  spread(Neoplasia, n) %>% 
  rename(Neoplasia = Sim) %>% 
  left_join(comorbidade)

comorbidade <- 
dados_corona_total %>%
  filter(Obesidade == 'Sim') %>% 
  group_by(Sexo,  Obesidade) %>% 
  count() %>% 
  spread(Obesidade, n) %>% 
  rename(Obesidade = Sim) %>% 
  left_join(comorbidade) 

comorbidade <- 
  dados_corona_total %>%
  filter(Pulmonar == 'Sim') %>% 
  group_by(Sexo,  Pulmonar) %>% 
  count() %>% 
  spread(Pulmonar, n) %>% 
  rename(Pulmonar = Sim) %>% 
  left_join(comorbidade) 

DT::datatable(comorbidade, options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-c08fe7b9c43867d13bcf" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-c08fe7b9c43867d13bcf">{"x":{"filter":"none","vertical":false,"data":[["1","2"],["Feminino","Masculino"],[3659,2655],[6369,5190],[588,528],[12587,10932],[27109,22525],[7533,6467]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Sexo<\/th>\n      <th>Pulmonar<\/th>\n      <th>Obesidade<\/th>\n      <th>Neoplasia<\/th>\n      <th>Diabetes<\/th>\n      <th>Hipertensao<\/th>\n      <th>Cardiovascular<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[2,3,4,5,6,7]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

# Tabelas Cruzadas

Sexo x Situação x Hospitalização


```r
# Sexo x Situaçao x Hospitaliza??o
dados_corona_total %>%
  filter(!is.na(Situacao)) %>% 
  group_by(Sexo,Hospitalizado, Situacao) %>%
  count() %>%  spread(Hospitalizado, n) %>% 
  DT::datatable( options = list(dom = 't'),filter = "none")
```

```{=html}
<div id="htmlwidget-8e3fcfd82b8f76e5869d" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-8e3fcfd82b8f76e5869d">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8"],["Feminino","Feminino","Feminino","Feminino","Masculino","Masculino","Masculino","Masculino"],["Em Monitoramento","Óbito","Óbito por Outras Causas","Recuperado","Em Monitoramento","Óbito","Óbito por Outras Causas","Recuperado"],[9382,5846,36,288320,7756,8035,59,259645],[183,9,null,55,195,2,null,73]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Sexo<\/th>\n      <th>Situacao<\/th>\n      <th>Não<\/th>\n      <th>Sim<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[3,4]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

Profissional da Seguran?a x Situa??o x Hospitaliza??o


```r
dados_corona %>%
  group_by(ProfissionalSeguranca,Hospitalizado, Situacao) %>%
  count() %>%  spread(ProfissionalSeguranca, n) %>% 
  arrange(desc(Hospitalizado))
```

```
## # A tibble: 7 x 4
## # Groups:   Hospitalizado, Situacao [7]
##   Hospitalizado Situacao                   Não   Sim
##   <chr>         <chr>                    <int> <int>
## 1 Sim           Em Monitoramento             6     1
## 2 Sim           Óbito                       10    NA
## 3 Sim           Recuperado                 111    NA
## 4 Não           Em Monitoramento           624     3
## 5 Não           Óbito                     8909    56
## 6 Não           Óbito por Outras Causas     62    NA
## 7 Não           Recuperado              454362  2330
```

Gestantes x Situaçao x Hospitalização


```r
# Gestantes x Situa??o x Hospitaliza??o
dados_corona %>%
  group_by(Gestante,Hospitalizado, Situacao) %>%
  count() %>%  spread(Hospitalizado, n)
```

```
## # A tibble: 8 x 4
## # Groups:   Gestante, Situacao [8]
##   Gestante Situacao                   Não   Sim
##   <chr>    <chr>                    <int> <int>
## 1 Não      Em Monitoramento           618     7
## 2 Não      Óbito                     8925    10
## 3 Não      Óbito por Outras Causas     60    NA
## 4 Não      Recuperado              454230   108
## 5 Sim      Em Monitoramento             9    NA
## 6 Sim      Óbito                       40    NA
## 7 Sim      Óbito por Outras Causas      2    NA
## 8 Sim      Recuperado                2462     3
```















