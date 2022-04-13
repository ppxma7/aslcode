#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub08"
mydata="220408_GBPERM_08_v1/structurals/"

fslmaths ${mypath}${mydata}/left.nii.gz -uthr 1 ${mypath}${mydata}/left2.nii.gz
fslmaths ${mypath}${mydata}/left2.nii.gz -thr 1 ${mypath}${mydata}/left_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/leftcsf.nii.gz -uthr 1 ${mypath}${mydata}/leftcsf2.nii.gz
fslmaths ${mypath}${mydata}/leftcsf2.nii.gz -thr 1 ${mypath}${mydata}/leftcsf_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/right.nii.gz -uthr 1 ${mypath}${mydata}/right2.nii.gz
fslmaths ${mypath}${mydata}/right2.nii.gz -thr 1 ${mypath}${mydata}/right_roi_mask.nii.gz

fslmaths ${mypath}${mydata}/rightcsf.nii.gz -uthr 1 ${mypath}${mydata}/rightcsf2.nii.gz
fslmaths ${mypath}${mydata}/rightcsf2.nii.gz -thr 1 ${mypath}${mydata}/rightcsf_roi_mask.nii.gz