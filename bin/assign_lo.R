Args <-commandArgs(TRUE);
inputF1= Args[1];#input the CP h5 file;
inputF2= Args[2];#input the reformated bed file
output1= Args[3];#output the riboseq signal for all transcripts
options(scipen=1000);

library(rhdf5);
####	assign function:
my_fuc=function(X){
####	remove nonsense points first
x0	=	eval(parse(text=X))
ID	=	which(x0<1);
if(length(ID)>0){
	x0	=	x0[-ID];
}
ID	=	which(x0>LCP);
if(length(ID)>0){
	x0	=	x0[-ID];
}
####	after removal, if there's other coordinates, calculates
####	otherwise, just assign 0
if(length(x0)>=1){
	tmp	=	CP[x0];
	AVE	=	mean(tmp,na.rm=T);
	MAX	=	max(tmp,na.rm=T);
	if(length(tmp)>1){
		VAR	=	var(tmp,na.rm=T);
	}else{
		VAR	=	0;
	}
	y	=	round(c(AVE,MAX,VAR),4);
}else{
	y	=	c(0,0,0);
}
y
}
####	
TR_all	=	read.table(inputF2,sep="\t",head=F,quote="");
PT_u	=	as.vector(unique(TR_all[,1]))
flag	=	1;
HDF5s	=	as.vector(as.matrix(read.table(inputF1,sep="\t",head=F,quote="")));
for(i in PT_u){
	print(i)
	ID_i	=	which(TR_all[,1]==i);
	TR	=	TR_all[ID_i,];
	TRID    =	as.matrix(TR[,2]);
	m       =       as.character(as.vector(TR[,3]));
	for(j in 1:length(HDF5s)){
		CP	<<-	h5read(HDF5s[j],i);
		LCP	<<-	length(CP);
		out	=	as.matrix(t(sapply(m,my_fuc)));
		if(j==1){
			out2=	cbind(TRID,out);
		}else{
			out2=	cbind(out2,out);
		}
	}
	if(flag==1){
		final_out	=	out2;
	}else{
		final_out	=	rbind(final_out,out2);
	}
		flag	=	flag+1;
}

write.table(final_out,file=output1,quote=F,sep="\t",col.name=F,row.name=F);
rm(list=ls());

