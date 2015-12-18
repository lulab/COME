Args	=	commandArgs(TRUE);
inputF1	=	Args[1];#input the matrix; with anno.detail, bin anno, and header;
inputF2	=	as.numeric(Args[2]);#from which column to perform kmeans
inputF3	=	as.numeric(Args[3]);#input k as parameter
output1	=	Args[4];#output the matrix with subclassID;

mx	=	read.table(inputF1,sep="\t",head=T,quote="",check.names=F);
mx1	=	as.data.frame(as.matrix(mx[,1:(inputF2-1)]));
mx2	=	as.matrix(mx[,inputF2:ncol(mx)]);
mx2     =       as.data.frame(format(round(mx2, 4), nsmall = 4));

km      =	kmeans(mx2,inputF3,iter.max=1000);
subclass	=	(km$cluster);
mx3	=	cbind(subclass,mx2);
mx4	=	cbind(mx1,mx3);
ID	=	order(mx4[,inputF2])
mx5	=	mx4[ID,]

write.table(mx5,file=output1,sep="\t",quote=F,col.name=T,row.name=F);


rm(list=ls());

