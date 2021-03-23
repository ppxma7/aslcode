#!/bin/bash


anatlist="m001_H03 m001_H07 m001_H08 m001_H09 m001_H11 m001_H13 m001_H14 m001_H15 m001_H16 m001_H17 m001_H19 m001_H23 m001_H24 m001_H25\
    m001_H27 m001_H28 m001_H29 m001_H30 m001_P01 m001_P02 m001_P04 m001_P05 m001_P06 m001_P08 m001_P12 m001_P13 m001_P15 m001_P16 m001_P17\
    m001_P18 m001_P19 m001_P20 m001_P21 m001_P22 m001_P23 m001_P24 m001_P26 m001_P27 m001_P28 m001_P30 m001_P31 m001_P32 m001_P33 m001_P35\
    m001_P37 m001_P40 m001_P41 m001_P42 m001_P43 m001_P44 m001_P45 m004_P01\
    mBL002 mBL003 mBL004 mBL005 mBL006 mBL007 mBL008 mBL010 mBL011 mBL012 mBL013 mBL014 mBL015 mBL016 mBL017 mBL018\
    msub-003 msub-004 msub-005 msub-006 msub-008 msub-011 msub-012 msub-014 msub-020 msub-021 msub-022 msub-024 msub-025 msub-026\
    msub-027 msub-028 msub-031 msub-032 msub-033 msub-034 msub-038"  

anatlist="msub-038"

subjectlist="001_H07_V1 001_H07_V2 001_H07_V1 001_H08_V2 001_H09_V1 001_H09_V2 001_H11_V1 001_H11_V2 001_H13_V1 001_H13_V2\
    001_H14_V1 001_H14_V2 001_H15_V1 001_H15_V2 001_H16_V1 001_H16_V2 001_H17_V1 001_H17_V2 001_H19_V1 001_H19_V2\
    001_H23_V1 001_H23_V2 001_H24_V1 001_H24_V2 001_H25_V1 001_H25_V2 001_H27_V1 001_H27_V2 001_H28_V1 001_H28_V2\
    001_H29_V1 001_H29_V2 001_H30_V1 001_H30_V2"

subjectlistP="001_P01_V1 001_P01_V2 001_P02_V1 001_P02_V2 001_P03_V1 001_P03_V2 001_P04_V1 001_P04_V2 001_P05_V1 001_P05_V2\
	001_P06_V1 001_P06_V2 001_P07_V1 001_P08_V1 001_P08_V2 001_P09_V1 001_P09_V2 001_P10_V1 001_P10_V2 001_P11_V1\
	012_P01_V1 012_P01_V2 001_P13_V2 001_P14_V1 001_P15_V1 001_P15_V2 001_P16_V1 001_P17_V1 001_P17_V2 001_P18_V1 001_P18_V2\
	001_P19_V1 001_P19_V2 001_P20_V1 001_P20_V2 001_P21_V1 001_P21_V2 001_P22_V1 001_P22_V2 001_P23_V1 001_P23_V2\
	001_P24_V1 001_P24_V2 001_P37_V1 001_P37_V2 001_P40_V1 001_P40_V2 001_P41_V1 001_P41_V2 001_P42_V1 001_P42_V2\
	001_P43_V1 001_P43_V2 001_P44_V1 001_P44_V2 001_P45_V1 001_P45_V2 004_P01_V1 004_P01_V2"

subjectlistJord="003 004 005 006 008 011 012 014 020 021 022 024 025 026 027 028 032 033 034 038"


# anatlist="m001_H07"

# subjectlist="001_H07_V1"
#MOUNT="/Volumes/ares/data/HDREMODEL/PA/motion_corrected/"
MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNTP="/Volumes/ares/data/IBD/ASL/ASL_gita/Patients/"

MOUNTjord="/Volumes/ares/data/IBD/ASL/ASL_jord/"

ANATMOUNT="/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/"


# First, we should align all anatomicals to MNI SPACE
# for anatsub in $anatlist
# do
# 	echo ${anatsub}.nii
# 	echo "Running bet..."
# 	bet ${ANATMOUNT}/${anatsub}.nii ${ANATMOUNT}/${anatsub}_brain\
# 	   -f 0.2 -g 0
# 	echo "Running flirt now..."
# 	flirt -in ${ANATMOUNT}/${anatsub}_brain.nii.gz\
# 		-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
# 		-out ${ANATMOUNT}/${anatsub}_brain_mni.nii.gz\
# 		-omat ${ANATMOUNT}/${anatsub}_brain_mni.mat\
# 		-bins 256\
# 		-cost corratio\
# 		-searchrx -90 90\
# 		-searchry -90 90\
# 		-searchrz -90 90\
# 		-dof 12\
# 		-interp trilinear
# done

# return

cd ${MOUNT}

# THEN, GO THROUGH ALL epi data and align these to their respective anatomicals

for anatsub in $anatlist
do
	#echo mPA_${anatsub}.nii.gz
	echo ${anatsub}.nii

	for subject in $subjectlist
	do
		SUBSTRING=${subject:3:4} #change this to 0:3 for the patients,
		echo $SUBSTRING
		if [[ "$anatsub" =~ "$SUBSTRING" ]]; then
			echo "We gotta match" 
			echo "${subject}"

			# In this case, actually better to use FLIRT

			echo "Align EPI to Anatomical with 12 DOF..."
			flirt -in ${MOUNT}/${subject}/${subject}_WIPASL17a_aslpp/diffav_calib.nii.gz\
				-ref ${ANATMOUNT}/${anatsub}.nii\
				-out ${MOUNT}${subject}/${subject}_WIPASL17a_aslpp/diffav_calib_flirt\
				-omat ${MOUNT}${subject}/${subject}_WIPASL17a_aslpp/diffav_calib_flirt.mat\
				-bins 256\
				-cost corratio\
				-searchrx -90 90\
				-searchry -90 90\
				-searchrz -90 90\
				-dof 12\
				-interp trilinear


			# now apply transform to move EPI to MNI space
			echo "Align EPI to standard using Anatomical transformation..."
			flirt -in ${MOUNT}${subject}/${subject}_WIPASL17a_aslpp/diffav_calib_flirt\
				-ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain\
				-out ${MOUNT}${subject}/${subject}_WIPASL17a_aslpp/diffav_calib_flirt_mni\
				-applyxfm -init ${ANATMOUNT}/${anatsub}_brain_mni.mat

			
			# ORIGINAL AFNI CODE
			#echo "Aligning centers..."
			#@align_centers -base ${ANATMOUNT}/${anatsub}.nii -dset ${MOUNT}/${subject}/${subject}_WIPASL17a_aslpp/diffav_calib.nii.gz

			#echo "Running align_epi_anat script..."
			#cd ${MOUNT}/${subject}/${subject}_WIPASL17a_aslpp/

			#align_epi_anat.py -anat ${ANATMOUNT}/${anatsub}.nii -epi ${MOUNT}/${subject}/${subject}_WIPASL17a_aslpp/diffav_calib.nii.gz -epi_base 0 -epi2anat
			#echo "Now converting to Nifti..."
			#3dAFNItoNIFTI ${MOUNT}/${subject}/${subject}_WIPASL17a_aslpp/diffav_calib_al+orig
		fi
	done
done







# for subject in $subjectlist
# do
# 	fslorient -forceradiological HDREMODEL_${subject}_RCR_mc.nii
# 	echo ${subject}
# done
