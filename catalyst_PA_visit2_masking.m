mypath = '/Volumes/ares/CATALYST/';
mysubs = {'220202_GBPERM_01_v2/','220531_GBPERM_09_v2/'...
    '220531_GBPERM_10_v2/','220414_GBPERM_07_v2/',...
    '220223_GBPERM_04_v2/','220308_GBPERM_06_v2/',...
    '220323_GBPERM_03_v2/','220209_GBPERM_02_v2/',...
    '220509_GBPERM_08_v2/'};

mprage_list = {'f_r220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_51.nii',...
    'f_r220531_GBPERM_09_v2_MPRAGE_850ms_OPTS2_5_20220531085651_54.nii',...
    'f_r220531_GBPERM_10_v2_MPRAGE_850ms_OPTS2_5_20220531110348_58.nii',...
    'f_r220414_GBPERM_07_v2_MPRAGE_850ms_OPTS2_5_20220414102456_54.nii',...
    'f_rGBPERM_04_v2_MPRAGE_850ms_OPTS2_5_20220223100844_53.nii',...
    'f_rGBPERM_06_v2_MPRAGE_850ms_OPTS2_5_20220308152457_53.nii',...
    'f_rGBPERM_03_v2_MPRAGE_850ms_OPTS2_5_20220223121541_54.nii',...
    'f_r220209_GBPERM_02_v2_MPRAGE_850ms_OPTS2_5_20220209125931_50.nii',...
    'r220509_GBPERM_08_v2_MPRAGE_850ms_OPTS2_5_20220509125701_52.nii'};

mymaskR = 'rright_roi_mask_flo.nii';
mymaskL = 'rleft_roi_mask_flo.nii';
ventricle_mask = 'rnative_structures_justvens_bin.nii';

magicSize = [256 256 120];


for ii = 1:length(mysubs)
    
    mmaskR = MRIread([mypath mysubs{ii} 'masking/' mymaskR]);
    mmaskL = MRIread([mypath mysubs{ii} 'masking/' mymaskL]);
    mventricle_mask = MRIread([mypath mysubs{ii} 'masking/' ventricle_mask]);
    the_mprage = MRIread([mypath mysubs{ii} 'masking/' mprage_list{ii}]);

    mmaskR_data = mmaskR.vol;
    mmaskL_data = mmaskL.vol;
    mventricle_mask_data = mventricle_mask.vol;
    mmprage_data = the_mprage.vol;

    mmaskR_data_vec = mmaskR_data(:);
    nandex = isnan(mmaskR_data_vec);
    mmaskR_data_vec(nandex) = 0;
    mmaskR_data_vec_thr = mmaskR_data_vec>0.8;

    mmaskL_data_vec = mmaskL_data(:);
    nandex = isnan(mmaskL_data_vec);
    mmaskL_data_vec(nandex) = 0;
    mmaskL_data_vec_thr = mmaskL_data_vec>0.8;

    mventricle_mask_data_vec = mventricle_mask_data(:);
    nandex = isnan(mventricle_mask_data_vec);
    mventricle_mask_data_vec(nandex) = 0;
    mventricle_mask_data_vec_thr = mventricle_mask_data_vec>0.8;


    % and now do something to the gad mprage using these masks

    


end