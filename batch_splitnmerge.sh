#! /bin/bash

mypath="/Volumes/nemosine/CATALYST_BCSFB/"
mysub="sub09"
# mydata="220518_GBPERM_09_v1/magnitude/"

# sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata}/ *1000ms* FAIR1000 0 31 31
# sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata}/ *2000ms* FAIR2000 0 31 31
# sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata}/ *3000ms* FAIR3000 0 31 31
# sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata}/ *4000ms* FAIR4000 0 31 31

mydata2="220518_GBPERM_09_v1/phase/"

sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata2}/ *1000ms* FAIR1000 0 31 31
sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata2}/ *2000ms* FAIR2000 0 31 31
sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata2}/ *3000ms* FAIR3000 0 31 31
sh /Users/ppzma/Documents/MATLAB/aslcode/splitnmerge.sh ${mypath}${mydata2}/ *4000ms* FAIR4000 0 31 31




#echo ${mypath}${mydata}

#cd ${mypath}${mydata}/

#echo *1000ms*