% simulate a curve


t = [20 30 40 50 60 70 80 90 100 150 200 250 300 350 400];

% y = [20000 11000 8000 7000 6000];
% ymo = [20000 14000 10000 8000 7000];

% %y = [20000 14000 11000 8000 6400 5800 5200 4400 4000 3000 2200 2000 2000 1800 1900];
%y = [20000 18000 16000 14000 13000 12000 11000 10500 9500 7500 6000 5000 5000 4000 3800];
% 

% y = [20000 18000 16000 14000,....
%     12500 10000 8000 7000,...
%     6000 4000 3000 2000,...
%     1000 500 0];

y = [20000 17000 14000 12000,....
    10000 8000 6000 4000,...
    3400 1600 1000 400,...
    100 50 0];


opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','Display','off');

% figure, scatter(x,ymo)
% hold on
% scatter(x,ybi)

T2short = 40;
T2long = 200;

F = @(x,xdata) x(1)*exp(-xdata/T2short) +x(3); 
F2 = @(x,xdata) x(1).*exp(-xdata/T2short)+(1-x(2)).*exp(-xdata/T2long +x(3));

x0 = [0 10000 0 25000 0];
%x0 = [20 50000 ];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts)
[x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x0,t,y,[],[],opts)


figure
plot(t,y,'ro')
%xticks(t)
hold on
plot(t,F(x,t),'-b','Linewidth',2)
plot(t,F2(x2,t),'--m','Linewidth',2)
xlabel('TE (ms)')
ylabel('M')
legend([{'Data'},{'Monoexp'},{'Biexp'}])

ylim([0 20000])

