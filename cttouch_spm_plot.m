clear all
close all

mypath = '/Volumes/ares/PFS/3T_spm/cttouch/firstlevelmni/';

cd(mypath)

mylist = {'ct_0p3_s1.mat','ct_0p3_s2.mat','ct_0p3_ofc.mat',...
    'ct_0p3_insula.mat','ct_3_s1.mat','ct_3_s2.mat',...
    'ct_3_acc.mat','ct_30_s1.mat','ct_30_s2.mat','ct_30_ofc.mat'};

for ii = 1:length(mylist)

    thisCluster{ii} = load(mylist{ii});

end

%ct_0p3_s1
thisplot(:,1) = thisCluster{1}.ymean_102;
thisplot(:,2) = thisCluster{1}.ymean_186;
thisplot_a(:,1) = mean(thisplot,2);

%ct_3_s1
thisplot_a(:,2) = thisCluster{5}.ymean_286;

%ct_30_s1
thisplot_a(:,3) = thisCluster{8}.ymean_262;

%ct_0p3_s2
thisplot(:,1) = thisCluster{2}.ymean_283;
thisplot(:,2) = thisCluster{2}.ymean_44;
thisplot(:,3) = thisCluster{2}.ymean_63;
thisplot_a(:,4) = mean(thisplot,2);

%ct_3_s2.mat
thisplot_a(:,5) = thisCluster{6}.ymean_136;

%ct_30_s2.mat
thisplot_a(:,6) = thisCluster{9}.ymean_346;

% ct_0p3_ofc
thisplot(:,1) = thisCluster{3}.ymean_23;
thisplot(:,2) = thisCluster{3}.ymean_30;
thisplot(:,3) = thisCluster{3}.ymean_35;
thisplot_a(:,7) = mean(thisplot,2);

% ct_0p3_insula
thisplot(:,1) = thisCluster{4}.ymean_24;
thisplot(:,2) = thisCluster{4}.ymean_29;
thisplot(:,3) = thisCluster{4}.ymean_67;
thisplot_a(:,8) = mean(thisplot,2);

%ct_3_acc.mat
thisplot_a(:,9) = thisCluster{7}.ymean_88;

%ct_30_ofc
thisplot(:,1) = thisCluster{10}.ymean_19;
thisplot(:,2) = thisCluster{10}.ymean_40;
thisplot_a(:,10) = mean(thisplot,2);

%

% myrates = {'0p3','3','30','0p3','3','30','0p3','0p3','3','30'};
% myregions = {'s1','s1','s1','s2','s2','s2','ofc','insula','acc','ofc'};

% rateStack = cell(size(thisplot_a,1),length(myrates));
% regionStack = cell(size(thisplot_a,1),length(myrates));
% 
% 
% for ii = 1:length(myrates)
%     rateStack(:,ii) = repmat(myrates(ii),size(thisplot_a,1),1);
%     regionStack(:,ii) = repmat(myregions(ii),size(thisplot_a,1),1);
% end
% 
% rateStack_vert = rateStack(:);
% regionStack_vert = regionStack(:);
% thisplot_a_vert = thisplot_a(:);
% 
% clear g
% figure
% g = gramm('x',rateStack_vert,'y',thisplot_a_vert);
% g.stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
% g.draw
% g.update('y',thisplot_a_vert,'color',regionStack_vert)
% g.geom_jitter('dodge',0.5)
% g.set_text_options('Font','Helvetica', 'base_size', 16)
% g.set_point_options('base_size',12)
% g.draw


thisplot_a_s1 = thisplot_a(:,1:3);
thisplot_a_s1_vert = thisplot_a_s1(:);
myrates_s1 = [repmat({'0p3'},size(thisplot_a,1),1); repmat({'3'},size(thisplot_a,1),1); repmat({'30'},size(thisplot_a,1),1)];

thisplot_a_s2 = thisplot_a(:,4:6);
thisplot_a_s2_vert = thisplot_a_s2(:);
myrates_s2 = myrates_s1;

thisplot_a_ofc = [thisplot_a(:,7), thisplot_a(:,10)];
thisplot_a_ofc_vert = thisplot_a_ofc(:);
myrates_ofc = [repmat({'0p3'},size(thisplot_a,1),1); repmat({'30'},size(thisplot_a,1),1)];

thisplot_a_insula = thisplot_a(:,8);
thisplot_a_insula_vert = thisplot_a_insula(:);
myrates_insula = repmat({'0p3'},size(thisplot_a,1),1);

thisplot_a_acc = thisplot_a(:,9);
thisplot_a_acc_vert = thisplot_a_acc(:);
myrates_acc = repmat({'0p3'},size(thisplot_a,1),1);

clear g
figure('Position',[100 100 1024 768])
g(1,1) = gramm('x',myrates_s1,'y',thisplot_a_s1_vert);
g(1,1).stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(1,1).set_title('S1')
g(1,1).set_text_options('Font','Helvetica', 'base_size', 16)
g(1,1).set_point_options('base_size',12)
g(1,1).set_names('x','rate (cm/s)','y', 'Y')

g(1,2) = gramm('x',myrates_s2,'y',thisplot_a_s2_vert);
g(1,2).stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(1,2).set_title('S2')
g(1,2).set_text_options('Font','Helvetica', 'base_size', 16)
g(1,2).set_point_options('base_size',12)
g(1,2).set_names('x','rate (cm/s)','y', 'Y')

g(1,3) = gramm('x',myrates_ofc,'y',thisplot_a_ofc_vert);
g(1,3).stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(1,3).set_title('OFC')
g(1,3).set_text_options('Font','Helvetica', 'base_size', 16)
g(1,3).set_point_options('base_size',12)
g(1,3).set_names('x','rate (cm/s)','y', 'Y')

g(2,1) = gramm('x',myrates_insula,'y',thisplot_a_insula_vert);
g(2,1).stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(2,1).set_title('Insula')
g(2,1).set_text_options('Font','Helvetica', 'base_size', 16)
g(2,1).set_point_options('base_size',12)
g(2,1).set_names('x','rate (cm/s)','y', 'Y')

g(2,2) = gramm('x',myrates_acc,'y',thisplot_a_acc_vert);
g(2,2).stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(2,2).set_title('ACC')
g(2,2).set_text_options('Font','Helvetica', 'base_size', 16)
g(2,2).set_point_options('base_size',12)
g(2,2).set_names('x','rate (cm/s)','y', 'Y')

g.draw()

heightparam = 0.2;
widthparam = 0.2;
g(1,1).update('y',thisplot_a_s1_vert)
g(1,1).geom_jitter('height',heightparam,'width',widthparam)

g(1,2).update('y',thisplot_a_s2_vert)
g(1,2).geom_jitter('height',heightparam,'width',widthparam)

g(1,3).update('y',thisplot_a_ofc_vert)
g(1,3).geom_jitter('height',heightparam,'width',widthparam)

g(2,1).update('y',thisplot_a_insula_vert)
g(2,1).geom_jitter('height',heightparam,'width',widthparam)

g(2,2).update('y',thisplot_a_acc_vert)
g(2,2).geom_jitter('height',heightparam,'width',widthparam)

g.draw()

filename = 'cttouch_rates';
g.export('file_name',filename, ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Pain Relief Grant - General/PFP_results/',...
    'file_type','pdf')






















