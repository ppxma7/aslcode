#!/bin/bash

MOUNT="/Volumes/nemosine/CATALYST_BCSFB/"
SUBDIR="220126_GBPERM_01_v1"
STDIR="/usr/local/fsl/data/standard/"

antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--output [registered_,registered_Warped.nii.gz,registered_InverseWarped.nii.gz] \
--interpolation Linear \
--use-histogram-matching 0 \
--winsorize-image-intensities [0.005,0.995] \
--initial-moving-transform ${MOUNT}/${SUBDIR}/FAIR1000_aslpp/itk_manual.txt \
--transform Rigid[0.05] \
--metric CC[${STDIR}/MNI152_T1_2mm_brain.nii.gz,${MOUNT}/${SUBDIR}/FAIR1000_aslpp/diffav.nii.gz,0.7,32,Regular,0.1] \
--convergence [1000x500,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform Affine[0.1] \
--metric MI[${STDIR}/MNI152_T1_2mm_brain.nii.gz,${MOUNT}/${SUBDIR}/FAIR1000_aslpp/diffav.nii.gz,0.7,32,Regular,0.1] \
--convergence [1000x500,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform SyN[0.1,2,0] \
--metric CC[${STDIR}/MNI152_T1_2mm_brain.nii.gz,${MOUNT}/${SUBDIR}/FAIR1000_aslpp/diffav.nii.gz,1,2] \
--convergence [500x100,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \

#-x mask.nii