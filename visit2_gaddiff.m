clear all
close all
clc

mypath = '/Volumes/nemosine/CATALYST_BCSFB/220202_GBPERM_01_v2/analysis';
cd(mypath)
mp1 = 'f_220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_43.nii';
mp2 = 'f_r220202_GBPERM_01_v2_MPRAGE_850ms_OPTS2_5_20220202095131_51.nii';

% V_MP1 = niftiread(mp1);
% METADATA_V_MP1 = niftiinfo(mp1);
% V_MP2 = niftiread(mp2);
% METADATA_V_MP2 = niftiinfo(mp2);


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
histogram(nonzeros(thediff_range_prc))

aa = size(img_data_vmp1);
thediff_range_prc_img = reshape(thediff_range_prc,aa);

% [I,J,K] = ind2sub(aa,thediff_range_prc);

%V_MPX = V_MP1;
%V_MPX.img = thediff_range_prc_img;
outfile=[mypath, fname, '_gaddiff.nii'];
%info_t1 = make_ana(thediff_range_prc_img);
%save_untouch_nii(info_t1,outfile)
%V_MPX.fileprefix = outfile;

%save_untouch_nii(V_MPX,outfile);
thisguy = make_nii(thediff_range_prc_img);
thisguy.hdr.hist = V_MP1.hdr.hist;
save_nii(thisguy,outfile);












