####	ORFscore
ORFscore	=	function(ORFtrk){
ORFtrk		=	ORFtrk+1e-5;
ORFtrk		=	ORFtrk[4:(length(ORFtrk)-3)];
frame0		=	ORFtrk[seq(1,length(ORFtrk),by=3)];
frame1		=	ORFtrk[seq(2,length(ORFtrk),by=3)];
frame2		=	ORFtrk[seq(3,length(ORFtrk),by=3)];
if( (mean(frame0)<mean(frame1)) | (mean(frame0)<mean(frame2)) ){
A		=	-1;
}else{
A		=	1;
}
frame0_sum	=	sum((frame0-mean(ORFtrk))^2/mean(ORFtrk))
frame1_sum	=	sum((frame1-mean(ORFtrk))^2/mean(ORFtrk))
frame2_sum	=	sum((frame2-mean(ORFtrk))^2/mean(ORFtrk))
B		=	log(frame0_sum+frame1_sum+frame2_sum+1);
out		=	A*B;
names(out)	=	"ORFscore";
out;
}
