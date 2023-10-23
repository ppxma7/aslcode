#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mydata=("220202_GBPERM_01_v2/")

# mydata=("220126_GBPERM_01_v1/\
# 	220208_GBPERM_02_v1/\
# 	220216_GBPERM_03_v1/\
# 	220222_GBPERM_04_v1/\
# 	220311_GBPERM_06_v1/\
# 	220518_GBPERM_09_v1/\
# 	220530_GBPERM_10_v1/")


for index in $mydata
do

	#echo $index

	cd ${mypath}${index}/masking/
	echo ${mypath}${index}
	ventricle_mask_file="native_structures.nii"
	ventricle_mask=$(echo "${ventricle_mask_file}" | cut -f 1 -d '.')
	fslmaths $ventricle_mask -uthr 2 ${ventricle_mask}_justvens
	fslmaths ${ventricle_mask}_justvens -div ${ventricle_mask}_justvens ${ventricle_mask}_justvens_bin


	#ventricle_mask_file="rnative_structures.nii.gz"
	#ventricle_mask=$(echo "${ventricle_mask_file}" | cut -f 1 -d '.')
	#echo $ventricle_mask

	#fslmaths $ventricle_mask -uthr 2 ${ventricle_mask}_justvens
	#fslmaths ${ventricle_mask}_justvens -div ${ventricle_mask}_justvens ${ventricle_mask}_justvens_bin
	
	
	# here bin the CP masks

	
	# csfmask_file="csfmask.nii"
	# csf_mask=$(echo "${csfmask_file}" | cut -f 1 -d '.')
	# #echo $csf_mask

	# fslmaths $ventricle_mask -div $ventricle_mask ${ventricle_mask}_bin
	# #echo ${ventricle_mask}_bin
	# fslmaths ${ventricle_mask}_bin -dilM ${ventricle_mask}_bin_dil
	# fslmaths $csf_mask -sub ${ventricle_mask}_bin_dil ${csf_mask}_presub
	# fslmaths ${csf_mask}_presub -thr 0.1 ${csf_mask}_noventricles
done

