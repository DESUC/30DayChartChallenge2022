library(readxl)
library(dplyr)
library(tidyverse)
library(desuctools)
library(ggplot2)
library(gganimate)



daddy <- read_excel("C:/Users/Alex Leyton/Dropbox (ISUC)/ALEX/30diasgrÃ¡ficos/Experiment/daddy.xlsx")
daddy$fecha <- as.Date(daddy$fecha)




windowsFonts("Roboto" = windowsFont("Roboto"))
theme_desuc <- list(theme_minimal(base_family = 'Roboto'),
                    theme(text = element_text(size = 15),
                          plot.caption = element_text(color = 'grey40', size = rel(0.5)),
                          plot.title = element_text(color = "grey40", face = "bold", size = rel(1.2), family = "Roboto"),
                          plot.subtitle = element_text(color = 'grey40', size = rel(0.9))))



# Plot
a <- daddy %>%
  ggplot( aes(x=fecha, y=vis, group=ano, color=ano)) +
  geom_line() +
  geom_point() +
  labs(title = "Experimento: Descontrol, Daddy Yankee",
       subtitle = "Cuando el grupo de control no funciona",
       caption = "Fuente: https://kworb.net/youtube/video/LpoFBlH4wMI.html \nLas líneas representa el número de visualizaciones del video Descontrol en Youtube")  +
  theme_desuc  +
  theme(
    legend.position = "none",
    panel.grid = element_blank() 
  ) +
  ylab("Visualizaciones en Youtube") + xlab ("") +
  transition_reveal(fecha)

a

# Save at gif:
anim_save("Descrontrol.gif",
          height = 3, 
          width = 4, 
          units = "in", 
          res = 150)



