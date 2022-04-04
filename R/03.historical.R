library(tidyverse)
library(sjmisc)

#Tema gráfico

theme_desuc <- theme_minimal() +
                theme(text = element_text(size = 20, family="Berlin Sans FB", face = "italic", color = 'grey20'),
                     plot.caption = element_text(color = 'grey20', size = rel(0.7)),
                     plot.title = element_text(color = "#DF744A", face = "bold", size = rel(2.2), family = "Berlin Sans FB"),
                     legend.text = element_text(color = 'grey20'),
                     legend.title = element_blank(),
                     panel.grid.major = element_line(colour = "white"),
                     legend.position = "top")


#Guardar

gg_save_desuc <- function(gg_chart, name,
                          width = 22,
                          height = 13) {
  ggsave(filename = paste0('output/', name),
         plot = gg_chart,
         width = width,
         height = height,
         units = 'cm')
}

# Información extraída de: https://www.mifuturo.cl/bases-de-datos-de-matriculados/

# Apertura base

base <- read.csv2("input/OFICIAL_WEB_PROCESO_MAT_2007_al_2021_29_06_2021.csv") %>% 
  janitor::clean_names()

# Arreglo base

base_uc_matricula <- base %>% 
  filter(nombre_instituci_u_fffd_n == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE") %>% 
  filter(nivel_global=="Pregrado") %>% 
  rename(tes_sad = tes_corp_de_administraci_u_fffd_n_delegada,
         tes_sle = tes_servicio_local_educacion) %>% 
  rowwise() %>%
  mutate(tes_estado = sum(tes_municipal, tes_sad, tes_sle, na.rm=TRUE)) %>% 
  mutate(a_o = fct_relabel(a_o, ~str_entre(., ini = "_", fin = "")))

tabla <- base_uc_matricula %>% 
  group_by(a_o) %>% 
  summarise(es= sum(tes_estado, na.rm = T),
            ps= sum(tes_particular_subvencionado, na.rm = T),
            pp= sum(tes_particular_pagado, na.rm = T))

tabla <- tabla %>% 
  rowwise() %>%
  mutate(matricula_total = sum(es, ps, pp, na.rm=TRUE),
         Estatal = round((es/matricula_total)*100),
         PP = round((pp/matricula_total)*100),
         PS = round((ps/matricula_total)*100)) %>% 
  select(-es, -pp, -ps, -matricula_total)

tabla_long <- tabla %>% 
  pivot_longer(
    cols =  c('Estatal', 'PS', 'PP'),
    names_to = "Dependencia",
    values_to = "Matricula")


# Gráfico 

gg<- ggplot(tabla_long, aes(x = fct_rev(a_o), y = Matricula, fill = Dependencia)) +
    geom_bar(position="fill", stat="identity") +
    scale_y_continuous(labels = scales::percent) +
  geom_text(aes(label=Matricula), position=position_fill(vjust = 0.5)) +
    scale_fill_manual(values = c('#DCB239', '#8FD8d2', '#FEDCD2')) +
    labs(title = "Composición Matrícula UC \npregrado 1° año 2007 a 2021",
         subtitle = "Según dependencia del establecimiento \nde procedencia de estudiantes",
         caption = "Base de datos mifuturo.cl\nPS=Particular Subvencionado, PP=Particular Pagado",
         x = "") +
    theme_desuc
  gg
  
  gg_save_desuc(gg, 
                width = 25,
                height = 25,
                'historical_1.png')
  
  gg_save_desuc(gg, 
                width = 50,
                height = 25,
                'historical_2.png')
  