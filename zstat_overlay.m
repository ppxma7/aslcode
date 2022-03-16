clear all; clc;
subj = {'SUB01','SUB02','SUB03','SUB04','SUB05','SUB06','SUB07','SUB08','SUB09'};%

for n = 1:length(subj)
    path  = ['R:\DRS-Laminar-Layers\Dan\Layers\EEG_fMRI\',subj{n},'\functional\Coregistered\GLM_inputs\fsl\',subj{n},'_allruns.gfeat\cope2.feat'];
    zstat_fname = '\stats\zstat1.nii.gz';
    bg_fname = '\mean_func.nii.gz';
    zstat_data = niftiread([path,zstat_fname]);
    bg_img = niftiread([path,bg_fname]);
    %%
    figure('Position',[10 10 1200 700])
    bg_slices = imtile(rot90(bg_img),'GridSize', [5 9]);
    bg_slices = max(bg_slices,0);
    zstat_tiles = imtile(rot90(zstat_data),'GridSize', [5 9]);
    alpha_mask = (zstat_tiles > 1.5);
    ax1 = tight_subplot(1,1,[.01 .03],[0.01,0.01],[0.01,0.06]); imagesc(ax1, bg_slices); hold on; colormap(ax1,'gray'); axis equal; axis off;
    ax2 = tight_subplot(1,1,[.01 .03],[0.01,0.01],[0.01,0.06]); zstat_img = imagesc(ax2, zstat_tiles, 'alphadata', alpha_mask); axis equal; axis off;
    colormap(ax2,'autumn'); caxis(ax2,[min(zstat_tiles(alpha_mask)) max(zstat_tiles(alpha_mask))]);
    ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); c = colorbar; c.Position = [0.95 0.06 0.0178 0.88]; ax1Position = get(ax2,'Position');
    %saveas(gcf,[path,'\',subj{n},'_EEG_2p3_zstat_overlay.png'])
end