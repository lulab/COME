# COME --- calculate COding potential from Multiple fEatures.

## 0. About COME

COME (coding potential calculator based on multiple features) is a computational tool that predicts the coding potential for a given transcript. It integrates multiple sequence-derived and experiment-based features using a decompose-compose method, which makes COME’s performance more accurate and robust than other well-known tools, for transcripts with different lengths and assembly qualities. First, COME compose the feature matrix for the given transcripts using the pre-calculated features vectors. Second, COME predict the coding potential by the pre-trained models, using the feature matrix generated in the first step.

COME is currently pre-trained for five model species: human (hg19), mouse (mm10), fly (dm3), worm (ce10) and plant (TAIR10). The pre-trained models were avaible in the folder of [bin/models] (http://github.com/lulab/COME/tree/master/bin/models)

COME integreated features including GC content, DNA sequence conservation, protein conservation and RNA secondary structure conservation, expression abundance from poly(A)+, poly(A)- and small RNA sequencing, H3K36me3 and H3K4me3 modification. These input features were pre-calculated and avaiable in folder of [bin/HDF5] (http://github.com/lulab/COME/tree/master/bin/HDF5)


COME also is avaliable as a [webserver](http://RNAfinder.ncrnalab.org/COME)  

## 1. Installation and Requirements

COME requires R(>=2.15.2) and R packages "randomForest" and "rhd5" pre-installed in a linux system. In your terminal, enter R and type the following commands:

	install.packages("randomForest"); install.packages("rhd5");

#### COME doesn't need installation.    
1. Users need to download the folder of [bin](http://github.com/lulab/COME) (which contains source codes) from the github into their working directories.
2. Second, users need to download your species' feature vector files from the [download page](http://1drv.ms/1GG4eTA). These (nine) files need to be placed in the subfolder of /your/working/dir/bin/HDF5.
3. Third, users need to download your species' model file from the [download page](http://1drv.ms/1GG4eTA). The model file need to be placed in the subfolder of /your/working/dir/bin/models.
4. For example, if you want to calculate coding potential scores for your _human_ transcripts, here's the instrcution:

		wget

## 2. Usage

	/path/to/COME/bin/folder/COME_chr.sh    /path/to/your/transcripts.gtf    /path/to/your/output    /path/to/COME/bin/folder    model_species_name
  
_____
* `/path/to/COME/bin/folder` is the folder where you kept downloaded COME's scripts and models, namely, the _bin folder_.

* `/path/to/COME/bin/folder/COME_chr.sh` is COME's main program script.

* `/path/to/your/transcripts.gtf` is your input gtf file. Should be given with absolute path. The input gtf file should be:    
  * as the description of ucsc's [gtf format](http://genome.ucsc.edu/FAQ/FAQformat.html#format4)     
  * Users can check the input gtf files using our provided [check_gtf.sh](https://github.com/lulab/COME/check_gtf.sh) script.   
  * `/path/to/COME/bin/folder/check_gtf.sh	/path/to/your/transcripts.gtf	model_species_name`

* `/path/to/your/output` is a folder that will be created (if the user didn't create it already) to save your output file(s).

* `model_species_name` is one of these five names: human, mouse, fly, worm and plant. It specifies which species' CPL file and level 2 model should be applied to your calculation

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
