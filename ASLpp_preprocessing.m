clear all
close all
clc

% choose files
%[fname,path] = uigetfile('R:\RenalMRGroup\FRESENIUS\HD_REMODEL\HV study\healthy volunteers\DATA\166-1812\*.PAR','Select base, ASL and inflow files','MultiSelect', 'on');
% [fname,path] = uigetfile('R:\\RenalMRGroup\FRESENIUS\HD_REMODEL\DATA\HDRemodel_17_EM_0235\*.PAR','Select base, ASL and inflow files','MultiSelect', 'on');
[fname,path] = uigetfile('/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/001_H07_V1/sundries/*.PAR','Select base, ASL and inflow files','MultiSelect', 'on');



s = size(fname);

for i=1:s(2)
    fname1 = fname{i};
    fid = [path, fname1];
    
    % find filetype
    k = strfind(fname1, 'ASL'); k1=size(k);
    if k1(1)>0 
        scantype = 'ASL' ;
    end
    kk = strfind(fname1, 'BASE'); kk1=size(kk);
    if kk1(1)==1 
        scantype = 'BASE' ;
    end
    kkk = strfind(fname1, 'INFLOW'); kkk1=size(kkk);
    if kkk1(1)==1 
        scantype = 'INFLOW' ;
    end
    
%     filename = strfind(fname1, 'scan');
%     filename_save = fname1(1:filename+4);
    filename = strfind(fname1, 'WIP');
    filename_save = fname1(1:filename-2);
        
    % convert to nifti
    fname2 = fname1(1:end-4);
    str = which('ASLpp_preprocessing');
    path_ptoa = fileparts(str);
    copyfile(fid,[path_ptoa,filesep,fname{i}]);
    copyfile([path, fname2, '.REC'],[path_ptoa,filesep,fname2,'.REC']);
    cd (path_ptoa)
    
    cmd = ['ptoa -f -nii -gz ' fname2];
    z = dos(cmd);
    
    switch scantype
        case 'BASE'
            copyfile([path_ptoa,filesep, fname2,'.nii'],[path, filename_save, '_BASE.nii']);
            delete([path_ptoa,filesep, fname2,'.nii']);
            
            fid_1 = strcat(path, filename_save,'_BASE.nii');
            img_data1 = load_untouch_nii(fid_1);
            
            M = mean(img_data1.img,4); %M_rep = repmat(M,[1,1,1,5]);
            
            M_nii = img_data1;
            M_nii.hdr.dime.dim(5) = 1;
            M_nii.hdr.dime.dim(1) = 3;
            M_nii.img = M;
            outfile = strcat(fid_1(1:end-4),'_M0.nii.gz');
            save_untouch_nii(M_nii,outfile)
            
%             M_rep_nii = img_data1;
%             M_rep_nii.hdr.dime.dim(5) = 5;
%             M_rep_nii.hdr.dime.dim(1) = 4;
%             M_rep_nii.img = M_rep;
%             outfile = strcat(fid_1(1:end-4),'_M0_multi.nii.gz');
%             save_untouch_nii(M_rep_nii,outfile)
            
            outfile = strcat(fid_1,'.gz');
            save_untouch_nii(img_data1,outfile)
            
            delete([path,filesep, filename_save, '_BASE.nii.gz']);
            
        case 'ASL'
            copyfile([path_ptoa,filesep, fname2,'_label1.nii'],[path, filename_save, '_ASL_TI1500_label1.nii']);
            delete([path_ptoa,filesep, fname2,'_label1.nii']);
            copyfile([path_ptoa,filesep, fname2,'_label2.nii'],[path, filename_save, '_ASL_TI1500_label2.nii']);
            delete([path_ptoa,filesep, fname2,'_label2.nii']);
            
            fid_1 = strcat(path, filename_save,'_ASL_TI1500_label1.nii');
            fid_2 = strcat(path, filename_save,'_ASL_TI1500_label2.nii');
            img_data1 = load_untouch_nii(fid_1);
            img_data2 = load_untouch_nii(fid_2);
            
            outfile = strcat(fid_1,'.gz');
            save_untouch_nii(img_data1,outfile)
            outfile = strcat(fid_2,'.gz');
            save_untouch_nii(img_data2,outfile)
            
        case 'INFLOW'
            copyfile([path_ptoa,filesep, fname2,'_label1.nii'],[path, filename_save, '_INFLOW_label1.nii']);
            delete([path_ptoa,filesep, fname2,'_label1.nii']);
            copyfile([path_ptoa,filesep, fname2,'_label2.nii'],[path, filename_save, '_INFLOW_label2.nii']);
            delete([path_ptoa,filesep, fname2,'_label2.nii']);
            
            fid_1 = strcat(path, filename_save,'_INFLOW_label1.nii');  
            fid_2 = strcat(path, filename_save,'_INFLOW_label2.nii'); 
            img_data1 = load_untouch_nii(fid_1);
            img_data2 = load_untouch_nii(fid_2);
            
            inflow1_ti300 = img_data1.img(:,:,:,1:5);
            inflow1_ti500 = img_data1.img(:,:,:,6:10);
            inflow1_ti800 = img_data1.img(:,:,:,11:15);
            inflow1_ti1200 = img_data1.img(:,:,:,16:20);
            inflow2_ti300 = img_data2.img(:,:,:,1:5);
            inflow2_ti500 = img_data2.img(:,:,:,6:10);
            inflow2_ti800 = img_data2.img(:,:,:,11:15);
            inflow2_ti1200 = img_data2.img(:,:,:,16:20);
            
            inflow1_ti300_nii = img_data1;
            inflow1_ti300_nii.hdr.dime.dim(5) = 5;
            inflow1_ti300_nii.img = inflow1_ti300;
            outfile = strcat(fid_1(1:end-10),'TI0300_label1.nii.gz');
            save_untouch_nii(inflow1_ti300_nii,outfile)
            
            inflow1_ti500_nii = img_data1;
            inflow1_ti500_nii.hdr.dime.dim(5) = 5;
            inflow1_ti500_nii.img = inflow1_ti500;
            outfile = strcat(fid_1(1:end-10),'TI0500_label1.nii.gz');
            save_untouch_nii(inflow1_ti500_nii,outfile)
            
            inflow1_ti800_nii = img_data1;
            inflow1_ti800_nii.hdr.dime.dim(5) = 5;
            inflow1_ti800_nii.img = inflow1_ti800;
            outfile = strcat(fid_1(1:end-10),'TI0800_label1.nii.gz');
            save_untouch_nii(inflow1_ti800_nii,outfile)
            
            inflow1_ti1200_nii = img_data1;
            inflow1_ti1200_nii.hdr.dime.dim(5) = 5;
            inflow1_ti1200_nii.img = inflow1_ti1200;
            outfile = strcat(fid_1(1:end-10),'TI1200_label1.nii.gz');
            save_untouch_nii(inflow1_ti1200_nii,outfile)
            
            inflow2_ti300_nii = img_data2;
            inflow2_ti300_nii.hdr.dime.dim(5) = 5;
            inflow2_ti300_nii.img = inflow2_ti300;
            outfile = strcat(fid_2(1:end-10),'TI0300_label2.nii.gz');
            save_untouch_nii(inflow2_ti300_nii,outfile)
            
            inflow2_ti500_nii = img_data2;
            inflow2_ti500_nii.hdr.dime.dim(5) = 5;
            inflow2_ti500_nii.img = inflow2_ti500;
            outfile = strcat(fid_2(1:end-10),'TI0500_label2.nii.gz');
            save_untouch_nii(inflow2_ti500_nii,outfile)
            
            inflow2_ti800_nii = img_data2;
            inflow2_ti800_nii.hdr.dime.dim(5) = 5;
            inflow2_ti800_nii.img = inflow2_ti800;
            outfile = strcat(fid_2(1:end-10),'TI0800_label2.nii.gz');
            save_untouch_nii(inflow2_ti800_nii,outfile)
            
            inflow2_ti1200_nii = img_data2;
            inflow2_ti1200_nii.hdr.dime.dim(5) = 5;
            inflow2_ti1200_nii.img = inflow2_ti1200;
            outfile = strcat(fid_2(1:end-10),'TI1200_label2.nii.gz');
            save_untouch_nii(inflow2_ti1200_nii,outfile)
                     
            delete([path,filesep, filename_save, '_INFLOW_label1.nii']);
            delete([path,filesep, filename_save, '_INFLOW_label2.nii']);   
    end
    
    delete([path_ptoa,filesep, fname2,'.PAR']);
    delete([path_ptoa,filesep, fname2,'.REC']);
  
end

disp('finished');


% fid = [path, fname{1}];
% PV_WM_data = load_untouch_nii(fid);
% 
% fid = [path, fname{2}];
% PV_GM_data = load_untouch_nii(fid);
% 
% fid = [path, fname{3}];
% PV_CSF_data = load_untouch_nii(fid);
% 
% PV_data = cat(4,PV_GM_data.img,PV_WM_data.img,PV_CSF_data.img);
% 
% figure(1); imagesc(PV_data(:,:,3,1));
% figure(2); imagesc(PV_data(:,:,3,2));
% figure(3); imagesc(PV_data(:,:,3,3));
% 
% PVmaps_nii = PV_WM_data;
% PVmaps_nii.hdr.dime.dim(5) = 3;
% PVmaps_nii.hdr.dime.dim(1) = 4;
% 
% PVmaps_nii.img = PV_data;
% outfile = strcat(fid(1:end-10),'maps.nii.gz');
% save_untouch_nii(PVmaps_nii,outfile)