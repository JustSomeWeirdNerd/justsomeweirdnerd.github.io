
library(ggplot2)
library(stringr)
library(grid)
library(gridExtra)

ggplotRegression <- function (fit, title_text, y_axis, x_axis) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    
    labs(title=title_text,
         subtitle = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                          "; Intercept =",signif(fit$coef[[1]],5 ),
                          "\nSlope =",signif(fit$coef[[2]], 5),
                          "; P =",signif(summary(fit)$coef[2,4], 5)),sep="")+
    
    theme(
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5)
    )+
    xlab(x_axis)+
    ylab(y_axis)+
    scale_x_continuous(expand = c(0, 0.05))
}


#Input poop data from 3 continents:
Africa <- read.delim("~/Desktop/blog/Poop_Olympics/Africa.txt", stringsAsFactors = F)
Africa$Continent <- "Africa"
America <- read.delim("~/Desktop/blog/Poop_Olympics/Americas.txt", stringsAsFactors = F)
America$Continent <- "Americas"
Europe <- read.delim("~/Desktop/blog/Poop_Olympics/Europe.txt", stringsAsFactors = F)
Europe$Continent <- "Europe"
All_Data <- rbind(Africa, America, Europe)
All_Data$order <- str_replace(All_Data$order, "INSETIVORA", "INSECTIVORA")

#Input animal lengths:
Lengths <- read.delim("~/Desktop/blog/poop_animals_body_len.txt", stringsAsFactors = F)
Lengths <- na.omit(Lengths)
Lengths$avg <- (Lengths$min+Lengths$max)/2

#convert Length units to cm
Lengths_cm <- Lengths[Lengths$unit == "cm",]
Lengths_cm$avg_len_cm  <- Lengths_cm$avg
Lengths_mm <- Lengths[Lengths$unit == "mm",]
Lengths_mm$avg_len_cm  <- (Lengths_mm$avg/10)
Lengths_m <- Lengths[Lengths$unit == "m",]
Lengths_m$avg_len_cm  <- (Lengths_m$avg*100)
Lengths_in <- Lengths[Lengths$unit == "in",]
Lengths_in$avg_len_cm  <- (Lengths_in$avg/0.393701)
Lengths_ft <- Lengths[Lengths$unit == "ft",]
Lengths_ft$avg_len_cm  <- (Lengths_ft$avg/0.03280841666667)
Lengths <- rbind(Lengths_cm, Lengths_mm, Lengths_m, Lengths_in, Lengths_ft)
rm(Lengths_cm, Lengths_mm, Lengths_m, Lengths_in, Lengths_ft)
All_Data <- merge(All_Data, Lengths[c(1,6)], by="species")

#Average the body mass of each animal by taking the midpoint of their mass range:
All_Data$body_avg_kg <- (All_Data$body_min_kg + All_Data$body_max_kg)/2
All_Data$cm_per_kg <- (All_Data$feces_max_dim_cm/All_Data$body_avg_kg)
All_Data$poop_to_body <- All_Data$feces_max_dim_cm/All_Data$avg_len_cm

#log length and mass data for graphing:
All_Data$log_Kg <- log(All_Data$body_avg_kg+1)
All_Data$log_cm_kg <- log(All_Data$cm_per_kg+1)
All_Data$log_ratio <- log(All_Data$poop_to_body+1)
All_Data$log_len <- log(All_Data$avg_len_cm+1)

#convert order to a factor:
All_Data$order <- as.factor(All_Data$order)

#small mammal category (combined) 
temp <- All_Data[All_Data$order == "PRIMATA" | All_Data$order == "INSECTIVORA" | All_Data$order == "LAGOMORPHA" | All_Data$order == "XENARTHRA" | All_Data$order == "PINNIPEDIA" | All_Data$order ==  "INSETIVORA",]

usable_orders <- c("RODENTIA", "CARNIVORA", "UNGULATA")


for(order in usable_orders){
  temp <- All_Data[All_Data$order == order,]
  #graph_1 = lm of poop length vs. log body mass
  g1 <- ggplotRegression((lm(formula = feces_max_dim_cm ~ log_Kg, data = temp)), "Body Mass vs. Poop Length", "Avg Poop Length (cm)", "Avg Log Body Mass (kg)")
  
  #graph_2 = lm of log ratio vs. log body mass
  g2 <- ggplotRegression((lm(formula = cm_per_kg ~ log_Kg, data = temp)), "Body Mass vs. Poop Length per Kg Body Mass", "Avg cm Poop/Kg Body Mass", "Avg Log Body Mass (kg)")
  
  #graph_3 = lm of log ratio vs. log body mass
  g3 <- ggplotRegression((lm(formula = feces_max_dim_cm ~ log_len, data = temp)), "Body Length vs. Poop Length", "Avg Poop Length (cm)", "Avg Log Body Length (cm)")
  
  #graph_4 = lm of log ratio vs. log body len
  g4 <- ggplotRegression((lm(formula = poop_to_body ~ log_len, data = temp)), "Body Length vs. Poop Length as % Body Length", "Poop Length (% of Body Length)", "Avg Log Body Length (cm)")
  
 
  grid.arrange(g1, g2, g3, g4, nrow = 2, top = textGrob(order,gp=gpar(fontsize=20,font=3)))
  
}
#Repeat for small mammals, and All_Data





