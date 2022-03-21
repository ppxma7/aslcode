#!/bin/bash


anatlist="15123"

#subjectlist="220317_15123_testing"


#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNT="/Volumes/nemosine/PAIN/220317_15123_testing/"
#MOUNT="/Volumes/ares/data/IBD/ASL/ASL_jord/"

ANATMOUNT="/Volumes/nemosine/subs/"

# #First, we should align all anatomicals to MNI SPACE
# for anatsub in $anatlist
# do
# 	echo ${anatsub}.nii
# 	echo "Running bet..."
# 	bet ${ANATMOUNT}/${anatsub}/surfRelax/${anatsub}_mprage_pp.img ${ANATMOUNT}/${anatsub}/${anatsub}_brain\
# 	   -f 0.2 -g 0
# 	echo "Running flirt now..."
# 	flirt -in ${ANATMOUNT}/${anatsub}/${anatsub}_brain.nii.gz\
# 		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
# 		-out ${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.nii.gz\
# 		-omat ${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.mat\
# 		-bins 256\
# 		-cost corratio\
# 		-searchrx -90 90\
# 		-searchry -90 90\
# 		-searchrz -90 90\
# 		-dof 12\
# 		-interp trilinear

# 	echo "Running fnirt now..."
# 	fnirt --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz\
# 		--in=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni.nii.gz\
# 		--iout=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni_fnirt.nii.gz\
# 		--cout=${ANATMOUNT}/${anatsub}/${anatsub}_brain_mni_fnirt_transform\
# 		#--config=/usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz
# done


for file in $(find ${MOUNT}/ -name 'D1xMPR.hdr' );
do
	# now apply transform to move EPI to MNI space
	echo "Align EPI to standard using Anatomical transformation..."
	tmpPath=$(dirname $file)
	flirt -in $file\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out $tmpPath/D1xMPR_mni\
		-applyxfm -init ${ANATMOUNT}/${anatlist}/${anatlist}_brain_mni.mat
done

for file in $(find ${MOUNT}/ -name 'D2xMPR.hdr' );
do
	# now apply transform to move EPI to MNI space
	echo "Align EPI to standard using Anatomical transformation..."
	tmpPath=$(dirname $file)
	flirt -in $file\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out $tmpPath/D2xMPR_mni\
		-applyxfm -init ${ANATMOUNT}/${anatlist}/${anatlist}_brain_mni.mat
done

for file in $(find ${MOUNT}/ -name 'D3xMPR.hdr' );
do
	# now apply transform to move EPI to MNI space
	echo "Align EPI to standard using Anatomical transformation..."
	tmpPath=$(dirname $file)
	flirt -in $file\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out $tmpPath/D3xMPR_mni\
		-applyxfm -init ${ANATMOUNT}/${anatlist}/${anatlist}_brain_mni.mat
done

for file in $(find ${MOUNT}/ -name 'D4xMPR.hdr' );
do
	# now apply transform to move EPI to MNI space
	echo "Align EPI to standard using Anatomical transformation..."
	tmpPath=$(dirname $file)
	flirt -in $file\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out $tmpPath/D4xMPR_mni\
		-applyxfm -init ${ANATMOUNT}/${anatlist}/${anatlist}_brain_mni.mat
done

for file in $(find ${MOUNT}/ -name 'D5xMPR.hdr' );
do
	# now apply transform to move EPI to MNI space
	echo "Align EPI to standard using Anatomical transformation..."
	tmpPath=$(dirname $file)
	flirt -in $file\
		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
		-out $tmpPath/D5xMPR_mni\
		-applyxfm -init ${ANATMOUNT}/${anatlist}/${anatlist}_brain_mni.mat
done










