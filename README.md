# COME --- calculate COding potential from Multiple fEatures.

## 0. About COME

COME (coding potential calculator based on multiple features) is a computational tool that predicts the coding potential for a given transcript, which is not required to be conserved or fully assembled. It is a two-level machine-learning method, which uses multiple features of a transcript to predict its coding potential.The first level model is to generate a coding potential landscape, which describes the coding potential fluctuation of bins (100-nt intervals with 50-nt overlap) along the whole genome. The coding potential landscape (CPL) is integrated from multiple features (sequence, structure, expression and histone modification features) of bins. The second level learning model is to predict an input transcript to be a coding transcript or a non-coding transcript based on its overlapped CPL's pattern. 

Since the level 1 learning model integrated lots of features, which is a very complicated process, we pre-calculated the CPL for five model species: human (hg19), mouse (mm10), fly (dm3), worm (ce10) and plant (TAIR10). The known coding and non-coding trasncripts' CPL patterns are also learned and stored in our level 2 models for these species.

COME also is avaliable as a [webserver](http://RNAfinder.ncrnalab.org/COME)  

## 1. Installation and Requirements

COME requires R(>=2.15.2) and R packages "randomForest" and "rhd5" pre-installed in a linux system.

#### COME doesn't need installation.    
1. users need to download the [scripts](https://github.com/lulab/COME) (which contains source codes) from the github into his working directory. Make sure all the files are in one folder, hereafter, we name this folder the _bin folder_.    
2. Second, users need to download your species' CPL file and level 2 model from the [download page](http://1drv.ms/1GG4eTA). These (two) files need to be also placed in the _bin folder_ under your working directory.

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
