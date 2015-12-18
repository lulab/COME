#!/bin/bash
# Print help message if no parameter given
if [ "$#" == 0 ];then
echo "Usage: ./pre_process_gtf.sh in_gtf species out_file;
in_gtf is the transcript.gtf file
species is one of five species: human, mouse, fly, worm and plant
out_file is the output file
"
exit;
fi
########################	input_parameters
in_gtf=$1
species=$2;
out_file=$3;

####	check 1st column to be "chr*", 3rd column to be "exon", 7th column to be "+/-" and 10th column to be "transcript_id *";
if   [ "$species" == "human"	];then 
awk -F '[;\t]' -v hah="$out_file.foo" '{
if(!( $1=="chr1" || $1=="chr2" || $1=="chr3"|| $1=="chr4"|| $1=="chr5"|| $1=="chr6"|| $1=="chr7"|| $1=="chr8"|| $1=="chr9"|| $1=="chr10"|| $1=="chr11"|| $1=="chr12"|| $1=="chr13"|| $1=="chr14"|| $1=="chr15"|| $1=="chr16"|| $1=="chr17"|| $1=="chr18"|| $1=="chr19"|| $1=="chr20"|| $1=="chr21"|| $1=="chr22"|| $1=="chrX"|| $1=="chrY")){
print "Warning: the 1st column contains wrong chromosome ID, row ",NR," is skipped";
}else if($3!="exon"){
print "Warning: the 3rd column should be \"exon\", row ",NR," is skipped";
}else if(!($7=="+"||$7=="-")){
print "Warning: the 7th column should be \"+/-\", row ",NR," is skipped";
}else if($10!~/ transcript_id/){
print "Warning: the 10th column should be \" transcript_id\", row ",NR," is skipped";
}else{
print $1"\t"$4"\t"$5"\t"$7"\t"$10 > hah;
}}'	$in_gtf;
elif [ "$species" == "mouse"	];then
awk -F '[;\t]' -v hah="$out_file.foo" '{
if(!( $1=="chr1" || $1=="chr2" || $1=="chr3"|| $1=="chr4"|| $1=="chr5"|| $1=="chr6"|| $1=="chr7"|| $1=="chr8"|| $1=="chr9"|| $1=="chr10"|| $1=="chr11"|| $1=="chr12"|| $1=="chr13"|| $1=="chr14"|| $1=="chr15"|| $1=="chr16"|| $1=="chr17"|| $1=="chr18"|| $1=="chr19"|| $1=="chrX"|| $1=="chrY")){
print "Warning: the 1st column contains wrong chromosome ID, row ",NR," is skipped";
}else if($3!="exon"){
print "Warning: the 3rd column should be \"exon\", row ",NR," is skipped";
}else if(!($7=="+"||$7=="-")){
print "Warning: the 7th column should be \"+/-\", row ",NR," is skipped";
}else if($10!~/ transcript_id/){
print "Warning: the 10th column should be \" transcript_id\", row ",NR," is skipped";
}else{
print $1"\t"$4"\t"$5"\t"$7"\t"$10 > hah;
}}'	$in_gtf;
elif [ "$species" == "plant"	];then
awk -F '[;\t]' -v hah="$out_file.foo" '{
if(!( $1=="chr1" || $1=="chr2" || $1=="chr3"|| $1=="chr4"|| $1=="chr5")){
print "Warning: the 1st column contains wrong chromosome ID, row ",NR," is skipped";
}else if($3!="exon"){
print "Warning: the 3rd column should be \"exon\", row ",NR," is skipped";
}else if(!($7=="+"||$7=="-")){
print "Warning: the 7th column should be \"+/-\", row ",NR," is skipped";
}else if($10!~/ transcript_id/){
print "Warning: the 10th column should be \" transcript_id\", row ",NR," is skipped";
}else{
print $1"\t"$4"\t"$5"\t"$7"\t"$10 > hah;
}}'	$in_gtf;
elif [ "$species" == "worm"	];then
awk -F '[;\t]' -v hah="$out_file.foo" '{
if(!( $1=="chrI" || $1=="chrII" || $1=="chrIII" || $1=="chrIV" || $1=="chrV" || $1=="chrM" || $1=="chrX" )){
print "Warning: the 1st column contains wrong chromosome ID, row ",NR," is skipped";
}else if($3!="exon"){
print "Warning: the 3rd column should be \"exon\", row ",NR," is skipped";
}else if(!($7=="+"||$7=="-")){
print "Warning: the 7th column should be \"+/-\", row ",NR," is skipped";
}else if($10!~/ transcript_id/){
print "Warning: the 10th column should be \" transcript_id\", row ",NR," is skipped";
}else{
print $1"\t"$4"\t"$5"\t"$7"\t"$10 > hah;
}}'	$in_gtf;
elif [ "$species" == "fly"	];then
awk -F '[;\t]' -v hah="$out_file.foo" '{
if(!( $1=="chr2L" || $1=="chr2R" || $1=="chr3L" || $1=="chr3R" || $1=="chr4" || $1=="chrX" )){
print "Warning: the 1st column contains wrong chromosome ID, row ",NR," is skipped";
}else if($3!="exon"){
print "Warning: the 3rd column should be \"exon\", row ",NR," is skipped";
}else if(!($7=="+"||$7=="-")){
print "Warning: the 7th column should be \"+/-\", row ",NR," is skipped";
}else if($10!~/ transcript_id/){
print "Warning: the 10th column should be \" transcript_id\", row ",NR," is skipped";
}else{
print $1"\t"$4"\t"$5"\t"$7"\t"$10 > hah;
}}'	$in_gtf;
else echo "wrong speices specified, only human mouse fly worm plant are avilable now."; exit;
fi

####	sort
sort -k6,6 -k1,1 -k2,2n -k3,3n -k4,4	$out_file.foo          >       $out_file;
####	clean
rm -rf	$out_file.foo;

