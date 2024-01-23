install.packages("vegan")
library(vegan)
library(ggplot2)

otu <- read.delim('S_psd.txt', row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
nmds_otu <- metaMDS(otu, distance = 'bray', k = 2)
nmds_otu$stress

nmds_otu_site <- data.frame(nmds_otu$points)


nmds_otu_species <- data.frame(nmds_otu$species)

nmds_otu_site$name <- rownames(nmds_otu_site)
nmds_otu_site$group <- c(rep('SS', 3), rep('SR', 10), rep('SW', 10))



#S_psd
ggplot(data = nmds_otu_site, aes(MDS1, MDS2)) +
  geom_point(aes(color = group)) +
  stat_ellipse(aes(fill = group), geom = 'polygon', level = 0.95, alpha = 0.1, show.legend = FALSE) +	
  scale_color_manual(values = c( 'red3', 'orange3', 'green3')) +
  scale_fill_manual(values = c('red3', 'orange3', 'green3')) +
  geom_vline(xintercept = 0, color = 'gray', linewidth = 0.25) +
  geom_hline(yintercept = 0, color = 'gray', linewidth = 0.25) +
  labs(x = 'NMDS1', y = 'NMDS2', title = 'S_metal') +
  theme(panel.grid = element_blank(), 
        panel.background = element_rect(color = 'black', fill = 'transparent'), 
        plot.title = element_text(hjust = 0.5,family = 'serif',size = 7.5), 
        legend.key = element_rect(fill = 'transparent'),
        legend.text = element_text(family = 'serif',size = 7.5),
        axis.text = element_text(family = 'serif',size = 7.5),
        axis.title = element_text(family = 'serif',size = 7.5),
        text = element_text(family = 'serif',size = 7.5)) +
  geom_text(label = paste('Stress =', round(nmds_otu$stress, 4)), x = -0.2, y = 0.15,colour = 'black')+	
  geom_text(label = 'SR',x = 0.1, y = -.05, colour = 'green3') +
  geom_text(label ='SJ', x = 0.02, y = 0.02 ,colour = 'orange3') +
  geom_text(label ='SD', x = -0.1, y = 0.02, colour = 'red3')+
  geom_text(label = sprintf('italic(R^2) == %.3f', 0.992), x = .2, y = 0.15, parse = TRUE)

###
stressplot(nmds_otu, main = 'Shepard')

gof <- goodness(nmds_otu)
plot(nmds_otu, type = 'text', display = 'sites', main = 'degree of fitting')
points(nmds_otu, display = 'site', cex = gof * 100, col = 'red')
