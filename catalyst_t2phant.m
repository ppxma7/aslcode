
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

chorplex = 24;
chorpley = 23;
chorplez = 3;
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
F = @(x,xdata)x(1).*exp(-xdata/x(2)); 
x0 = [20 100000];


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


t2map = zeros(length(msc30mvec),1);

opts = optimset('Display','off');

tmp = 0;
%fprintf('%.3f%%\n',tmp)

% this takes 13 minutes
tic
for mydude = 1:length(hix30)
    y = [hix30(mydude);hix100(mydude);hix200(mydude);hix300(mydude);hix400(mydude)];
    [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts);    
    t2map(mydude) = x(2);
    
    tmp = (mydude ./ length(hix30)) .*100;
    %fprintf('\b\b\b\b\b\b\b%.3f%%',tmp)
end
toc

t2map_rs = reshape(t2map, [64 64 8]);

mri = msc30;
mri.vol = t2map_rs;
outputfilename = [mypath2 't2map.nii'];
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
            
            
            
            
            




























