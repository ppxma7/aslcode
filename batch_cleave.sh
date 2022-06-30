#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub10"
mydata="220530_GBPERM_10_v1/topup/"

echo "cleaving the noise scan"

fslroi BASE400 BASE400crop 0 3
fslroi BASE400topup BASE400topupcrop 0 3

fslroi FAIR1000_label1_nordic FAIR1000_label1_nordic_clv 0 30
fslroi FAIR2000_label1_nordic FAIR2000_label1_nordic_clv 0 30
fslroi FAIR3000_label1_nordic FAIR3000_label1_nordic_clv 0 30
fslroi FAIR4000_label1_nordic FAIR4000_label1_nordic_clv 0 30

fslroi FAIR1000_label2_nordic FAIR1000_label2_nordic_clv 0 30
fslroi FAIR2000_label2_nordic FAIR2000_label2_nordic_clv 0 30
fslroi FAIR3000_label2_nordic FAIR3000_label2_nordic_clv 0 30
fslroi FAIR4000_label2_nordic FAIR4000_label2_nordic_clv 0 30

