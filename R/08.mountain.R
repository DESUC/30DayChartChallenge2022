install.packages('Rspotify')
library(Rspotify)
library(tidyverse)
devtools::install_github("jbgb13/peRReo") #paleta de colores
library(peRReo)
library(sjmisc)


#Para acceder a datos de la m�sica, visitar: https://r-music.rbind.io/posts/2018-10-01-rspotify/


#Extraemos las canciones

#The Climb

find_song_1 <- searchTrack("The Climb", token = keys)
find_song_1 %>% slice(1)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_1 <- find_song_1 %>% 
filter(popularity  == "78") %>% 
  pull(id)

song_1 <- getFeatures(id_song_1, token = keys)
S_1 <- song_1 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()



#Ain't no mountain High

find_song_2 <- searchTrack("Ain´t No Mountain High Enough", token = keys)
find_song_2 %>% slice(1)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_2 <- find_song_2 %>% 
  filter(popularity  == "85") %>% 
  pull(id)

song_2 <- getFeatures(id_song_2, token = keys)
S_2 <- song_2 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()


#River deep, Mountain High

find_song_3 <- searchTrack("River deep - Mountain High", token = keys)
find_song_3 %>% slice(1)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_3 <- find_song_3 %>% 
  filter(popularity  == "63") %>% 
  pull(id)

song_3 <- getFeatures(id_song_3, token = keys)
S_3 <- song_3 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()


#Misty Mountain Hop

find_song_4 <- searchTrack("Misty Mountain Hop", token = keys)
find_song_4 %>% slice(1)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_4 <- find_song_4 %>% 
  filter(popularity  == "60") %>% 
  pull(id)

song_4 <- getFeatures(id_song_4, token = keys)
S_4 <- song_4 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()



#Mountain Sound

find_song_5 <- searchTrack("Mountain Sound", token = keys)
find_song_5 %>% slice(1:2)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_5 <- find_song_5 %>% 
  filter(popularity  == "66") %>% 
  pull(id)

song_5 <- getFeatures(id_song_5, token = keys)
S_5 <- song_5 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()




#Mountains

find_song_6 <- searchTrack("Mountains", token = keys)
find_song_6 %>% slice(1:2)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_6 <- find_song_6 %>% 
  filter(popularity  == "67") %>% 
  pull(id)

song_6 <- getFeatures(id_song_6, token = keys)
S_6 <- song_6 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()


#Cordillera

find_song_7 <- searchTrack("Cordillera", token = keys)
find_song_7 %>% slice(1:3)  %>% arrange(desc(popularity)) %>%
  knitr::kable()

id_song_7 <- find_song_7 %>% 
  filter(popularity  == "41") %>% 
  pull(id)

song_7 <- getFeatures(id_song_7, token = keys)
S_7 <- song_7 %>% select(-uri, -analysis_url) %>% glimpse() %>% knitr::kable()

#rbind

data2 <- as.data.frame(rbind(song_1, song_2, song_3, song_4, song_5, song_6, song_7))
nombres <- c("The Climb - Miley Cyrus", "Ain't no mountain High - Marvin Gaye", "River deep, Mountain High - Ike & Tina Turner", "Misty Mountain Hop - Led Zeppelin", 
             "Mountain Sound - Of Monsters and Men", "Mountains - Hans Zimmer", "Cordillera - Alex Anwandter")
nombres2 <- as.data.frame(nombres)

data3 <- cbind(nombres2, data2)


#Gráfico


colores <- latin_palette("shakira",7) #ocupé la paleta de Shakira, porque 


windowsFonts("Roboto" = windowsFont("Roboto"))
theme_desuc <- list(theme_minimal(base_family = 'Roboto'),
                    theme(text = element_text(size = 20),
                          plot.caption = element_text(color = 'grey40', size = rel(0.5)),
                          plot.title = element_text(color = "grey40", face = "bold", size = rel(1,8), family = "Roboto"),
                          plot.subtitle = element_text(color = 'grey40', size = rel(1))))



p <- data3 %>% 
  ggplot(aes(y = acousticness, x = valence, colour = nombres)) +
  geom_point(aes(size = instrumentalness), alpha = 0.7) +
  xlim(-0.1, 1) + ylim(-0.1, 1) +
  scale_size_continuous(range = c(15,18)) + 
  scale_color_manual(values = colores, '') +
   labs(x = 'Positividad', 
       y = 'Acústica',
       title = 'Mountain',
       subtitle = 'Canciones referidas: Positividad y acústica',
       caption = 'El tamaño del círculo indica instrumentalidad. \nMientras más grande, más instrumentos tiene.\nfuente: spotify') + 
  guides(size = F, colour = guide_legend(nrow = 3, override.aes = list(size = 5))) +
  theme_desuc  +
  theme(
    legend.position = 'bottom', legend.direction = 'horizontal',
    legend.key.size = unit(.5, "cm"),
    plot.background = element_rect(fill = "white", color = NA),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(), 
  )
  
  
p

#Guardamos

ggsave('m_1.png',
       width = 10,
       height = 5,
       scale = 4,
       units = 'cm')


ggsave('m_2.png',
       width = 8,
       height = 8,
       scale = 4,
       units = 'cm')
