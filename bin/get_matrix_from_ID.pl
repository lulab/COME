use strict;
use warnings;

### header not considered here, the output file will inherit the order of row of the input file. 
open FileTarget	,	"$ARGV[0]" or die; ##first column is the ID, second and latter is one value of prob, all line are outputted
open FileLinenum,	"$ARGV[1]" or die; ##first column is the IDs.
open OUT	,	">$ARGV[2]" or die;##output matched lines 
my $line	=	"";
my %hashTarget;

#process the target file into a hash. prepare for the index search. first is the binID, second 
while($line=<FileTarget>){
	chomp($line);
	my @arr	=	split /\t/,	$line;
	$hashTarget{$arr[0]}=$line;
}
#read the transcripts.binID file, binID as index and ouput corresponding line. 
while($line=<FileLinenum>){
        chomp($line);
	my @arr =       split /\t/,     $line;
        if(defined($hashTarget{$arr[0]})){
                print OUT "$hashTarget{$arr[0]}\n";
        }else{
                print OUT "$arr[0]\tError, can't find the key in the original file\n";
        }
}


