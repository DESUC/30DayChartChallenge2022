library(tidyverse)
library(png)
library(magick)
library(cowplot)

# Agregado ----

gg_lorde <- ggplot() +
  # ggplot(aes(x = year, y = binary)) +
  # geom_bar(stat = "identity", width = 0.1, fill = "#03277D") +
  geom_hline(yintercept = 0, color = "white") +
  scale_x_continuous(breaks = seq(2011,2024,1), limits = c(2011,2022)) +
  theme_void(base_family = "Roboto Condensed") +
  labs(title = "#30DayChartChallenge2022: Conexiones",
       subtitle = "Lorde dijo una vez 'let me be your ruler~' pensando en Chile.\nElecciones presidenciales chilenas y lanzamientos de álbumes de Lorde.\n¿Predicción de la actuación de los gobiernos? ¿Una mera coincidencia? No lo creo.",
       caption = "Fuente: Lorde me lo dijo en un sueño.") +
  theme(plot.title = element_text(family = "Courier", face = "bold", size = 14, color = "#F7AB4F"),
        plot.margin = margin(2, 0.5, 1, 0.5, "cm"),
        plot.subtitle = element_text(size = 12, color = "white"),
        plot.caption = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, colour = "white"),
        axis.ticks.x = element_line(colour = "white", lineend = "round"),
        axis.ticks.length = unit(-.5, "cm"),
        panel.background = element_rect(fill="black"),
        panel.grid.major = element_line(colour = "black"),
        plot.background = element_rect(fill="black")) 

gg_lorde <- gg_lorde +
  annotate(geom = "text", x = 2013, y = 0.05, family = "Roboto Condensed", fontface = "bold", 
           color = "white", angle = 90, hjust = 0, size = 4,
           label = "Lanzamiento de album: 2013-09-27\nElecciones chilenas: 2013-11-17") +
  annotate("segment", x = 2013.7, xend = 2013.7, y = 0, yend = 1, colour = "white") +
  annotate("segment", x = 2013.9, xend = 2013.9, y = 0, yend = 1, colour = "white") +
  annotate(geom = "text", x = 2017, y = 0.05, family = "Roboto Condensed", fontface = "bold", 
           color = "white", angle = 90, hjust = 0, size = 4,
           label = "Lanzamiento de album: 2017-06-16\nElecciones chilenas: 2017-11-19") +
  annotate("segment", x = 2017.55, xend = 2017.55, y = 0, yend = 1, colour = "white") +
  annotate("segment", x = 2017.9, xend = 2017.9, y = 0, yend = 1, colour = "white") +
  annotate(geom = "text", x = 2021, y = 0.05, family = "Roboto Condensed", fontface = "bold", 
           color = "white", angle = 90, hjust = 0, size = 4,
           label = "Lanzamiento de album: 2021-08-21\nElecciones chilenas: 2021-11-21") +
  annotate("segment", x = 2021.6, xend = 2021.6, y = 0, yend = 1, colour = "white") +
  annotate("segment", x = 2021.9, xend = 2021.9, y = 0, yend = 1, colour = "white") 

gg_lorde               
       
gg_lorde_r <- ggdraw(gg_lorde) +
  draw_image("input/pure_heroine-modified.png", scale = 0.2, x = -0.33, y = 0.15) +
  draw_image("input/melodrama-modified.png", scale = 0.2, x = -0.03, y = 0.15) +
  draw_image("input/solar_powe-modified.png", scale = 0.2, x = 0.28, y = 0.15) 

gg_lorde_r

ggsave("output/day17_conexiones.png", gg_lorde_r, device = "png", width = 7, height = 7)

