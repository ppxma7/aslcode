cd('/Volumes/ares/CATALYST/');
load('catfitsv1.mat')

% ygroup are raw
% each row is a IT
% each column is
% y = pixR(:,ii);
% y2 = pixL(:,ii);
% y3 = pixcsfl(:,ii);
% y4 = pixcsfr(:,ii);
% each 3rd dim is a subject

% same for fgroup but they are fits.
%%
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Michael_Sue - Catalyst/patient_data/'];

% get mean and std across groups
x = [1000 2000 3000 4000]';

meany = mean(ygroup,3);
stdy = std(ygroup,0,3);

meanf = mean(fgroup,3);
stdf = std(fgroup,0,3);

names = {'CP Right','CP Left', 'CSF Left','CSF Right'};

figure('Position',[100 100 800 600])
tiledlayout(2,2)
for iCol = 1:4
    nexttile
    shadedErrorBar(x,meany(:,iCol),stdy(:,iCol),'lineprops','-o')
    ylim([0.2 0.7])
    hold on
    
    shadedErrorBar(x,meanf(:,iCol),stdf(:,iCol),'lineprops','-ro')
    ylim([0.2 0.7])

    title(names{iCol})
    legend([{'Fit'},{'Y'}],...
        'Location','bestoutside','NumColumns',1)


end

filename2 = fullfile(savedir, 'fit-GBPERM-summary.pdf');
set(gcf, 'PaperOrientation', 'landscape');
print(gcf, filename2, '-dpdf', '-r300', '-bestfit');




