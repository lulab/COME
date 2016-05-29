Args	=	commandArgs(TRUE)
inputF1	=	Args[1];##input file: format as Transcript_ID\tORF_ID\tStart_on_the_transcript\tStop_on_the_transcript\tLength
output1	=	Args[2];##output file.

mx	=	read.table(inputF1,sep="\t",head=F,quote="");
TRs	=	as.vector(mx[,1]);
TR_u	=	as.vector(unique(TRs));
mx2	=	mx;
for(i in 1:length(TR_u)){
	TR_i	=	TR_u[i];
	TR_i_ID	=	which(TRs==TR_i);
	mx_i	=	mx[TR_i_ID,]
	mx_i_cp	=	mx_i;
	Starts	=	c(mx_i[,3],mx_i[1,5])
	for(j in 1:nrow(mx_i)){
		stop_i	=	mx_i[j,4]+1;
		nearest_start	=	min(Starts[which(Starts>stop_i)])
		mx_i_cp[j,3]	=	stop_i;
		mx_i_cp[j,4]	=	nearest_start-1;
	}
	mx2[TR_i_ID,]	=	mx_i_cp;
}

write.table(mx2,file=output1,col.names=F,row.names=F,quote=F,sep="\t");
