#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub06"
mydata="220311_GBPERM_06_v1/topup/"

cd ${mypath}${mydata}/

echo "running topup on the base scan"
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/toppedup.sh . BASE400crop BASE400topup input1 input2

echo "applying base topup to labels"
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . BASE400crop BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR1000_label1_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR2000_label1_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR3000_label1_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR4000_label1_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR1000_label2_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR2000_label2_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR3000_label2_nordic BASE400crop_merged
sh /Users/ppzma/Documents/MATLAB/nottingham/bin/applytoppedup.sh . FAIR4000_label2_nordic BASE400crop_merged


echo "cleaving the noise scan"
fslroi FAIR1000_label1_nordic_toppedupabs FAIR1000_label1_nordic_toppedupabs_clv 0 30
fslroi FAIR2000_label1_nordic_toppedupabs FAIR2000_label1_nordic_toppedupabs_clv 0 30
fslroi FAIR3000_label1_nordic_toppedupabs FAIR3000_label1_nordic_toppedupabs_clv 0 30
fslroi FAIR4000_label1_nordic_toppedupabs FAIR4000_label1_nordic_toppedupabs_clv 0 30

fslroi FAIR1000_label2_nordic_toppedupabs FAIR1000_label2_nordic_toppedupabs_clv 0 30
fslroi FAIR2000_label2_nordic_toppedupabs FAIR2000_label2_nordic_toppedupabs_clv 0 30
fslroi FAIR3000_label2_nordic_toppedupabs FAIR3000_label2_nordic_toppedupabs_clv 0 30
fslroi FAIR4000_label2_nordic_toppedupabs FAIR4000_label2_nordic_toppedupabs_clv 0 30

