% plot signal vs TI in the choroid plexus


mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_19_Jul_2021/';


mymask = 'maskbin2.nii.gz';
mycsf = 'maskbinnocp.nii.gz';

mmask = MRIread([mypath mymask]);
mcsf = MRIread([mypath mycsf]);


% FAIR 
% 15 16 17 18
% 750 1000 2000 2500

t1000 = MRIread([mypath '7split_aslpp/diffav.nii.gz']);
t2000 = MRIread([mypath '9split_aslpp/diffav.nii.gz']);
t3000 = MRIread([mypath '8split_aslpp/diffav.nii.gz']);
t4000 = MRIread([mypath '10split_aslpp/diffav.nii.gz']);

m1000 = t1000.vol(:);
m2000 = t2000.vol(:);
m3000 = t3000.vol(:);
m4000 = t4000.vol(:);

% find the mask voxels
them = mmask.vol(:);
[I,J]=ind2sub(size(m1000),find(them==1));

themCSF = mcsf.vol(:);
[Ic,Jc]=ind2sub(size(m1000),find(themCSF==1));


% CP mask
m1000_masked = m1000(I);
m2000_masked = m2000(I);
m3000_masked = m3000(I);
m4000_masked = m4000(I);

m1000mn = mean(m1000_masked);
m2000mn = mean(m2000_masked);
m3000mn = mean(m3000_masked);
m4000mn = mean(m4000_masked);

% csf mask
m1000_maskedc = m1000(Ic);
m2000_maskedc = m2000(Ic);
m3000_maskedc = m3000(Ic);
m4000_maskedc = m4000(Ic);

m1000csf = mean(m1000_maskedc);
m2000csf = mean(m2000_maskedc);
m3000csf= mean(m3000_maskedc);
m4000csf = mean(m4000_maskedc);

pix = [m1000mn;m2000mn;m3000mn;m4000mn];
pixcsf = [m1000csf;m2000csf;m3000csf;m4000csf];
TIs = [1000;2000;3000;4000];

figure
plot(TIs,pix,'linewidth',2)
xlabel('TI (ms)')
ylabel('M (au)')
hold on
plot(TIs, pixcsf,'linewidth',2)
legend([{'CSF CP'},{'CSF no CP'}])
%ylim([-100 200])



