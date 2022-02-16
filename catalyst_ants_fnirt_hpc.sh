#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=48:00:00

echo "Running on `hostname`"
#module load ants-uon/binary/2.1.0
module load ants-uoneasy/2.3.5-foss-2021a
export SUBJECTS_DIR=/home/ppzma/subjects_dir/
export DATA_DIR=/home/ppzma/gbperm01/
export FAIR_DIR=/home/ppzma/gbperm01/FAIR1000_aslpp/

subjectlist="03"

for subject in $subjectlist
do

	antsRegistration \
	--verbose 1 \
	--dimensionality 3 \
	--float 1 \
	--output [${DATA_DIR}/${FAIR_DIR}/registered_,${DATA_DIR}/${FAIR_DIR}/registered_Warped.nii.gz,${DATA_DIR}/${FAIR_DIR}/registered_InverseWarped.nii.gz] \
	--interpolation Linear \
	--use-histogram-matching 0 \
	--winsorize-image-intensities [0.005,0.995] \
	--initial-moving-transform ${DATA_DIR}/${FAIR_DIR}/itk_manual.txt \
	--transform Rigid[0.05] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform Affine[0.1] \
	--metric MI[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR}/diffav.nii.gz,0.7,32,Regular,0.1] \
	--convergence [1000x500,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \
	--transform SyN[0.1,2,0] \
	--metric CC[${SUBJECTS_DIR}/sub${subject}_brain_mni_fnirt.nii.gz,${DATA_DIR}/${FAIR_DIR}/diffav.nii.gz,1,2] \
	--convergence [500x100,1e-6,10] \
	--shrink-factors 2x1 \
	--smoothing-sigmas 1x0vox \

done




