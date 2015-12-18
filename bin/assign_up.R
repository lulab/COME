Args <-commandArgs(TRUE);
inputF1= Args[1];#input the CP h5 file;
inputF2= Args[2];#input the reformated bed file
output1= Args[3];#output the riboseq signal for all transcripts
options(scipen=1000);

library(rhdf5);
####	assign function:
my_fuc=function(x0){
if(x0[1]>0 && x0[1]<=LCP && x0[L]>0 && x0[L]<=LCP){
tmp	=	CP[x0];
tmp2	=	tmp*W;
AVE     =       mean(tmp2,na.rm=T);
MAX     =       max(tmp,na.rm=T);
if(length(tmp)>1){
VAR     =       var(tmp,na.rm=T);
}else{
VAR     =       0;
}
y       =       round(c(AVE,MAX,VAR),4);
}else{
y	=	c(0,0,0);
}
}

####	reverse the strands here:
my_evu	=	function(X){
y	=	eval(parse(text=X))
if(STR=="-"){
y	=	rev(y);
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
	tmp	=	unlist(strsplit(i,fix=T,split="."));
	STR	<<-	tmp[length(tmp)];
	TR	=	TR_all[ID_i,];
	TRID    =	as.matrix(TR[,2]);
	m       =       as.character(as.vector(TR[,3]));
	m2	=	t(sapply(m,my_evu));
	L	<<-	ncol(m2);
	W	<<-	exp(-1 * (((L-1):0)/L));
	for(j in 1:length(HDF5s)){
		CP	<<-	h5read(HDF5s[j],i);
		LCP	<<-	length(CP);
		out	=	as.matrix(t(apply(m2,1,my_fuc)));
		if(j==1){
			out2	=	cbind(TRID,out);
		}else{
			out2	=	cbind(out2,out);
		}
	}
	if(flag==1){
		fout	=	out2;
	}else{
		fout	=	rbind(fout,out2);
	}
		flag	=	flag+1;
}

write.table(fout,file=output1,quote=F,sep="\t",col.name=F,row.name=F);
rm(list=ls());

