library(tidyverse)
library(cowplot)
library(magick)
library(gridExtra)

# Preparación base de datos de actores y actrices:

df_actors <- read_csv("input/all_actors_movies_gender_gold.csv")
names(df_actors)

df_actors_g <- df_actors %>% 
  select(year, language, gender) %>% 
  filter(language == "['English']")

df_actors_g <- df_actors_g %>% 
  group_by(year, gender) %>% 
  summarise(n = length(gender)) %>% 
  filter(gender != "unknown") %>% 
  group_by(year) %>% 
  mutate(total = sum(n),
         p = n/total) %>% 
  mutate(category = "Actores")

# Preparación de base de datos de directores:

df_directors <- read_csv("input/all_directors_gender.csv")
names(df_directors)

df_directors_g <- df_directors %>% 
  select(year, gross, director, language, gender) %>% 
  filter(language == "['English']")

df_directors_g <- df_directors_g %>% 
  group_by(year, gender) %>% 
  summarise(n = length(gender)) %>% 
  filter(gender != "unknown", year != 202013) %>% 
  group_by(year) %>% 
  mutate(total = sum(n),
         p = n/total) %>% 
  mutate(category = "Directores")

# Unir bases de datos:

df_general <- bind_rows(df_actors_g, df_directors_g)

# Selección de películas dirigidas por mujeres en el 2017:

df_movies <- df_directors %>% 
  filter(year == 2017, gender == "female")

# Correlación entre ambas:

cor.test(df_directors_g$p, df_actors_g$p, method = "pearson")

# Gráfico general ----

# Paleta de colores (morado + fucsia)

paletas <- c("#9e0059","#ff0054")

# Gráfico general de correlación entre ambas variables:

gg_general <- df_general %>% 
  filter(gender == "female") %>% 
  ggplot(aes(x = year, y = p, fill = category, color = category)) +
  geom_line(aes(group = category)) +
  geom_point(aes(size = p)) +
  geom_text(aes(label = n), color = "white", family = "Roboto Condensed", size = 3) +
  scale_x_continuous(breaks = seq(2000,2018,1)) +
  scale_y_continuous(labels = scales::label_percent(1), limits = c(0,0.5)) +
  scale_size_continuous(range = c(2, 8), guide = "none") +
  scale_fill_manual(guide = "none", values = paletas) +
  scale_color_manual(guide = "none", values = paletas) +
  labs(y = "Porcentaje",
       x = "Año",
       title = "#30DayChartChallenge2022: Correlación",
       subtitle = "Mujeres en la industria del cine: actrices y directoras (2000-2018).
¿Existe una relación entre el número de realizadoras y el número de actrices
parte del elenco en una película?",
       caption = "Notas: En relación a actrices, no se habla de papeles protagónicos, 
sino su inclusión dentro de un elenco. Aún así, el número de mujeres en el total 
de producciones no alcanzaba el 40% en el 2018.
Fuente: https://github.com/taubergm/HollywoodGenderData.git") +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1),
        plot.title = element_text(family = "Courier", face = "bold", hjust=0.5),
        plot.subtitle = element_text(size = 10, hjust=0.5),
        axis.title.x = element_text(size = 9, hjust = 1),
        axis.title.y = element_text(size = 9, hjust = 1))

# Agregamos las notas aparte:

gg_general <- gg_general +
  annotate(geom = "text", y = .4, x = 2002.7, color = "#9e0059", label = "Número de actrices", family = "Roboto Condensed", fontface = 2) +
  annotate(geom = "text", y = .15, x = 2003, color = "#ff0054", label = "Número de directoras", family = "Roboto Condensed", fontface = 2)

gg_general

# Guardar la imagen del primer gráfico solo:

ggsave("output/day13_correlacion.png", device = "png", width = 5, height = 5)

# Agregado ----

gg_movies <- ggplot() +
  theme_void(base_family = "Roboto Condensed") +
  labs(title = "Algunas de las películas del 2017...",
       subtitle = "Lady Bird dirigida por Greta Gerwig y protagonizada por Saoirce Ronan,\n y Raw de la directora Julia Ducournau, protagonizada por Garance\nMarillier. La primera estuvo nominada a los Oscar en las categorías de\nMejor Actriz, Mejor Película y Mejor Director, entre otros.\nLa directora de Raw el 2021 ganó la Palma de Oro en Cannes por\nsu película Titane.",
       caption = "Existe una alta correlación entre ambas:\nentre más mujeres hay en la dirección\nde películas, más mujeres hay en los elencos.") +
  theme(plot.title = element_text(family = "Courier", face = "bold", size = 10, color = "#ff0054"),
        plot.margin = margin(2, 0.5, 1, 0.5, "cm"),
        plot.subtitle = element_text(size = 8),
        plot.caption = element_text(size = 8)) 

gg_movies

gg_movies <- ggdraw() +
  draw_image("input/lady_bird.jpg", scale = 0.45, x = 0.25, y = -.1) +
  draw_image("input/raw.jpg", scale = 0.45, x = -0.22, y = -.1) +
  draw_plot(gg_movies)

# Unir los dos gráficos ----

grid.arrange(gg_general, gg_movies, ncol = 2, widths = c(2,1))
gg_unido <- arrangeGrob(gg_general, gg_movies, ncol = 2, widths = c(2,1))

# Guardar el gráfico con los cambios:

ggsave("output/day13_unido.png", gg_unido, device = "png", width = 10, height = 5)



