#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub09"
mydata="220518_GBPERM_09_v1/topup/"

cd ${mypath}${mydata}/

echo "running topup on the base scan"
# Usage: sh toppedup.sh path fMRIdata topupdata outputfMRI outputtopup"	
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh ${mypath}${mydata} BASE400crop BASE400topupcrop input1 input2

echo "applying base topup to labels"
# Usage: sh applytoppedup.sh path fMRIdata mergeddata"	
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} BASE400crop BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR1000_label1_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR2000_label1_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR3000_label1_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR4000_label1_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR1000_label2_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR2000_label2_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR3000_label2_nordic_clv BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh ${mypath}${mydata} FAIR4000_label2_nordic_clv BASE400crop_merged


# echo "cleaving the noise scan"
# fslroi FAIR1000_label1_nordic_toppedupabs FAIR1000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR2000_label1_nordic_toppedupabs FAIR2000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR3000_label1_nordic_toppedupabs FAIR3000_label1_nordic_toppedupabs_clv 0 30
# fslroi FAIR4000_label1_nordic_toppedupabs FAIR4000_label1_nordic_toppedupabs_clv 0 30

# fslroi FAIR1000_label2_nordic_toppedupabs FAIR1000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR2000_label2_nordic_toppedupabs FAIR2000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR3000_label2_nordic_toppedupabs FAIR3000_label2_nordic_toppedupabs_clv 0 30
# fslroi FAIR4000_label2_nordic_toppedupabs FAIR4000_label2_nordic_toppedupabs_clv 0 30

