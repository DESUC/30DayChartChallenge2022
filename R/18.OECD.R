# Carga de paquetes

library(tidyverse)
library(extrafont)
library(readxl)
library(ggsci)

# Definiciones generales

## Theme

theme_desuc <- list(theme_minimal(base_family = 'Roboto Condensed'),
                    theme(text = element_text(size = 20),
                          plot.title.position = 'plot',
                          legend.position = 'right',
                          legend.text=element_text(size=rel(.7)),
                          plot.caption = element_text(color = 'grey29', size = rel(0.5)),
                          plot.title = element_text(color = "grey29", face = "bold", size = rel(2.3), family = "Roboto Condensed"),
                          plot.subtitle = element_text(color = 'grey29', size = rel(1.7)),
                          axis.title = element_text(size = rel(.7), color = "grey29"),
                          axis.text = element_text(size = rel(.9), color = "grey29"),
                          axis.title.y = element_blank(),
                          panel.grid = element_line(color = "grey59"),
                          plot.background = element_rect(fill = '#EBDEF0', color = NA)))

## Guardar

gg_save_desuc <- function(gg_chart, name,
                          width = 50,
                          height = 25) {
  ggsave(filename = paste0('output/', name),
         plot = gg_chart,
         width = width,
         height = height,
         units = 'cm')
}

# Lectura y procesamiento base. Obtenidas a partir de: https://data.oecd.org/eduresource/education-spending.htm/ y https://data.oecd.org/pisa/mathematics-performance-pisa.htm/

gasto <- read.csv("input/DP_LIVE_18042022041836901.csv") %>% 
  filter(TIME==2018) %>% 
  select('ï..LOCATION',Value) %>% 
  rename(gasto = Value)

ptje_pisa <- read.csv("input/DP_LIVE_18042022042109856.csv")

df <- left_join(ptje_pisa,
                gasto,
                by = "ï..LOCATION") %>% 
  filter(!(is.na(gasto))) %>% 
  rename(iso3c = "ï..LOCATION")

paises <- countrycode::codelist %>% 
  select(iso3c, un.name.es, continent)

df <- left_join(df,
                paises,
                by = "iso3c") %>% 
  mutate(continent = case_when(continent == 'Americas' ~ 'América',
                               continent == 'Africa' ~ 'África',
                               continent == 'Europe' ~ 'Europa',
                               continent == 'Oceania' ~ 'Oceanía',
                               T ~ 'Asia'),
         un.name.es = ifelse(iso3c=="GBR", "Reino Unido", un.name.es))

rm(gasto,ptje_pisa,paises)

# Gráfico


gg <- df %>% 
  mutate(un.name.es = fct_reorder(un.name.es,Value)) %>% 
  ggplot( aes(x=un.name.es, y=Value, size=gasto, color=continent)) +
  geom_point(alpha=.6) +
  scale_size(range = c(1, 20), name="% gasto\ndel PIB\nen educación") + 
  scale_y_continuous(breaks = seq(from = 350, to = 550, by = 25))+
  ggsci::scale_color_locuszoom(name="") +
  coord_flip() +
  labs(title = "Relación entre gasto en educación\ny resultados PISA matemáticas",
       subtitle = "En países OECD, año 2018",
       y = "Puntaje prueba PISA matemáticas",
       x = "",
       caption = "Fuente: OECD") +
  guides(colour = guide_legend(override.aes = list(size=8))) + 
  theme_desuc
  
gg_save_desuc(gg, 
              'day18_OECD_1.png')

gg_save_desuc(gg, 
              width = 25,
              'day18_OECD_2.png')