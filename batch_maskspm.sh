#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
#mysub="sub10"
mydata="220126_GBPERM_01_v1/ 220208_GBPERM_02_v1/ 220216_GBPERM_03_v1/ 220222_GBPERM_04_v1/ 220311_GBPERM_06_v1/ 220407_GBPERM_07_v1/ 220408_GBPERM_08_v1/ 220518_GBPERM_09_v1/ 220530_GBPERM_10_v1/"

cd ${mypath}${mydata}/structurals/


fslmaths rleft_roi_mask_flo.nii -thr 0.01 rleft_roi_mask_flo_bin.nii.gz
fslmaths rright_roi_mask_flo.nii -thr 0.01 rright_roi_mask_flo_bin.nii.gz
fslmaths rleftcsf_roi_mask_flo.nii -thr 0.01 rleftcsf_roi_mask_flo_bin.nii.gz
fslmaths rrightcsf_roi_mask_flo.nii -thr 0.01 rrightcsf_roi_mask_flo_bin.nii.gz

fslmaths rleft_roi_mask_flo_bin.nii.gz -bin rleft_roi_mask_flo_bin_mask.nii.gz
fslmaths rright_roi_mask_flo_bin.nii.gz -bin rright_roi_mask_flo_bin_mask.nii.gz
fslmaths rleftcsf_roi_mask_flo_bin.nii.gz -bin rleftcsf_roi_mask_flo_bin_mask.nii.gz
fslmaths rrightcsf_roi_mask_flo_bin.nii.gz -bin rrightcsf_roi_mask_flo_bin_mask.nii.gz