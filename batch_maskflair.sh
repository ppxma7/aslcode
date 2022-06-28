#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub09"
mydata="220518_GBPERM_09_v1/structurals/"

fslmaths ${mypath}${mydata}/left.nii.gz -uthr 2 ${mypath}${mydata}/left2.nii.gz
fslmaths ${mypath}${mydata}/left2.nii.gz -thr 1 ${mypath}${mydata}/left_roi_m.nii.gz
fslmaths ${mypath}${mydata}/left_roi_m.nii.gz -bin left_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/leftcsf.nii.gz -uthr 2 ${mypath}${mydata}/leftcsf2.nii.gz
fslmaths ${mypath}${mydata}/leftcsf2.nii.gz -thr 1 ${mypath}${mydata}/leftcsf_roi_m.nii.gz
fslmaths ${mypath}${mydata}/leftcsf_roi_m.nii.gz -bin leftcsf_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/right.nii.gz -uthr 2 ${mypath}${mydata}/right2.nii.gz
fslmaths ${mypath}${mydata}/right2.nii.gz -thr 1 ${mypath}${mydata}/right_roi_m.nii.gz
fslmaths ${mypath}${mydata}/right_roi_m.nii.gz -bin right_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/rightcsf.nii.gz -uthr 2 ${mypath}${mydata}/rightcsf2.nii.gz
fslmaths ${mypath}${mydata}/rightcsf2.nii.gz -thr 1 ${mypath}${mydata}/rightcsf_roi_m.nii.gz
fslmaths ${mypath}${mydata}/rightcsf_roi_m.nii.gz -bin rightcsf_roi_mask.nii.gz
