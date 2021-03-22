% simulate curves from Ohene 2021
% model
figure
%
BB_lambda = 0.9;

TI_a = 800;
TI_b = 1500;
TE = [8 10 12 15 18 23 30 40 50 65];

simASLsig_a = [1 0.95 0.88 0.75 0.65 0.59 0.45 0.3 0.22 0.1]; %pseudo data

rising = 0:0.01:0.09; 
simASLsig_b = simASLsig_a + rising; %pseudo data


% y = 2*exp(-0.2*x) + 0.1*randn(size(x));
% r = 1+(0.5-0.1).*rand(1);
% linfunc =  exp([0.1:0.1:1]);
% simASLsig2 = simASLsig.*linfunc;

%
% scatter(TE, simASLsig_a)
% xlim([0 70])
% ylim([0 1.5])
% ylabel('ASL signal (au)')
% xlabel('TE (ms)')
% hold on
% scatter(TE, simASLsig_b)
% 
% legend('TI=800ms','TI=1500ms')

%

TR = 5000;

% from data
CBF = 191; % adult mice mL/100g/min
T2iv800 = 20.6; % ms
T2iv1500 = 14.3;
T2ev800 = 37.1;
T2ev1500 = 34.5;


T1a = 2400; %longitudinal relaxation of arterial blood (ms) at 9.4 T
R1a = 1/T1a;
R1app = 1/1700;
tau = 1700; % temporal length of tagged bolus

% arrival time of the labeled bolus of blood water to imaging
% ROI, estimated using multi TI ASL acquisition
% At short TIs, ASL signal dM has linear dependence on TI
% dM = 0 when artTT > TI
artTT = 400; %typical 500ms to arrive
Moa = 1; % assume magnetization recovers to 1

inv_eff = 0.9; %inversion efficiency

TI_artTT = [200 300 400 500];
TE_artTT = 10;
TR_artTT = 10000;

theTIs = [200 750 1500 2750 4000 6500];

A = 2.*inv_eff.*Moa.*(CBF/BB_lambda);

%EQUATION (2)
dM = A.*(theTIs-artTT).*exp(-theTIs./T1a); % when artTT < TI

figure, scatter(1:length(dM),dM)

Mo = 1;

%EQUATION (3)
%T1b = ???;
T1prime_reciprocal = 1/T1a + CBF/BB_lambda;
T1prime = 1/T1prime_reciprocal;
k = 1/T1b - 1/T1prime;
q1 = exp(k.*theTIs).*exp(-k.*artTT)-(exp(-k.*theTIs)/k.*(theTIs-artTT));
q2 = exp(k.*theTIs).*exp(-k.*artTT)-(exp(-k.*(tau+artTT)/k.*tau));
dMb = 2.*Mo.*(theTIs-artTT).*inv_eff.*CBF.*(max(0,theTIs-artTT)/theTIs-artTT).*(exp(-theTIs.*R1a).*q1.*(min(0,theTIs-artTT-tau)/TI-artTT-tau)+2.*Mo.*tau.*inv_eff.*exp(-theTIs.*R1a).*q2.*(max(0,theTIs-artTT-tau)/theTIs-artTT-tau));














