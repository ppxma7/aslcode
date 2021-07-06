% plot signal vs TI in the choroid plexus


mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_05_Jul_2021/';


mymask = 'maskbin.nii.gz';
mycsf = 'maskbincsf.nii.gz';

mmask = MRIread([mypath mymask]);
mcsf = MRIread([mypath mycsf]);


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

themCSF = mcsf.vol(:);
[Ic,Jc]=ind2sub(size(m0750),find(themCSF==1));

% CP mask
m0750_masked = m0750(I);
m1000_masked = m1000(I);
m2000_masked = m2000(I);
m2500_masked = m2500(I);

m0750mn = mean(m0750_masked);
m1000mn = mean(m1000_masked);
m2000mn = mean(m2000_masked);
m2500mn = mean(m2500_masked);

% csf mask
m0750_maskedc = m0750(Ic);
m1000_maskedc = m1000(Ic);
m2000_maskedc = m2000(Ic);
m2500_maskedc = m2500(Ic);

m0750csf = mean(m0750_maskedc);
m1000csf = mean(m1000_maskedc);
m2000csf= mean(m2000_maskedc);
m2500csf = mean(m2500_maskedc);

pix = [m0750mn;m1000mn;m2000mn;m2500mn];
pixcsf = [m0750csf;m1000csf;m2000csf;m2500csf];
TIs = [750;1000;2000;2500];

figure
plot(TIs,pix,'linewidth',2)
xlabel('TI (ms)')
ylabel('M (au)')
hold on
plot(TIs, pixcsf,'linewidth',2)
legend([{'CSF CP'},{'CSF no CP'}])
ylim([-100 200])


%%

t = TIs;
y = pix;

opts = optimoptions('lsqcurvefit','Display','off');

%F = @(x,xdata) x(1)*exp(-xdata/x(2)) + x(3); % MONOEXP
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP


%x0 = [1 40 0.05];
x02 = [1 40 100 0.05 ];

% x1 = zeros(1000,3);
% x2 = zeros(1000,4);
% 
% outmono = zeros(1000,length(t));
% outbi = zeros(1000,length(t));
% 
% lb = [0 0 0 0];
% ub = [2 100 300 2];

%[x1,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts);
[x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x02,t,y,[],[],opts);
   

figure
scatter(t,y,'ko')
hold on

%plot(t,F(x1,t),'-k','Linewidth',2)
plot(t,F2(x2,t),'-r','Linewidth',2)
xlabel('TI (ms)')
ylabel('M')
legend([{'Data'},{'Bi Fit'}])


% % figure
% % 
% % plot(t,log(y))



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
theTIs = [0.75; 1; 2; 2.5];

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

TEs = [30; 400];
                      

% equation 10
dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));

% equation 11
dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);

%equation 9
IV_fraction = dMiv ./ (dMiv + dMev);
% this is equation 8 from Ohene
%dMc = dMiv.*exp(-(TEs./T2iv)) + dMev.*exp(-(TEs./T2ev));


%% fitting
F3 = @(x,xdata) dMiv.*exp(-x(1)/xdata)+dMev.*exp(-x(2)/xdata) +x(3); % BIEXP
% F3b = @(x,xdata) dMiv(2).*exp(-xdata/x(1))+dMev(2).*exp(-xdata/x(2)) +x(3); % BIEXP
% F3c = @(x,xdata) dMiv(3).*exp(-xdata/x(1))+dMev(3).*exp(-xdata/x(2)) +x(3); % BIEXP
% F3d = @(x,xdata) dMiv(4).*exp(-xdata/x(1))+dMev(4).*exp(-xdata/x(2)) +x(3); % BIEXP

x03 = [30 400 0.1];
[x3,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y,[],[],opts);
% [x3b,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3b,x03,t,y,[],[],opts);
% [x3c,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3c,x03,t,y,[],[],opts);
% [x3d,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3d,x03,t,y,[],[],opts);

figure
scatter(t,y,'ko')
hold on

plot(t,F3(x3,t),'-r','Linewidth',2)
% plot(t,F3b(x3b,t),'-k','Linewidth',2)
% plot(t,F3c(x3c,t),'-k','Linewidth',2)
% plot(t,F3d(x3d,t),'-k','Linewidth',2)

xlabel('TI (ms)')
ylabel('M')
legend([{'Data'},{'Equation 8 TI750'},{'Equation 8 TI1000'},{'Equation 8 TI2000'},{'Equation 8 TI2500'}])






