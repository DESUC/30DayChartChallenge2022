# Carga de paquetes

library(tidyverse)
library(ggplot2)
library(sf)
library(extrafont)
library(scales)
library(rgl)

# Definiciones generales

## Theme

theme_desuc <- list(theme_minimal(base_family = 'Roboto Condensed'),
                    theme(plot.title.position = 'plot',
                          legend.position = 'right',
                          legend.text = element_text(size = rel(.9), color = 'grey15'),
                          legend.title = element_text(color = 'grey15'),
                          plot.caption = element_text(color = 'grey15', size = rel(0.7)),
                          plot.title = element_text(color = "grey15", face = "bold", size = rel(1.5)),
                          plot.subtitle = element_text(color = 'grey15', size = rel(.9)),
                          axis.title = element_blank(),
                          axis.text = element_blank(),
                          panel.grid = element_blank(),
                          plot.background = element_rect(fill = '#FCF3CF', color = NA)))

# Lectura y procesamiento base. Obtenidas a partir de bases con información cartográfica de INE y Casen de: http://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-en-pandemia-2020#:~:text=Los%20objetivos%20de%20Casen%20en,%2C%20vivienda%2C%20trabajo%20e%20ingresos.

sf_comunas_gs <- readRDS('input/sf_comunas_gs.rds')

if(!exists('casen')){
  casen <- readRDS("input/Casen en Pandemia 2020.rds")
}

casen <- casen %>% 
  filter(comuna %in% sf_comunas_gs$comuna) %>% #filtramos para quedarnos solo con comunas del GS
  select(comuna, id_vivienda, hogar, pco1, expc, ytotcorh, ytrabajocorh) %>% 
  filter(pco1==1) #nos quedamos solo con los jefes de hogar

datos_casen <- casen %>% 
  group_by(comuna) %>% 
  summarise(ingreso_total = weighted.mean(ytotcorh,expc),
            ingreso_trabajo = weighted.mean(ytrabajocorh, expc))

df <- inner_join(datos_casen,
                 sf_comunas_gs,
                 by = 'comuna')

df <- sf::st_as_sf(df)

rm(casen,datos_casen,sf_comunas_gs)

# Gráfico

gg <- df %>% ggplot(aes(fill = ingreso_trabajo)) + 
  geom_sf() +
  scale_fill_gradient(low="#D5D1F8", high="#312271", 
                      name = "", 
                      labels = label_dollar(big.mark = ("."), decimal.mark = ",")) +
  geom_curve(x=-70.7, xend= -70.58, y=-33.2, yend=-33.25, curvature = -0.2, size=.9,
             arrow = arrow(length = unit(0.03, "npc"))) + 
  # annotate(geom = "text", x = -70.9, y =-33.2, label = paste0("Max $",number(max(df$ingreso_trabajo),big.mark = ".", decimal.mark = ",")), hjust = "left", family = 'Roboto Condensed', size = 4, color = "grey15") +
  geom_curve(x=-70.85, xend= -70.7, y=-33.58, yend=-33.5, curvature = -0.2, size=.9,
             arrow = arrow(length = unit(0.03, "npc"))) +
  # annotate(geom = "text", x = -70.95, y =-33.6, label = paste0("Min $",number(min(df$ingreso_trabajo),big.mark = ".", decimal.mark = ",")), hjust = "left", family = 'Roboto Condensed', size = 4, color = "grey15") +
  labs(title = "Relación entre comuna y\npromedio de ingresos totales\npor trabajo del hogar",
       subtitle = paste0("Dentro del Gran Santiago\nMínimo $",number(min(df$ingreso_trabajo),big.mark = ".", decimal.mark = ","),"\nMáximo $",number(max(df$ingreso_trabajo),big.mark = ".", decimal.mark = ",")),
       caption = "Fuente: Casen en Pandemia, 2020") +
  theme_desuc

rayshader::plot_gg(gg)
# rayshader::render_snapshot()
rayshader::render_movie("output/day14.mp4",frames = 720, fps=30,zoom=0.6,fov = 30)