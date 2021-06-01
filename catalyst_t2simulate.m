% simulate a curve


t = [20 30 40 50 60 70 80 90 100 150 200 250 300 350 400];


T2short = 40;
T2long = 200;

simk = 0.9;
simk2 = 1-simk;

ymono = simk.*exp(-t/T2short); % monoexp curve
ybi = simk.*exp(-t/T2short) + simk2.*exp(-t/T2long); %biexp curve

% add noise snr 50:1 or 20:1
hmnoise = 1./50;

outmono = ymono + hmnoise*rand(size(t));
outbi = ybi + hmnoise*rand(size(t));
    % 
figure
scatter(t,ymono,'ko')
hold on
scatter(t,ybi,'ro')
legend([{'Monoexp'},{'Biexp'}])
% ylim([0 20000])

%%

% 1000 times fits / loop / mean of the fits + variance
% grab mean of variance of x1 and x2
% effect of sampling times on accuracy of fits.
% figure out ideal number of time points


opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','Display','off');

% bootstrap this x1000
myboot = 1000;

F = @(x,xdata) x(1)*exp(-xdata/x(2)) + x(3); % MONOEXP
F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP
x0 = [0.8 45 0.05];
x02 = [0.8 45 190 0.05 ];

x1 = zeros(1000,3);
x2 = zeros(1000,4);

outmono = zeros(1000,length(t));
outbi = zeros(1000,length(t));


% 6 seconds
tic
for ii = 1:myboot
    
    outmono(ii,:,:) = ymono + hmnoise*rand(size(t));
    outbi(ii,:,:) = ybi + hmnoise*rand(size(t));
    
    [x1(ii,:,:),resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,outmono(ii,:,:),[],[],opts);
    [x2(ii,:,:),resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x02,t,outbi(ii,:,:),[],[],opts);
    
    
end
toc

%%


mymeansmo = mean(x1);
mymeansbi = mean(x2);
myvarmo = var(x1);
myvarbi = var(x2);

%%
randplot = 500;
figure
%for ii = 1:1000
scatter(t,outmono(randplot,:,:),'ko')
%xticks(t)
hold on
scatter(t,outbi(randplot,:,:),'ro')
%end

%
plot(t,F(x1(randplot,:,:),t),'-k','Linewidth',2)
plot(t,F2(x2(randplot,:,:),t),'-r','Linewidth',2)

xlabel('TE (ms)')
ylabel('M')
legend([{'Mono Data'},{'Bi Data'},{'Mono Fit'},{'Bi Fit'}])

%ylim([0 20000])


%%
% Try simulating mono and bi, and try fitting to each in turn
% biexp should go to 0 if it's a mono curve








%%


% yfittedbi = x2(1).*exp(-t/T2short)+(1-x2(2)).*exp(-t/T2long +x2(3));
% 
% figure, scatter(t,y)
% hold on
% plot(t,yfittedbi)




