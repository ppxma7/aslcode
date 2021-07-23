% plot signal vs TI in the choroid plexus


mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_19_Jul_2021/';


mymaskR = 'maskbinRIGHT.nii.gz';
mymaskL = 'maskbinLEFT.nii.gz';
mycsf = 'maskbinnocp22.nii.gz';

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


% figure
% subplot(2,2,1)
% histogram(nonzeros(m1000_masked))
% subplot(2,2,2)
% histogram(nonzeros(m2000_masked))
% subplot(2,2,3)
% histogram(nonzeros(m3000_masked))
% subplot(2,2,4)
% histogram(nonzeros(m4000_masked))

% CP mask
m1000_masked = m1000(IR);
m2000_masked = m2000(IR);
m3000_masked = m3000(IR);
m4000_masked = m4000(IR);
% CP mask left
m1000_maskedL = m1000(IL);
m2000_maskedL = m2000(IL);
m3000_maskedL = m3000(IL);
m4000_maskedL = m4000(IL);
% csf mask
m1000_maskedc = m1000(Ic);
m2000_maskedc = m2000(Ic);
m3000_maskedc = m3000(Ic);
m4000_maskedc = m4000(Ic);

%%

domode = 0;

if domode ~= 1
    m1000mn = mean(nonzeros(m1000_masked));
    m2000mn = mean(nonzeros(m2000_masked));
    m3000mn = mean(nonzeros(m3000_masked));
    m4000mn = mean(nonzeros(m4000_masked));
    
    m1000mnL = mean(nonzeros(m1000_maskedL));
    m2000mnL = mean(nonzeros(m2000_maskedL));
    m3000mnL = mean(nonzeros(m3000_maskedL));
    m4000mnL = mean(nonzeros(m4000_maskedL));
    
    
    m1000csf = mean(nonzeros(m1000_maskedc));
    m2000csf = mean(nonzeros(m2000_maskedc));
    m3000csf = mean(nonzeros(m3000_maskedc));
    m4000csf = mean(nonzeros(m4000_maskedc));

else %do mode
    
    m1000mn = mode(nonzeros(m1000_masked));
    m2000mn = mode(nonzeros(m2000_masked));
    m3000mn = mode(nonzeros(m3000_masked));
    m4000mn = mode(nonzeros(m4000_masked));
    
    m1000mnL = mode(nonzeros(m1000_maskedL));
    m2000mnL = mode(nonzeros(m2000_maskedL));
    m3000mnL = mode(nonzeros(m3000_maskedL));
    m4000mnL = mode(nonzeros(m4000_maskedL));
    
    m1000csf = mode(nonzeros(m1000_maskedc));
    m2000csf = mode(nonzeros(m2000_maskedc));
    m3000csf= mode(nonzeros(m3000_maskedc));
    m4000csf = mode(nonzeros(m4000_maskedc));
end


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

t = TIs;
y = pixR;
y2 = pixL;
y3 = pixcsf;

%% histogram
EDGES = 36;
figure('Position',[100 100 1000 800])
subplot(3,4,1)
histogram(nonzeros(m1000_masked),EDGES)
ylabel('RIGHT CP')
subplot(3,4,2)
histogram(nonzeros(m2000_masked),EDGES)
subplot(3,4,3)
histogram(nonzeros(m3000_masked),EDGES)
subplot(3,4,4)
histogram(nonzeros(m4000_masked),EDGES)
subplot(3,4,5)
histogram(nonzeros(m1000_maskedL),EDGES)
ylabel('LEFT CP')
subplot(3,4,6)
histogram(nonzeros(m2000_maskedL),EDGES)
subplot(3,4,7)
histogram(nonzeros(m3000_maskedL),EDGES)
subplot(3,4,8)
histogram(nonzeros(m4000_maskedL),EDGES)
subplot(3,4,9)
histogram(nonzeros(m1000_maskedc),EDGES)
ylabel('CSF')
subplot(3,4,10)
histogram(nonzeros(m2000_maskedc),EDGES)
subplot(3,4,11)
histogram(nonzeros(m3000_maskedc),EDGES)
subplot(3,4,12)
histogram(nonzeros(m4000_maskedc),EDGES)

%% First try a bi fit


opts = optimoptions('lsqcurvefit','Display','off');

%F = @(x,xdata) x(1)*exp(-xdata/x(2)) + x(3); % MONOEXP
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP


%x0 = [1 40 0.05];
x02 = [1 40 100 0.05 ];

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
theTIs = [1; 2; 3; 4];

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


                      

% equation 10
dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));

% equation 11
dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);

%equation 9
IV_fraction = dMiv ./ (dMiv + dMev);
% this is equation 8 from Ohene
%dMc = dMiv.*exp(-(TEs./T2iv)) + dMev.*exp(-(TEs./T2ev));
%%
TE = 400;


%F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP

% We're trying to the fit the dMiv and the dMev bit, one part goes up, the
% other goes down

%F3 = @(x,data) x(1).*exp(-dMiv/x(2))+x(3).*exp(-dMev/x(4)) + x(5);
F3 = @(x,data) x(1).*exp(-dMiv/x(2))+(1-x(1)).*exp(-dMev/x(4)) + x(5);

%F3 = @(x,xdata) dMiv.*exp(-TE/x(1))+dMev.*exp(-TE/x(2)) +x(3); % BIEXP
% F3b = @(x,xdata) dMiv(2).*exp(-xdata/x(1))+dMev(2).*exp(-xdata/x(2)) +x(3); % BIEXP
% F3c = @(x,xdata) dMiv(3).*exp(-xdata/x(1))+dMev(3).*exp(-xdata/x(2)) +x(3); % BIEXP
% F3d = @(x,xdata) dMiv(4).*exp(-xdata/x(1))+dMev(4).*exp(-xdata/x(2)) +x(3); % BIEXP

%x03 = [1 1 0.1];
x03 = [1 1 1 1 0.05 ];

[x3,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y,[],[],opts);
[x3L,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y2,[],[],opts);
[x3csf,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y3,[],[],opts);


% [x3b,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3b,x03,t,y,[],[],opts);
% [x3c,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3c,x03,t,y,[],[],opts);
% [x3d,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3d,x03,t,y,[],[],opts);

figure
scatter(t,y,'ro')
hold on
scatter(t,y2,'bo')
scatter(t,y3,'ko')


plot(t,F3(x3,t),'-r','Linewidth',2)
plot(t,F3(x3L,t),'-b','Linewidth',2)
plot(t,F3(x3csf,t),'-k','Linewidth',1)

% plot(t,F3b(x3b,t),'-k','Linewidth',2)
% plot(t,F3c(x3c,t),'-k','Linewidth',2)
% plot(t,F3d(x3d,t),'-k','Linewidth',2)

xlabel('TI (ms)')
ylabel('M')
legend([{'Data RIGHT'},{'Data LEFT'},{'Data CSF'},{'FitR'},{'FitL'}, {'FitCSF'}])






