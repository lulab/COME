#!/bin/bash
# Print help message if no parameter given
if [ "$#" == 0 ];then
echo "Usage: ./Index.sh in_gtf out_index
in_gtf is the transcript.gtf.foo file
out_index is the transcript index
"
exit;
fi
########################	predefined parameters
RI=50;#the resolution of index is half bin size. which is 50 nt;
RA=0.5;#RATIO is the ratio mapped to a 50nt resolution, should be [0.02,1.00];

########################	input_parameters
in_gtf=$1;
out_index=$2;
########################	index for each exon: 
#lap=`echo ""|awk -v RA="$RA" -v RI="$RI" '{print int(RI*RA)}'`;
awk -F '\t' -v RA="$RA" -v RI="$RI" '{ lap=int(RA*RI);
N1=int(($2-1)/RI)+1;	n1=($2-1)%RI;	if(n1 >= lap){N1=N1+1;}
N2=int(($3-1)/RI)+0;	n2=($3-1)%RI;	if(n2 >= lap){N2=N2+1;}
if(N2>=N1){
	print   $1"."$4"\t"$5"\t"N1":"N2;
}else{
	print   $1"."$4"\t"$5"\t0:0";
}}'	$in_gtf	>	$out_index.foo2;
########################	index for each transcript 
awk -F '\t' '{if(NR==1){ID=$2;foo=$3;chrstr=$1;}else{if(ID!=$2){print chrstr"\t"ID"\tc("foo")";ID=$2;foo=$3;chrstr=$1;}else{foo=foo","$3;}}
}END{print chrstr"\t"ID"\tc("foo")";}'	$out_index.foo2	>	$out_index;
########################	stpe3:	clean
rm -rf 	$out_index.foo2;


