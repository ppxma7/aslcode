% plot signal vs TI in the choroid plexus


mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_19_Jul_2021/';


mymaskR = 'maskbinRIGHT.nii.gz';
mymaskL = 'maskbinLEFT.nii.gz';
mycsf = 'maskbinnocp2.nii.gz';

mmaskR = MRIread([mypath mymaskR]);
mmaskL = MRIread([mypath mymaskL]);

mcsf = MRIread([mypath mycsf]);


% FAIR 
% 15 16 17 18
% 750 1000 2000 2500

t1000 = MRIread([mypath '7split_aslpp/diffav.nii.gz']);
t2000 = MRIread([mypath '9split_aslpp/diffav.nii.gz']);
t3000 = MRIread([mypath '8split_aslpp/diffav.nii.gz']);
t4000 = MRIread([mypath '10split_aslpp/diffav.nii.gz']);

base400 = MRIread([mypath 'base400.nii']);

m1000 = t1000.vol(:);
m2000 = t2000.vol(:);
m3000 = t3000.vol(:);
m4000 = t4000.vol(:);

% find the mask voxels
them = mmaskR.vol(:);
[IR,JR]=ind2sub(size(m1000),find(them==1));

themL = mmaskL.vol(:);
[IL,JL]=ind2sub(size(m1000),find(themL==1));

themCSF = mcsf.vol(:);
[Ic,Jc]=ind2sub(size(m1000),find(themCSF==1));


% CP mask
m1000_masked = m1000(IR);
m2000_masked = m2000(IR);
m3000_masked = m3000(IR);
m4000_masked = m4000(IR);

% figure
% subplot(2,2,1)
% histogram(nonzeros(m1000_masked))
% subplot(2,2,2)
% histogram(nonzeros(m2000_masked))
% subplot(2,2,3)
% histogram(nonzeros(m3000_masked))
% subplot(2,2,4)
% histogram(nonzeros(m4000_masked))

% 
m1000mn = mean(nonzeros(m1000_masked));
m2000mn = mean(nonzeros(m2000_masked));
m3000mn = mean(nonzeros(m3000_masked));
m4000mn = mean(nonzeros(m4000_masked));

% m1000mn = mode(nonzeros(m1000_masked));
% m2000mn = mode(nonzeros(m2000_masked));
% m3000mn = mode(nonzeros(m3000_masked));
% m4000mn = mode(nonzeros(m4000_masked));

% CP mask left
m1000_maskedL = m1000(IL);
m2000_maskedL = m2000(IL);
m3000_maskedL = m3000(IL);
m4000_maskedL = m4000(IL);

m1000mnL = mean(nonzeros(m1000_maskedL));
m2000mnL = mean(nonzeros(m2000_maskedL));
m3000mnL = mean(nonzeros(m3000_maskedL));
m4000mnL = mean(nonzeros(m4000_maskedL));
% m1000mnL = mode(nonzeros(m1000_maskedL));
% m2000mnL = mode(nonzeros(m2000_maskedL));
% m3000mnL = mode(nonzeros(m3000_maskedL));
% m4000mnL = mode(nonzeros(m4000_maskedL));


% csf mask
m1000_maskedc = m1000(Ic);
m2000_maskedc = m2000(Ic);
m3000_maskedc = m3000(Ic);
m4000_maskedc = m4000(Ic);
% 
m1000csf = mean(nonzeros(m1000_maskedc));
m2000csf = mean(nonzeros(m2000_maskedc));
m3000csf = mean(nonzeros(m3000_maskedc));
m4000csf = mean(nonzeros(m4000_maskedc));

% m1000csf = mode(nonzeros(m1000_maskedc));
% m2000csf = mode(nonzeros(m2000_maskedc));
% m3000csf= mode(nonzeros(m3000_maskedc));
% m4000csf = mode(nonzeros(m4000_maskedc));

pixR = [m1000mn;m2000mn;m3000mn;m4000mn];
pixL = [m1000mnL;m2000mnL;m3000mnL;m4000mnL];
pixcsf = [m1000csf;m2000csf;m3000csf;m4000csf];
TIs = [1000;2000;3000;4000];

figure
plot(TIs,pixR,'linewidth',2)
xlabel('TI (ms)')
ylabel('M (au)')
hold on
plot(TIs, pixL,'linewidth',2)
plot(TIs,pixcsf,'linewidth',2)
legend([{'CSF Right'},{'CSF Left'},{'CSF no CP'}])

%ylim([-100 200])



%% histogram

figure
subplot(3,4,1)
histogram(nonzeros(m1000_masked))
ylabel('RIGHT CP')
subplot(3,4,2)
histogram(nonzeros(m2000_masked))
subplot(3,4,3)
histogram(nonzeros(m3000_masked))
subplot(3,4,4)
histogram(nonzeros(m4000_masked))
subplot(3,4,5)
histogram(nonzeros(m1000_maskedL))
ylabel('LEFT CP')
subplot(3,4,6)
histogram(nonzeros(m2000_maskedL))
subplot(3,4,7)
histogram(nonzeros(m3000_maskedL))
subplot(3,4,8)
histogram(nonzeros(m4000_maskedL))
subplot(3,4,9)
histogram(nonzeros(m1000_maskedc))
ylabel('CSF')
subplot(3,4,10)
histogram(nonzeros(m2000_maskedc))
subplot(3,4,11)
histogram(nonzeros(m3000_maskedc))
subplot(3,4,12)
histogram(nonzeros(m4000_maskedc))








