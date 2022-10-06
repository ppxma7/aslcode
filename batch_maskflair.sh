#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub10"
mydata="220530_GBPERM_10_v1/structurals/"

cd ${mypath}${mydata}/

# fslmaths ${mypath}${mydata}/left.nii.gz -uthr 2 ${mypath}${mydata}/left2.nii.gz
# fslmaths ${mypath}${mydata}/left2.nii.gz -thr 1 ${mypath}${mydata}/left_roi_m.nii.gz
# fslmaths ${mypath}${mydata}/left_roi_m.nii.gz -bin left_roi_mask.nii.gz

# fslmaths ${mypath}${mydata}/leftcsf.nii.gz -uthr 2 ${mypath}${mydata}/leftcsf2.nii.gz
# fslmaths ${mypath}${mydata}/leftcsf2.nii.gz -thr 1 ${mypath}${mydata}/leftcsf_roi_m.nii.gz
# fslmaths ${mypath}${mydata}/leftcsf_roi_m.nii.gz -bin leftcsf_roi_mask.nii.gz

# fslmaths ${mypath}${mydata}/right.nii.gz -uthr 2 ${mypath}${mydata}/right2.nii.gz
# fslmaths ${mypath}${mydata}/right2.nii.gz -thr 1 ${mypath}${mydata}/right_roi_m.nii.gz
# fslmaths ${mypath}${mydata}/right_roi_m.nii.gz -bin right_roi_mask.nii.gz

# fslmaths ${mypath}${mydata}/rightcsf.nii.gz -uthr 2 ${mypath}${mydata}/rightcsf2.nii.gz
# fslmaths ${mypath}${mydata}/rightcsf2.nii.gz -thr 1 ${mypath}${mydata}/rightcsf_roi_m.nii.gz
# fslmaths ${mypath}${mydata}/rightcsf_roi_m.nii.gz -bin rightcsf_roi_mask.nii.gz


fslmaths ${mypath}${mydata}/FLAIRBET_L_roi.nii.gz -uthr 2 ${mypath}${mydata}/left2.nii.gz
fslmaths ${mypath}${mydata}/left2.nii.gz -thr 1 ${mypath}${mydata}/left_roi_m.nii.gz
fslmaths ${mypath}${mydata}/left_roi_m.nii.gz -bin left_roi_mask_fl.nii.gz

fslmaths ${mypath}${mydata}/FLAIRBET_L_roi_csf.nii.gz -uthr 2 ${mypath}${mydata}/leftcsf2.nii.gz
fslmaths ${mypath}${mydata}/leftcsf2.nii.gz -thr 1 ${mypath}${mydata}/leftcsf_roi_m.nii.gz
fslmaths ${mypath}${mydata}/leftcsf_roi_m.nii.gz -bin leftcsf_roi_mask_fl.nii.gz

fslmaths ${mypath}${mydata}/FLAIRBET_R_roi.nii.gz -uthr 2 ${mypath}${mydata}/right2.nii.gz
fslmaths ${mypath}${mydata}/right2.nii.gz -thr 1 ${mypath}${mydata}/right_roi_m.nii.gz
fslmaths ${mypath}${mydata}/right_roi_m.nii.gz -bin right_roi_mask_fl.nii.gz

fslmaths ${mypath}${mydata}/FLAIRBET_R_roi_csf.nii.gz -uthr 2 ${mypath}${mydata}/rightcsf2.nii.gz
fslmaths ${mypath}${mydata}/rightcsf2.nii.gz -thr 1 ${mypath}${mydata}/rightcsf_roi_m.nii.gz
fslmaths ${mypath}${mydata}/rightcsf_roi_m.nii.gz -bin rightcsf_roi_mask_fl.nii.gz

rm left2.nii.gz left_roi_m.nii.gz leftcsf2.nii.gz leftcsf_roi_m.nii.gz right2.nii.gz right_roi_m.nii.gz rightcsf2.nii.gz rightcsf_roi_m.nii.gz

fslchfiletype NIFTI left_roi_mask_fl left_roi_mask_flo
fslchfiletype NIFTI leftcsf_roi_mask_fl leftcsf_roi_mask_flo
fslchfiletype NIFTI right_roi_mask_fl right_roi_mask_flo
fslchfiletype NIFTI rightcsf_roi_mask_fl rightcsf_roi_mask_flo

rm left_roi_mask_fl.nii.gz leftcsf_roi_mask_fl.nii.gz right_roi_mask_fl.nii.gz rightcsf_roi_mask_fl.nii.gz

