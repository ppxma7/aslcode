

clc
mydir = '/Volumes/nemosine/CATALYST_BCSFB/020921_catalyst_hi_res_13676/020921_t1mapping/';

scan14 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_FS_20210902130627_14_T1.nii.gz']);
scan15 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_med_FS_20210902130627_15_T1.nii.gz']);
scan16 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_low_FS_20210902130627_16_T1.nii.gz']);
scan17 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_noFS_20210902130627_17_T1.nii.gz']);
scan18 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_FS_20210902130627_18_T1.nii.gz']);

mask = MRIread([mydir '14_mean_mask_mask.nii.gz']);
%mask2 = MRIread([mydir '020921_catalyst_hi_res_13676_WIPIR_MB3_8dyn_FS_20210902130627_18_mask.nii.gz']);
mask2 = MRIread([mydir '18avgmask_mask.nii.gz']);

scan14_masked = scan14.vol.*mask.vol;
scan15_masked = scan15.vol.*mask.vol;
scan16_masked = scan16.vol.*mask.vol;
scan17_masked = scan17.vol.*mask.vol;
scan18_masked = scan18.vol.*mask2.vol;
%%
biglad = [nonzeros(scan14_masked(:));nonzeros(scan15_masked(:));...
    nonzeros(scan16_masked(:));nonzeros(scan17_masked(:))];
GRO = [repmat({'FS'},length(nonzeros(scan14_masked(:))),1);...
    repmat({'Med FS'},length(nonzeros(scan15_masked(:))),1);...
    repmat({'Low FS'},length(nonzeros(scan16_masked(:))),1);...
    repmat({'no FS'},length(nonzeros(scan17_masked(:))),1)];

EDGES = 1000;
figure
subplot(4,1,1)
histogram(nonzeros(scan17_masked(:)), EDGES)
title('No')
xlim([0 2500])
subplot(4,1,2)
histogram(nonzeros(scan16_masked(:)), EDGES)
title('Low')
xlim([0 2500])
subplot(4,1,3)
histogram(nonzeros(scan15_masked(:)), EDGES)
title('Med')
xlim([0 2500])
subplot(4,1,4)
histogram(nonzeros(scan14_masked(:)), EDGES)
title('FS')
xlim([0 2500])

% figure
% histogram(nonzeros(scan18_masked(:)))
%
whichGeom = 'stairs';

figure
g = gramm('x',biglad,'color',GRO);
g.stat_bin('geom',whichGeom,'nbins',1000);
g.axe_property('XLim', [500 2500])
g.draw()

%g.axe_property('YLim', [0 6000])
g.set_order_options('x',0)
g.set_text_options('Font','Helvetica', 'base_size', 14)

g.draw()

g.export('file_name','testStacks_030921', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - Catalyst/IR/',...
    'file_type','pdf')






