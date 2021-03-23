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

subjectlist="001_H07_V2 001_H08_V1 001_H08_V2 001_H09_V1 001_H09_V2 001_H11_V1 001_H11_V2 001_H13_V1 001_H13_V2\
    001_H14_V1 001_H14_V2 001_H15_V1 001_H15_V2 001_H16_V1 001_H16_V2 001_H17_V1 001_H19_V1 001_H19_V2\
    001_H23_V1 001_H23_V2 001_H24_V1 001_H24_V2 001_H25_V1 001_H25_V2 001_H27_V1 001_H27_V2 001_H28_V1 001_H28_V2\
    001_H29_V1 001_H29_V2 001_H30_V1 001_H30_V2"

subjectlistP="001_P01_V1 001_P01_V2 001_P02_V1 001_P02_V2 001_P03_V1 001_P03_V2 001_P04_V1 001_P04_V2 001_P05_V1 001_P05_V2\
	001_P06_V1 001_P06_V2 001_P07_V1 001_P08_V1 001_P08_V2 001_P09_V1 001_P09_V2 001_P10_V1 001_P10_V2 001_P11_V1\
	001_P12_V1 001_P12_V2 001_P13_V2 001_P14_V1 001_P15_V1 001_P15_V2 001_P16_V1 001_P17_V1 001_P18_V1 001_P18_V2\
	001_P19_V1 001_P19_V2 001_P20_V1 001_P20_V2 001_P21_V1 001_P21_V2 001_P22_V1 001_P22_V2 001_P23_V1 001_P23_V2\
	001_P24_V1 001_P24_V2 001_P37_V1 001_P37_V2 001_P40_V1 001_P40_V2 001_P41_V1 001_P41_V2 001_P42_V1 001_P42_V2\
	001_P43_V1 001_P43_V2 001_P44_V1 001_P44_V2 001_P45_V1 001_P45_V2 004_P01_V1 004_P01_V2"

subjectlist="001_H07_V1"

MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNTP="/Volumes/ares/data/IBD/ASL/ASL_gita/Patients/"

for subject in $subjectlist
do
	cd ${MOUNT}
	# filename=$(basename -- "$fullfile")
	# extension="${filename##*.}"
	# filename="${filename%.*}"

	# First, convert base to nii gz
	SUBSTRING='base'
	SUBSTRING2='SOURCE'
	for entry in ${MOUNT}/${subject}/*.nii
	do
		if [[ "$entry" == *"$SUBSTRING"* ]]; then 
			echo $entry
			name=$(echo $entry | cut -f 1 -d '.')
			echo $name
			fslchfiletype NIFTI_GZ $entry $name
			rm $entry
		fi
	done

	# Then, chop up labels in asl data
	for asldata in ${MOUNT}/${subject}/*.nii
	do
		if [[ "$asldata" != *"$SUBSTRING"* ]]; then #&& [[ "$asldata" != *"$SUBSTRING2"* ]];
			echo $asldata
			aslname=$(echo $asldata | cut -f 1 -d '.')
			echo $aslname

			fslroi $aslname ${aslname}_label1 0 30
			fslroi $aslname ${aslname}_label2 30 30
			#rm $asldata
		fi
	done

done


# echo "calling fslroi"
# fslroi $2 ${3}_label1 $4 $6
# fslroi $2 ${3}_label2 $5 $6

# fslchfiletype NIFTI_GZ $7 ${3}_base


# fslsplit $2 s$3 -t


# fslmerge -t $3_label1 s${3}0000 s${3}0002 s${3}0004 s${3}0006 s${3}0008 s${3}0010 s${3}0012 s${3}0014 s${3}0016 s${3}0018 s${3}0020 s${3}0022 s${3}0024 s${3}0026 s${3}0028 s${3}0030 s${3}0032 s${3}0034 s${3}0036 s${3}0038 s${3}0040 s${3}0042 s${3}0044 s${3}0046 s${3}0048 s${3}0050 s${3}0052 s${3}0054 s${3}0056 s${3}0058
# fslmerge -t $3_label2 s${3}0001 s${3}0003 s${3}0005 s${3}0007 s${3}0009 s${3}0011 s${3}0013 s${3}0015 s${3}0017 s${3}0019 s${3}0021 s${3}0023 s${3}0025 s${3}0027 s${3}0029 s${3}0031 s${3}0033 s${3}0035 s${3}0037 s${3}0039 s${3}0041 s${3}0043 s${3}0045 s${3}0047 s${3}0049 s${3}0051 s${3}0053 s${3}0055 s${3}0057 s${3}0059


# echo "removing split files"
# rm s*


# fslchfiletype NIFTI_GZ $4 ${3}_base










