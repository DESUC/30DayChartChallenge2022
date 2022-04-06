library(tidyverse)
library(readxl)
library(ggrepel)
library(prismatic)

# Función para guardar gráfico

gg_save_desuc <- function(gg_chart, name,
                          width = 22,
                          height = 13) {
  ggsave(filename = paste0('output/', name),
         plot = last_plot(),
         width = width,
         height = height,
         units = 'cm')
}

# Base extraída de los resultados de encuesta bicentenario: https://encuestabicentenario.uc.cl/resultados/

bicen <- readxl::read_xlsx("input/slopes.xlsx")

afirmaciones_color <- c("#9e398f", "#ebd883", "#eb6cd9", "#54ebe1", "#419e98", "#368C9E")

# Orden de items ----
bicen$item <- fct_reorder2(bicen$item,
                           bicen$ano, bicen$prop,
                           function(x, y) mean(y[x == 2021]))

# Largo de las etiquetas ----
bicen <- bicen %>%  
  mutate(item_lb = fct_relabel(item, stringr::str_wrap, width = 35)) 

# Gráfico ----
ggplot(data = bicen, 
       aes(x = ano, y = prop, group = item)) +
  geom_line(aes(color = item), size = 2) +
  ggrepel::geom_label_repel(data = ~filter(., ano == "2021"), 
                            aes(label = item_lb,
                                colour = stage(item, 
                                               after_scale = prismatic::clr_darken(colour, 0.3))),
                            nudge_x = 0.5,
                            direction = 'y',
                            min.segment.length = 0,
                            hjust = 'left',
                            size = 4) +
  geom_point(colour = 'white',
             size = 8) +
  geom_point(aes(colour = stage(item, 
                                after_scale = alpha(colour, alpha = .3))),
             size = 8) +
  geom_text(aes(label = round(prop)), 
            size = 5) +
  scale_x_continuous(position = "top",
                     breaks = unique(bicen$ano),
                     expand = expansion(mult = c(0.1, 0.5))) +
  labs(title = "¿Cuál cree usted que es la probabilidad o \nchance que tiene en este país...?",
       subtitle = "% Muy alta + Bastante alta",
       caption = "Encuesta Bicentenario 2011-2021") +
  theme_minimal()+
  coord_cartesian(clip = 'off') +
  theme(legend.position = "none") +
  scale_color_manual(values = afirmaciones_color) +
  scale_fill_manual(values = afirmaciones_color) +
  theme(panel.border     = element_blank(),
        axis.title.y     = element_blank(),
        axis.text.y      = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.title.x       = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x.top    = element_text(size=14),
        axis.ticks       = element_blank(),
        plot.title       = element_text(size=22, face = "bold", hjust = 0.5),
        plot.subtitle    = element_text(hjust = 0.5, size = 14))

gg_save_desuc(width = 25,
              height = 25,
              name = 'slopes_1.png')

gg_save_desuc(width = 50,
              height = 25,
              name = 'slopes_2.png')
 