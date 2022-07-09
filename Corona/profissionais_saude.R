# Universidade Federal de Mato Grosso
# Disciplina: Laboratorio de estatistica


# Pacotes
library(tidyverse)
library(readxl)
library(readr)

# Leitura de dados
dados_corona_total <- read_excel("Corona/dados_corona.xlsx")

dados_corona_total <- dados_corona_total %>% 
  mutate(idade = as.numeric(idade))

# Numero de casos Registrados
nrow(dados_corona_total)

# Quantos sao profissionais de saúde
dados_corona_total %>% group_by(ProfissionalSaude) %>% count()

# Filtrar apenas dados de profissionais de saude
corona_prof_saude <- dados_corona_total %>% filter(ProfissionalSaude == 'Sim')


############## Gráfico de Pizza para a variavel Sexo

dist_sexo <- table(corona_prof_saude$Sexo) %>% 
             as.data.frame()

p_sexo <- dist_sexo %>% 
  mutate(p = round(
           Freq/sum(Freq)*100
            ,2)) %>% pull(p)

p_sexo <- paste(p_sexo, "%", sep="")

pie(x = dist_sexo$Freq,
    labels = p_sexo, 
    col = c("#fd45df","blue"),
    main = "Proporção Sexo")

legend("bottomleft",
       pch = 15, 
       col = c("#fd45df","blue"),
       legend =c("Feminino", 
                 "Masculino")
       )

par(mfrow = c(1,2))

############## Histograma para a idade

hist(x = corona_prof_saude$idade,
     xlab = "Idade",
     ylab = "Frequencia",
     main = "Histograma para a idade")

# media de idade
mean(corona_prof_saude$idade)


############## Analise de Situação Feminino X Masculino

situacao <- corona_prof_saude %>% 
            group_by(Sexo, Situacao) %>%  
            count() %>% spread(key = Sexo, value = n) %>% 
            as.data.frame()
            
situacao












