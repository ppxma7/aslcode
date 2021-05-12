
% fit T2 map to different TEs
mypath ='/Volumes/nemosine/CATALYST_BCSFB/ASL/phantom_2021_05_05/';

d30 = 'DICOM_phantom_WIP_BASE_30MS_20210505160940_701.nii';
d400 = 'DICOM_phantom_WIP_BASE_20210505160940_801.nii';
d200 = 'DICOM_phantom_WIP_BASE_20210505160940_901.nii';
d300 = 'DICOM_phantom_WIP_BASE_20210505160940_1001.nii';
d100 = 'DICOM_phantom_WIP_BASE_20210505160940_1101.nii';

% look for consistent vox in fsleyes
myvox = 18;
myvoy = 33;
myvoz = 4;

m30 = MRIread([mypath d30]);
m100 = MRIread([mypath d100]);
m200 = MRIread([mypath d200]);
m300 = MRIread([mypath d300]);
m400 = MRIread([mypath d400]);

pix30 = m30.vol(myvox,myvoy,myvoz);
pix100 = m100.vol(myvox,myvoy,myvoz);
pix200 = m200.vol(myvox,myvoy,myvoz);
pix300 = m300.vol(myvox,myvoy,myvoz);
pix400 = m400.vol(myvox,myvoy,myvoz);

pix = [pix30;pix100;pix200;pix300;pix400];
TEs = [30;100;200;300;400];

% plot the real data now
figure
scatter(TEs,pix)
xlabel('TE (ms)')
ylabel('M (au)')

%% now we want to figure out how to fit a T2 curve to this!






