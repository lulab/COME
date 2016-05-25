Args	=	commandArgs(TRUE);
inputF1	=	Args[1];#input the model;
inputF2	=	Args[2];#input the predict matrix;
output1	=	Args[3];#output the predition probablity.

Nlines	= 	10000;
library("randomForest");
load(inputF1);

INid	=	file(inputF2,"r");			
flag	=	0;
IN	=	readLines(INid,n=Nlines);			
while(length(IN)	!=	0){
	if(flag ==	0){
		Mx	=	read.table(text=IN,sep="\t",head=T,quote="",check.names=F);
		HEADER	=	colnames(Mx);
		tmp	=	model_list[[1]];
		FI	=	as.vector(rownames(tmp$importance));
		ID	=	which(is.element(HEADER,FI));
		Mx	=	as.matrix(Mx[,ID]);
		for(m in 1:length(model_list)){
			rf	=	model_list[[m]];
			RF_pred	=	predict(rf,Mx,type="vote");
			if(m==1){
				RF_pred_sum	=	RF_pred
			}else{
				RF_pred_sum	=	RF_pred_sum + RF_pred;
			}
		}
		RF_pred_mean	=	round(RF_pred_sum/length(model_list),4);
		write.table(RF_pred_mean,file=output1,quote=F,sep="\t",col.name=T,row.name=F,append = FALSE);
		flag	=	1;
	}else{
		Mx	=	read.table(text=IN,sep="\t",head=F);
		colnames(Mx)	=	HEADER;
		Mx	=	as.matrix(Mx[,ID]);
		for(m in 1:length(model_list)){
			rf	=	model_list[[m]];
			RF_pred	=	predict(rf,Mx,type="vote");
			if(m==1){
				RF_pred_sum	=	RF_pred
			}else{
				RF_pred_sum	=	RF_pred_sum + RF_pred;
			}
		}
		RF_pred_mean	=	round(RF_pred_sum/length(model_list),4);
		write.table(RF_pred_mean,file=output1,quote=F,sep="\t",col.name=F,row.name=F,append = TRUE);
	
	}
	rm(Mx, RF_pred_sum, RF_pred, RF_pred_mean);
	IN	=	readLines(INid,n=Nlines);
}
close(INid);

rm(list=ls());

