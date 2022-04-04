# Carga de paquetes

library(tidyverse)
library(sjmisc)
library(extrafont)
library(readxl)
library(labelled)
library(RColorBrewer)

# Definiciones generales

## Theme

theme_desuc <- list(theme_minimal(base_family = 'Roboto Condensed'),
                    theme(text = element_text(size = 20),
                          plot.title.position = 'plot',
                          legend.position = 'top',
                          legend.text = element_text(size = rel(.9)),
                          plot.caption = element_text(color = 'grey40', size = rel(0.7)),
                          plot.title = element_text(color = "grey40", face = "bold", size = rel(2.2), family = "Roboto"),
                          plot.subtitle = element_text(color = 'grey40', size = rel(1.5)),
                          axis.title = element_text(size = rel(0.7)), 
                          plot.background = element_rect(fill = '#D0EBCA', color = NA)))


# Guardar

gg_save_desuc <- function(gg_chart, name,
                          width = 22,
                          height = 13) {
  ggsave(filename = paste0('output/', name),
         plot = gg_chart,
         width = width,
         height = height,
         units = 'cm')
}

# Lectura y procesamiento base

df <- read_excel("input/NominaDeEspeciesSegunEstadoConservacion-Chile_actualizado_17moProcesoRCE_rev04febrero2022.xlsx",
                 sheet = "Estadísticas",
                 range = "B62:L67") #Obtenida a partir de: https://clasificacionespecies.mma.gob.cl/

df <- df %>% 
  rename(tipo_planta = '...1') %>% 
  select(tipo_planta, EX:VU,NT:DD) %>% 
  filter(!(tipo_planta == 'PLANTAS'))

df <- df %>% 
  pivot_longer(!tipo_planta, names_to = "estado_conservacion", values_to = "count") %>% 
  mutate(estado_conservacion = case_when(estado_conservacion == 'EX' ~ 'Extinta',
                                         estado_conservacion == 'EW' ~ 'Extinta en estado silvestre',
                                         estado_conservacion == 'CR' ~ 'Peligro crítico',
                                         estado_conservacion == 'EN' ~ 'En peligro',
                                         estado_conservacion == 'VU' ~ 'Vulnerable',
                                         estado_conservacion == 'NT' ~ 'Casi amenazada',
                                         estado_conservacion == 'LC' ~ 'Preocupación menor',
                                         estado_conservacion == 'DD' ~ 'Datos insuficientes'))

df <- df %>% 
  mutate(estado_conservacion = factor(estado_conservacion,
                                      levels = c('Extinta','Extinta en estado silvestre','Peligro crítico','En peligro','Vulnerable','Casi amenazada','Preocupación menor','Datos insuficientes')))

# Gráfico

gg <- ggplot(df, aes(fill=estado_conservacion, y=count, x=tipo_planta, label = count)) + 
  geom_bar(position="stack", stat="identity", width = .55) + 
  geom_text(data=subset(df,count != 0), size = 6,  position = position_stack(vjust = .5), family = "Roboto Condensed") + 
  scale_fill_brewer(palette = "YlOrRd", direction = -1, guide = guide_legend(title = NULL, reverse = T)) +
  scale_y_continuous(expand = c(0, 1)) +
  labs(title = 'Estado de conservación de\nflora en Chile',
       subtitle = 'Según tipo de planta 🌵🌿🌳🌲',
       x = 'Tipo de planta',
       y = 'Número de especies') + 
  coord_flip() + 
  theme_desuc 

gg_save_desuc(gg, 
              width = 28,
              height = 25,
              'day4_floral_1.png')

gg_save_desuc(gg, 
              width = 50,
              height = 25,
              'day4_floral_2.png')