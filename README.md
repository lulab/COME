# COME --- calculate COding potential from Multiple fEatures.

## 0. About COME

COME (coding potential calculator based on multiple features) is a computational tool that predicts the coding potential for a given transcript. It integrates multiple sequence-derived and experiment-based features using a decompose-compose method, which makes COME’s performance more accurate and robust than other well-known tools, for transcripts with different lengths and assembly qualities. First, COME compose the feature matrix for the given transcripts using the pre-calculated features vectors. Second, COME predict the coding potential by the pre-trained models, using the feature matrix generated in the first step.

COME is currently pre-trained for five model species: human (hg19), mouse (mm10), fly (dm3), worm (ce10) and plant (TAIR10). The pre-trained models were avaible in the folder of [bin/models] (http://github.com/lulab/COME/tree/master/bin/models)

COME integreated features including GC content, DNA sequence conservation, protein conservation and RNA secondary structure conservation, expression abundance from poly(A)+, poly(A)- and small RNA sequencing, H3K36me3 and H3K4me3 modification. These input features were pre-calculated and avaiable in folder of [bin/HDF5] (http://github.com/lulab/COME/tree/master/bin/HDF5)


COME also is avaliable as a [webserver](http://RNAfinder.ncrnalab.org/COME)  

## 1. Installation
####	Pre-requisite:
1. Linux
2. R (>=2.15.2)
3. R packages ("randomForest" and "rhd5"); You can install these packages by entering R and typing these: `install.packages("randomForest"); install.packages("rhd5");`

####	Download files into sepcific folders.   
1. First, change directory to your working directory, download the source codes from https://github.com/lulab/COME/archive/master.zip and decompress it. Enter the subfolder "COME-master/bin" and define the path as the variable `Bin_dir`

		unzip	master.zip;
		cd 	COME-master/bin;
		Bin_dir=`pwd|awk '{print $1}'`;

2. Second, download your species'(Let's say, _human_) feature vector files from the [download page for feature vectors](http://1drv.ms/1GG4eTA). These (nine) files need to be placed in the subfolder "COME-master/bin/HDF5".  transcriptome.

		unzip	human.feature_vector.HDF5.zip;
		mv	./human.feature_vector.HDF5/*	$Bin_dir/HDF5;
	
3. Third, download your species' model file from the [download page for models](http://1drv.ms/1GG4eTA). The (one) model file need to be placed in the subfolder "COME-master/bin/models".

		mv	human.model	$Bin_dir/models;


## 2. Usage

	$Bin_dir/COME_main.sh /path/to/your/transcripts.gtf	/path/to/your/output	$Bin_dir	species
  
_____
* `$Bin_dir` is the folder where you kept downloaded COME's "bin" subfolder.

* `$Bin_dir/COME_main.sh` is COME's main program script.

* `/path/to/your/transcripts.gtf` is your input gtf file. The input gtf file should be as the description of ucsc's [gtf format] (http://genome.ucsc.edu/FAQ/FAQformat.html#format4).    

* `/path/to/your/output` is a folder that will be created (if the user didn't create it already) to save your output file.

* `species` is one of these five names: human, mouse, fly, worm and plant. It specifies which species' feature vector files and model should be applied to your calculation

______  

#### An example:

Assuming I want to predict human transcripts, `/my/test/transcript.gtf`. I would download the [scripts] (https://github.com/lulab/COME) into `/my/working/directory/bin`, also downloaded `human.CPL`, `human.chr.models` from the [download page](http://1drv.ms/1GG4eTA) and move them into `/my/working/directory/bin`. And the output files would be saved in `/my/output/directory`;  
The command would be: 

	/my/working/directory/bin/check_gtf.sh   /my/test/transcript.gtf    human
	/my/working/directory/bin/COME_chr.sh    /my/test/transcript.gtf    /my/output/directory    /my/working/directory/bin    human


## 3. Citing COME
=================

Hu L., Hu B. and Lu ZJ,  COME: a robust coding potential calculator for lncRNA identification and characterization based on multiple features,   2015


## 4. Contact
==========

Long Hu <hulongptp@gmail.com>
