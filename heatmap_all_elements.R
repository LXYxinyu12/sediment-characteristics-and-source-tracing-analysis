setwd('E:/R_code/particles/heatmap')

dt = read.csv('dt_all1.csv')#utf-8
dt = read.csv('dt_metal.csv')

rownames(dt) = dt[,1]
dt = dt[,-1]
data <- dt[,-c(1,2)]
data = as.data.frame(lapply(data,as.numeric))
rownames(data) = rownames(dt[,-c(1,2)])

rownum <- nrow(data) 
colnum <- ncol(data)

# 循环进行归一化
for (i in 1:colnum) {
  
  col <- data[,i ]
  
  min_val <- min(col)
  max_val <- max(col)
  
  data[,i] <- (col - min_val) / (max_val - min_val)
}

Month = factor(c('01','02','03','04','05','06','07','08','09','10','12','01','02','03','05','06','07','08','09','10','12','01','02','03','05','06','07','08','09','10','12',
                 '04','05','06','01','02','03','05','06','07','08','09','10','12','01','02','03','05','06','07','08','09','10','12'))
annotation_row = data.frame(Month,Site = factor(rep(c("CS", "CR", "CW",'SS','SR','SW'), c(11, 10, 10,3,10,10))))

rownames(annotation_row) = rownames(dt)

ann_colors=list(Site=c(CS = '#E9967A', CR='#815c94',CW='#778899',SS = '#525288', SR='#815c94',SW='#778899'))

Elements = factor(c('C_N_S','Major_metal_element','Trace_metal_element'))
annotation_col = data.frame(Elements = factor(rep(c('C_N_S','Major_metal_element','Trace_metal_element'), c(3, 6, 16))))
rownames(annotation_col) = colnames(data)


library(pheatmap)
pheatmap(data,cluster_cols = F,cluster_rows = T,cellwidth = 12,main = 'Title',
         annotation_row = annotation_row, annotation_colors=ann_colors,
         cutree_rows = 5,show_colnames = T,treeheight_col = 0,treeheight_row = 0, border_color = 'grey')
