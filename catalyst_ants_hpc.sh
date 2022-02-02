#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=48:00:00

echo "Running on `hostname`"
module load ants-uoneasy/2.3.5-foss-2021a
export SUBJECTS_DIR=/home/ppzma/subjects_dir/
export DATA_DIR=/home/ppzma/gbperm01/

antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--output [registered_,registered_Warped.nii.gz,registered_InverseWarped.nii.gz] \
--interpolation Linear \
--use-histogram-matching 0 \
--winsorize-image-intensities [0.005,0.995] \
--initial-moving-transform ${DATA_DIR}/FAIR1000_aslpp/itk_manual.txt \
--transform Rigid[0.05] \
--metric CC[${SUBJECTS_DIR}/sub01_brain_mni.nii.gz,${DATA_DIR}/FAIR1000_aslpp/diffav.nii.gz,0.7,32,Regular,0.1] \
--convergence [1000x500,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform Affine[0.1] \
--metric MI[${SUBJECTS_DIR}/sub01_brain_mni.nii.gz,${DATA_DIR}/FAIR1000_aslpp/diffav.nii.gz,0.7,32,Regular,0.1] \
--convergence [1000x500,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform SyN[0.1,2,0] \
--metric CC[${SUBJECTS_DIR}/sub01_brain_mni.nii.gz,${DATA_DIR}/FAIR1000_aslpp/diffav.nii.gz,1,2] \
--convergence [500x100,1e-6,10] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \

echo done


