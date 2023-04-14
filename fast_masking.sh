#!/bin/bash

#MOUNT="/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/"
MOUNT="/Volumes/nemosine/CATALYST_BCSFB/"



subjectlist="220126_GBPERM_01_v1 220208_GBPERM_02_v1 220216_GBPERM_03_v1 220222_GBPERM_04_v1 220311_GBPERM_06_v1 220407_GBPERM_07_v1 220408_GBPERM_08_v1 220518_GBPERM_09_v1 220530_GBPERM_10_v1"
for subject in $subjectlist
do
   
    cd ${MOUNT}


 #   echo "copying files..."



#    echo "running FAST segmentation..."
#    fast -n 3 -g ${MOUNT}/${subject}/structurals/wm/FLAIRBET.nii
    echo "${subject} has been completed"


    fslmaths ${MOUNT}/${subject}/structurals/wm/wm_mask.nii.gz -uthr 1 ${MOUNT}/${subject}/structurals/wm/wm_mask_bin.nii.gz


done
echo "Task complete. Shutting down..."

