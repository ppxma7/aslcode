#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub10"
mydata="220530_GBPERM_10_v1/structurals/"

cd ${mypath}${mydata}/


fslmaths rleft_roi_mask_flo.nii -thr 0.01 rleft_roi_mask_flo_bin.nii.gz
fslmaths rright_roi_mask_flo.nii -thr 0.01 rright_roi_mask_flo_bin.nii.gz
fslmaths rleftcsf_roi_mask_flo.nii -thr 0.01 rleftcsf_roi_mask_flo_bin.nii.gz
fslmaths rrightcsf_roi_mask_flo.nii -thr 0.01 rrightcsf_roi_mask_flo_bin.nii.gz

fslmaths rleft_roi_mask_flo_bin.nii.gz -bin rleft_roi_mask_flo_bin_mask.nii.gz
fslmaths rright_roi_mask_flo_bin.nii.gz -bin rright_roi_mask_flo_bin_mask.nii.gz
fslmaths rleftcsf_roi_mask_flo_bin.nii.gz -bin rleftcsf_roi_mask_flo_bin_mask.nii.gz
fslmaths rrightcsf_roi_mask_flo_bin.nii.gz -bin rrightcsf_roi_mask_flo_bin_mask.nii.gz