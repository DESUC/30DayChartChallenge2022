# Carga de paquetes

library(tidyverse)
# library(sjmisc)
library(extrafont)
library(readxl)
library(ggrepel)
library(ggsci)
# library(showtext)
library(ggtext)

# Definiciones generales

## Theme

theme_desuc <- list(theme_minimal(base_family = 'Roboto Condensed'),
                    theme(text = element_text(size = 20),
                          plot.title.position = 'plot',
                          legend.position = 'none',
                          plot.caption = element_markdown(color = 'grey89', size = rel(0.9)),
                          plot.title = element_markdown(color = "white", face = "bold", size = rel(2.3), family = "Roboto Condensed"),
                          plot.subtitle = element_text(color = 'grey89', size = rel(1.7)),
                          axis.title = element_text(size = rel(1.1), color = "grey89"),
                          axis.title.x = element_blank(),
                          axis.text = element_text(size = rel(1.2), color = "grey89"),
                          panel.grid = element_line(color = "grey59"),
                          panel.grid.major.x = element_blank(),
                          plot.background = element_rect(fill = 'black', color = NA)))

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

# Lectura y procesamiento base. Obtenidas a partir de: https://top10.netflix.com/

df <- read_excel("input/all-weeks-countries.xlsx")

paises <- c('Argentina','Bolivia','Chile','Colombia','Venezuela','Peru')

df <- df %>% 
  filter(week == '2022-04-10') %>% 
  filter(category == 'TV') %>% 
  filter(country_name %in% paises) %>% 
  filter(weekly_rank < 6)

# Gráfico

gg <- ggplot(df, aes(x=country_name, y = weekly_rank, group = show_title, color = show_title, label = cumulative_weeks_in_top_10)) + 
  geom_line(size = 5) +
  geom_point(size = 12) +
  scale_y_reverse(minor_breaks = seq(1, 5, 1), name = "Ranking semanal") +
  scale_x_discrete(expand = expansion(mult = c(0.02, 0.05))) + 
  scale_color_futurama() + 
  geom_curve(aes(x=1.4, xend=1.1, y=4.2, yend=4), color = "#84D7E1FF", size = 1.2,
               arrow = arrow(length = unit(0.03, "npc"))) + 
  annotate(geom = "text", x = 1.4, y = 4.4, label = "La Reina\ndel Flow", hjust = "left", family = 'Roboto Condensed', size = 8, color = "#84D7E1FF") +
  geom_curve(aes(x=3.5, xend=3.9, y=4.2, yend=4), color = "#8A4198FF", curvature = -.2, size = 1.2,
             arrow = arrow(length = unit(0.03, "npc"))) + 
  annotate(geom = "text", x = 3.2, y = 4.5, label = "Pablo Escobar\nel Patrón\ndel mal", hjust = "left", family = 'Roboto Condensed', size = 8, color = "#8A4198FF") +
  geom_curve(aes(x=4.7, xend=5, y=4.5, yend=4.85), color = "#5A9599FF", curvature = -0.2, size = 1.2,
             arrow = arrow(length = unit(0.03, "npc"))) + 
  annotate(geom = "text", x = 4.4, y = 4.5, label = "Pasión de\ngavilanes", hjust = "left", family = 'Roboto Condensed', size = 8, color = "#5A9599FF") +
  ggrepel::geom_label_repel(data = ~filter(., country_name == "Venezuela"), 
                            aes(label = show_title,color = show_title),
                            fill = "black",
                            family = "Roboto Condensed",
                            label.size = NA,
                            nudge_x = .8,
                            nudge_y = .4,
                            direction = 'y',
                            segment.size = 1.2,
                            min.segment.length = 0,
                            hjust = 'right',
                            size = 8) +
  labs(title = "Ranking top 5 de
       <span style='color:#db0000;'>NETFLIX</span>",
       subtitle = "Semana 10 de abril de 2022",
       caption = "Fuente:
       <span style='color:#db0000;'>NETFLIX</span>") +
  theme_desuc

gg_save_desuc(gg, 
              'day15_multivariate_1.png')

gg_save_desuc(gg, 
              width = 29,
              'day15_multivariate_2.png')