library(ggplot2)
library(reshape2)

# 创建示例数据
data <- data.frame(
  big_category = rep(c("Category 1", "Category 2", "Category 3"), each = 100),
  small_category = rep(c("Subcategory 1", "Subcategory 2", "Subcategory 3", "Subcategory 4", "Subcategory 5"), 60),
  value = rnorm(300)
)

# 绘制分组的小提琴图
ggplot(data, aes(x = big_category, y = value)) +
  geom_violin(fill = "lightblue", color = "black") +
  facet_grid(. ~ small_category) +
  theme_minimal()+
  coord_flip()

data = read.table('clipboard',header = TRUE)
data$site = as.factor(data$site)
#data$season = as.factor(data$season)
mydata<-melt(data,id.vars="ID",variable.name="Cluster",value.name="TOC")
mydata = melt(data, id.vars = c("ID", "site"), variable.name = "Cluster", value.name = "TOC")


ggplot(mydata, aes(x = TOC, y = Cluster, fill = Cluster)) +
  geom_violin(position = "identity",  alpha = 0.5,aes(linetype = NA)) +
  geom_point(shape=21,position = position_jitter(width = 0))+
  facet_wrap(~ site, scales = "free",nrow = 1) +
  theme_clean()
