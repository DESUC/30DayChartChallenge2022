library(tidyverse)
library(readxl)


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

# Base extraída de los resultados de encuesta bicentenario: https://encuestabicentenario.uc.cl/resultados/

bicen <- readxl::read_xlsx("input/slopes.xlsx")

#Gráfico

bicen <- bicen %>%  
  mutate(item_lb = stringr::str_wrap(item, width = 45)) 

gg <- ggplot(data = bicen, aes(x = ano, y = prop, group = item)) +
  geom_line(aes(color = item), size = 2) +
  geom_text(data = bicen %>% filter(ano == "2021"), 
            aes(label = paste0(" * ", item_lb)),   
            hjust = -0.05, 
            vjust = 0.25,
            size = 4) +
  geom_label(aes(label = round(prop)), 
             size = 5, 
             label.padding = unit(0.05, "lines"), 
             label.size = 0.0) +
  scale_x_continuous(limits = c(2011,2028), breaks = c(2011,2013, 2015, 2017, 2019, 2021), position = "top") +
  labs(title = "¿Cuál cree usted que es la probabilidad o \nchance que tiene en este país...?",
       subtitle = "% Muy alta + Bastante alta",
       caption = "Encuesta Bicentenario 2011-2021") +
  theme_minimal()+
  theme(legend.position = "none") +
  scale_color_manual(values = c("#9e398f", "#ebd883", "#eb6cd9", "#54ebe1", "#419e98", "#368C9E")) +
  theme(panel.border     = element_blank(),
        axis.title.y     = element_blank(),
        axis.text.y      = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.title.x     = element_blank(),
        #panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x.top      = element_text(size=14),
        axis.ticks       = element_blank(),
        plot.title       = element_text(size=22, face = "bold", hjust = 0.5),
        plot.subtitle    = element_text(hjust = 0.5, size = 14)) 
gg


gg_save_desuc(gg, 
              width = 25,
              height = 25,
              'slopes_1.png')


gg_save_desuc(gg, 
              width = 50,
              height = 25,
              'slopes_2.png')