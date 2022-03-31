library(tidyverse)
library(sjmisc)
library(sjlabelled)
library(desuctools)
library(treemapify)

#Tema gráfico

windowsFonts("Roboto" = windowsFont("Roboto"))
theme_desuc <- list(theme_minimal(base_family = 'Roboto'),
                    theme(text = element_text(size = 20),
                          plot.caption = element_text(color = 'grey40', size = rel(0.7)),
                          plot.title = element_text(color = "grey40", face = "bold", size = rel(2.2), family = "Roboto"),
                          plot.subtitle = element_text(color = 'grey40', size = rel(1.5))))


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

base <- read.csv2("input/OFICIAL_WEB_PROCESO_MAT_2021_29_06_2021.csv") %>% 
  janitor::clean_names()

# Arreglo base

base_uc_pregrado <- base %>% 
  filter(nombre_instituci_u_fffd_n == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE") %>% 
  filter(nivel_global=="Pregrado")

base_uc_pregrado <- base_uc_pregrado %>% 
  rename(matricula_primer = total_matriculados_primer_a_u_fffd_o,
         matricula_primer_m = matriculados_mujeres_primer_a_u_fffd_o,
         matricula_primer_h = matriculados_hombres_primer_a_u_fffd_o)

tabla <- base_uc_pregrado %>% 
  group_by(rea_del_conocimiento) %>% 
  summarise(Primero= sum(matricula_primer, na.rm = T),
            Mujer= sum(matricula_primer_m, na.rm = T),
            Hombre= sum(matricula_primer_h, na.rm = T))

tabla_long <- tabla %>% 
  pivot_longer(
    cols =  c('Mujer', 'Hombre'),
    names_to = "sexo",
    values_to = "matricula"
  ) %>% 
  select(-Primero)

# Gráfico

gg <- ggplot(tabla_long, aes(area = matricula, fill = sexo,
                             label = sexo, subgroup = rea_del_conocimiento)) +
  geom_treemap() +
  geom_treemap_subgroup_border(colour = "white", size = 8) +
  geom_treemap_text(colour = "grey50", place = "bottomright",
                    size = 12, grow = FALSE, fontface = "italic") +
  geom_treemap_subgroup_text(place = "centre", grow = FALSE, colour = "grey40",
                             size = 22) +
  scale_fill_manual(values = c('#f4dba0', '#81d2cc')) +
  labs(title = "Matrícula UC por área del \nconocimiento 2021",
       subtitle = "Según sexo",
       caption = "Base de datos mifuturo.cl \nEl area representa el tamaño de la matrícula") +
  theme_desuc +
  theme(legend.position = "none")

# Guardar en dos tamaños

gg_save_desuc(gg, 
              width = 25,
              height = 25,
              'part_to_whole_1.png')



gg_save_desuc(gg, 
              width = 50,
              height = 25,
              'part_to_whole_2.png')



