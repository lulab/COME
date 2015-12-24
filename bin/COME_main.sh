
#!/bin/bash
# Print help message if no parameter given
if [ "$#" == 0 ];then
echo "Usage: ./COME_main.sh in_gtf out_dir BIN_DIR species
####	in_gtf	:	is the transcript.gtf file with its absolute path.
####	out_dir	:	is the output folder for your results, better in absolute path.
####	BIN_DIR	:	is the bin folder for COME's scripts, better in absolute path.
####	species	:	is the species your transcripts belong to. Now, only human mouse fly worm plant were allowed.
"
exit;
fi

########################	input_parameters

in_gtf=$1;
out_dir=$2;
BIN_DIR=$3;
species=$4;

########################	processing
####	predefined parameters;
echo "You have specified COME's bin folder as $BIN_DIR";
FILE=${in_gtf##*/};
echo "The input file's name is : $FILE";
if   [ "$species" == "human"	];then CUTOFF=0.4830;	UPSTREAM=100;	MODEL=$BIN_DIR/models/human.model;
elif [ "$species" == "mouse"	];then CUTOFF=0.5052;	UPSTREAM=100;	MODEL=$BIN_DIR/models/mouse.model;
elif [ "$species" == "plant"	];then CUTOFF=0.4282;	UPSTREAM=40;	MODEL=$BIN_DIR/models/plant.model;
elif [ "$species" == "worm"	];then CUTOFF=0.3869;	UPSTREAM=40;	MODEL=$BIN_DIR/models/worm.model;
elif [ "$species" == "fly"	];then CUTOFF=0.4589;	UPSTREAM=40;	MODEL=$BIN_DIR/models/fly.model;
else 
echo "wrong speices specified, only human mouse fly worm plant are avilable now. Exiting...";
exit 1;
fi
echo "You have specified the species as $species";

####	build the output dir (if not exists already) and build temparary folder
[[ -d $out_dir ]] || mkdir -p $out_dir;
cd $out_dir;
TEMP_DIR=`mktemp -d COME.temp.XXXXXX|awk '{print $1}'`;

####	transcript pre-process
bash	$BIN_DIR/pre_process_gtf.sh	$in_gtf		$species	$out_dir/$TEMP_DIR/$FILE.foo	$out_dir/$TEMP_DIR/$FILE.length;
if [ -s $out_dir/$TEMP_DIR/$FILE.foo ]; then echo "Pre-processing is done"; 
else echo "An empty file generated after the pre-processing. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi
####	transcript length
if [ -s $out_dir/$TEMP_DIR/$FILE.length ]; then echo "Transcripts length calculation is done"; 
else echo "An empty file generated after length calculation. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi

####	map index for exon;
bash	$BIN_DIR/Index.sh	$out_dir/$TEMP_DIR/$FILE.foo		$out_dir/$TEMP_DIR/$FILE.index.exon;
if [ -s $out_dir/$TEMP_DIR/$FILE.index.exon ]; then echo "Transcripts index calculation is done"; 
else echo "An empty file generated after transcript index calculation. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi

####	index for up-stream;
awk -F '\t' '{b=split($3,a,"[:,]");print $1"\t"$2"\t"a[1]":"a[b]}'	$out_dir/$TEMP_DIR/$FILE.index.exon	>	$out_dir/$TEMP_DIR/$FILE.index.foo1;
awk -F '\t' -v N="$UPSTREAM" '{split($3,a,"[(:)]");if($1~/-$/){foo=(a[3]+1)":"(a[3]+N);}else{foo=(a[2]-N)":"(a[2]-1);}
print $1"\t"$2"\tc("foo")";}'	$out_dir/$TEMP_DIR/$FILE.index.foo1	>	$out_dir/$TEMP_DIR/$FILE.index.up;
if [ -s $out_dir/$TEMP_DIR/$FILE.index.up ]; then echo "Transcripts upstream index calculation is done"; 
else echo "An empty file generated after transcript upstream index calculation. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi
####	assign feature vector
ls	$BIN_DIR/HDF5/$species.HDF5.*	|grep -v "h3k4me3"		>	$out_dir/$TEMP_DIR/$species.HDF5.list.lo;
ls	$BIN_DIR/HDF5/$species.HDF5.*	|grep  "h3k4me3"		>	$out_dir/$TEMP_DIR/$species.HDF5.list.up;
Rscript	$BIN_DIR/assign_lo.R	$out_dir/$TEMP_DIR/$species.HDF5.list.lo	$out_dir/$TEMP_DIR/$FILE.index.exon	$out_dir/$TEMP_DIR/$FILE.FV.exon;
Rscript	$BIN_DIR/assign_up.R	$out_dir/$TEMP_DIR/$species.HDF5.list.up	$out_dir/$TEMP_DIR/$FILE.index.up	$out_dir/$TEMP_DIR/$FILE.FV.up;
####	feature vector names
awk -F '[/.]' '{print $NF}' $out_dir/$TEMP_DIR/$species.HDF5.list.lo|awk 'BEGIN{foo="transcript_ID";}{
foo=foo"\t"$1".exon.mean\t"$1".exon.max\t"$1".exon.var";}END{print foo}'	>	$out_dir/$TEMP_DIR/$FILE.header.exon;
awk -F '[/.]' '{print $NF}' $out_dir/$TEMP_DIR/$species.HDF5.list.up|awk 'BEGIN{foo="transcript_ID";}{
foo=foo"\t"$1".up.mean\t"$1".up.max\t"$1".up.var";}END{print foo}'		>	$out_dir/$TEMP_DIR/$FILE.header.up;
####	transcript matrix;
cut -d $'\t' -f 2-				$out_dir/$TEMP_DIR/$FILE.header.up	>	$out_dir/$TEMP_DIR/$FILE.header.up.foo;
cut -d $'\t' -f 2-				$out_dir/$TEMP_DIR/$FILE.FV.up		>	$out_dir/$TEMP_DIR/$FILE.FV.up.foo;
paste	$out_dir/$TEMP_DIR/$FILE.FV.exon	$out_dir/$TEMP_DIR/$FILE.FV.up.foo	>	$out_dir/$TEMP_DIR/$FILE.mx.foo;
paste	$out_dir/$TEMP_DIR/$FILE.header.exon	$out_dir/$TEMP_DIR/$FILE.header.up.foo	>	$out_dir/$TEMP_DIR/$FILE.header;
cat	$out_dir/$TEMP_DIR/$FILE.header		$out_dir/$TEMP_DIR/$FILE.mx.foo		>	$out_dir/$TEMP_DIR/$FILE.mx;

if [ -s $out_dir/$TEMP_DIR/$FILE.mx ]; then echo "Transcripts matrix construction is done";
else echo "An empty file generated after transcript matrix construction. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi
rm -rf	$out_dir/$TEMP_DIR/$FILE.foo;
rm -rf	$out_dir/$TEMP_DIR/$FILE.index.foo1;
rm -rf	$out_dir/$TEMP_DIR/$FILE.index.exon	$out_dir/$TEMP_DIR/$FILE.index.up;
rm -rf	$out_dir/$TEMP_DIR/$species.HDF5.list.lo	$out_dir/$TEMP_DIR/$species.HDF5.list.up;
rm -rf	$out_dir/$TEMP_DIR/$FILE.FV.exon	$out_dir/$TEMP_DIR/$FILE.FV.up	$out_dir/$TEMP_DIR/$FILE.header.exon	$out_dir/$TEMP_DIR/$FILE.header.up;
rm -rf	$out_dir/$TEMP_DIR/$FILE.header.up.foo	$out_dir/$TEMP_DIR/$FILE.FV.up.foo	$out_dir/$TEMP_DIR/$FILE.mx.foo	$out_dir/$TEMP_DIR/$FILE.header;

####	predict the matrix by models
head -1	$out_dir/$TEMP_DIR/$FILE.mx		|awk -F '\t' '{for(i=1;i<=NF;i++){print $i}}'	|sed '1d'	>	$out_dir/$TEMP_DIR/$FILE.feat;
Rscript $BIN_DIR/BRF_pred.R	$MODEL		$out_dir/$TEMP_DIR/$FILE.mx	$out_dir/$TEMP_DIR/$FILE.feat	$out_dir/$TEMP_DIR/$FILE.prob0;
echo -e "Coding_Potential\tPrediction"	>	$out_dir/$TEMP_DIR/$FILE.prob;
awk -F '\t' -v cutoff="$CUTOFF" 'NR>1{
if($1>=cutoff){	foo=0.5+(0.5/(1-cutoff))*($1-cutoff);	printf "%0.4f\tcoding\n", foo;
}else{		foo=(0.5*$1)/cutoff;			printf "%0.4f\tnoncoding\n", foo;
}}'     $out_dir/$TEMP_DIR/$FILE.prob0	>>	$out_dir/$TEMP_DIR/$FILE.prob;
cut -f 1 $out_dir/$TEMP_DIR/$FILE.mx	>	$out_dir/$TEMP_DIR/$FILE.foo;
paste	$out_dir/$TEMP_DIR/$FILE.foo		$out_dir/$TEMP_DIR/$FILE.prob	>	$out_dir/$TEMP_DIR/$FILE.prob2;

if [ -s $out_dir/$TEMP_DIR/$FILE.prob2 ]; then echo "Coding potential prediction is done";
else echo "An empty file generated after coding potential prediction. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi
rm -rf	$out_dir/$TEMP_DIR/$FILE.prob0		$out_dir/$TEMP_DIR/$FILE.foo		$out_dir/$TEMP_DIR/$FILE.prob;

####	scaled matrix:
cut -d $'\t' -f 1,3,6,9,12,15,18,21,24,27 	$out_dir/$TEMP_DIR/$FILE.mx	>	$out_dir/$TEMP_DIR/$FILE.mx2;
sed	's/GC.exon.max/GC_content/g;
	s/blastx.exon.max/Protein_Cons/g;
	s/blastn.exon.max/DNA_Cons/g
	s/infernal.exon.max/RNA_Structure/g;
	s/h3k4me3.up.max/H3K4me3/g;
	s/h3k36me3.exon.max/H3K36me3/g;
	s/expnonpolyA.exon.max/PolyA-/g;
	s/exppolyA.exon.max/PolyA+/g;
	s/expsmall.exon.max/smallRNA/g;'	$out_dir/$TEMP_DIR/$FILE.mx2	>	$out_dir/$TEMP_DIR/$FILE.mx3;
matrix_size=`wc -l $out_dir/$TEMP_DIR/$FILE.mx3|awk '{print $1-1}'`
if [ `expr "$matrix_size" ">" "5"` -eq "1"	]; then 
Rscript $BIN_DIR/normalize.R			$out_dir/$TEMP_DIR/$FILE.mx3	2	$out_dir/$TEMP_DIR/$FILE.mx4;
echo "The transcript matrix is scaled successfully.";
else echo "Transcript number is less than 5, can't scale the transcript matrix for such small matrix. Exiting..."; ! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR; exit 1;
fi

####	output the final results
if [ `expr "$matrix_size" "<" "101"` -eq "1"      ]; then 
	####	kmeans and heatmap;
	Rscript $BIN_DIR/kmeans.R	$out_dir/$TEMP_DIR/$FILE.mx4	2	3	$out_dir/$TEMP_DIR/$FILE.kmeans;
	####	output prediction results: coding, coding_potential, length, each feature score;
	cut -f 1 $out_dir/$TEMP_DIR/$FILE.kmeans|sed '1d'|awk -F '\t' '{if(NR==1){print "transcript_ID\n"$1}else{print $1}}'	>	$out_dir/$TEMP_DIR/$FILE.TRIDs
	perl	$BIN_DIR/get_matrix_from_ID.pl	$out_dir/$TEMP_DIR/$FILE.prob2	$out_dir/$TEMP_DIR/$FILE.TRIDs		$out_dir/$TEMP_DIR/$FILE.foo1;
	perl	$BIN_DIR/get_matrix_from_ID.pl	$out_dir/$TEMP_DIR/$FILE.length	$out_dir/$TEMP_DIR/$FILE.TRIDs		$out_dir/$TEMP_DIR/$FILE.foo3;
	cut -f 2- $out_dir/$TEMP_DIR/$FILE.kmeans	>	$out_dir/$TEMP_DIR/$FILE.foo2;
	cut -f 2- $out_dir/$TEMP_DIR/$FILE.foo3		>	$out_dir/$TEMP_DIR/$FILE.foo4;
	paste	$out_dir/$TEMP_DIR/$FILE.foo1	$out_dir/$TEMP_DIR/$FILE.foo2	$out_dir/$TEMP_DIR/$FILE.foo4	|sed 's/ transcript_id //g;s/"//g'	>	$out_dir/result.txt;
        sed '1d' $out_dir/result.txt	|awk -F '\t' '{printf "%s\t%0.4f\t%s\t%d\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%d\t%0.4f\t%d\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14;}'	>	$out_dir/result;
	echo "3 subclasses were assigned. Output matrix is done."
else
	####	1 subclass.
	awk 'BEGIN{FS=OFS="\t"}{if(NR==1){foo="subclass"}else{foo=1;}print $1,foo,$2,$3,$4,$5,$6,$7,$8,$9,$10}'		$out_dir/$TEMP_DIR/$FILE.mx4	>	$out_dir/$TEMP_DIR/$FILE.kmeans;
	####	output prediction results: coding, coding_potential, length, each feature score;
	cut -f 1 $out_dir/$TEMP_DIR/$FILE.kmeans|sed '1d'|awk -F '\t' '{if(NR==1){print "transcript_ID\n"$1}else{print $1}}'	>	$out_dir/$TEMP_DIR/$FILE.TRIDs
	perl	$BIN_DIR/get_matrix_from_ID.pl	$out_dir/$TEMP_DIR/$FILE.prob2	$out_dir/$TEMP_DIR/$FILE.TRIDs		$out_dir/$TEMP_DIR/$FILE.foo1;
	perl	$BIN_DIR/get_matrix_from_ID.pl	$out_dir/$TEMP_DIR/$FILE.length	$out_dir/$TEMP_DIR/$FILE.TRIDs		$out_dir/$TEMP_DIR/$FILE.foo3;
	cut -f 2- $out_dir/$TEMP_DIR/$FILE.kmeans	>	$out_dir/$TEMP_DIR/$FILE.foo2;
	cut -f 2- $out_dir/$TEMP_DIR/$FILE.foo3		>	$out_dir/$TEMP_DIR/$FILE.foo4;
	paste	$out_dir/$TEMP_DIR/$FILE.foo1	$out_dir/$TEMP_DIR/$FILE.foo2	$out_dir/$TEMP_DIR/$FILE.foo4	|sed 's/ transcript_id //g;s/"//g;'	>	$out_dir/result.txt;
        sed '1d' $out_dir/result.txt	|awk -F '\t' '{printf "%s\t%0.4f\t%s\t%d\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%0.4f\t%d\t%0.4f\t%d\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14;}'	>	$out_dir/result;
	echo "1 subclass were assigned. Output matrix is done."
fi;

####	clean
! [[ -d $out_dir/$TEMP_DIR ]] || rm -r -f $out_dir/$TEMP_DIR;

