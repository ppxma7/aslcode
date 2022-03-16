#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
#mysub="sub01"
mydata="220222_GBPERM_04_v1/structurals/"

cd ${mypath}${mydata}/

fslmaths left_roi -uthr 1 test
fslmaths test -thr 1 left_roi_mask
fslmaths right_roi -uthr 1 test
fslmaths test -thr 1 right_roi_mask
fslmaths leftcsf_roi -uthr 1 test
fslmaths test -thr 1 leftcsf_roi_mask
fslmaths rightcsf_roi -uthr 1 test
fslmaths test -thr 1 rightcsf_roi_mask



