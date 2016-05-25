Args	=	commandArgs(TRUE);
inputF1	=	Args[1];#input the matrix; with bin anno clust, and header;
output1	= 	Args[2];#output the heatmap file;
library("gplots")
Matrix	=	read.table(inputF1,sep="\t",head=T,quote="");
cluster =       as.matrix(Matrix[,2]);
clusters=	unique(cluster);
ID	=	c();
for(i in 1:length(clusters)){
ID1	=	which(cluster==clusters[i]);
if(length(ID1)>500){
ID2	=	sample(ID1,size=500,replace=F)
}else{
ID2	=	ID1;
}
ID	=	c(ID,ID2);
}
ID4	=	sort(ID)
if(nrow(Matrix)>3000){
ID4     =       sort(sample(1:nrow(Matrix),size=3000,replace=F));
Matrix	=	Matrix[ID4,];
}
tmp	=	Matrix[,-c(1:2)];
Matrix1	=	as.matrix(tmp);

cluster =       as.matrix(Matrix[,2]);
mycolhc	=	rainbow(40, start=0.1, end=0.95); 
mycolhc	=	mycolhc[c(1,2,5,15,22,23,28,31,34,36,38,40)]
cluster =       mycolhc[cluster];

pdf(output1,width=6,height=8);
print(heatmap.2(Matrix1,Rowv = FALSE, Colv=FALSE, margins = c(8, 1),labRow=F,dendrogram="none",scale = "none",trace="none",RowSideColors=cluster));
dev.off()


