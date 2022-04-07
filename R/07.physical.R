library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(desuctools)


dua2 <- read_excel("input/dua2.xlsx")


windowsFonts("Roboto" = windowsFont("Roboto"))
theme_desuc <- list(theme_minimal(base_family = 'Roboto'),
                    theme(text = element_text(size = 20),
                          plot.caption = element_text(color = 'grey40', size = rel(0.8)),
                          plot.title = element_text(color = "grey40", face = "bold", size = rel(1.8), family = "Roboto"),
                          plot.subtitle = element_text(color = 'grey40', size = rel(1.3))))

gg_save_desuc <- function(gg_chart, name,
                          width = 22,
                          height = 13) {
  ggsave(filename = paste0('output/', name),
         plot = gg_chart,
         width = width,
         height = height,
         units = 'cm')
}


# Nombre y poscición de la etiqueta
dua2$id <- seq(1, nrow(dua2))
label_data <-  dua2
number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar  
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)



#Plot
p2 <- ggplot(dua2, aes(x=as.factor(id), y=vis)) + 
  geom_bar(stat="identity", color = "black", fill=alpha("#7FFF00")) +
  ylim(0,36000000) +
  coord_polar(start = 0) + 
  geom_text(data=label_data, aes(x=id, y=vis+10, label=nom, hjust=hjust), color="#551A8B", 
            fontface="bold", alpha=0.7, size=5, angle= label_data$angle, inherit.aes = FALSE ) +
  labs(title = "Physical - Dua Lipa",
       subtitle = "Visualizaciones en youtube",
       caption = "Datos extraídos de: \nhttps://kworb.net/youtube/video/9HDEHj2yzew.html \nLas barras representan la cantidad de visualizaciones \ndel video Physical de Dua Lipa en Youtube")  +
  theme_desuc  +
  theme(
    legend.position = "none",
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank() 
  )

p2

  #Guardar


gg_save_desuc(p2, 
              width = 25,
              height = 25,
              'physical_1.png')



gg_save_desuc(p2, 
              width = 50,
              height = 25,
              'physical_2.png')

