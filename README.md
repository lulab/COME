# COME --- calculate COding potential from Multiple fEatures.

## 0. About COME

COME (coding potential calculator based on multiple features) is a computational tool that predicts the coding potential for a given transcript. It integrates multiple sequence-derived and experiment-based features using a decompose-compose method, which makes COME’s performance more accurate and robust than other well-known tools, for transcripts with different lengths and assembly qualities. First, COME compose the feature matrix for the given transcripts using the pre-calculated features vectors. Second, COME predict the coding potential by the pre-trained models, using the feature matrix generated in the first step.

COME is currently pre-trained for five model species: human (hg19), mouse (mm10), fly (dm3), worm (ce10) and plant (TAIR10). The pre-trained models were avaible in the folder of [bin/models] (https://github.com/lulab/COME/tree/master/bin/models)

COME integreated features including GC content, DNA sequence conservation, protein conservation and RNA secondary structure conservation, expression abundance from poly(A)+, poly(A)- and small RNA sequencing, H3K36me3 and H3K4me3 modification. These input features were pre-calculated and avaiable in folder of [bin/HDF5] (https://github.com/lulab/COME/tree/master/bin/HDF5)


COME also is avaliable as a [webserver](http://RNAfinder.ncrnalab.org/COME)  

## 1. Installation
####	Pre-requisite:
1. Linux
2. R (>=2.15.2)
3. R packages ("randomForest" and "rhdf5"); You can install these packages by entering R and typing these:

		## Install package "randomForest"
		install.packages("randomForest"); 
		## Install package "rhdf5"
		source("http://bioconductor.org/biocLite.R");biocLite("rhdf5");


####	Download files into sepcific folders.   
1. First, change directory to your working directory, download the source codes from https://github.com/lulab/COME/archive/master.zip and decompress it. Enter the subfolder "COME-master/bin" and define the path as the variable `Bin_dir`

		$ unzip		./master.zip;
		$ cd 		./COME-master/bin;
		$ Bin_dir=`pwd|awk '{print $1}'`;

2. Second, download your species'(Let's say, _human_) feature vector files from the [download page for feature vectors](https://onedrive.live.com/redir?resid=AFBF18A0971099A!51586&authkey=!AJaFH5EENUp0FVI&ithint=folder%2czip) or [mirror](http://pan.baidu.com/s/1bnShVA3). These (nine) files need to be placed in the subfolder "COME-master/bin/HDF5".

		$ unzip	./human.feature_vector.HDF5.zip;
		$ mv	./human/human.HDF5.*	$Bin_dir/HDF5;
	
3. Third, download your species' model file from the [download page for models](https://onedrive.live.com/redir?resid=AFBF18A0971099A!51594&authkey=!AJf5-cl93Z-4nJs&ithint=folder%2cmodel) or [mirror](http://pan.baidu.com/s/1dEs2pjV). The (one) model file need to be placed in the subfolder "COME-master/bin/models".

		$ mv	./human.model	$Bin_dir/models;


## 2. Usage and Examples

	/path/to/bin_subfolder/COME_main.sh /path/to/your/transcripts.gtf	/path/to/your/output_folder/	/path/to/bin_subfolder/	species;
  
_____
* `/path/to/bin_subfolder/` is the path where you kept downloaded COME's "bin" subfolder, i.e., the `$Bin_dir`

* `/path/to/bin_subfolder/COME_main.sh` is COME's main program script.

* `/path/to/your/transcripts.gtf` is your input gtf file. The input gtf file should be as the description of ucsc's [gtf format] (http://genome.ucsc.edu/FAQ/FAQformat.html#format4).    

* `/path/to/your/output_folder/` is a folder that will be created (if the user didn't create it already) to save your output file "result.txt"

* `species` is one of these five names: human, mouse, fly, worm and plant. It specifies which species' feature vector files and model should be applied to your calculation

______  

#### An example:

Assuming I want to predict the human test transcripts from the [examples] (https://github.com/lulab/COME/tree/master/examples) folder, `human.test.gtf`. I would work on my home directory `~/` and I want the output of COME stored in a folder named `~/COME_out/`.

`~/COME-master.zip` was downloaded to my working directory `~/` from [github] (https://github.com/lulab/COME/archive/master.zip).

`~/human.feature_vector.HDF5.zip` was downloaded to my working directory `~/` from [download page for feature vectors](https://onedrive.live.com/redir?resid=AFBF18A0971099A!51586&authkey=!AJaFH5EENUp0FVI&ithint=folder%2czip) or [mirror](http://pan.baidu.com/s/1bnShVA3).

`~/human.model` was downloaded to my working directory `~/` from [download page for models](https://onedrive.live.com/redir?resid=AFBF18A0971099A!51594&authkey=!AJf5-cl93Z-4nJs&ithint=folder%2cmodel) or [mirror](http://pan.baidu.com/s/1dEs2pjV). 

The example input file `human.test.gtf` and example output file `human.test.result.txt` was downloaded to my working directory `~/` from [github] (https://github.com/lulab/COME/tree/master/examples).

The commands would be: 

		## Installation and preparison
		$ cd ~/;		
		$ unzip	./master.zip;
		$ cd 	./COME-master/bin;
		## Save the path of "bin" subfolder to the variable "$Bin_dir"
		$ Bin_dir=`pwd|awk '{print $1}'`;
		$ unzip	./human.feature_vector.HDF5.zip;
		$ mv	./human/human.HDF5.*	$Bin_dir/HDF5;
		$ mv	./human.model	$Bin_dir/models;
		## Running COME
		$ $Bin_dir/COME_main.sh ~/human.test.gtf	~/COME_out/	$Bin_dir	human;


The final output will be stored in `~/COME_out/result.txt`;
We can compare it with the example output file `~/human.test.result.txt` by the following command:

		$ diff	~/COME_out/result.txt	~/human.test.result.txt;


## 3. Citing COME
=================

Hu L., Hu B. and Lu ZJ,  COME: a robust coding potential calculator for lncRNA identification and characterization based on multiple features,   2015


## 4. Contact
==========

Long Hu <hulongptp@gmail.com>
