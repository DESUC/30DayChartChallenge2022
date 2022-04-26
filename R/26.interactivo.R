#install.packages("rvest")
#install.packages("xml2")
library(rvest)
library(xml2)
library(tidyverse)

# Primera página ----

web <- 'https://www.imdb.com/search/title/?genres=animation&sort=user_rating,desc&title_type=feature&num_votes=25000,&pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=5aab685f-35eb-40f3-95f7-c53f09d542c3&pf_rd_r=CAHVHSNK8JZF9791EF10&pf_rd_s=right-6&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_gnr_3'
website <- read_html(web)
website

# Ranking ----

rank_data_html <- html_nodes(website,'.text-primary')
rank_data_html
rank_data <- html_text(rank_data_html)
rank_data
head(rank_data)
rank_data<-as.numeric(rank_data)
head(rank_data)

# Título ----

title_data_html <- html_nodes(website,'.lister-item-header a')
#Converting the title data to text
title_data <- html_text(title_data_html)
head(title_data)

# Duración ----

runtime_data_web <- html_nodes(website,'.runtime')
runtime_data_web
runtime_data <- html_text(runtime_data_web)
head(runtime_data)
runtime_data <- gsub(" min","",runtime_data)
runtime_data
runtime_data<-as.numeric(runtime_data)
runtime_data
head(runtime_data)

# Rating ----

rating_data_web <- html_nodes(website,'.ratings-imdb-rating strong')
rating_data_web
rating_data <- html_text(rating_data_web)
rating_data
rating_data<-as.numeric(rating_data)
head(rating_data)

# Año ----

year_data_web <- html_nodes(website,'.text-muted.unbold')
year_data_web
year_data <- html_text(year_data_web)
year_data <- gsub("(I) ", "", year_data, fixed = T)
year_data <- desuctools::str_entre_parentesis(year_data)
year_data<-as.numeric(year_data)
head(year_data)

# Recaudación ----

gross_data_web <- html_nodes(website,'.ghost~ .text-muted+ span')
gross_data <- html_text(gross_data_web)
gross_data
gross_data<-gsub("M","",gross_data)
gross_data<-substring(gross_data,2,6)
gross_data
length(gross_data)

# Primera version

for (i in c(3,16,17,18,19,24,25,31,37,42)){
  
  a<-gross_data[1:(i-1)]
  
  b<-gross_data[i:length(gross_data)]
  
  gross_data<-append(a,list("NA"))
  
  gross_data<-append(gross_data,b)
  
}

gross_data<-as.numeric(gross_data)
length(gross_data)
summary(gross_data)

# Género  ----

genre_data_web <- html_nodes(website,'.genre')
genre_data_web
genre_data <- html_text(genre_data_web)
genre_data<-gsub("\n","",genre_data)
genre_data<-gsub(" ","",genre_data)
genre_data<-desuctools::str_entre(genre_data, ini = ",", fin = ",")
genre_data
genre_data<-as.factor(genre_data)
head(genre_data)

# Data:

df_animacion01 <-data.frame(ranking = rank_data, 
                            titulo = title_data,
                            duracion = runtime_data,
                            ano = year_data,
                            rating = rating_data,
                            recaudacion = gross_data,
                            genero = genre_data)

# Segunda página ----

web <- 'https://www.imdb.com/search/title/?title_type=feature&num_votes=25000,&genres=animation&sort=user_rating,desc&start=51&ref_=adv_nxt'
website <- read_html(web)
website

# Ranking ----

rank_data_html <- html_nodes(website,'.text-primary')
rank_data_html
rank_data <- html_text(rank_data_html)
rank_data
head(rank_data)
rank_data<-as.numeric(rank_data)
head(rank_data)

# Título ----

title_data_html <- html_nodes(website,'.lister-item-header a')
#Converting the title data to text
title_data <- html_text(title_data_html)
head(title_data)

# Duración ----

runtime_data_web <- html_nodes(website,'.runtime')
runtime_data_web
runtime_data <- html_text(runtime_data_web)
head(runtime_data)
runtime_data <- gsub(" min","",runtime_data)
runtime_data
runtime_data<-as.numeric(runtime_data)
runtime_data
head(runtime_data)

# Rating ----

rating_data_web <- html_nodes(website,'.ratings-imdb-rating strong')
rating_data_web
rating_data <- html_text(rating_data_web)
rating_data
rating_data<-as.numeric(rating_data)
head(rating_data)

# Año ----

year_data_web <- html_nodes(website,'.text-muted.unbold')
year_data_web
year_data <- html_text(year_data_web)
year_data <- gsub("(I) ", "", year_data, fixed = T)
year_data <- desuctools::str_entre_parentesis(year_data)
year_data<-as.numeric(year_data)
head(year_data)

# Recaudación ----

gross_data_web <- html_nodes(website,'.ghost~ .text-muted+ span')
gross_data <- html_text(gross_data_web)
gross_data
gross_data<-gsub("M","",gross_data)
gross_data<-substring(gross_data,2,6)
gross_data
length(gross_data)

# Segunda version

for (i in c(4,6,14,20,24,36,37,40,43,48)){
  
  a<-gross_data[1:(i-1)]
  
  b<-gross_data[i:length(gross_data)]
  
  gross_data<-append(a,list("NA"))
  
  gross_data<-append(gross_data,b)
  
}

gross_data<-as.numeric(gross_data)
length(gross_data)
summary(gross_data)

# Género  ----

genre_data_web <- html_nodes(website,'.genre')
genre_data_web
genre_data <- html_text(genre_data_web)
genre_data<-gsub("\n","",genre_data)
genre_data<-gsub(" ","",genre_data)
genre_data<-desuctools::str_entre(genre_data, ini = ",", fin = ",")
genre_data
genre_data<-as.factor(genre_data)
head(genre_data)

# Data:

df_animacion02 <-data.frame(ranking = rank_data, 
                          titulo = title_data,
                          duracion = runtime_data,
                          ano = year_data,
                          rating = rating_data,
                          recaudacion = gross_data,
                          genero = genre_data)

# Unir bases ----

df_animacion <- bind_rows(df_animacion01, df_animacion02)

df_animacion <- df_animacion %>% 
  rename(Recaudación = recaudacion)

# Gráfico:

library(plotly)
library(htmlwidgets)

gg_animacion <- df_animacion %>% 
  filter(!is.na(Recaudación), !is.na(genero)) %>% 
  ggplot(aes(x = ano, y = rating, size = Recaudación)) +
  geom_point(aes(text = titulo, color = genero), alpha = 0.8) +
  scale_y_continuous("Rating IMDB", limits = c(7,9)) +
  scale_x_continuous("Estreno (año)",breaks = seq(1935,2025,10)) +
  scale_size_continuous(range = c(1,10), guide = 'none') +
  scale_color_brewer("Género:", palette = "Paired", direction = 1, 
                     guide = guide_legend(
                       direction = "horizontal", title.position = "top", nrow = 1,
                       override.aes = list(size = 5)
  )) +
  labs(title = "#30DayChartChallenge2022: Interactivo",
       subtitle = "Las mejores 100 películas de animación según IMDB.
La animación es una técnica utilizada para contar todo tipo de historias,
desde aventuras familiares y fantásticas, a documentales. En el siguiente
gráfico, se encuentran las 100 mejores películas de animación según IMDB,
ordenadas por su año de estreno, su puntuación en IMDB y su género.",
       caption = "El tamaño del círculo corresponde a la recaudación
que tuvo la película en Estados Unidos. De las 100, 20 películas no
tenían esta información, entre ellas algunas estrenadas directamente
en plataformas (Soul, La Familia Mitchell vs. Las Máquinas), y películas
internacionales.
Fuente: Datos obtenidos de https://www.imdb.com.") +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(legend.position = "top",
        plot.title.position = "plot",
        plot.title = element_text(face = "bold"),
        plot.caption.position = "plot")

gg_animacion

ggsave("output/day26_interactivo.png", gg_animacion, device = "png", width = 6, height = 6)

gg_interactivo <- ggplotly(gg_animacion, tooltip = c("titulo","Recaudación")) 

saveWidget(gg_interactivo, "output/day26_interactivo.html", selfcontained = F, libdir = "lib")
