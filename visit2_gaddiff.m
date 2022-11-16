clear variables
close all
clc

mypath = '/Volumes/nemosine/CATALYST_BCSFB/';
cd(mypath)


subs = {'220202_GBPERM_01_v2','220209_GBPERM_02_v2','220323_GBPERM_03_v2',...
    '220223_GBPERM_04_v2','220308_GBPERM_06_v2','220414_GBPERM_07_v2',...
    '220509_GBPERM_08_v2','220531_GBPERM_09_v2','220531_GBPERM_10_v2'};

v1subs = {'220126_GBPERM_01_v1','220208_GBPERM_02_v1','220216_GBPERM_03_v1',...
    '220222_GBPERM_04_v1','220311_GBPERM_06_v1','220407_GBPERM_07_v1',...
    '220408_GBPERM_08_v1','220518_GBPERM_09_v1','220530_GBPERM_10_v1'};
%subs = {'220509_GBPERM_08_v2'};
%v1subs = {'220408_GBPERM_08_v1'}; 

subnames = {'sub01','sub02','sub03','sub04','sub06','sub07','sub08','sub09','sub10'};

%subnames = {'sub08'};

datasetsa = {'f_220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_43.nii',...
    'f_220209_GBPERM_02_v2_MPRAGE_850ms_OPTS2_5_20220209125931_42.nii',...
    'f_GBPERM_03_v2_MPRAGE_850ms_OPTS2_5_20220223121541_45.nii',...
    'f_GBPERM_04_v2_MPRAGE_850ms_OPTS2_5_20220223100844_45.nii',...
    'f_GBPERM_06_v2_MPRAGE_850ms_OPTS2_5_20220308152457_44.nii',...
    'f_220414_GBPERM_07_v2_MPRAGE_850ms_OPTS2_5_20220414102456_45.nii',...
    'rmprage45.nii',...
    'f_220531_GBPERM_09_v2_MPRAGE_850ms_OPTS2_5_20220531085651_46.nii',...
    'f_220531_GBPERM_10_v2_MPRAGE_850ms_OPTS2_5_20220531110348_46.nii'};
%datasetsa = {'rmprage45_thr.nii'};

datasetsb =  {'f_r220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_51.nii',...
    'f_r220209_GBPERM_02_v2_MPRAGE_850ms_OPTS2_5_20220209125931_50.nii',...
    'f_rGBPERM_03_v2_MPRAGE_850ms_OPTS2_5_20220223121541_54.nii',...
    'f_rGBPERM_04_v2_MPRAGE_850ms_OPTS2_5_20220223100844_53.nii',...
    'f_rGBPERM_06_v2_MPRAGE_850ms_OPTS2_5_20220308152457_53.nii',...
    'f_r220414_GBPERM_07_v2_MPRAGE_850ms_OPTS2_5_20220414102456_54.nii',...
    'rmprage52.nii',...
    'f_r220531_GBPERM_09_v2_MPRAGE_850ms_OPTS2_5_20220531085651_54.nii',...
    'f_r220531_GBPERM_10_v2_MPRAGE_850ms_OPTS2_5_20220531110348_58.nii'};
%datasetsb = {'rmprage52_thr.nii'};

datasetsd = {'f_220202_GBPERM_01_v2_IR_TSE_700mm_1mm_OPTS_2_20220202095131_42.nii',...
    'f_220209_GBPERM_02_v2_IR_TSE_700mm_1mm_OPTS_2_20220209125931_41.nii',...
    'f_GBPERM_03_v2_IR_TSE_700mm_1mm_OPTS_2_20220223121541_44.nii',...
    'f_GBPERM_04_v2_IR_TSE_700mm_1mm_OPTS_2_20220223100844_44.nii',...
    'f_GBPERM_06_v2_IR_TSE_700mm_1mm_OPTS_2_20220308152457_43.nii',...
    'f_220414_GBPERM_07_v2_IR_TSE_700mm_1mm_OPTS_2_20220414102456_44.nii',...
    'rirtse44.nii',...
    'f_220531_GBPERM_09_v2_IR_TSE_700mm_1mm_OPTS_2_20220531085651_45.nii',...
    'f_220531_GBPERM_10_v2_IR_TSE_700mm_1mm_OPTS_2_20220531110348_45.nii'};
%datasetsd = {'rirtse44.nii'};

datasetse =  {'f_r220202_GBPERM_01_v2_IR_TSE_700mm_1mm_OPTS_2_20220202095131_50.nii',...
    'f_r220209_GBPERM_02_v2_IR_TSE_700mm_1mm_OPTS_2_20220209125931_49.nii',...
    'f_rGBPERM_03_v2_IR_TSE_700mm_1mm_OPTS_2_20220223121541_53.nii',...
    'f_rGBPERM_04_v2_IR_TSE_700mm_1mm_OPTS_2_20220223100844_52.nii',...
    'f_rGBPERM_06_v2_IR_TSE_700mm_1mm_OPTS_2_20220308152457_52.nii',...
    'f_r220414_GBPERM_07_v2_IR_TSE_700mm_1mm_OPTS_2_20220414102456_53.nii',...
    'rirtse53.nii',...
    'f_r220531_GBPERM_09_v2_IR_TSE_700mm_1mm_OPTS_2_20220531085651_53.nii',...
    'f_r220531_GBPERM_10_v2_IR_TSE_700mm_1mm_OPTS_2_20220531110348_54.nii'};
%datasetse = {'rirtse53.nii'};


% ppt stuff

import mlreportgen.ppt.*;
ppt_path = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - Catalyst/visit2_ppts/';
cd(ppt_path)
ppt = Presentation('V2maps.pptx'); %ppt_path,
open(ppt);
slide1 = add(ppt,'Title Slide');
replace(slide1,'Title','V2 Gad');
replace(slide1,'Subtitle','Michael Asghar');

spacing = 2; % for tight_tile()


%%
tic
for ii = 1:length(subs)
    disp([subnames{ii}]);
    
    
    mp1 = [mypath subs{ii} '/analysis/' datasetsa{ii}];
    mp2 = [mypath subs{ii} '/analysis/' datasetsb{ii}];
   
    
    V_MP1 = load_untouch_nii(mp1);
    V_MP2 = load_untouch_nii(mp2);
    
    img_data_vmp1 = double(V_MP1.img);
    img_data_vmp2 = double(V_MP2.img);
    
    if strcmpi(subnames{ii},'sub08')
        img_data_vmp1 = normalize(img_data_vmp1,'range',[0 350]);
        img_data_vmp2 = normalize(img_data_vmp2,'range',[0 350]);
    end

    v1name = extractBefore(datasetsa{ii},'.');
    v2name = extractBefore(datasetsb{ii},'.');

    
    close all
    tight_tile(img_data_vmp1,'gray',0,250,1,[50:60]);
    v1_fig = [ppt_path subnames{ii} '/', v1name,'_tiled.png'];
    saveas(gcf,v1_fig)
    
    
    tight_tile(img_data_vmp2,'gray',0,250,1,[50:60]);
    v2_fig = [ppt_path subnames{ii} '/', v2name,'_tiled.png'];
    saveas(gcf,v2_fig)
    t1fig_position = get(gcf,'position');
    
    img_data_vmp1_vec = img_data_vmp1(:);
    img_data_vmp1_vec(img_data_vmp1_vec==0) = NaN;
    
    img_data_vmp2_vec = img_data_vmp2(:);
    img_data_vmp2_vec(img_data_vmp2_vec==0) = NaN;
    
    %% load masks
    % instead of a diff, we can divide by a WM mask to get the enhancement
    % ratio
    %wm_mask = [mypath v1subs{ii} '/structurals/wm/FLAIRBET_seg_1.nii.gz'];
    % this is a big ROI, from FAST segmentation
    
    wm_mask = [mypath v1subs{ii} '/structurals/wm/wm_mask_bin.nii.gz']; % this is a manually drawn small ROI
    
    wm_mask_x = load_untouch_nii(wm_mask);
    wm_mask_xy = double(wm_mask_x.img);
    wm_mask_name = 'WM_mask';
    wm_mask_v = wm_mask_xy(:);
    wm_mask_v_bin = logical(wm_mask_v);
    
    % need a mask of the ROIs
    maskdata_R = [mypath v1subs{ii} '/structurals/right_roi_mask_flo.nii'];
    maskdata_L = [mypath v1subs{ii} '/structurals/left_roi_mask_flo.nii'];
    
    maskdata_Rx = load_untouch_nii(maskdata_R);
    maskdata_Lx = load_untouch_nii(maskdata_L);
    
    maskdata_Rxy = double(maskdata_Rx.img);
    maskdata_Lxy = double(maskdata_Lx.img);
    
    maskdata_R_name = 'right_mask';
    maskdata_L_name = 'left_mask';
    
    maskdata_Rv = maskdata_Rxy(:);
    maskdata_RV_bin = logical(maskdata_Rv);
    
    maskdata_Lv = maskdata_Lxy(:);
    maskdata_LV_bin = logical(maskdata_Lv);
    
    maskdata = maskdata_Rv+maskdata_Lv;
    maskdata_bin = logical(maskdata);
    
    %%

    %thediff = (img_data_vmp2_vec-img_data_vmp1_vec ./ img_data_vmp1_vec).*100;
    thediff = img_data_vmp2_vec-img_data_vmp1_vec;
    thediff(thediff==0)= NaN;
    
    %thediff_enhanced = thediff.*wm_mask_v_bin;
    %thediff_enhanced(thediff_enhanced==0)= NaN;
    
    %enhanceR = thediff./thediff_enhanced;
    %enhanceR_rs = reshape(enhanceR,size(img_data_vmp1,1),size(img_data_vmp1,2),size(img_data_vmp1,3));
    
    % explicit here for sanity
    change = thediff./img_data_vmp1_vec;
    change(change==0)= NaN;
    prc_change = change.*100;
    
    % back to 3D data for tight_tile()
    thediff_rs = reshape(prc_change,size(img_data_vmp1,1),size(img_data_vmp1,2),size(img_data_vmp1,3));
    
    % extra varargin for loading an overlay
    % overlay the difference map on the mprage
    tight_tile(img_data_vmp1,'gray',0,250,1,[50:60],thediff_rs,[-100 1000]);
    diff_fig = [ppt_path subnames{ii} '/mprage_diff_fig_tiled.png'];
    saveas(gcf,diff_fig)
    
    outfile = [mypath subs{ii} '/analysis/' subnames{ii} '_mprage_gaddiff.nii'];
    thisguy = make_nii(thediff_rs);
    thisguy.hdr.hist = V_MP1.hdr.hist;
    save_nii(thisguy,outfile);
    
    

    % here we mask for histograms/ ER
    % mask for L R CP masks
    img_v1_bin_R = img_data_vmp1_vec.*maskdata_RV_bin;
    img_v2_bin_R = img_data_vmp2_vec.*maskdata_RV_bin;
    prc_change_bin_R = prc_change.*maskdata_RV_bin;
    
    img_v1_bin_L = img_data_vmp1_vec.*maskdata_LV_bin;
    img_v2_bin_L = img_data_vmp2_vec.*maskdata_LV_bin;
    prc_change_bin_L = prc_change.*maskdata_LV_bin;
    
    % just one bilateral WM mask here
    img_v2_bin_wm = img_data_vmp2_vec.*wm_mask_v_bin;
    d = img_v2_bin_wm(~isnan(img_v2_bin_wm));
    d0 = d(d~=0);
    
    % clean nans and 0s
    a_R = img_v1_bin_R(~isnan(img_v1_bin_R));
    a0_R = a_R(a_R~=0);
    b_R = img_v2_bin_R(~isnan(img_v2_bin_R));
    b0_R = b_R(b_R~=0);
    c_R = prc_change_bin_R(~isnan(prc_change_bin_R));
    c0_R = c_R(c_R~=0);
    
    a_L = img_v1_bin_L(~isnan(img_v1_bin_L));
    a0_L = a_L(a_L~=0);
    b_L = img_v2_bin_L(~isnan(img_v2_bin_L));
    b0_L = b_L(b_L~=0);
    c_L = prc_change_bin_L(~isnan(prc_change_bin_L));
    c0_L = c_L(c_L~=0);
    

    %brightest part of CP ./ mean of WM
    ER_R(ii) = max(b0_R)./mean(d0);
    ER_R_mean(ii) = mean(b0_R)./mean(d0);
    ER_R_mode(ii) = mode(b0_R)./mean(d0);
    ER_L(ii) = max(b0_L)./mean(d0);
    ER_L_mean(ii) = mean(b0_L)./mean(d0);
    ER_L_mode(ii) = mode(b0_L)./mean(d0);
    
    ER_LR_mn(ii) = mean([ER_R, ER_L]); % mean of the max's for L and R
    ER_LR_se(ii) = std([ER_R; ER_L],0,1) ./ sqrt(2); % std error of above
    
    
    
    % histogram of differences
    figure('Position',[100 100 1200 500])
    tiledlayout(1,2)
    nexttile
    edges = linspace(0, 500, 10);
    [v1values, ~] = histcounts(a0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v1values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    text(100,100,['mode v1 ' num2str(mode(a0_R))]);
    hold on
    [v2values, ~] = histcounts(b0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v2values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    legend('V1','V2','Location','best');
    ylabel('Count'); xlabel('Intensity (au)');
    text(100,110,['mode v2 ' num2str(mode(b0_R))]);   
    ylim([0 200])
    nexttile
    edges = linspace(-100, 1000, 20);
    [diffvalues, ~] = histcounts(c0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, diffvalues, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('% change');
    text(0,100,['mean prc diff ' num2str(mean(c0_R))]);
    ylim([0 200])
    comp_histogram_R = [ppt_path subnames{ii} '/R_hist_tiled.png'];
    saveas(gcf,comp_histogram_R)
    Rhistfig_position = get(gcf,'position');
    
    figure('Position',[100 100 1200 500])
    tiledlayout(1,2)
    nexttile
    edges = linspace(0, 500, 10);
    [v1values, ~] = histcounts(a0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v1values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    text(100,100,['mode v1 ' num2str(mode(a0_L))]);
    hold on
    [v2values, ~] = histcounts(b0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v2values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    legend('V1','V2','Location','best');
    ylabel('Count'); xlabel('Intensity (au)');
    text(100,110,['mode v2 ' num2str(mode(b0_L))]);   
    ylim([0 200])
    nexttile
    edges = linspace(-100, 1000, 20);
    [diffvalues, ~] = histcounts(c0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, diffvalues, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('% change');
    text(0,100,['mean prc diff ' num2str(mean(c0_L))]);
    ylim([0 200])
    comp_histogram_L = [ppt_path subnames{ii} '/L_hist_tiled.png'];
    saveas(gcf,comp_histogram_L)
    Lhistfig_position = get(gcf,'position');
    
    

    

    
    %% ir tse
    
%     mp1 = [mypath subs{ii} '/analysis/' datasetsd{ii}];
%     mp2 = [mypath subs{ii} '/analysis/' datasetse{ii}];
%     
%     outfile = [mypath subs{ii} '/analysis/' subnames{ii} '_mprage_irtse.nii'];


    mp1 = [mypath subs{ii} '/analysis/' datasetsd{ii}];
    mp2 = [mypath subs{ii} '/analysis/' datasetse{ii}];
   
    
    V_MP1 = load_untouch_nii(mp1);
    V_MP2 = load_untouch_nii(mp2);
    
    img_data_vmp1 = double(V_MP1.img);
    img_data_vmp2 = double(V_MP2.img);

    v1name = extractBefore(datasetsd{ii},'.');
    v2name = extractBefore(datasetse{ii},'.');

    
    close all
    tight_tile(img_data_vmp1,'gray',0,250,1,[50:60]);
    v1_figt = [ppt_path subnames{ii} '/', v1name,'_tiled.png'];
    saveas(gcf,v1_figt)
    
    
    tight_tile(img_data_vmp2,'gray',0,250,1,[50:60]);
    v2_figt = [ppt_path subnames{ii} '/', v2name,'_tiled.png'];
    saveas(gcf,v2_figt)
    t1fig_position = get(gcf,'position');
    
    img_data_vmp1_vec = img_data_vmp1(:);
    img_data_vmp1_vec(img_data_vmp1_vec==0) = NaN;
    
    img_data_vmp2_vec = img_data_vmp2(:);
    img_data_vmp2_vec(img_data_vmp2_vec==0) = NaN;
    
    %thediff = (img_data_vmp2_vec-img_data_vmp1_vec ./ img_data_vmp1_vec).*100;
    thediff = img_data_vmp2_vec-img_data_vmp1_vec;
    thediff(thediff==0)= NaN;
    thediff = abs(thediff);
    
    % explicit here for sanity
    change = thediff./img_data_vmp1_vec;
    change(change==0)= NaN;
    prc_change = change.*100;
    
    % back to 3D data for tight_tile()
    %thediff_rs = reshape(prc_change,size(img_data_vmp1,1),size(img_data_vmp1,2),size(img_data_vmp1,3));
    
    thediff_rs = reshape(thediff,size(img_data_vmp1,1),size(img_data_vmp1,2),size(img_data_vmp1,3));
    
    % extra varargin for loading an overlay
    tight_tile(img_data_vmp1,'gray',0,250,1,[50:60],thediff_rs,[0 100]);
    diff_figt = [ppt_path subnames{ii} '/irtse_diff_fig_tiled.png'];
    saveas(gcf,diff_figt)
    outfile = [mypath subs{ii} '/analysis/' subnames{ii} '_irtse_gaddiff.nii'];    %info_t1 = make_ana(thediff_range_prc_img);
    thisguy = make_nii(thediff_rs);
    thisguy.hdr.hist = V_MP1.hdr.hist;
    save_nii(thisguy,outfile);
    
    
    
    img_v1_bin_R = img_data_vmp1_vec.*maskdata_RV_bin;
    img_v2_bin_R = img_data_vmp2_vec.*maskdata_RV_bin;
    prc_change_bin_R = prc_change.*maskdata_RV_bin;
    
    img_v1_bin_L = img_data_vmp1_vec.*maskdata_LV_bin;
    img_v2_bin_L = img_data_vmp2_vec.*maskdata_LV_bin;
    prc_change_bin_L = prc_change.*maskdata_LV_bin;
    
    % just one bilateral WM mask here
    img_v2_bin_wm = img_data_vmp2_vec.*wm_mask_v_bin;
    d = img_v2_bin_wm(~isnan(img_v2_bin_wm));
    d0 = d(d~=0);
    
    % clean nans and 0s
    a_R = img_v1_bin_R(~isnan(img_v1_bin_R));
    a0_R = a_R(a_R~=0);
    b_R = img_v2_bin_R(~isnan(img_v2_bin_R));
    b0_R = b_R(b_R~=0);
    c_R = prc_change_bin_R(~isnan(prc_change_bin_R));
    c0_R = c_R(c_R~=0);
    
    a_L = img_v1_bin_L(~isnan(img_v1_bin_L));
    a0_L = a_L(a_L~=0);
    b_L = img_v2_bin_L(~isnan(img_v2_bin_L));
    b0_L = b_L(b_L~=0);
    c_L = prc_change_bin_L(~isnan(prc_change_bin_L));
    c0_L = c_L(c_L~=0);
    

    %brightest part of CP ./ mean of WM
    ER_R_irtse(ii) = max(b0_R)./mean(d0);
    ER_R_mean_irtse(ii) = mean(b0_R)./mean(d0);
    ER_R_mode_irtse(ii) = mode(b0_R)./mean(d0);
    ER_L_irtse(ii) = max(b0_L)./mean(d0);
    ER_L_mean_irtse(ii) = mean(b0_L)./mean(d0);
    ER_L_mode_irtse(ii) = mode(b0_L)./mean(d0);
    
    ER_LR_mn_irtse(ii) = mean([ER_R_irtse, ER_L_irtse]); % mean of the max's for L and R
    ER_LR_se_irtse(ii) = std([ER_R_irtse; ER_L_irtse],0,1) ./ sqrt(2); % std error of above
    
    
    % histogram of differences
    figure('Position',[100 100 1200 500])
    tiledlayout(1,2)
    nexttile
    edges = linspace(0, 500, 10);
    [v1values, ~] = histcounts(a0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v1values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    text(100,100,['mode v1 ' num2str(mode(a0_R))]);
    hold on
    [v2values, ~] = histcounts(b0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v2values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    legend('V1','V2','Location','best');
    ylabel('Count'); xlabel('Intensity (au)');
    text(100,110,['mode v2 ' num2str(mode(b0_R))]); 
    ylim([0 200])
    nexttile
    edges = linspace(-100, 1000, 20);
    [diffvalues, ~] = histcounts(c0_R,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, diffvalues, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('% change');
    text(0,100,['mean prc diff ' num2str(mean(c0_R))]);
    ylim([0 200])
    comp_histogram_R = [ppt_path subnames{ii} '/irtse_R_hist_tiled.png'];
    saveas(gcf,comp_histogram_R)
    Rhistfig_position = get(gcf,'position');
    
    figure('Position',[100 100 1200 500])
    tiledlayout(1,2)
    nexttile
    edges = linspace(0, 500, 10);
    [v1values, ~] = histcounts(a0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v1values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    text(100,100,['mode v1 ' num2str(mode(a0_L))]);
    hold on
    [v2values, ~] = histcounts(b0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, v2values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    legend('V1','V2','Location','best');
    ylabel('Count'); xlabel('Intensity (au)');
    text(100,110,['mode v2 ' num2str(mode(b0_L))]);
    ylim([0 200])
    nexttile
    edges = linspace(-100, 1000, 20);
    [diffvalues, ~] = histcounts(c0_L,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, diffvalues, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('% change');
    text(0,100,['mean prc diff ' num2str(mean(c0_L))]);
    ylim([0 200])
    comp_histogram_L = [ppt_path subnames{ii} '/irtse_L_hist_tiled.png'];
    saveas(gcf,comp_histogram_L)
    Lhistfig_position = get(gcf,'position');
    


    

%% ppt
%Create Powerpoint Slides for each subject
    mp_gad_v1 = Picture(v1_fig);
    mp_gad_v1.Width = num2str(1.4*t1fig_position(3)); mp_gad_v1.Height = num2str(1.4*t1fig_position(4));
    mp_gad_v1.X = '0'; mp_gad_v1.Y = '140';
    pictureSlide = add(ppt,'Title Only');
    replace(pictureSlide,'Title',[subnames{ii}, ' Visit 1']);
    add(pictureSlide,mp_gad_v1);
    

    mp_gad_v2 = Picture(v2_fig);
    mp_gad_v2.Width = num2str(1.4*t1fig_position(3)); mp_gad_v2.Height = num2str(1.4*t1fig_position(4));
    mp_gad_v2.X = '0'; mp_gad_v2.Y = '140';
    pictureSlide2 = add(ppt,'Title Only');
    replace(pictureSlide2,'Title',[subnames{ii}, ' Visit 2']);
    add(pictureSlide2,mp_gad_v2);
    

    mp_gad_diff = Picture(diff_fig);
    mp_gad_diff.Width = num2str(1.4*t1fig_position(3)); mp_gad_diff.Height = num2str(1.4*t1fig_position(4));
    mp_gad_diff.X = '0'; mp_gad_diff.Y = '140';
    pictureSlide3 = add(ppt,'Title Only');
    replace(pictureSlide3,'Title',[subnames{ii}, ' percentage difference']);
    add(pictureSlide3,mp_gad_diff);
    
    
    
    mp_hist = Picture(comp_histogram_R);
    mp_hist.Width = num2str(Rhistfig_position(3)); mp_hist.Height = num2str(Rhistfig_position(4));
    mp_hist.X = '0'; mp_hist.Y = '140';
    pictureSlide4 = add(ppt,'Title Only');
    replace(pictureSlide4,'Title',[subnames{ii}, ' Histograms in R CP']);
    add(pictureSlide4,mp_hist);
    
    mp_hist = Picture(comp_histogram_L);
    mp_hist.Width = num2str(Lhistfig_position(3)); mp_hist.Height = num2str(Lhistfig_position(4));
    mp_hist.X = '0'; mp_hist.Y = '140';
    pictureSlide5 = add(ppt,'Title Only');
    replace(pictureSlide5,'Title',[subnames{ii}, ' Histograms in L CP']);
    add(pictureSlide5,mp_hist);
    
    % irtse
    
    ir_gad_v1 = Picture(v1_figt);
    ir_gad_v1.Width = num2str(1.4*t1fig_position(3)); ir_gad_v1.Height = num2str(1.4*t1fig_position(4));
    ir_gad_v1.X = '0'; ir_gad_v1.Y = '140';
    pictureSlide6 = add(ppt,'Title Only');
    replace(pictureSlide6,'Title',[subnames{ii}, ' Visit 1 irtse']);
    add(pictureSlide6,ir_gad_v1);
    

    ir_gad_v2 = Picture(v2_figt);
    ir_gad_v2.Width = num2str(1.4*t1fig_position(3)); ir_gad_v2.Height = num2str(1.4*t1fig_position(4));
    ir_gad_v2.X = '0'; ir_gad_v2.Y = '140';
    pictureSlide7 = add(ppt,'Title Only');
    replace(pictureSlide7,'Title',[subnames{ii}, ' Visit 2 irtse']);
    add(pictureSlide7,ir_gad_v2);
    

    ir_gad_diff = Picture(diff_figt);
    ir_gad_diff.Width = num2str(1.4*t1fig_position(3)); ir_gad_diff.Height = num2str(1.4*t1fig_position(4));
    ir_gad_diff.X = '0'; ir_gad_diff.Y = '140';
    pictureSlide8 = add(ppt,'Title Only');
    replace(pictureSlide8,'Title',[subnames{ii}, ' irtse abs difference']);
    add(pictureSlide8,ir_gad_diff);
    
    
    
    mp_hist = Picture(comp_histogram_R);
    mp_hist.Width = num2str(Rhistfig_position(3)); mp_hist.Height = num2str(Rhistfig_position(4));
    mp_hist.X = '0'; mp_hist.Y = '140';
    pictureSlide9 = add(ppt,'Title Only');
    replace(pictureSlide9,'Title',[subnames{ii}, ' irtse Histograms in R CP']);
    add(pictureSlide9,mp_hist);
    
    mp_hist = Picture(comp_histogram_L);
    mp_hist.Width = num2str(Lhistfig_position(3)); mp_hist.Height = num2str(Lhistfig_position(4));
    mp_hist.X = '0'; mp_hist.Y = '140';
    pictureSlide10 = add(ppt,'Title Only');
    replace(pictureSlide10,'Title',[subnames{ii}, ' irtse Histograms in L CP']);
    add(pictureSlide10,mp_hist);


end

    
close(ppt);


% table of ERs
block = [subnames(:); 'Mean'; 'SE'];



TR = table(ER_R(:),ER_R_mean(:),ER_R_mode(:),ER_R_irtse(:),ER_R_mean_irtse(:),ER_R_mode_irtse(:),...
    'RowName',subnames(:),...
    'VariableNames',["ER Max MPRAGE","ER Mean MPRAGE","ER Mode","ER Max IRTSE","ER Mean IRTSE","ER Mode IRTSE"]);
M = varfun(@mean, TR, 'InputVariables',@isnumeric);
SE = varfun(@(x) std(x,[],1)./sqrt(length(subnames)), TR, 'InputVariables',@isnumeric);
TRx = array2table([table2array(TR); table2array(M); table2array(SE)],'RowName',block,...
    'VariableNames',["ER Max MPRAGE","ER Mean MPRAGE","ER Mode","ER Max IRTSE","ER Mean IRTSE","ER Mode IRTSE"]);
writetable(TRx,'ER_table_smallROI_more_R.xlsx','WriteVariableNames',true,'WriteRowNames',true)

TL = table(ER_L(:),ER_L_mean(:),ER_L_mode(:),ER_L_irtse(:),ER_L_mean_irtse(:),ER_L_mode_irtse(:),...
    'RowName',subnames(:),...
    'VariableNames',["ER Max MPRAGE","ER Mean MPRAGE","ER Mode","ER Max IRTSE","ER Mean IRTSE","ER Mode IRTSE"]);
M = varfun(@mean, TL, 'InputVariables',@isnumeric);
SE = varfun(@(x) std(x,[],1)./sqrt(length(subnames)), TL, 'InputVariables',@isnumeric);
TLx = array2table([table2array(TL); table2array(M); table2array(SE)],'RowName',block,...
    'VariableNames',["ER Max MPRAGE","ER Mean MPRAGE","ER Mode","ER Max IRTSE","ER Mean IRTSE","ER Mode IRTSE"]);
writetable(TLx,'ER_table_smallROI_more_L.xlsx','WriteVariableNames',true,'WriteRowNames',true)

Tboth = table(ER_LR_mn(:), ER_LR_se(:), ER_LR_mn_irtse(:), ER_LR_se_irtse(:),...
    'RowName',subnames(:),...
    'VariableNames',["Mean of ER Max (MPRAGE)","SE of ER Max (MPRAGE)", "Mean of ER Max (IRTSE)","SE of ER Max (IRTSE)"]);
writetable(Tboth,'ER_both_LR.xlsx','WriteVariableNames',true,'WriteRowNames',true);


disp('done')
toc




