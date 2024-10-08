library(TreeDist)
library(ape)
library(cluster)
library(ggplot2)
library(openxlsx)

setwd("D:/000青岛-海洋所工作/2023年8月-鹿角珊瑚属/02构树结果/并联树/03计算基因树与物种树之间的距离")
trees<-read.tree("species_genes.tre")
trees_dist<-dist.topo(trees, method = "PH85") #计算RF，trees_dist的数据类别是dist
trees_matric<-as.matrix(trees_dist) # 转化dist到矩阵matrix
write.table (trees_matric, file ="RF_pairs.tsv", sep ="\t") # 保存矩阵数据到RF_pairs.tsv文件


mds1 <- cmdscale(trees_dist, eig=TRUE, k=1) # k代表维度
mds1.df <- as.data.frame(mds1$points)
gskmn1 <- clusGap(mds1.df, FUN = KMeansPP, nstart = 20, K.max = 8, B = 100) ## Compute the gap statistic
plot(gskmn1, xlab = "Number of clusters")
n1 <- maxSE( gskmn1$Tab[, "gap"], gskmn1$Tab[, "SE.sim"], method ="Tibs2001SEmax")
cat("Estimated number of clusters (k=1):", n1, "\n")
#Estimated number of clusters (k=1): 1

mds2 <- cmdscale(trees_dist, eig=TRUE, k=2) # k代表维度
mds2.df <- as.data.frame(mds2$points)
gskmn2 <- clusGap(mds2.df, FUN = KMeansPP, nstart = 20, K.max = 8, B = 100) ## Compute the gap statistic
plot(gskmn2, xlab = "Number of clusters")
n2 <- maxSE( gskmn2$Tab[, "gap"], gskmn2$Tab[, "SE.sim"], method ="Tibs2001SEmax")
cat("Estimated number of clusters (k=2):", n2, "\n")
#Estimated number of clusters (k=2): 1

mds3 <- cmdscale(trees_dist, eig=TRUE, k=3) # k代表维度
mds3.df <- as.data.frame(mds3$points)
gskmn3 <- clusGap(mds3.df, FUN = KMeansPP, nstart = 20, K.max = 8, B = 100) ## Compute the gap statistic
plot(gskmn3, xlab = "Number of clusters")
n3 <- maxSE( gskmn3$Tab[, "gap"], gskmn3$Tab[, "SE.sim"], method ="Tibs2001SEmax")
cat("Estimated number of clusters (k=3):", n3, "\n")
#Estimated number of clusters (k=3): 1

mds4 <- cmdscale(trees_dist, eig=TRUE, k=4) # k代表维度
mds4.df <- as.data.frame(mds4$points)
gskmn4 <- clusGap(mds4.df, FUN = KMeansPP, nstart = 20, K.max = 8, B = 100) ## Compute the gap statistic
plot(gskmn4, xlab = "Number of clusters")
n4 <- maxSE( gskmn4$Tab[, "gap"], gskmn4$Tab[, "SE.sim"], method ="Tibs2001SEmax")
cat("Estimated number of clusters (k=4):", n4, "\n")
#Estimated number of clusters (k=4): 3

mds5 <- cmdscale(trees_dist, eig=TRUE, k=5) # k代表维度
mds5.df <- as.data.frame(mds5$points)
gskmn5 <- clusGap(mds5.df, FUN = KMeansPP, nstart = 20, K.max = 8, B = 100) ## Compute the gap statistic
plot(gskmn5, xlab = "Number of clusters")
n5 <- maxSE( gskmn5$Tab[, "gap"], gskmn5$Tab[, "SE.sim"], method ="Tibs2001SEmax")
cat("Estimated number of clusters (k=5):", n5, "\n")
#Estimated number of clusters (k=5): 3


kmclusters <- kmeans(mds4.df, 3, nstart = 10)
kmclusters <- as.factor(kmclusters$cluster)
kmclusters
mds4.var.per <- round(mds4$eig/sum(mds4$eig)*100,2)
mds4.var.per
mds4.values <- mds4$points

mds4.data <- data.frame(Sample=rownames(mds4.values), X=mds4.values[,1], Y=mds4.values[,2],Z=mds4.values[,3], A=mds4.values[,4])
mds4.data$groups <- kmclusters
mds4.data$Size <- ifelse(mds4.data$Sample == "tree1", 5, 1)
write.table(mds4.data,file="mds4.tsv",sep="\t") # 把MDS的二维值保存到mds.tsv
write.xlsx(mds4.data,file="mds4.xlsx")

ggplot(data=mds4.data, aes(x=X, y=Y,label=Sample, color=groups,size=Size))+
  geom_point() +
  xlab(paste("MDS1 - ", mds4.var.per[1], "%", sep=""))+
  ylab(paste("MDS2 - ", mds4.var.per[2], "%", sep=""))+
  theme_bw()+
  ggtitle("MDS plot using Euclidean distance")



















