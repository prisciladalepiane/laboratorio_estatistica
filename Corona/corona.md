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
# library(formattable)


porcent <- function(x){
  y = paste(round(x*100,2), '%')
  return(y)
}
```


# Introdução: {-}

A Covid-19 é uma infecão respiratória aguda causada pelo coronavírus
SARS-CoV-2, potencialmente grave, de elevada transmissibilidade e de distribuição global.

Os dados são referentes a casos notificados de covid-19 em Mato Grosso, no ano de 2021.

 
Fonte: <a href="http://www.saude.mt.gov.br/painelcovidmt2/"
target="_blank">Secretaria de Estado de Saúde de Mato Grosso </a>



# Conjunto de dados: {-}



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
dados_corona <- dados_corona_total %>% drop_na(-DataModificacaoObito)
```



```r
# Ajuste dos dados
dados_corona_total <- dados_corona_total %>% 
  mutate(idade = as.numeric(idade),
         ProfissionalSeguranca = ifelse(ProfissionalSeguranca == 'N?o', 'Não',ProfissionalSeguranca),
         ProfissionalSaude = ifelse(ProfissionalSaude == 'N?o', 'Não',ProfissionalSaude))
```

# Situação: {-}

No ano de 2021 foram registrados 579.663 casos de covid-19 em Mato
Grosso. Desses casos, 94,5% dos infectados foram recuperados, 2,4% morreram
por causa da doença.


```r
# Situação, total de obitos

total <- nrow(dados_corona_total)

a <- dados_corona_total %>%
  group_by(Situacao) %>%
  summarise(n = n(), '%' = porcent(n/total)) 

DT::datatable(a, options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-1896af110c85ba2180ce" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-1896af110c85ba2180ce">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["Em Monitoramento","Óbito","Óbito por Outras Causas","Recuperado",null],[17516,13892,95,548093,67],["3.02 %","2.4 %","0.02 %","94.55 %","0.01 %"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Situacao<\/th>\n      <th>n<\/th>\n      <th>%<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```


# Analise por Idade: {-}

### Tabela 1: Numero de casos e óbitos por Faixa Etária

```r
######## Analise por idade  ########

morte <- dados_corona_total %>% filter(Situacao == "Óbito", !is.null(idade))


morte_idade <- 
  morte %>% 
  filter(!is.null(idade)) %>% 
  select(idade) %>% 
  mutate(FaixaEtaria = ifelse(idade >= 0 & idade <= 20, "0 a 20",
                       ifelse(idade > 20 & idade <= 40, "21 a 40",
                       ifelse(idade > 40 & idade <= 60, "41 a 60",
                       ifelse(idade > 60 & idade <= 80, "61 a 80", 
                             "mais de 80"))))) %>% 
            group_by(FaixaEtaria) %>% 
            summarise(n_obitos = n(), '%' = porcent(n()/nrow(morte)))

idade_casos <- 
  dados_corona_total %>% 
  filter(!is.null(idade)) %>% 
  select(idade) %>% 
  mutate(FaixaEtaria = ifelse(idade >= 0 & idade <= 20, "0 a 20",
                       ifelse(idade > 20 & idade <= 40, "21 a 40",
                       ifelse(idade > 40 & idade <= 60, "41 a 60",
                       ifelse(idade > 60 & idade <= 80, "61 a 80", 
                        "mais de 80"))))) %>% 
            group_by(FaixaEtaria) %>% 
            summarise(n_casos = n(), '% ' = porcent(n()/total))

idade <- idade_casos %>% left_join(morte_idade, by = "FaixaEtaria")

idade1 <- idade %>% rename('nº de casos' = n_casos,
                           'nº de óbitos' =  n_obitos)

DT::datatable(idade1, options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-f22e83006f78dbe212c6" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-f22e83006f78dbe212c6">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["0 a 20","21 a 40","41 a 60","61 a 80","mais de 80"],[74439,254068,184717,58732,7707],["12.84 %","43.83 %","31.87 %","10.13 %","1.33 %"],[79,1161,4451,6169,2032],["0.57 %","8.36 %","32.04 %","44.41 %","14.63 %"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>FaixaEtaria<\/th>\n      <th>nº de casos<\/th>\n      <th>% <\/th>\n      <th>nº de óbitos<\/th>\n      <th>%<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[2,4]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```


```r
# Histograma de idade

par(mfrow=c(1, 2))

hist(dados_corona_total$idade, 
     xlim = c(0,100),
     xlab = "Idade", 
     ylab = "Frequencia",
     main = "Histograma de Casos por Idade")

hist(morte$idade, 
     xlim = c(0,100),
     xlab = "Idade", 
     ylab = "Frequencia",
     main = "Histograma de óbitos por Idade")
```

![](corona_files/figure-html/figures-side-1.png)<!-- -->

### Tabela 2: Porcentagem relativa de mortes por quantidade de casos entre as Faixas Etarias

```r
a <- idade %>% mutate(n = porcent(n_obitos/n_casos)) %>%
  select(FaixaEtaria, n) %>% 
  rename("% Obitos" = n)
  

DT::datatable(a, options = list(dom = 't'), filter = "none", width = "50%")
```

```{=html}
<div id="htmlwidget-3890c2214471bff3e46f" style="width:50%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-3890c2214471bff3e46f">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["0 a 20","21 a 40","41 a 60","61 a 80","mais de 80"],["0.11 %","0.46 %","2.41 %","10.5 %","26.37 %"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>FaixaEtaria<\/th>\n      <th>% Obitos<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

Observa-se um aumento da porcentagem de óbitos causados pelo covid conforme a 
idade aumenta. A maior porcentagem foi para pessoas com mais de 80 anos, sendo 
26,4% dos infectados morreram. Enquanto que para menores de 20 anos a porcentagem 
foi de 0,08%


# Comorbidades

### Tabela 3: Número Comorbidades por Sexo

```r
######## Analise por comorbidade #######

# Porcentagem de comorbidade por sexo
# 
# dados_corona %>%
#   group_by(Sexo, Comorbidade) %>% 
#   count() %>% spread(Sexo,n) %>% 
#   arrange(desc(Comorbidade))

# Numero de casos registrados para cada tipo de comorbidade

#names(dados_corona)[13:18] #Comorbidades


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
<div id="htmlwidget-9a692bb1b7cd597c13cd" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-9a692bb1b7cd597c13cd">{"x":{"filter":"none","vertical":false,"data":[["1","2"],["Feminino","Masculino"],[3659,2655],[6369,5190],[588,528],[12587,10932],[27109,22525],[7533,6467]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Sexo<\/th>\n      <th>Pulmonar<\/th>\n      <th>Obesidade<\/th>\n      <th>Neoplasia<\/th>\n      <th>Diabetes<\/th>\n      <th>Hipertensao<\/th>\n      <th>Cardiovascular<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[2,3,4,5,6,7]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

### Teste Qui-quadrado Relação Gestante Hospitalização


```r
teste <- dados_corona_total %>%
  filter(!is.na(Hospitalizado) &!is.na(Gestante)) %>% 
  group_by(Gestante, Hospitalizado) %>%
  count() %>% spread(Gestante, n) %>% 
  rename( Gestante = Sim, 
          NaoGestante = Não)
teste
```

```
## # A tibble: 2 x 3
## # Groups:   Hospitalizado [2]
##   Hospitalizado NaoGestante Gestante
##   <chr>               <int>    <int>
## 1 Não                569171     3066
## 2 Sim                   501       16
```

```r
chisq.test(teste[,2:3])
```

```
## Warning in chisq.test(teste[, 2:3]): Chi-squared approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  teste[, 2:3]
## X-squared = 58.508, df = 1, p-value = 2.024e-14
```




# Tabelas Cruzadas

### Sexo x Situação 


```r
# Sexo x Situaçao x Hospitaliza??o
dados_corona_total %>%
  filter(!is.na(Situacao)) %>%
  group_by(Sexo,  Situacao) %>%
  count() %>%  spread(Sexo, n) %>%
  DT::datatable(options = list(dom = 't'), filter = "none") 
```

```{=html}
<div id="htmlwidget-62da459d9746d3ef958b" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-62da459d9746d3ef958b">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4"],["Em Monitoramento","Óbito","Óbito por Outras Causas","Recuperado"],[9565,5855,36,288375],[7951,8037,59,259718]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Situacao<\/th>\n      <th>Feminino<\/th>\n      <th>Masculino<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[2,3]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

### Profissional da Segurança x  Hospitalização

```r
dados_corona_total %>%
  filter(!is.na(Hospitalizado) & !is.na(ProfissionalSeguranca)) %>% 
  group_by(ProfissionalSeguranca, Hospitalizado) %>%
  count() %>%  spread(ProfissionalSeguranca, n) %>%
  arrange(desc(Hospitalizado)) %>%
  DT::datatable(options = list(dom = 't'), filter = "none")
```

```{=html}
<div id="htmlwidget-4d5319abcd9adc39abba" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-4d5319abcd9adc39abba">{"x":{"filter":"none","vertical":false,"data":[["1","2"],["Sim","Não"],[517,570553],[1,2896]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Hospitalizado<\/th>\n      <th>Não<\/th>\n      <th>Sim<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[2,3]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```














