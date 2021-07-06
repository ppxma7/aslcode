% plot signal vs TI in the choroid plexus


mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_05_Jul_2021/';


mymask = 'maskbin.nii.gz';

mmask = MRIread([mypath mymask]);

% pCASL first
% 15 16 17 18
% 750 1000 2000 2500

t0750 = MRIread([mypath '15spl_aslpp/diffav.nii.gz']);
t1000 = MRIread([mypath '16spl_aslpp/diffav.nii.gz']);
t2000 = MRIread([mypath '17spl_aslpp/diffav.nii.gz']);
t2500 = MRIread([mypath '18spl_aslpp/diffav.nii.gz']);

m0750 = t0750.vol(:);
m1000 = t1000.vol(:);
m2000 = t2000.vol(:);
m2500 = t2500.vol(:);

% find the mask voxels
them = mmask.vol(:);
[I,J]=ind2sub(size(m0750),find(them==1));

m0750_masked = m0750(I);
m1000_masked = m1000(I);
m2000_masked = m2000(I);
m2500_masked = m2500(I);

m0750mn = mean(m0750_masked);
m1000mn = mean(m1000_masked);
m2000mn = mean(m2000_masked);
m2500mn = mean(m2500_masked);

pix = [m0750mn;m1000mn;m2000mn;m2500mn];
TIs = [750;1000;2000;2500];

figure
scatter(TIs,pix)
xlabel('TI (ms)')
ylabel('M (au)')

%%








