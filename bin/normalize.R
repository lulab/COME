Args <-commandArgs(TRUE);
inputF1= Args[1];#input the feature file, has no header, all columns are features; top and bottom 2.5% were as the max or the minimum score, then if range more than 100, log scale first.
inputF2= Args[2];#from which column to scale
outputF= Args[3];#the output normalized file;
options(scipen=1000);
my_fuc	=	function(tmp){
###replace extrem values
        bottom=quantile(tmp,0.025,na.rm=T);
        top=quantile(tmp,0.975,na.rm=T);
        tmp[tmp>top]=top;
        tmp[tmp<bottom]=bottom;
###log scale
        if(top - bottom>100){
                tmp=log10(tmp-bottom+1);
        }
###scale to 0 ~1 
        MAX2=max(tmp,na.rm=T);
        MIN2=min(tmp,na.rm=T);
	if(MAX2==MIN2){
		tmp=rep(0,length=length(tmp));
	}else{
        	tmp=(tmp-MIN2)/(MAX2-MIN2);
	}
        y=tmp;
}
inputF2	=	as.numeric(inputF2);

mx	=	read.table(inputF1,sep="\t",head=T,quote="",check.names=F);
mx1	=	mx[,1:(inputF2-1)];
mx2	=	as.matrix(mx[,inputF2:ncol(mx)]);
mx3	=	apply(mx2,2,my_fuc);
#mx4	=	as.data.frame(round(mx3,4));
mx4	=	as.data.frame(format(round(mx3, 4), nsmall = 4));
mx5	=	cbind(mx1,mx4);
write.table(mx5,file=outputF,quote=F,row.name=F,col.name=T,sep="\t");
rm(list=ls());

