% simulate curves from Ohene 2021

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
CBF = 70; % adult mice 191 mL/100g/min - for human brain 70 ml/100g/min

CBF=CBF/6000; %%convert to SI units


T1a = 1.9; %longitudinal relaxation of arterial blood (ms) at 9.4 T 2.4s human at 3.0 T = 1.9 s
R1a = 1/T1a;
R1app = 1/1.7; %seconds
tau = 1.7; % temporal length of tagged bolus seconds

% arrival time of the labeled bolus of blood water to imaging
% ROI, estimated using multi TI ASL acquisition
% At short TIs, ASL signal dM has linear dependence on TI
% dM = 0 when artTT > TI
artTT = 0.400; %typical 500ms to arrive
Moa = 1; % assume magnetization recovers to 1

inv_eff = 0.9; %inversion efficiency

TI_artTT = [0.2 0.3 0.4 0.5];
TE_artTT = 0.01;
TR_artTT = 10; % seconds

theTIs = [0.2 0.75 1.5 2.75 4 6.5];

A = 2.*inv_eff.*Moa.*(CBF/BB_lambda);

%% section 2.2
% equation 2
dM = A.*(theTIs-artTT).*exp(-theTIs./T1a); % when artTT < TI

dM(dM<0)=0; % to ensure below zero there is no negative dM (TI must be greater than artTT)

figure, scatter(theTIs,dM)
xlabel('TI (s)')
xticks(theTIs)
%xticklabels(theTIs)
ylabel('dM')
%
Mo = 1;

T1b = 2;

% equation 7
T1prime_reciprocal = 1/T1a + CBF/BB_lambda;
T1prime = 1/T1prime_reciprocal;

% equation 6
k = 1/T1b - 1/T1prime; %%% Need to fix this bit, something going wrong

% what if k is tiny and positive
%k = 0.00001;

% equation 4 & 5
q1 = exp(k.*theTIs).*exp(-k.*artTT)-(exp(-k.*theTIs)/k.*(theTIs-artTT));
q2 = exp(k.*theTIs).*exp(-k.*artTT)-(exp(-k.*(tau+artTT)/k.*tau));

%equation 3
dMb = 2.*Mo.*(theTIs-artTT).*inv_eff.*CBF.*(max(0,theTIs-artTT)/theTIs-artTT).*(exp(-theTIs.*R1a).*q1.*(min(0,theTIs-artTT-tau)/theTIs-artTT-tau)+2.*Mo.*tau.*inv_eff.*exp(-theTIs.*R1a).*q2.*(max(0,theTIs-artTT-tau)/theTIs-artTT-tau));


%figure, scatter(1:length(dMb),dMb)
figure, scatter(theTIs,dMb)
xlabel('TI (s)')
xticks(theTIs)
%xticklabels(theTIs)
ylabel('dMb')

%% section 2.3
tissueTT = 0.5; % GUESS
dR = R1app - R1a;
T2iv800 = 20.6; % ms
T2iv1500 = 14.3;
T2ev800 = 37.1;
T2ev1500 = 34.5;

T2iv = [T2iv800, T2iv1500];
T2ev = [T2ev800, T2ev1500];

% equation 10
dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));

% equation 11
dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);

%equation 9
IV_fraction = dMiv ./ (dMiv + dMev);

%equation 8
% NEED TO FIX DIMENSIONS HERE - fixed
dMc = zeros(6,10,2);
% dMiv has 6 vals, TE has 10 vals, T2 has 2 values
for T2_idx = 1:length(T2iv)
    for TE_idx = 1:length(TE)
        tmpVal = dMiv.*exp(-(TE(TE_idx)./T2iv(T2_idx))) + dMev.*exp(-(TE(TE_idx)./T2ev(T2_idx)));
        tmpVal = tmpVal(:)
        dMc(:,TE_idx,T2_idx) = tmpVal;
    end
    
end

%equation 12
% water exchange time Twex
% time for magnetically labeled vascular water to transfer across the BBB
% into brain tissue entering the imaging slice/
Twex = tissueTT - artTT;

% T2 1
figure
for ii = 1:10
plot(theTIs, dMc(:,ii, 1))
xlabel('TI (s)')
xticks(theTIs)
ylabel('dMc')

hold on
end


% T2 2
figure
for ii = 1:10
plot(theTIs, dMc(:,ii, 2))
xlabel('TI (s)')
xticks(theTIs)
ylabel('dMc')

hold on
end













