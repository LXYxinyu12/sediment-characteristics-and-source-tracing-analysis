library(ggthemes)
library(ggplot2)
dt = read.table('clipboard',header = TRUE)

FRI = dt[,-7]
FRI<-melt(FRI,id.vars="ID",variable.name="Region",value.name="Intensity")
ggplot(FRI,aes(ID,Intensity,fill=Region))+
  geom_bar(stat="identity",position="dodge")+
  theme_clean()+#选择主题
  scale_fill_wsj("colors6", "")+#填充颜色
  guides(fill=guide_legend(title=NULL))+
  theme(axis.title = element_blank(),legend.position='none')+
  facet_grid(.~Region)+
  coord_flip()
Source = dt[,c(1,7)]
ggplot(Source,aes(x = Source, y = ID)) + geom_point(shape = 21, size = 2.5, color ='#619ac3' ,fill = '#619ac3')+
  theme_clean()#选择主题
