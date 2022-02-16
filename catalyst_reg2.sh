#!/bin/bash


anatlist="sub03"

subjectlist="220216_GBPERM_03_v1"


#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNT="/Volumes/nemosine/CATALYST_BCSFB/"
#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_jord/"

ANATMOUNT="/Volumes/nemosine/CATALYST_BCSFB/GBPERM_subs/"

#First, we should align all anatomicals to MNI SPACE
for anatsub in $anatlist
do
	echo ${anatsub}.nii
	echo "Running bet..."
	bet ${ANATMOUNT}/${anatsub}/${anatsub}_mprage.nii ${ANATMOUNT}/${anatsub}/${anatsub}_brain\
	   -f 0.2 -g 0
	echo "Running flirt now..."
	flirt -in ${ANATMOUNT}/${anatsub}/${anatsub}_brain.nii.gz\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out ${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.nii.gz\
		-omat ${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.mat\
		-bins 256\
		-cost corratio\
		-searchrx -90 90\
		-searchry -90 90\
		-searchrz -90 90\
		-dof 12\
		-interp trilinear

	echo "Running fnirt now..."
	fnirt --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz\
		--in=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.nii.gz\
		--iout=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni_fnirt.nii.gz\
		--cout=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni_fnirt_transform\
		#--config=/usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz
done


# ##--aff=${ANATMOUNT}/${anatsub}_brain_mni.mat\

# cd ${MOUNT}

# #THEN, GO THROUGH ALL epi data and align these to their respective anatomicals

# for anatsub in $anatlist
# do
# 	#echo mPA_${anatsub}.nii.gz
# 	#echo ${anatsub}.nii

# 	for subject in $subjectlist
# 	do
# 		SUBSTRING=${subject:0:5} #change this to 0:3 for the patients,
# 		#SUBSTRING=${subject:0:3}
# 		echo $SUBSTRING
# 		if [[ "$anatsub" =~ "$SUBSTRING" ]]; then
# 			echo "We gotta match" 
# 			echo "${subject}"
# 			echo "${anatsub}"
# 			# In this case, actually better to use FLIRT

# 			#echo "Align EPI to Anatomical with 12 DOF..."

# 			for file in $(find ${MOUNT}/${subject}/ -name 'base_5_6_wh_merged_toppedup.nii.gz' );
# 			do 
# 				echo $file
# 				tmpPath=$(dirname $file)
# 				echo $tmpPath

# 				flirt -in $file\
# 					-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
# 					-out $tmpPath/base_5_6_flirt\
# 					-omat $tmpPath/base_5_6_flirt.mat\
# 					-bins 256\
# 					-cost corratio\
# 					-searchrx -90 90\
# 					-searchry -90 90\
# 					-searchrz -90 90\
# 					-dof 6\
# 					-interp trilinear
# 			done

			# apply transformation of EPI to Anatomy space to other images

			# for file2 in $(find ${MOUNT}/${subject}/ -name 'base_7_8_30ms_merged_toppedup.nii.gz' );
			# do
			# 	echo $file2
			# 	tmpPath=$(dirname $file2)
			# 	echo $tmpPath

			# 	flirt -in $file2\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath/base_7_8_flirt\
			# 		-omat $tmpPath/base_7_8_flirt.mat\
			# 		-bins 256\
			# 		-cost corratio\
			# 		-searchrx -90 90\
			# 		-searchry -90 90\
			# 		-searchrz -90 90\
			# 		-dof 6\
			# 		-interp trilinear
			# done

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'base_9_10_400ms_merged_toppedup.nii.gz' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/base_9_10_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'BCSFB_WIPBASE_300MS_20210505165327_11.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/sc_11_300ms_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'BCSFB_WIPBASE_200MS_20210505165327_12.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/sc_12_200ms_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'BCSFB_WIPBASE_100MS_20210505165327_13.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/sc_13_100ms_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done  








			# for file3 in $(find ${MOUNT}/${subject}/ -name 'fair_30ms_label1.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/fair_30ms_label1_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'fair_30ms_label2.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/fair_30ms_label2_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'fair_400ms_label1.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/fair_400ms_label1_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file3 in $(find ${MOUNT}/${subject}/ -name 'fair_400ms_label2.nii' );
			# do

			# 	echo "Align secondary images to Anatomical..."
			# 	tmpPath2=$(dirname $file3)
			# 	flirt -in $file3\
			# 		-ref ${ANATMOUNT}/${anatsub}/m${anatsub}.nii\
			# 		-out $tmpPath2/fair_400ms_label2_flirt\
			# 		-applyxfm -init ${MOUNT}/${subject}/base_7_8_flirt.mat
			# done 

			# for file2 in $(find ${MOUNT}/${subject}/ -name 'diffav_calib_flirt.nii.gz' );
			# do

			# # now apply transform to move EPI to MNI space
			# 	echo "Align EPI to standard using Anatomical transformation..."
			# 	tmpPath2=$(dirname $file2)
			# 	flirt -in $file2\
			# 		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
			# 		-out $tmpPath2/diffav_calib_flirt_mni\
			# 		-applyxfm -init ${ANATMOUNT}/${anatsub}_brain_mni.mat
			# done


			# for file3 in $(find ${MOUNT}/${subject}/ -name 'diffav_calib_flirt_mni.nii.gz' );
			# do
			# 	tmpPath3=$(dirname $file3)
			# 	applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm\
			# 		--in=$file3\
			# 		--warp=${ANATMOUNT}/${anatsub}_brain_mni_fnirt_transform\
			# 		--out=$tmpPath3/diffav_calib_flirt_mni_fnirt

			# done
			
			# cd ${MOUNT}
# 		fi
# 	done
# done







