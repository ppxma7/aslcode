#!/bin/bash


anatlist="sub01"

subjectlist="220126_GBPERM_01_v1"


#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNT="/Volumes/nemosine/CATALYST_BCSFB/"
#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_jord/"

ANATMOUNT="/Volumes/nemosine/CATALYST_BCSFB/GBPERM_subs/"

for anatsub in $anatlist
do


for subject in $subjectlist
	do
		## this bit FLIRTs the EPI to the ANATOMICAL, but in scan sesh, it's already in the right 
		## place, so don't need to FLIRT. We just need to FLIRT to MNI, using the ANATOMICAL's 
		## transform we got in catalyst_reg2.sh right?
		##

		for file in $(find ${MOUNT}/${subject}/FAIR1000_aslpp/ -name 'diffav.nii.gz' );
		do 
		# 	echo $file
		# 	tmpPath=$(dirname $file)
		# 	echo $tmpPath
		# -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		tmpPath=$(dirname $file)
			flirt -in $file\
				-ref ${ANATMOUNT}/${anatsub}/${anatsub}_brain.nii.gz\
				-out $tmpPath/diffav_flirt\
				-omat $tmpPath/diffav_flirt.mat\
				-bins 256\
				-cost corratio\
				-searchrx -90 90\
				-searchry -90 90\
				-searchrz -90 90\
				-dof 12\
				-interp trilinear
		done


			# for file2 in $(find ${MOUNT}/${subject}/FAIR1000_aslpp/ -name 'diffav.nii.gz' );
			# do

			# # now apply transform to move EPI to MNI space
			# 	echo "Align EPI to standard using Anatomical transformation..."
			# 	tmpPath2=$(dirname $file2)
			# 	flirt -in $file2\
			# 		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
			# 		-out $tmpPath2/diffav_mni\
			# 		-applyxfm -init ${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.mat\
			# 		#-schedule /usr/local/fsl/etc/flirtsch/ztransonly.sch

			# done

			# for file3 in $(find ${MOUNT}/${subject}/FAIR1000_aslpp/ -name 'diffav_mni.nii.gz' );
			# do
			# 	tmpPath3=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
			# 		-out $tmpPath3/diffav_mni2\



			# done


			# for file3 in $(find ${MOUNT}/${subject}/FAIR1000_aslpp/ -name 'diffav_mni.nii.gz' );
			# do
			# 	tmpPath3=$(dirname $file3)
			# 	applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm\
			# 		--in=$file3\
			# 		--warp=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni_fnirt_transform\
			# 		--out=$tmpPath3/diffav_mni_fnirt

			# done
			
#			cd ${MOUNT}

	done

done

