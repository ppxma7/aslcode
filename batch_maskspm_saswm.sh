#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
#mysub="sub10"
#mydata="220126_GBPERM_01_v1/ 220208_GBPERM_02_v1/ 220216_GBPERM_03_v1/ 220222_GBPERM_04_v1/ 220311_GBPERM_06_v1/ 220407_GBPERM_07_v1/ 220408_GBPERM_08_v1/ 220518_GBPERM_09_v1/ 220530_GBPERM_10_v1/"
mydata="220216_GBPERM_03_v1/"



for k in $mydata
	do
		operating=${mypath}${k}/structurals/wm/fairspace/
		echo $operating
		fslmaths ${operating}rwmmask.nii -thr 0.85 ${operating}rwmmask_bin.nii.gz
		#fslmaths ${operating}rcsfmask_noventricles.nii -thr 0.5 ${operating}rcsfmask_noventricles_bin.nii.gz
		#fslmaths ${operating}rwmmask_bin.nii.gz -bin ${operating}rwmmask_bin_mask.nii.gz
		fslmaths ${operating}rwmmask_bin.nii.gz -div ${operating}rwmmask_bin.nii.gz ${operating}rwmmask_bin_mask
		#fslmaths ${operating}rcsfmask_noventricles_bin.nii.gz -bin ${operating}rcsfmask_noventricles_bin_mask.nii.gz

	done

# fslmaths ${operating}rwmmask.nii -thr 0.01 rwmmask_bin.nii.gz
# fslmaths rcsfmask_noventricles.nii -thr 0.01 rcsfmask_noventricles_bin.nii.gz

# fslmaths rwmmask_bin.nii.gz -bin rwmmask_bin_mask.nii.gz
# fslmaths rcsfmask_noventricles_bin.nii.gz -bin rcsfmask_noventricles_bin_mask.nii.gz
