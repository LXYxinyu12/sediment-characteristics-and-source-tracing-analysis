library(ggplot2)
library(grid)
library(tidyverse)
library(ggsignif)

dt = read.csv('Sb.csv',header = T)
dt = read.csv('TOC.csv',header = T)
dt$Seasons = factor(dt$Season,levels = c('wet','dry'),labels = c('wet','dry'))
dt$Site = factor(dt$site,levels = c('CS','CR','CW','SS','SR','SW'),labels = c('CS','CR','CW','SS','SR','SW'))


plot1 = ggplot(dt,aes(Site,Igeo))+
  stat_boxplot(aes(fill=Season),geom="errorbar",width=0.1,linewidth=0.5,position=position_dodge(0.6))+
  geom_boxplot(aes(fill=Season),
               position=position_dodge(0.6),
               size=0.5,
               width=0.3,
               outlier.shape = 19,
               outlier.size = 1.5,
               outlier.stroke = 0.5,
               outlier.alpha = 45,
               notch = F,
               notchwidth = 0.5)+
  scale_y_continuous(breaks = seq(-3, 5, by = 1))+
  geom_signif(comparisons = list(c('CS','CR'),c('CS','CW'),c('CR','CW'),c('SS','SR'),c('SS','SW'),c('SR','SW')),
              y_position = c(4,4.5,4,4,4.5,4),
              map_signif_level = T)+
  geom_signif(comparisons = list(c('CS','SS')),y_position = 5,map_signif_level = T)+
  geom_signif(y_position = c(2.2),xmin = c(0.7),xmax = c(1.3))


plot = ggplot(dt,aes(Site,TOC))+
  stat_boxplot(aes(fill=Season),geom="errorbar",width=0.1,linewidth=0.5,position=position_dodge(0.6))+
  geom_boxplot(aes(fill=Season),
               position=position_dodge(0.6),
               size=0.5,
               width=0.3,
               outlier.shape = 19,
               outlier.size = 1.5,
               outlier.stroke = 0.5,
               outlier.alpha = 45,
               notch = F,
               notchwidth = 0.5)+
  scale_y_continuous(breaks = seq(0, 70, by = 5))+
  geom_signif(comparisons = list(c('CS','CR'),c('CS','CW'),c('CR','CW'),c('SS','SR'),c('SS','SW'),c('SR','SW')),
              y_position = c(40,45,40,40,45,40),
              map_signif_level = T)+
  geom_signif(comparisons = list(c('CS','SS')),y_position = 50,map_signif_level = T)+
  geom_signif(y_position = c(2.2),xmin = c(0.7),xmax = c(1.3))