# COME --- calculate COding potential from Multiple fEatures.

## 0. About COME

COME (coding potential calculator based on multiple features) is a computational tool that predicts the coding potential for a given transcript. It integrates multiple sequence-derived and experiment-based features using a decompose-compose method, which makes COME’s performance more accurate and robust than other well-known tools. First, COME compose the feature matrix for the given transcripts using the pre-calculated features vectors. Second, COME predict the coding potential by the pre-trained models, using the feature matrix generated in the first step.

COME is currently pre-trained for five model species: human (hg19), mouse (mm10), fly (dm3), worm (ce10) and plant (TAIR10). The pre-trained models were avaible in the folder of [bin/models] (https://github.com/lulab/COME/tree/master/bin/models)

COME integreated features including GC content, DNA sequence conservation, protein conservation and RNA secondary structure conservation, expression abundance from poly(A)+, poly(A)- and small RNA sequencing, H3K36me3 and H3K4me3 modification. These input features were pre-calculated and avaiable in folder of [bin/HDF5] (https://github.com/lulab/COME/tree/master/bin/HDF5)

For users who are not familiar with Linux, we also provide a [webserver](http://RNAfinder.ncrnalab.org/COME), which is still in a beta version.


## 1. Installation
####	Pre-requisite
1. **Download HDF5 and model files** from [onedrive](https://1drv.ms/f/s!ApoJcQmK8fsKg5MS7NfEUGhahiLLFA) or [Tsinghua Cloud](https://cloud.tsinghua.edu.cn/d/dfbc9a67f9124bda93c6/)
2. Linux
3. R (>=2.15.2)
4. R packages ("randomForest" and "rhdf5"); You can install these packages by entering R and typing these:

		## Install package "randomForest"
		install.packages("randomForest"); 
		## Install package "rhdf5"
		source("http://bioconductor.org/biocLite.R");biocLite("rhdf5");


####	Download files into sepcific folders.   
1. First, change directory to your working directory, download the source codes from https://github.com/lulab/COME/archive/master.zip and decompress it. Enter the subfolder "COME-master/bin" and define the path as the variable `Bin_dir`

		$ unzip		./COME-master.zip;
		$ cd 		./COME-master/bin;
		$ Bin_dir=`pwd|awk '{print $1}'`;

2. Second, download your species'(Let's say, _human_) feature vector files from onedrive or Tsinghua Cloud ( [see download links above](#pre-requisite) ). These (nine) files need to be placed in the subfolder "COME-master/bin/HDF5".

		$ unzip	./human.feature_vector.HDF5.zip;
		$ mv	./human/human.HDF5.*	$Bin_dir/HDF5;
	
3. Third, download your species' model file from onedrive or Tsinghua Cloud ( [see download links above](#pre-requisite) ). The (one) model file need to be placed in the subfolder "COME-master/bin/models".

		$ mv	./human.model	$Bin_dir/models;


## 2. Usage and Examples

	bash /path/to/bin_subfolder/COME_main.sh /path/to/your/transcripts.gtf	/path/to/your/output_folder/	/path/to/bin_subfolder/	species	model;
  
_____
* `/path/to/bin_subfolder/` is the path where you kept downloaded COME's "bin" subfolder, i.e., the `$Bin_dir`

* `/path/to/bin_subfolder/COME_main.sh` is COME's main program script.

* `/path/to/your/transcripts.gtf` is your input gtf file. The input gtf file should be as the description of ucsc's [gtf format] (http://genome.ucsc.edu/FAQ/FAQformat.html#format4). In summary, the first field should be chormosome in lower and abbreviate case (e.g., chr1, chrX); the third field should be exactly "exon"; the seventh field should be strand (i.e., + or -). The subsequent attribute list must begin with the two mandatory attributes: gene_id "value"; transcript_id "value". In addition, transcript length should be longer than 50 nucleotides. Any lines of your input file don't match the criteria aboved will be skipped.

* `/path/to/your/output_folder/` is a folder that will be created (if the user didn't create it already) to save your output file "result.txt"

* `species` is one of these five names: "human", "mouse", "fly", "worm" and "plant". It specifies which species' feature vector files should be applied to your calculation

* `model` is one of these ten names: "human.model", "human.NoExpHis.model", "mouse.model", "mouse.NoExpHis.model", "fly.model", "fly.NoExpHis.model", "worm.model", "worm.NoExpHis.model", "plant.model" and "plant.NoExpHis.model". It specifies which model should be applied to your calculation. `*.model`, e.g., `human.model`, is the default model trained by multiple sequence-derived and experiment-based features. We also provided `*.NoExpHis.model`, e.g., `human.NoExpHis.model`, which is the model trained by multiple sequence-derived features only.



______  

#### An example:

Assuming I want to predict the human test transcripts from the [examples] (https://github.com/lulab/COME/tree/master/examples) folder, `human.test.gtf`. I would work on my home directory `~/` and I want the output of COME stored in a folder named `~/COME_out/`.

1. `~/COME-master.zip` was downloaded to my working directory `~/` from [github] (https://github.com/lulab/COME/archive/master.zip) by clicking the link or wget:

		$ cd ~;
		$ wget -c --content-disposition   http://github.com/lulab/COME/archive/master.zip;
		
2. `~/human.feature_vector.HDF5.zip` was downloaded to my working directory `~/` from onedrive or Tsinghua Cloud ( [see download links above](#pre-requisite) ) or wget:

		$ cd ~;
		$ wget -c --content-disposition http://lulab.life.tsinghua.edu.cn/RNAfinder/download_files_for_COME/HDF5/human.feature_vector.HDF5.zip

3. `~/human.model` was downloaded to my working directory `~/` from onedrive or Tsinghua Cloud ( [see download links above](#pre-requisite) ) or wget:
	
		$ cd ~;
		$ wget -c --content-disposition   http://lulab.life.tsinghua.edu.cn/RNAfinder/download_files_for_COME/models/human.model

4. Then run COME by the following commands: 

		## Installation and preparison
		$ cd ~/;		
		$ unzip	./COME-master.zip;
		$ cd 	./COME-master/bin;
		## Save the path of "bin" subfolder to the variable "$Bin_dir"
		$ Bin_dir=`pwd|awk '{print $1}'`;
		$ cd ~/;
		$ unzip	./human.feature_vector.HDF5.zip;
		$ mv	./human/human.HDF5.*	$Bin_dir/HDF5;
		$ rm -rf	./human;
		$ mv	./human.model	$Bin_dir/models;
		## Running COME
		$ bash $Bin_dir/COME_main.sh	$Bin_dir/../examples/human.test.gtf	~/COME_out	$Bin_dir	human	human.model;

6. The final output will be stored in `~/COME_out/result.txt`. We can compare it with the example output file `~/human.test.result.txt`. (Notice: the subclass number may be different, because the K-means algorithm used random seed.)

7. Users are recommended to use the absolute path (`/dir1/dir2/file1`) instead of the relative path (`../../file2`).



## 3. Citing COME
=================

Hu L., Xu Z., Hu B. and Lu ZJ, COME: a robust coding potential calculation tool for lncRNA identification and characterization based on multiple features, 2016 


## 4. Contact
==========

Long Hu <hulongptp@gmail.com>
