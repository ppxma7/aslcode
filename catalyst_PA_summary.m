cd('/Volumes/nemosine/CATALYST_BCSFB/');
load('catalyst_v1_fits.mat')

% ygroup are raw
% each row is a IT
% each column is
% y = pixR(:,ii);
% y2 = pixL(:,ii);
% y3 = pixcsfl(:,ii);
% y4 = pixcsfr(:,ii);
% each 3rd dim is a subject

% same for fgroup but they are fits.

% get mean and std across groups
x = [1000 2000 3000 4000]';

meany = mean(ygroup,3);
stdy = std(ygroup,0,3);

meanf = mean(fgroup,3);
stdf = std(fgroup,0,3);

figure
tiledlayout(2,2)
for iCol = 1:4
    nexttile
    shadedErrorBar(x,meany(:,iCol),stdy(:,iCol),'lineprops','-o')
    ylim([0.2 0.7])
    hold on
    
    shadedErrorBar(x,meanf(:,iCol),stdf(:,iCol),'lineprops','-ro')
    ylim([0.2 0.7])

    

end





