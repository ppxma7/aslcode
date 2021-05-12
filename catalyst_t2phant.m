
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

sc30 = 'base_7_8_flirt.nii.gz';
sc400 = 'base_9_10_flirt.nii.gz';
sc200 = 'sc_12_200ms_flirt.nii.gz';
sc300 = 'sc_11_300ms_flirt.nii.gz';
sc100 = 'sc_13_100ms_flirt.nii.gz';

msc30 = MRIread([mypath2 sc30]);
msc100 = MRIread([mypath2 sc100]);
msc200 = MRIread([mypath2 sc200]);
msc300 = MRIread([mypath2 sc300]);
msc400 = MRIread([mypath2 sc400]);

chorplex = 106;
chorpley = 98;
chorplez = 83;
chorplet = 1;

hix30 = msc30.vol(chorplex,chorpley,chorplez);
hix100 = msc100.vol(chorplex,chorpley,chorplez,chorplet);
hix200 = msc200.vol(chorplex,chorpley,chorplez,chorplet);
hix300 = msc300.vol(chorplex,chorpley,chorplez,chorplet);
hix400 = msc400.vol(chorplex,chorpley,chorplez,chorplet);

hix = [hix30;hix100;hix200;hix300;hix400];
TEs = [30;100;200;300;400];

% plot the real data now
% figure
% scatter(TEs,hix)
% xlabel('TE (ms)')
% ylabel('M (au)')
%% fit to head 
t = TEs;
y = hix;

figure
plot(t,y,'ro')

F = @(x,xdata)x(1).*exp(-xdata/x(2)); 
x0 = [20 50000];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y)

hold on
plot(t,F(x,t))
hold off
xlabel('TE (ms)')
ylabel('M')

%% now fit to everywhere and get a T2 map


























