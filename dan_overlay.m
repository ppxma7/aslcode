cd /Volumes/nemosine/CATALYST_BCSFB/220311_GBPERM_06_v1/structurals/

load('testing.mat')

A = imshow(flipud(flairvol(:,:,60)),[],'Colormap',copper);
figure
imshow(flipud(diffavol(:,:,2)),[],'Colormap',copper);



them = roivol(:);
[IR,JR]=ind2sub(size(diffavol),find(them==1));