clear all
close all
clc

mypath = '/Volumes/nemosine/CATALYST_BCSFB/';
cd(mypath)

subs = {'220202_GBPERM_01_v2','220209_GBPERM_02_v2','220323_GBPERM_03_v2',...
    '220223_GBPERM_04_v2','220308_GBPERM_06_v2','220414_GBPERM_07_v2',...
    '220509_GBPERM_08_v2','220531_GBPERM_09_v2','220531_GBPERM_10_v2'};

subnames = {'sub01','sub02','sub03','sub04','sub06','sub07','sub08','sub09','sub10'};

datasetsa = {'f_220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_43.nii',...
    'f_220209_GBPERM_02_v2_MPRAGE_850ms_OPTS2_5_20220209125931_42.nii',...
    'f_GBPERM_03_v2_MPRAGE_850ms_OPTS2_5_20220223121541_45.nii',...
    'f_GBPERM_04_v2_MPRAGE_850ms_OPTS2_5_20220223100844_45.nii',...
    'f_GBPERM_06_v2_MPRAGE_850ms_OPTS2_5_20220308152457_44.nii',...
    'f_220414_GBPERM_07_v2_MPRAGE_850ms_OPTS2_5_20220414102456_45.nii',...
    'f_220509_GBPERM_08_v2_MPRAGE_850ms_OPTS2_5_20220509125701_45.nii',...
    'f_220531_GBPERM_09_v2_MPRAGE_850ms_OPTS2_5_20220531085651_46.nii',...
    'f_220531_GBPERM_10_v2_MPRAGE_850ms_OPTS2_5_20220531110348_46.nii'};


datasetsb =  {'f_r220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_51.nii',...
    'f_r220209_GBPERM_02_v2_MPRAGE_850ms_OPTS2_5_20220209125931_50.nii',...
    'f_rGBPERM_03_v2_MPRAGE_850ms_OPTS2_5_20220223121541_54.nii',...
    'f_rGBPERM_04_v2_MPRAGE_850ms_OPTS2_5_20220223100844_53.nii',...
    'f_rGBPERM_06_v2_MPRAGE_850ms_OPTS2_5_20220308152457_53.nii',...
    'f_r220414_GBPERM_07_v2_MPRAGE_850ms_OPTS2_5_20220414102456_54.nii',...
    'f_r220509_GBPERM_08_v2_MPRAGE_850ms_OPTS2_5_20220509125701_52.nii',...
    'f_r220531_GBPERM_09_v2_MPRAGE_850ms_OPTS2_5_20220531085651_54.nii',...
    'f_r220531_GBPERM_10_v2_MPRAGE_850ms_OPTS2_5_20220531110348_58.nii'};

datasetsd = {'f_220202_GBPERM_01_v2_IR_TSE_700mm_1mm_OPTS_2_20220202095131_42.nii',...
    'f_220209_GBPERM_02_v2_IR_TSE_700mm_1mm_OPTS_2_20220209125931_41.nii',...
    'f_GBPERM_03_v2_IR_TSE_700mm_1mm_OPTS_2_20220223121541_44.nii',...
    'f_GBPERM_04_v2_IR_TSE_700mm_1mm_OPTS_2_20220223100844_44.nii',...
    'f_GBPERM_06_v2_IR_TSE_700mm_1mm_OPTS_2_20220308152457_43.nii',...
    'f_220414_GBPERM_07_v2_IR_TSE_700mm_1mm_OPTS_2_20220414102456_44.nii',...
    'f_220509_GBPERM_08_v2_IR_TSE_700mm_1mm_OPTS_2_20220509125701_44.nii',...
    'f_220531_GBPERM_09_v2_IR_TSE_700mm_1mm_OPTS_2_20220531085651_45.nii',...
    'f_220531_GBPERM_10_v2_IR_TSE_700mm_1mm_OPTS_2_20220531110348_45.nii'};


datasetse =  {'f_r220202_GBPERM_01_v2_IR_TSE_700mm_1mm_OPTS_2_20220202095131_50.nii',...
    'f_r220209_GBPERM_02_v2_IR_TSE_700mm_1mm_OPTS_2_20220209125931_49.nii',...
    'f_rGBPERM_03_v2_IR_TSE_700mm_1mm_OPTS_2_20220223121541_53.nii',...
    'f_rGBPERM_04_v2_IR_TSE_700mm_1mm_OPTS_2_20220223100844_52.nii',...
    'f_rGBPERM_06_v2_IR_TSE_700mm_1mm_OPTS_2_20220308152457_52.nii',...
    'f_r220414_GBPERM_07_v2_IR_TSE_700mm_1mm_OPTS_2_20220414102456_53.nii',...
    'f_r220509_GBPERM_08_v2_IR_TSE_700mm_1mm_OPTS_2_20220509125701_53.nii',...
    'f_r220531_GBPERM_09_v2_IR_TSE_700mm_1mm_OPTS_2_20220531085651_53.nii',...
    'f_r220531_GBPERM_10_v2_IR_TSE_700mm_1mm_OPTS_2_20220531110348_54.nii'};



tic
for ii = 1:length(subs)
    disp([subnames{ii}]);
    mp1 = [mypath subs{ii} '/analysis/' datasetsd{ii}];
    mp2 = [mypath subs{ii} '/analysis/' datasetse{ii}];
    
    V_MP1 = load_untouch_nii(mp1);
    V_MP2 = load_untouch_nii(mp2);
    
    img_data_vmp1 = double(V_MP1.img);
    img_data_vmp2 = double(V_MP2.img);
    
    mygz = 4;
    k=length(mp1);
    fname = mp1(1:k-mygz);
    
    img_data_vmp1_vec = img_data_vmp1(:);
    img_data_vmp2_vec = img_data_vmp2(:);
    thediff = img_data_vmp2_vec-img_data_vmp1_vec;
    
    thediff_range = normalize(thediff,'range');
    
    %thediff_range = thediff./max(thediff);
    thediff_range_prc = thediff_range.*100;
    %histogram(nonzeros(thediff_range_prc))
    
    aa = size(img_data_vmp1);
    thediff_range_prc_img = reshape(thediff_range_prc,aa);
    
    % [I,J,K] = ind2sub(aa,thediff_range_prc);
    
    %V_MPX = V_MP1;
    %V_MPX.img = thediff_range_prc_img;
    outfile = [mypath subs{ii} '/analysis/' subnames{ii} '_irtse_gaddiff.nii'];    %info_t1 = make_ana(thediff_range_prc_img);
    %save_untouch_nii(info_t1,outfile)
    %V_MPX.fileprefix = outfile;
    
    %save_untouch_nii(V_MPX,outfile);
    thisguy = make_nii(thediff_range_prc_img);
    thisguy.hdr.hist = V_MP1.hdr.hist;
    save_nii(thisguy,outfile);
    
end
disp('done')
toc
% mp1 = 'f_220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_43.nii';
% mp2 = 'f_r220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_51.nii';

% V_MP1 = niftiread(mp1);
% METADATA_V_MP1 = niftiinfo(mp1);
% V_MP2 = niftiread(mp2);
% METADATA_V_MP2 = niftiinfo(mp2);


% V_MP1 = load_untouch_nii(mp1);
% V_MP2 = load_untouch_nii(mp2);
% 
% img_data_vmp1 = double(V_MP1.img);
% img_data_vmp2 = double(V_MP2.img);
% 
% mygz = 4;
% k=length(mp1);
% fname = mp1(1:k-mygz);
% 
% img_data_vmp1_vec = img_data_vmp1(:);
% img_data_vmp2_vec = img_data_vmp2(:);
% thediff = img_data_vmp2_vec-img_data_vmp1_vec;
% 
% thediff_range = normalize(thediff,'range');
% 
% %thediff_range = thediff./max(thediff);
% thediff_range_prc = thediff_range.*100;
% histogram(nonzeros(thediff_range_prc))
% 
% aa = size(img_data_vmp1);
% thediff_range_prc_img = reshape(thediff_range_prc,aa);
% 
% % [I,J,K] = ind2sub(aa,thediff_range_prc);
% 
% %V_MPX = V_MP1;
% %V_MPX.img = thediff_range_prc_img;
% outfile=[mypath, fname, '_gaddiff.nii'];
% %info_t1 = make_ana(thediff_range_prc_img);
% %save_untouch_nii(info_t1,outfile)
% %V_MPX.fileprefix = outfile;
% 
% %save_untouch_nii(V_MPX,outfile);
% thisguy = make_nii(thediff_range_prc_img);
% thisguy.hdr.hist = V_MP1.hdr.hist;
% save_nii(thisguy,outfile);
% 
% 










