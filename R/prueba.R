
install.packages("readxl")
install.packages("ggplot2")
install.packages("plotrix")
install.packages("RColorBrewer")
install.packages("hrbrthemes")
install.packages("ggridges")
install.packages("forcats")


library(ggplot2)
library (dplyr)
library(plotrix)



## Lectura BBDD 
base <- read_excel('/Users/desuc/Desktop/Gráfico challenge/Input/areas_protegidas.xlsx')

##gráfico
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(ggridges)
library(forcats)


# Plot
base %>%
  tail(10) %>%
  ggplot( aes(x=a_p, y=Visitantes)) +
  geom_line() +
  geom_point()


# Plot
base %>%
  tail(100000) %>%
  ggplot( aes(x=a_p, y=Visitantes)) +
  geom_line( color="grey") +
  geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
  theme_ipsum() +
  ggtitle("10 áreas protegidas más visitadas en Chile")



#pruebas 

base1 <- read_excel('/Users/desuc/Desktop/Gráfico challenge/Input/vap.xlsx')
ggplot(diamonds, aes(x = ano, y = n, fill = País)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")



#prueba 2
base %>% 
  mutate(Visitantes = case_when(Visitantes > 50000 ~ "#FFFF00",
                             CFR_level == "Med" ~ "#008000",
                             TRUE ~ "#FF0000")
  ) %>% 
  
  hchart(type = "coloredline", 
         hcaes(x = Date, y = Confirmed, group = Country.Region, segmentColor = CFR_col)) %>%
  hc_add_dependency("plugins/multicolor_series.js")


#prueba 3

Load dataset from github
data <- read.table("https://raw.githubusercontent.com/zonination/perceptions/master/probly.csv", header=TRUE, sep=",")
data <- data %>% 
  gather(key="text", value="value") %>%
  mutate(text = gsub("\\.", " ",text)) %>%
  mutate(value = round(as.numeric(value),0)) %>%
  filter(text %in% c("Almost Certainly","Very Good Chance","We Believe","Likely","About Even", "Little Chance", "Chances Are Slight", "Almost No Chance"))

# Plot
data %>%
  mutate(text = fct_reorder(text, value)) %>%
  ggplot( aes(y=text, x=value,  fill=text)) +
  geom_density_ridges(alpha=0.6, stat="binline", bins=20) +
  theme_ridges() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  ) +
  xlab("") +
  ylab("Assigned Probability (%)")
