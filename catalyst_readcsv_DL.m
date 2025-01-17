% startup

clc
close all
clear variables
thispath = '/Users/spmic/data/CATALYST/DL_structs_gbperm_results/';
otherpath = '/Users/spmic/data/CATALYST//';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - Catalyst/DL_vols/'];

% read everything in

chp_vols_file = readtable(fullfile(thispath, 'report_mprage_chp_volumes.csv'));
pvs_vols_file = readtable(fullfile(thispath, 'report_pvs_volumes.csv'));

ergbperm_file = readtable(fullfile(otherpath, 'er_gbperm.xlsx'));
%%
% organise
%subjects = chp_vols_file.scan_id;

% actually take the TIV corrected data
total_vol = chp_vols_file.total_volume_prc_corrected;
right_vol = chp_vols_file.right_volume_prc_corrected;
left_vol = chp_vols_file.left_volume_prc_corrected;

total_vol_raw = chp_vols_file.total_volume_mm3;
right_vol_raw = chp_vols_file.volume_right_mm3;
left_vol_raw = chp_vols_file.volume_left_mm3;
% sort the above cause the order is whack

% [subjects_sorted,I] = sort(subjects);
% total_vol_sorted = total_vol(I);
% right_vol_sorted = right_vol(I);
% left_vol_sorted = left_vol(I);

% now we can just use this subject var cause it's already sorted
subjects = pvs_vols_file.scan_id;
total_vol_pvs = pvs_vols_file.total_volume_prc_corrected;
total_vol_pvs_raw = pvs_vols_file.total_volume_mm3;

% stack

Y = [total_vol; right_vol; left_vol];
Y_raw = [total_vol_raw; right_vol_raw; left_vol_raw];
X = cat(1,subjects, subjects, subjects);
colorGrp = [repmat({'total vol'},length(total_vol),1),...
    repmat({'right vol'},length(total_vol),1),...
    repmat({'left vol'},length(total_vol),1)];

Y_pvs = total_vol_pvs;
Y_pvs_raw = total_vol_pvs_raw;
X_pvs = subjects;
colorGrp_pvs = repmat({'total vol'},length(total_vol),1);


ermax = ergbperm_file.ERMaxMprage;
erstd = ergbperm_file.ERMaxStdevMprage;
ermax_irtse = ergbperm_file.ERMaxIrtse;
erstd_irtse = ergbperm_file.ERMaxIrtseStdev;

er_vals = [ermax; ermax_irtse];
er_vals_std = [erstd; erstd_irtse];
colorGrp_er = [repmat({'MPRAGE'},length(total_vol),1);...
    repmat({'IRTSE'},length(total_vol),1)];

gb_cbf_cp = ergbperm_file.CBFCP;
gb_cbf_wm = ergbperm_file.CBFWM;
gb_tbi_cp = ergbperm_file.TBICSFCP;
gb_tbi_wm = ergbperm_file.TBICSFWM;

gb_cbf = [gb_cbf_cp; gb_cbf_wm];
gb_tbi = [gb_tbi_cp; gb_tbi_wm];
X_tbi = cat(1,subjects, subjects);
colorGrp_gb = [repmat({'CP'},length(total_vol),1),...
    repmat({'WM'},length(total_vol),1)];





%% for now, let's just plot
%maxLim = 7000;
maxLim = 0.5;

thismap = [215,48,39;...
    253,184,99;...
    26,152,80;
    69,117,180];
thismap = thismap./256;

thismap2 = [26,152,80];
thismap2 = thismap2./256;



close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 1400 600])

g(1,1) = gramm('x',X,'y',Y,'color',colorGrp(:));
g(1,1).geom_bar("dodge",0.4,"width",0.5)
g(1,2) = gramm('x',X_pvs,'y',Y_pvs,'color',colorGrp_pvs);
g(1,2).geom_bar("dodge",0.4,"width",0.5)

g.set_text_options('font', thisFont, 'base_size', myfontsize)
g(1,1).set_names('x','Subject', 'y', 'CHP % fraction of intracranial space')
g(1,2).set_names('x','Subject', 'y', 'PVS % fraction of intracranial space')

%g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 maxLim])
g.set_point_options('base_size',10)
%g(1,1).no_legend()
g(1,1).set_color_options('map',thismap)
g(1,2).set_color_options('map',thismap2)

%g.set_order_options('x',0,'color',0)
g.draw()

% g(1,1).update('y',Y)
% g(1,1).geom_point("dodge",0); 
% g(1,2).update('y',Y_pvs)
% g(1,2).geom_point("dodge",0); 
% g.draw()

filename = 'plot_vols_DL_tiv_corrected';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% alos plot raw volumes

maxLim = 7000;


close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 1400 600])

g(1,1) = gramm('x',X,'y',Y_raw,'color',colorGrp(:));
g(1,1).geom_bar("dodge",0.4,"width",0.5)
g(1,2) = gramm('x',X_pvs,'y',Y_pvs_raw,'color',colorGrp_pvs);
g(1,2).geom_bar("dodge",0.4,"width",0.5)

g.set_text_options('font', thisFont, 'base_size', myfontsize)
g(1,1).set_names('x','Subject', 'y', 'CHP volume mm^3')
g(1,2).set_names('x','Subject', 'y', 'PVS volume mm^3')

%g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 maxLim])
g.set_point_options('base_size',10)
%g(1,1).no_legend()
g(1,1).set_color_options('map',thismap)
g(1,2).set_color_options('map',thismap2)

%g.set_order_options('x',0,'color',0)
g.draw()

filename = 'plot_vols_DL_raw';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% and Enhancemnet ratios
maxLim = 14;
close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 1000 600])

g = gramm('x',X_tbi,'y',er_vals,'color',colorGrp_er,'ymin', er_vals - er_vals_std, 'ymax', er_vals + er_vals_std);
g.geom_bar("dodge",0.4,"width",0.5)
g.geom_interval('geom', 'errorbar','dodge',0.4); % Add error bars


g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Subject', 'y', 'Enhancement Ratio')

%g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 maxLim])
g.set_point_options('base_size',10)
%g(1,1).no_legend()
g.set_color_options('map',thismap)

%g.set_order_options('x',0,'color',0)
g.draw()

allErrorBars = findall(g.facet_axes_handles, 'Type', 'Line', '-and', 'LineStyle', '-'); % Error bars are usually lines with no markers
set(allErrorBars, 'Color', 'k'); % Set their color to black


filename = 'ertse_plots';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% GBPerm values
maxLim = 100;
close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 1400 600])

g(1,1) = gramm('x',X_tbi,'y',gb_cbf,'color',colorGrp_gb);
g(1,1).geom_bar("dodge",0.4,"width",0.5)
g(1,2) = gramm('x',X_tbi,'y',gb_tbi,'color',colorGrp_gb);
g(1,2).geom_bar("dodge",0.4,"width",0.5)

g.set_text_options('font', thisFont, 'base_size', myfontsize)
g(1,1).set_names('x','Subject', 'y', 'CBF (ml/100g/min)')
g(1,2).set_names('x','Subject', 'y', 'Water exchange time blood -> CSF')

%g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 maxLim])
g.set_point_options('base_size',10)
%g(1,1).no_legend()
g(1,1).set_color_options('map',thismap)
g(1,2).set_color_options('map',thismap)

%g.set_order_options('x',0,'color',0)
g.draw()

filename = 'gbperm_eq_plot';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')






%% later, simulate BBB Permeability values for logistic regression
% rng(0,'twister');
% a = 40;
% b = 80;
% r = (b-a).*rand(9,1) + a;
% %BBB_permeability_simulate = r;
% 
% % actually for logistic regression, Y should be binary/categorical
% BBB_permeability_simulate = [0 1 0 0 1 1 1 0 1];
% X_log = total_vol_sorted;
% 
% % Assuming X and Y are column vectors of the same length
% mdl = fitglm(X_log, BBB_permeability_simulate, 'Distribution', 'binomial', 'Link', 'logit');
% 
% %% Display results
% disp(mdl);
% 
% disp(mdl.Coefficients);
% 
% % Generate a range of X values for prediction
% x_range = linspace(min(X_log), max(X_log), 100);
% 
% % Predict the probabilities using the logistic regression model
% predicted_probs = predict(mdl, x_range');
% 
% % Plot the original data and the fitted curve
% figure;
% hold on;
% 
% % Scatter plot of the original data
% scatter(X_log, BBB_permeability_simulate, 'b', 'filled', 'DisplayName', 'Data');
% 
% % Plot the fitted logistic regression curve
% plot(x_range, predicted_probs, 'r-', 'LineWidth', 2, 'DisplayName', 'Logistic Fit');
% 
% % Add labels and legend
% xlabel('BBB Permeability');
% ylabel('Probability of Severe EPVS');
% title('Logistic Regression: BBB Permeability vs EPVS Severity');
% legend('show');
% grid on;
% hold off;


%%

