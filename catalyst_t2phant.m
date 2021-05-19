%% CATALYST_T2_PHANT
%
% This code tries to fit a T2 decay curve to data collected at various TEs.
% We have a phantom dataset, and also a head.
% So far using a monoexponential fit
% Spits out a T2 map for the head
% This is done in native space for speed reasons

% ma 2021-05-13


%% Phantom

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

%Mxy = Mo.*exp^(-TE/T2);

t = TEs;
y = pix;

figure
plot(t,y,'ro')

F = @(x,xdata)x(1).*exp(-xdata/x(2)); 
x0 = [20 10000];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y)

hold on
plot(t,F(x,t))
hold off
xlabel('TE (ms)')
ylabel('M')

%% Try it on a head

mypath2 ='/Volumes/nemosine/CATALYST_BCSFB/ASL/03315_2021_05_05/';

% so the native space are 64 64 8
% MPRAGE space is 256 256 162
sc30 = 'BCSFB_WIPBASE_30MS_20210505165327_7.nii';
sc400 = 'BCSFB_WIPBASE_400MS_20210505165327_9.nii';
sc200 = 'BCSFB_WIPBASE_200MS_20210505165327_12.nii';
sc300 = 'BCSFB_WIPBASE_300MS_20210505165327_11.nii';
sc100 = 'BCSFB_WIPBASE_100MS_20210505165327_13.nii';

% need mask with MPRAGE space data but not in native space
%scmask = 'mymask.nii.gz';
% 
% mymask = MRIread([mypath2 scmask]);
% mymaskv = mymask.vol(:,:,:,1);

msc30 = MRIread([mypath2 sc30]);
msc100 = MRIread([mypath2 sc100]);
msc200 = MRIread([mypath2 sc200]);
msc300 = MRIread([mypath2 sc300]);
msc400 = MRIread([mypath2 sc400]);

% chorplex = 106;
% chorpley = 98;
% chorplez = 83;
% chorplet = 1;

%% pick a good voxel
chorplex = 24;
chorpley = 25;
chorplez = 4;
chorplet = 1;


hix30 = msc30.vol(chorplex,chorpley,chorplez);
hix100 = msc100.vol(chorplex,chorpley,chorplez,chorplet);
hix200 = msc200.vol(chorplex,chorpley,chorplez,chorplet);
hix300 = msc300.vol(chorplex,chorpley,chorplez,chorplet);
hix400 = msc400.vol(chorplex,chorpley,chorplez,chorplet);

hix = [hix30;hix100;hix200;hix300;hix400];
TEs = [30;100;200;300;400];

%plot the real data now
% figure
% scatter(TEs,hix)
% xlabel('TE (ms)')
% ylabel('M (au)')

%% fit to head 
t = TEs;
y = hix;

figure
plot(t,y,'ro')
opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','Display','off');
% monoexp
% M = ke^-TE/T2 + offset
F = @(x,xdata)x(1).*exp(-xdata/x(2)) +x(3); 

% biexp
% M = k1e^-TE/T2short + k2e^-TE/T2long + offset
% note that from literature, only pixels were 4*T2short < T2long
%https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4180725/
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+x(3).*exp(-xdata/x(4) +x(5));

x0 = [0 10000 0 25000 0];
%x0 = [20 50000 ];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts)
[x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x0,t,y,[],[],opts)

hold on
plot(t,F(x,t),'-b','Linewidth',2)
plot(t,F2(x2,t),'--m','Linewidth',2)
xlabel('TE (ms)')
ylabel('M')
legend([{'Data'},{'Monoexp'},{'Biexp'}])



%% can we try to run our ASL_sim.m code as a third fitting option?
T1a = 1.9; %longitudinal relaxation of arterial blood (ms) at 9.4 T 2.4s human at 3.0 T = 1.9 s
R1a = 1/T1a;
R1app = 1/1.7; %seconds
tau = 1.7; % temporal length of tagged bolus seconds
BB_lambda = 0.9;
CBF = 70; % adult mice 191 mL/100g/min - for human brain 70 ml/100g/min
CBF=CBF/6000;
artTT = 0.400; %typical 500ms to arrive
Moa = 1; % assume magnetization recovers to 1
inv_eff = 0.9; %inversion efficiency
%TI_artTT = [0.2 0.3 0.4 0.5];
%TE_artTT = 0.01;
%TR_artTT = 10; % seconds

%theTIs = [0.2 0.75 1.5 2.75 4 6.5];

% for these data, we only have one TI
theTIs = [0.4];

A = 2.*inv_eff.*Moa.*(CBF/BB_lambda);

tissueTT = 0.5; % GUESS
dR = R1app - R1a;
T2iv800 = 20.6; % ms
T2iv1500 = 14.3;
T2ev800 = 37.1;
T2ev1500 = 34.5;

T2iv = [T2iv800, T2iv1500];
T2ev = [T2ev800, T2ev1500];

TEs = [30;100;200;300;400];


% equation 10
dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));

% equation 11
dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);

%equation 9
IV_fraction = dMiv ./ (dMiv + dMev);
% this is equation 8 from Ohene
dMc = dMiv.*exp(-(TEs./T2iv)) + dMev.*exp(-(TEs./T2ev));

% figure
% plot(t,log(y))

%% now fit to everywhere and get a T2 map

% this will take 5 hours

% msc30mask = msc30.vol.*mymaskv;
% msc100mask = msc100.vol(:,:,:,1).*mymaskv;
% msc200mask = msc200.vol(:,:,:,1).*mymaskv;
% msc300mask = msc300.vol(:,:,:,1).*mymaskv;
% msc400mask = msc400.vol(:,:,:,1).*mymaskv;
% msc30mvec = msc30mask(:);
% msc100mvec = msc100mask(:);
% msc200mvec = msc200mask(:);
% msc300mvec = msc300mask(:);
% msc400mvec = msc400mask(:);

msc30mvec = msc30.vol(:);
msc100mvec = msc100.vol(:,:,:,1);
msc100mvec = msc100mvec(:);
msc200mvec = msc200.vol(:,:,:,1);
msc200mvec = msc200mvec(:);
msc300mvec = msc300.vol(:,:,:,1);
msc300mvec = msc300mvec(:);
msc400mvec = msc400.vol(:,:,:,1);
msc400mvec = msc400mvec(:);

% vec = mymaskv(:);
% idx = find(vec>0);
% [ii,jj,kk] = ind2sub([256,256,162],idx);


% fitting equation
% monoexp
F = @(x,xdata)x(1).*exp(-xdata/x(2)) +x(3); 
% biexp
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+x(3).*exp(-xdata/x(4) + x(5));
x0 = [0 10000 0 25000 0];

%F = @(x,xdata)x(1).*exp(-xdata/x(2)); 
%x0 = [20 100000];


%t2map = zeros(size(msc30mask));
TEs = [30;100;200;300;400];

t = TEs;


% hix30 = msc30mvec(idx);
% hix100 = msc100mvec(idx);
% hix200 = msc200mvec(idx);
% hix300 = msc300mvec(idx);
% hix400 = msc400mvec(idx);
hix30 = msc30mvec;
hix100 = msc100mvec;
hix200 = msc200mvec;
hix300 = msc300mvec;
hix400 = msc400mvec;


t2map_mono = zeros(length(msc30mvec),1);
t2map_bi = zeros(length(msc30mvec),1);

mono_x1= zeros(length(msc30mvec),1);
mono_x2= zeros(length(msc30mvec),1);
mono_x3= zeros(length(msc30mvec),1);

bi_x1= zeros(length(msc30mvec),1);
bi_x2= zeros(length(msc30mvec),1);
bi_x3= zeros(length(msc30mvec),1);
bi_x4= zeros(length(msc30mvec),1);

opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','Display','off');

tmp = 0;

% this takes 13 minutes
tic
for mydude = 1:length(hix30)
    y = [hix30(mydude);hix100(mydude);hix200(mydude);hix300(mydude);hix400(mydude)];
    [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts);  
    [x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x0,t,y,[],[],opts);    
%     t2map_mono(mydude) = x(2);
%     t2map_bi(mydude) = x2(2);
    
    mono_x1(mydude) = x(1);
    mono_x2(mydude) = x(2);
    mono_x3(mydude) = x(3);
    
    
    bi_x1(mydude) = x2(1);
    bi_x2(mydude) = x2(2);
    bi_x3(mydude) = x2(3);
    bi_x4(mydude) = x2(4);
    
    %tmp = (mydude ./ length(hix30)) .*100;
end
toc



mono_x1_rs = reshape(mono_x1, size(msc30.vol));
mono_x2_rs = reshape(mono_x2, size(msc30.vol));
mono_x3_rs = reshape(mono_x3, size(msc30.vol));
bi_x1_rs = reshape(bi_x1, size(msc30.vol));
bi_x2_rs = reshape(bi_x2, size(msc30.vol));
bi_x3_rs = reshape(bi_x3, size(msc30.vol));
bi_x4_rs = reshape(bi_x4, size(msc30.vol));


mri = msc30;
mri.vol = mono_x1_rs;
outputfilename = [mypath2 'mono_x1.nii'];
MRIwrite(mri,outputfilename);

mri = msc30;
mri.vol = mono_x2_rs;
outputfilename = [mypath2 'mono_x2.nii'];
MRIwrite(mri,outputfilename);
mri = msc30;
mri.vol = mono_x3_rs;
outputfilename = [mypath2 'mono_x3.nii'];
MRIwrite(mri,outputfilename);
mri = msc30;
mri.vol = bi_x1_rs;
outputfilename = [mypath2 'bi_x1.nii'];
MRIwrite(mri,outputfilename);
mri = msc30;
mri.vol = bi_x2_rs;
outputfilename = [mypath2 'bi_x2.nii'];
MRIwrite(mri,outputfilename);
mri = msc30;
mri.vol = bi_x3_rs;
outputfilename = [mypath2 'bi_x3.nii'];
MRIwrite(mri,outputfilename);
mri = msc30;
mri.vol = bi_x4_rs;
outputfilename = [mypath2 'bi_x4.nii'];
MRIwrite(mri,outputfilename);






% tic
% for iz = 1:length(kk)
%     for iy = 1:length(jj)
%         for ix = 1:length(ii)
% 
%             hix30 = msc30mask(ii(ix),jj(iy),kk(iz));
%             hix100 = msc100mask(ii(ix),jj(iy),kk(iz),1);
%             hix200 = msc200mask(ii(ix),jj(iy),kk(iz),1);
%             hix300 = msc300mask(ii(ix),jj(iy),kk(iz),1);
%             hix400 = msc400mask(ii(ix),jj(iy),kk(iz),1);
%             
%             y = [hix30;hix100;hix200;hix300;hix400];
%             [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y);
%             
%             t2map(ix,iy,iz) = x(2);
%         end
%     end
% end
% toc
% 
            
            
            
            
            




























