#! /bin/bash

# split files into two chunks, into labels for further ASL processing
# ARGS
# $1 is the path to data
# $2 is input data filename without extensions 
# $3 is output data filename without extensions 
# $4 is start dynamic 
# $5 is start dynamic for second chunk 
# $6 is how long you want the chunks to be
# $7 is m0 base file   

# example usage
# sh /Users/ppzma/Documents/MATLAB/nottingham/bin/splitnmerge.sh . infile outfilename 0 30 30 basefile
# 0 31 31 if you have a noise scan

if [ $# -lt 6 ] ; then
     echo 
     # echo "Usage: sh splitnmerge.sh path indatafilename outdatafilename basename"
     echo "Usage: sh splitnmerge.sh path indatafilename outdatafilename start end numdyn" #baseimage	
     exit 1;
fi


echo "cd to path" 
cd $1

# fslsplit $2 s$3 -t


# fslmerge -t $3_label1 s${3}0000 s${3}0002 s${3}0004 s${3}0006 s${3}0008 s${3}0010 s${3}0012 s${3}0014 s${3}0016 s${3}0018 s${3}0020 s${3}0022 s${3}0024 s${3}0026 s${3}0028 s${3}0030 s${3}0032 s${3}0034 s${3}0036 s${3}0038 s${3}0040 s${3}0042 s${3}0044 s${3}0046 s${3}0048 s${3}0050 s${3}0052 s${3}0054 s${3}0056 s${3}0058
# fslmerge -t $3_label2 s${3}0001 s${3}0003 s${3}0005 s${3}0007 s${3}0009 s${3}0011 s${3}0013 s${3}0015 s${3}0017 s${3}0019 s${3}0021 s${3}0023 s${3}0025 s${3}0027 s${3}0029 s${3}0031 s${3}0033 s${3}0035 s${3}0037 s${3}0039 s${3}0041 s${3}0043 s${3}0045 s${3}0047 s${3}0049 s${3}0051 s${3}0053 s${3}0055 s${3}0057 s${3}0059


# echo "removing split files"
# rm s*


# fslchfiletype NIFTI_GZ $4 ${3}_base


echo "calling fslroi"
fslroi $2 ${3}_label1 $4 $6
fslroi $2 ${3}_label2 $5 $6

fslchfiletype NIFTI ${3}_label1 ${3}_label1
fslchfiletype NIFTI ${3}_label2 ${3}_label2

#fslchfiletype NIFTI_GZ $7 ${3}_base









