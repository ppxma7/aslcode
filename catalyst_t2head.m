%% CATALYST_T2_HEAD
%
% This code tries to fit a T2 decay curve to data collected at various TEs.
% 

% From dataset using MPRAGE to identify choroid plexus

% ma 2021-06-04

%% Load
% fit T2 map to different TEs
mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_04_Jun_2021/nifti/';


mymask = 'maskbet_roi_bin.nii.gz';
d30 = 'BCSFB_04_Jun_2021_WIPBASE_30MS_20210604151301_7.nii';
d60 = 'BCSFB_04_Jun_2021_WIPBASE_60MS_20210604151301_9.nii';
d90 = 'BCSFB_04_Jun_2021_WIPBASE_90MS_20210604151301_10.nii';
d120 = 'BCSFB_04_Jun_2021_WIPBASE_120MS_20210604151301_11.nii';
d150 = 'BCSFB_04_Jun_2021_WIPBASE_150MS_20210604151301_12.nii';
d200 = 'BCSFB_04_Jun_2021_WIPBASE_200MS_20210604151301_13.nii';
d300 = 'BCSFB_04_Jun_2021_WIPBASE_300MS_20210604151301_14.nii';
d400 = 'BCSFB_04_Jun_2021_WIPBASE_400MS_20210604151301_15.nii';

m30 = MRIread([mypath d30]);
m30vol = m30.vol(:);
m60 = MRIread([mypath d60]);
m60vol = m60.vol(:);
m90 = MRIread([mypath d90]);
m90vol = m90.vol(:);
m120 = MRIread([mypath d120]);
m120vol = m120.vol(:);
m150 = MRIread([mypath d150]);
m150vol = m150.vol(:);
m200 = MRIread([mypath d200]);
m200vol = m200.vol(:);
m300 = MRIread([mypath d300]);
m300vol = m300.vol(:);
m400 = MRIread([mypath d400]);
m400vol = m400.vol(:);

mmask = MRIread([mypath mymask]);

% find the mean mask values

them = mmask.vol(:);
[I,J]=ind2sub(size(m30vol),find(them==1));

m30vol_masked = m30vol(I);
m60vol_masked = m60vol(I);
m90vol_masked = m90vol(I);
m120vol_masked = m120vol(I);
m150vol_masked = m150vol(I);
m200vol_masked = m200vol(I);
m300vol_masked = m300vol(I);
m400vol_masked = m400vol(I);

m30mn = mean(m30vol_masked);
m60mn = mean(m60vol_masked);
m90mn = mean(m90vol_masked);
m120mn = mean(m120vol_masked);
m150mn = mean(m150vol_masked);
m200mn = mean(m200vol_masked);
m300mn = mean(m300vol_masked);
m400mn = mean(m300vol_masked);

pix = [m30mn;m60mn;m90mn;m120mn;m150mn; m200mn; m300mn; m400mn];
TEs = [30;60;90;120;150;200;300;400];

% figure
% scatter(TEs,pix)
% xlabel('TE (ms)')
% ylabel('M (au)')

%% fit
t = TEs;
y = pix;

opts = optimoptions('lsqcurvefit','Display','off');

F = @(x,xdata) x(1)*exp(-xdata/x(2)) + x(3); % MONOEXP
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP
x0 = [1 40 0.05];
x02 = [1 40 100 0.05 ];

% x1 = zeros(1000,3);
% x2 = zeros(1000,4);
% 
% outmono = zeros(1000,length(t));
% outbi = zeros(1000,length(t));
% 
% lb = [0 0 0 0];
% ub = [2 100 300 2];

[x1,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts);
[x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x02,t,y,[],[],opts);
   

figure
scatter(t,y,'ko')
hold on

plot(t,F(x1,t),'-k','Linewidth',2)
plot(t,F2(x2,t),'-r','Linewidth',2)
xlabel('TE (ms)')
ylabel('M')
legend([{'Data'},{'Mono Fit'},{'Bi Fit'}])


figure

plot(t,log(y))


%% try fitting a slightly different equation now

T1a = 1.9; %longitudinal relaxation of arterial blood (ms) at 9.4 T 2.4s human at 3.0 T = 1.9 s
Mo = 1;

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
theTIs = [0.8; 1.5];

A = 2.*inv_eff.*Moa.*(CBF/BB_lambda);

tissueTT = 0.5; % GUESS
dR = R1app - R1a;

% T2iv800 = 20.6; % ms
% T2iv1500 = 14.3;
% T2ev800 = 37.1;
% T2ev1500 = 34.5;
% 
% T2iv = [T2iv800, T2iv1500];
% T2ev = [T2ev800, T2ev1500];

TEs = [30;60;90;120;150;200;300;400];
                      

% equation 10
dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));

% equation 11
dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);

%equation 9
IV_fraction = dMiv ./ (dMiv + dMev);
% this is equation 8 from Ohene
%dMc = dMiv.*exp(-(TEs./T2iv)) + dMev.*exp(-(TEs./T2ev));


%% fitting
F3 = @(x,xdata) dMiv(1).*exp(-xdata/x(1))+dMev(1).*exp(-xdata/x(2)) +x(3); % BIEXP
F3b = @(x,xdata) dMiv(2).*exp(-xdata/x(1))+dMev(2).*exp(-xdata/x(2)) +x(3); % BIEXP

x03 = [40 400 0.1];
[x3,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y,[],[],opts);
[x3b,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3b,x03,t,y,[],[],opts);

figure
scatter(t,y,'ko')
hold on

plot(t,F3(x3,t),'-r','Linewidth',2)
plot(t,F3b(x3b,t),'-k','Linewidth',2)

xlabel('TE (ms)')
ylabel('M')
legend([{'Data'},{'Equation 8 TI1'},{'Equation 8 TI2'}])

   












