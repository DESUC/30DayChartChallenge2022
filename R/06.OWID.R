# Carga de paquetes

library(tidyverse)
library(sjmisc)
library(extrafont)
library(ggrepel)
library(ggsci)

# Definiciones generales

## Theme

theme_desuc <- list(theme_minimal(base_family = 'Bahnschrift'),
                    theme(text = element_text(size = 20),
                          plot.title.position = 'plot',
                          legend.position = 'top',
                          legend.text = element_text(size = rel(.9), color = 'grey89'),
                          legend.title = element_blank(),
                          plot.caption = element_text(color = 'grey89', size = rel(0.7)),
                          plot.title = element_text(color = "grey89", face = "bold", size = rel(2.2), family = "Roboto Condensed"),
                          plot.subtitle = element_text(color = 'grey89', size = rel(1.5)),
                          axis.title = element_text(size = rel(1.1), color = "grey89"),
                          axis.text = element_text(size = rel(0.7), color = "grey89"),
                          panel.grid = element_line(color = "grey59"),
                          plot.background = element_rect(fill = 'grey20', color = NA)))

# Guardar

gg_save_desuc <- function(gg_chart, name,
                          width = 50,
                          height = 25) {
  ggsave(filename = paste0('output/', name),
         plot = gg_chart,
         width = width,
         height = height,
         units = 'cm')
}

# Lectura y procesamiento base. Obtenidas a partir de: https://ourworldindata.org/human-rights

expresion <- read_csv('input/freedom-of-expression.csv') %>% 
  filter(Year == 2021) %>% 
  select(Entity, freeexpr_vdem_owid)

asociacion <- read_csv('input/freedom-of-association.csv') %>% 
  filter(Year == 2021) %>% 
  select(Entity, freeassoc_vdem_owid)

df <- left_join(expresion,
                asociacion,
                by = 'Entity')

continentes <- countrycode::codelist %>% #acá obtener y agregamos el dato de continente por país
  select(country.name.en, continent,region) %>% 
  rename(Entity = country.name.en) 

df <- left_join(df,
                continentes,
                by = 'Entity') %>% 
  filter(!(is.na(continent)))


set.seed(123)
muestra <- df %>% #seleccionamos una muestra estratificada por continente de tamaño n=5 por estrato
  group_by(continent) %>%
  sample_n(size=5)

df <- bind_rows(muestra,
                df %>% filter(Entity == 'Chile')) %>% #agregamos Chile de manea forzosa
  mutate(continent = case_when(continent == 'Americas' ~ 'América',
                              continent == 'Africa' ~ 'África',
                              continent == 'Europe' ~ 'Europa',
                              continent == 'Oceania' ~ 'Oceanía',
                              T ~ 'Asia'))

rm(asociacion,expresion,continentes,muestra)

# Gráfico

gg1 <- ggplot(df, aes(x=freeexpr_vdem_owid, y=freeassoc_vdem_owid, color=continent, label=Entity)) +
  geom_point(size = 6) +
  geom_text_repel(aes(color = continent), show.legend = FALSE, family = 'Bahnschrift', size = 8, max.overlaps = 13) +
  ggsci::scale_color_futurama() +
  scale_y_continuous(limits = c(0,1)) + 
  labs(title = 'Relación entre\nLibertad de asociación y de expresión',
       subtitle = "De algunos países del mundo, según continente",
       x = "Índice de Libertad de expresión",
       y = "Índice de Libertad de asociación",
       caption = "Fuente: Our World in Data, 2021") +
  geom_curve(x = .70, y = .99, xend = .835, yend = .87, curvature = -0.2,
    arrow = arrow(length = unit(0.03, "npc"))) +
  annotate(geom = "text", x = .6, y = .99, label = "Chile", hjust = "left", family = 'Bahnschrift', size = 8, color = "#C71000FF") +
  theme_desuc 

gg_save_desuc(gg1, 
              width = 25,
              'day6_OWID_1.png')

gg2 <- ggplot(df, aes(x=freeexpr_vdem_owid, y=freeassoc_vdem_owid, color=continent, label=Entity)) +
  geom_point(size = 6, alpha = .7) +
  geom_text_repel(show.legend = FALSE, family = 'Bahnschrift', size = 8, max.overlaps = 13) +
  ggsci::scale_color_futurama() +
  scale_y_continuous(limits = c(0,1)) + 
  labs(title = 'Relación entre\nLibertad de asociación y de expresión',
       subtitle = "De algunos países del mundo, según continente",
       x = "Índice de Libertad de expresión",
       y = "Índice de Libertad de asociación") +
  theme_desuc 

gg_save_desuc(gg2, 
              'day6_OWID_2.png')