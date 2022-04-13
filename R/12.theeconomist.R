# #30DayChartChallenge 
# Día 12 - The Economist theme

library(dplyr)
library(tidyr)
library(stringr)
library(labelled)
library(forcats)
library(ggplot2)
library(patchwork)

library(showtext)

df_base <- readRDS('input/13.df_bicen_22_probabilidad_sexo_edad_nse.rds')

# Datos de Encuesta Bicentenario 2022.
# 
# ¿Cuál cree Ud. que es la probabilidad o chance que tiene en este país…?
# 
# * Un pobre de salir de la pobreza
# * Una persona de clase media de llegar a tener una muy buena situación económica
# * Un joven inteligente pero sin recursos de ingresar a la universidad
# * Cualquier persona de iniciar su propio negocio y establecerse independientemente
# * Una persona que tiene un negocio o una empresa pequeña de convertirla en una empresa grande y exitosa
# * Cualquier trabajador de comprar su propia vivienda
# * Cualquier trabajador de alcanzar una pensión de retiro digna


# Sumar respuestas "% Muy alta + Bastante alta" para cada segmento de respuesta
# Uno niveles de interés
df_base$pregunta_cat <- df_base$pregunta_cat |> 
  to_factor() |> 
  fct_collapse("Muy y basanta alta" = c('Muy alta', 'Bastante alta'),
               other_level = 'Otro')

# Cálculo de porcentajes por segmento luego de agrupadas las categorías de respuesta
# de interés.
df_grafico <- df_base |> 
  group_by(across(!c(n, prop))) |> 
  summarise(across(everything(), sum),
            .groups = 'drop') |> 
  group_by(across(c(segmento_var:pregunta_lab))) |> 
  mutate(prop = n/sum(n)) |> 
  ungroup()

df_grafico <- df_grafico |> 
  filter(pregunta_cat != 'Otro')

# Ajuste de texto de preguntas para eje Y.
df_grafico$pregunta_eje <- df_grafico$pregunta_lab |> 
  str_extract('^\\(.*\\)') |> 
  str_remove_all('[\\(\\)]') |> 
  str_wrap(width = 40)


# Thermometer chart según The Economist.
# 
# Referencia: https://design-system.economist.com/documents/CHARTstyleguide_20170505.pdf
# Letra: https://fonts.google.com/specimen/Fira+Sans+Condensed

font_add_google("Fira Sans Condensed", "Fira Sans Condensed")

econ_red <- '#E3120B'

colores <- c('#63B6C0', '#7B3D45', '#D0AD6E', '#30638A', '#258A8E', '#9E868C')

scales::show_col(colores)

# Elementos de diseño de The Economist

f_econ_rect <- function(height){
  grid::grid.rect(
    x = 0,
    y = 1,
    width = unit(30, 'pt'),
    height = unit(height, 'pt'),
    gp = grid::gpar(fill = econ_red,
                    col = NA)
  )  
}

f_econ_linea <- function(lwd){
  grid::grid.lines(
    x = c(0, 1),
    y = 1,
    gp = grid::gpar(col = econ_red, 
                    lwd = lwd)
  )
}

# Theme

theme_set(
  theme_minimal(base_family = 'Fira Sans Condensed') +
    theme(
      panel.grid = element_blank(),
      panel.grid.major = element_line(size = unit(0.5, 'pt'), 
                                      color = "#A7B6BC"),
      plot.background = element_rect(color = NA, fill = "white"),
      axis.title = element_blank(),
      axis.text.y = element_text(size = unit(11, 'pt')),
      axis.line.y = element_line(color = "#1A1919", unit(0.4, 'pt')),
      axis.line.x = element_blank(),
      legend.position = "top",
      legend.justification = "center",
      legend.key.height = unit(12, 'pt'),
      legend.key.width = unit(5, 'pt'),
      plot.title = element_text(face = 'bold',
                                size = unit(14, 'pt'),
                                margin = margin(b = 4, 
                                                unit = 'pt')),
      plot.title.position = "plot",
      plot.subtitle = element_text(face = 'plain',
                                   size = unit(9, 'pt'),
                                   lineheight = 1,
                                   margin = margin(b = 13, 
                                                   unit = 'pt')),
      plot.caption = element_text(hjust = 0, 
                                  size = unit(8, 'pt'), 
                                  family = "Fira Sans Condensed Light",
                                  colour = 'grey25'),
      plot.caption.position = "plot",
      plot.margin = margin(t = 15, r = 5, b = 5, l = 0, 
                           unit = 'pt')
    )
)

f_gg_grafico <- function(.df){
  
  df_seg <- .df |> 
    group_by(across(c(pregunta_eje, pregunta_var))) |> 
    summarise(xmin = min(prop),
              xmax = max(prop),
              .groups = 'drop')
  
  ggplot(.df,
         aes(x = prop,
             y = pregunta_eje)) +
    geom_segment(data = df_seg,
                 aes(yend = pregunta_eje,
                     x = xmin,
                     xend = xmax),
                 colour = '#647A84',
                 size = unit(2, 'pt')) +
    geom_rect(aes(xmin = prop - .004,
                  xmax = prop + .004,
                  ymin = after_stat(y - .3),
                  ymax = after_stat(y + .3),
                  fill = segmento_cat)) +
    scale_fill_manual(NULL, 
                      values = colores) +
    scale_x_continuous(labels = scales::percent,
                       expand = expansion(mult = c(0, .02)),
                       limits = c(0, .5),
                       breaks = c(0, .25, .5),
                       position = "top")
}

gg_sexo <- df_grafico |> 
  filter(segmento_var == 'SEXO2') |> 
  f_gg_grafico() +
  labs(title = 'Sexo') +
  theme(plot.title = element_text(face = 'plain',
                                  size = unit(13, 'pt')))

gg_sexo

gg_nse <- df_grafico |> 
  filter(segmento_var == 'NSE') |> 
  f_gg_grafico() +
  labs(title = 'Nivel socioeconómico') +
  theme(axis.text.y = element_blank(),
        plot.title = element_text(face = 'plain',
                                  size = unit(13, 'pt')))
        
gg_final <- (gg_sexo + gg_nse) +
  patchwork::plot_annotation(title = 'Esperanza en Hombres y NSE Alto',
                             subtitle = '¿Cuál cree Ud. que es la probabilidad o chance que tiene en este país…?\n% de respuesta "Muy alta" y "Bastante alta" probabilidad',
                             caption = 'Fuente: Bicentenario UC 2022')

gg_final

# Elemento adicionales
ragg::agg_png("output/16-the_economist_1.png", 
              width = 25, height = 15, res = 300,
              units = "cm")

gg_final

f_econ_rect(10)
f_econ_linea(1)

dev.off()
