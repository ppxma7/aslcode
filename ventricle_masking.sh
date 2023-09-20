#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub10"
mydata="220530_GBPERM_10_v1/structurals/"

cd ${mypath}${mydata}/wm/

ventricle_mask_file="myvmask.nii.gz"
ventricle_mask=$(echo "${ventricle_mask_file}" | cut -f 1 -d '.')
echo $ventricle_mask

csfmask_file="csfmask.nii"
csf_mask=$(echo "${csfmask_file}" | cut -f 1 -d '.')
echo $csf_mask

fslmaths $ventricle_mask -div $ventricle_mask ${ventricle_mask}_bin
#echo ${ventricle_mask}_bin
fslmaths ${ventricle_mask}_bin -dilM ${ventricle_mask}_bin_dil
fslmaths $csf_mask -sub ${ventricle_mask}_bin_dil ${csf_mask}_presub
fslmaths ${csf_mask}_presub -thr 0.1 ${csf_mask}_noventricles

