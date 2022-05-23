# Universidade Federal de Mato Grosso
# Aluna: Priscila Dalepiane
# Disciplina: Laborat?rio de estat?stica


# Pacotes
library(tidyverse)
library(readxl)

# Leitura de dados
dados_corona_total <- read_excel("Corona/dados_corona.xlsx")

glimpse(dados_corona_total)

# Peridodo de analise
min(dados_corona_total$DataNotificacao)
max(dados_corona_total$DataNotificacao)

# Ajuste dos dados
dados_corona_total <- dados_corona_total %>% 
  mutate(idade = as.numeric(idade),
         ProfissionalSeguranca = ifelse(ProfissionalSeguranca == 'N?o', 'Não',ProfissionalSeguranca),
         ProfissionalSaude = ifelse(ProfissionalSaude == 'N?o', 'Não',ProfissionalSaude))

# Removido os dados faltantes
dados_corona <- dados_corona_total %>%
  drop_na(-DataModificacaoObito)

# Calculo de dados faltantes
a <- dados_corona_total %>% nrow(); a # Quantidade de casos registrados

b <- dados_corona %>% nrow(); b # Quantidade sem dados faltantes

b/a*100 # calculo da porcentagem


# Situaçao, total de obitos
dados_corona_total %>% group_by(Situacao) %>%  count()

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
Idade


esquisse::esquisser(dados_corona_total)

# Histograma de idade
hist(dados_corona_total$idade, 
     xlim = c(0,100),
     xlab = "Idade", 
     ylab = "Frequencia",
     main = "Histograma de Casos por Idade")

######## Analise por comorbidade #######

# Porcentagem de comorbidade por sexo

dados_corona %>%
  group_by(Sexo, Comorbidade) %>% 
  count() %>% spread(Sexo,n) %>% 
  arrange(desc(Comorbidade))

# Numero de casos registrados para cada tipo de comorbidade

names(dados_corona)[13:18] #Comorbidades


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

comorbidade

comorbidade[,2:7] %>% colSums()

######## Tabelas cruzadas ###############   
# Sexo x Situa??o x Hospitaliza??o
dados_corona_total %>%
  filter(!is.na(Situacao)) %>% 
  group_by(Sexo,Hospitalizado, Situacao) %>%
  count() %>%  spread(Hospitalizado, n) 

dados_corona_total %>%
  filter(!is.na(Situacao)) %>% 
  group_by(Hospitalizado, Situacao) %>%
  count() 

# Profissional da Sa?de x Situa??o x Hospitaliza??o
dados_corona %>%
  group_by(ProfissionalSaude, Hospitalizado, Situacao) %>%
  count() %>% spread(Situacao , n) %>% 
  arrange(desc(Hospitalizado))

# Profissional da Seguran?a x Situa??o x Hospitaliza??o
dados_corona %>%
  group_by(ProfissionalSeguranca,Hospitalizado, Situacao) %>%
  count() %>%  spread(ProfissionalSeguranca, n) %>% 
  arrange(desc(Hospitalizado))

# Gestantes x Situa??o x Hospitaliza??o
dados_corona %>%
  group_by(Gestante,Hospitalizado, Situacao) %>%
  count() %>%  spread(Hospitalizado, n)

# Gestante x Comorbidade x Situa??o
dados_corona %>%
  group_by(Gestante,Comorbidade, Situacao) %>%
  count()


# Gestante x Comorbidade x Hospitaliza??o
dados_corona %>%
  group_by(Gestante,Comorbidade, Hospitalizado) %>%
  count() 

# Gestante x Comorbidade x Hospitaliza??o
teste <- dados_corona %>%
  group_by(Gestante, Hospitalizado) %>%
  count() %>% spread(Gestante, n) %>% 
  rename( Gestante = Sim, 
          NaoGestante = N?o)

teste

# Teste Qui Quadrado

chisq.test(teste[,2:3])

# Total Hospitalizados
dados_corona_total %>% group_by(Hospitalizado) %>% count()

