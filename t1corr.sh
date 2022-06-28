#! /bin/bash

mypath="/Volumes/nemosine/PAIN/220624_t1mapping/"

if [ $# -lt 1 ] ; then
     echo 
     echo "Usage: sh t1corr.sh indata"	
     exit 1;
fi

echo "remember, no nifti extensions..."
echo "correcting t1 map..."
fslmaths $1 -recip $1_r1map
fslmaths $1_r1map -div 1.405 $1_r1corr
fslmaths $1_r1corr -recip $1_t1corr

#https://doi.org/10.1016/j.neuroimage.2021.117976
# R1 corr = R1 / 1 + b/a .* Fat shift pulse
# R1 corr = R1 / 1+0.0045 + 90
