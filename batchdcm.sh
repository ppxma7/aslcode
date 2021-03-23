#!/bin/bash
#001_H07_V1 
subjectlist="001_H08_V1 001_H08_V2 001_H09_V1 001_H09_V2 001_H11_V1 001_H11_V2 001_H13_V1 001_H13_V2\
    001_H14_V1 001_H14_V2 001_H15_V1 001_H15_V2 001_H16_V1 001_H16_V2 001_H17_V1 001_H17_V2 001_H19_V1 001_H19_V2\
    001_H23_V1 001_H23_V2 001_H24_V1 001_H24_V2 001_H25_V1 001_H25_V2 001_H27_V1 001_H27_V2 001_H28_V1 001_H28_V2\
    001_H29_V1 001_H29_V2 001_H30_V1 001_H30_V2"

# subjectlistP="001_P01_V1 001_P01_V2 001_P02_V1 001_P02_V2 001_P03_V1 001_P03_V2 001_P04_V1 001_P04_V2 001_P05_V1 001_P05_V2\
# 	001_P06_V1 001_P06_V2 001_P07_V1 001_P08_V1 001_P08_V2 001_P09_V1 001_P09_V2 001_P10_V1 001_P10_V2 

subjectlistP="001_P18_V1 001_P18_V2\
	001_P19_V1 001_P19_V2 001_P20_V1 001_P20_V2 001_P21_V1 001_P21_V2 001_P22_V1 001_P22_V2 001_P23_V1 001_P23_V2\
	001_P24_V1 001_P24_V2 001_P37_V1 001_P37_V2 001_P40_V1 001_P40_V2 001_P41_V1 001_P41_V2 001_P42_V1 001_P42_V2\
 	001_P43_V1 001_P43_V2 001_P44_V1 001_P44_V2 001_P45_V1 001_P45_V2 004_P01_V1 004_P01_V2"

#subjectlist="001_H07_V2"

MOUNT="/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/"
MOUNTP="/Volumes/ares/data/IBD/ASL/ASL_gita/Patients/"

# for subject in $subjectlist
# do
# 	echo "batch running dcm2niix"
# 	dcm2niix ${MOUNT}/${subject}
# 	cd ${MOUNT}/${subject}
# 	mkdir parrec
# 	mkdir jsonfiles
# 	mv *.PAR parrec
# 	mv *.REC parrec
# 	mv *.json jsonfiles
# 	tar -zcvf parrec.tar.gz parrec
# 	tar -zcvf jsonfiles.tar.gz jsonfiles
# 	rm -r parrec
# 	rm -r jsonfiles

# done
cd ${MOUNTP}
for subjectP in $subjectlistP
do
	echo "batch running dcm2niix"
	dcm2niix ${MOUNTP}/${subjectP}
	cd ${MOUNTP}/${subjectP}
	mkdir parrec
	mkdir jsonfiles
	mv *.PAR parrec
	mv *.REC parrec
	mv *.json jsonfiles
	tar -zcvf parrec.tar.gz parrec
	tar -zcvf jsonfiles.tar.gz jsonfiles
	rm -r parrec
	rm -r jsonfiles
	cd ${MOUNTP}
done


# to untar tar -zxvf archive_name.tar.gz