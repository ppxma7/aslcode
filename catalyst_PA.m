% plot signal vs TI in the choroid plexus

clear all
close all
clc

%mypath ='/Volumes/nemosine/CATALYST_BCSFB/BCSFB_19_Jul_2021/';
%mypath ='/Volumes/nemosine/CATALYST_BCSFB/020921_catalyst_hi_res_13676/';
mypath = '/Volumes/ares/CATALYST/';
mysubs = {'220126_GBPERM_01_v1/','220208_GBPERM_02_v1/',...
    '220216_GBPERM_03_v1/', '220222_GBPERM_04_v1/',...
    '220311_GBPERM_06_v1/','220407_GBPERM_07_v1/',...
    '220408_GBPERM_08_v1/','220518_GBPERM_09_v1/',...
    '220530_GBPERM_10_v1/'};

subOrder = {'sub-01','sub-02','sub-03','sub-04','sub-06',...
    'sub-07','sub-08','sub-09','sub-10'};

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Michael_Sue - Catalyst/patient_data/'];


% mymaskR = 'FLAIRBET_copy_R_cp_thresh.nii.gz';
% mymaskL = 'FLAIRBET_copy_L_cp_thresh.nii.gz';
% mycsf = 'FLAIRBET_copy_CSF.nii.gz';

mymaskR = 'rright_roi_mask_flo_bin_mask.nii.gz';
mymaskL = 'rleft_roi_mask_flo_bin_mask.nii.gz';
mycsfR = 'rrightcsf_roi_mask_flo_bin_mask.nii.gz';
mycsfL = 'rleftcsf_roi_mask_flo_bin_mask.nii.gz';

for ii = 1:length(mysubs)
    
    mmaskR = MRIread([mypath mysubs{ii} 'structurals/' mymaskR]);
    mmaskL = MRIread([mypath mysubs{ii} 'structurals/' mymaskL]);
    mcsfR = MRIread([mypath mysubs{ii} 'structurals/' mycsfR]);
    mcsfL = MRIread([mypath mysubs{ii} 'structurals/' mycsfL]);
    
    
    % FAIR
    % 15 16 17 18
    % 750 1000 2000 2500
    %
    % t1000 = MRIread([mypath 'topuplabels_usingbase/7split_aslpp/diffav.nii.gz']);
    % t2000 = MRIread([mypath 'topuplabels_usingbase/9split_aslpp/diffav.nii.gz']);
    % t3000 = MRIread([mypath 'topuplabels_usingbase/8split_aslpp/diffav.nii.gz']);
    % t4000 = MRIread([mypath 'topuplabels_usingbase/10split_aslpp/diffav.nii.gz']);
    
    t1000 = MRIread([mypath  mysubs{ii} 'FAIR1000_aslpp/diffav.nii.gz']);
    t2000 = MRIread([mypath  mysubs{ii} 'FAIR2000_aslpp/diffav.nii.gz']);
    t3000 = MRIread([mypath  mysubs{ii} 'FAIR3000_aslpp/diffav.nii.gz']);
    t4000 = MRIread([mypath  mysubs{ii} 'FAIR4000_aslpp/diffav.nii.gz']);
    % base400 = MRIread([mypath 'nordic/magnitude/NORDIC/BASE400_nordic_crop_toppedup_cleave.nii.gz']);
    
    % t1000 = MRIread([mypath '020921_FAIR_1000_400ms_toppedup_aslpp/diffav.nii.gz']);
    % t2000 = MRIread([mypath '020921_FAIR_2000_400ms_toppedup_aslpp/diffav.nii.gz']);
    % t3000 = MRIread([mypath '020921_FAIR_3000_400ms_toppedup_aslpp/diffav.nii.gz']);
    % t4000 = MRIread([mypath '020921_FAIR_4000_400ms_toppedup_aslpp/diffav.nii.gz']);
    % base400 = MRIread([mypath 'BASE400_nordic_crop_toppedup_cleave.nii.gz']);
    
    
    m1000 = t1000.vol(:);
    m2000 = t2000.vol(:);
    m3000 = t3000.vol(:);
    m4000 = t4000.vol(:);
    
    % find the mask voxels
    them = mmaskR.vol(:);
    [IR,JR]=ind2sub(size(m1000),find(them==1));
    
    themL = mmaskL.vol(:);
    [IL,JL]=ind2sub(size(m1000),find(themL==1));
    
    themCSFL = mcsfL.vol(:);
    [Icl,Jcl]=ind2sub(size(m1000),find(themCSFL==1));
    
    themCSFR = mcsfR.vol(:);
    [Icr,Jcr]=ind2sub(size(m1000),find(themCSFR==1));
    
    
    % figure
    % subplot(2,2,1)
    % histogram(nonzeros(m1000_masked))
    % subplot(2,2,2)
    % histogram(nonzeros(m2000_masked))
    % subplot(2,2,3)
    % histogram(nonzeros(m3000_masked))
    % subplot(2,2,4)
    % histogram(nonzeros(m4000_masked))
    
    % CP mask
    m1000_masked = m1000(IR);
    m2000_masked = m2000(IR);
    m3000_masked = m3000(IR);
    m4000_masked = m4000(IR);
    % CP mask left
    m1000_maskedL = m1000(IL);
    m2000_maskedL = m2000(IL);
    m3000_maskedL = m3000(IL);
    m4000_maskedL = m4000(IL);
    % csf mask
    m1000_maskedcl = m1000(Icl);
    m2000_maskedcl = m2000(Icl);
    m3000_maskedcl = m3000(Icl);
    m4000_maskedcl = m4000(Icl);
    
    m1000_maskedcr = m1000(Icr);
    m2000_maskedcr = m2000(Icr);
    m3000_maskedcr = m3000(Icr);
    m4000_maskedcr = m4000(Icr);
    
    
    %% normalise
    %method = 'scale';
    %method = 'zscore';
    %method = 'norm';
    %method = 'center';
    method = 'range';
    
    m1000_masked = normalize(m1000_masked,method);
    m2000_masked = normalize(m2000_masked,method);
    m3000_masked = normalize(m3000_masked,method);
    m4000_masked = normalize(m4000_masked,method);
    
    m1000_maskedL = normalize(m1000_maskedL,method);
    m2000_maskedL = normalize(m2000_maskedL,method);
    m3000_maskedL = normalize(m3000_maskedL,method);
    m4000_maskedL = normalize(m4000_maskedL,method);
    
    m1000_maskedcl = normalize(m1000_maskedcl,method);
    m2000_maskedcl = normalize(m2000_maskedcl,method);
    m3000_maskedcl = normalize(m3000_maskedcl,method);
    m4000_maskedcl = normalize(m4000_maskedcl,method);
    
    m1000_maskedcr = normalize(m1000_maskedcr,method);
    m2000_maskedcr = normalize(m2000_maskedcr,method);
    m3000_maskedcr = normalize(m3000_maskedcr,method);
    m4000_maskedcr = normalize(m4000_maskedcr,method);
    
    %%
    
    domode = 0;
    
    if domode ~= 1
        m1000mn = mean(nonzeros(m1000_masked));
        m2000mn = mean(nonzeros(m2000_masked));
        m3000mn = mean(nonzeros(m3000_masked));
        m4000mn = mean(nonzeros(m4000_masked));
        
        m1000mnL = mean(nonzeros(m1000_maskedL));
        m2000mnL = mean(nonzeros(m2000_maskedL));
        m3000mnL = mean(nonzeros(m3000_maskedL));
        m4000mnL = mean(nonzeros(m4000_maskedL));
        
        
        m1000csfl = mean(nonzeros(m1000_maskedcl));
        m2000csfl = mean(nonzeros(m2000_maskedcl));
        m3000csfl = mean(nonzeros(m3000_maskedcl));
        m4000csfl = mean(nonzeros(m4000_maskedcl));
        
        m1000csfr = mean(nonzeros(m1000_maskedcr));
        m2000csfr = mean(nonzeros(m2000_maskedcr));
        m3000csfr = mean(nonzeros(m3000_maskedcr));
        m4000csfr = mean(nonzeros(m4000_maskedcr));
        
    else %do mode
        
        m1000mn = mode(nonzeros(m1000_masked));
        m2000mn = mode(nonzeros(m2000_masked));
        m3000mn = mode(nonzeros(m3000_masked));
        m4000mn = mode(nonzeros(m4000_masked));
        
        m1000mnL = mode(nonzeros(m1000_maskedL));
        m2000mnL = mode(nonzeros(m2000_maskedL));
        m3000mnL = mode(nonzeros(m3000_maskedL));
        m4000mnL = mode(nonzeros(m4000_maskedL));
        
        m1000csfl = mode(nonzeros(m1000_maskedcl));
        m2000csfl = mode(nonzeros(m2000_maskedcl));
        m3000csfl= mode(nonzeros(m3000_maskedcl));
        m4000csfl = mode(nonzeros(m4000_maskedcl));
        
        m1000csfr = mode(nonzeros(m1000_maskedcr));
        m2000csfr = mode(nonzeros(m2000_maskedcr));
        m3000csfr= mode(nonzeros(m3000_maskedcr));
        m4000csfr = mode(nonzeros(m4000_maskedcr));
    end
    
    
    
    
    pixR(:,ii)  = [m1000mn;m2000mn;m3000mn;m4000mn];
    pixL(:,ii) = [m1000mnL;m2000mnL;m3000mnL;m4000mnL];
    pixcsfl(:,ii) = [m1000csfl;m2000csfl;m3000csfl;m4000csfl];
    pixcsfr(:,ii) = [m1000csfr;m2000csfr;m3000csfr;m4000csfr];
    TIs(:,ii) = [1000;2000;3000;4000];
    %%
    figure('Position',[100 100 1000 600])
    plot(TIs,pixR(:,ii),'r','linewidth',2)
    xlabel('TI (ms)')
    ylabel('M (au)')
    hold on
    plot(TIs, pixL(:,ii),'b','linewidth',2)
    plot(TIs,pixcsfl(:,ii),'--b','linewidth',2)
    plot(TIs,pixcsfr(:,ii),'--r','linewidth',2)
    
    legend([{'CP Right'},{'CP Left'},{'CSF Left'},{'CSF Right'}],'Location','bestoutside','NumColumns',1)
    
    title(sprintf('GBPERM-%s',subOrder{ii}))
    %print('-dpdf', [savedir 'nofit-GBPERM-' subOrder{ii}])

    % filename = fullfile(savedir, ['nofit-GBPERM-' subOrder{ii}]);
    % print(filename, '-dpdf', '-r300', '-bestfit', 'PaperOrientation', 'landscape');

    filename = fullfile(savedir, ['nofit-GBPERM-' subOrder{ii} '.pdf']);
    set(gcf, 'PaperOrientation', 'landscape');
    print(gcf, filename, '-dpdf', '-r300', '-bestfit');

    %print([savedir 'nofit-GBPERM-' subOrder{ii}], '-dpdf', '-r300','-bestfit','PaperOrientation','landscape');

    %ylim([-100 200])

    t = TIs(:,ii);
    y = pixR(:,ii);
    y2 = pixL(:,ii);
    y3 = pixcsfl(:,ii);
    y4 = pixcsfr(:,ii);
    
    %print('-dpdf', '/Users/ppzma/The University of Nottingham/Michael_Sue - Catalyst/patient_data/norm_range.pdf')
    
    
    %% histogram
    %     EDGES = 36;
    %     figure('Position',[100 100 1000 800])
    %     tiledlayout(4,4)
    %     nexttile
    %     histogram(nonzeros(m1000_masked),EDGES)
    %     nexttile
    %     histogram(nonzeros(m2000_masked),EDGES)
    %     nexttile
    %     histogram(nonzeros(m3000_masked),EDGES)
    %     nexttile
    %     histogram(nonzeros(m4000_masked),EDGES)
    %     ylabel('RIGHT CP')
    %     nexttile
    %     histogram(nonzeros(m1000_maskedL),EDGES)
    %     nexttile
    %     histogram(nonzeros(m2000_maskedL),EDGES)
    %     nexttile
    %     histogram(nonzeros(m3000_maskedL),EDGES)
    %     nexttile
    %     histogram(nonzeros(m4000_maskedL),EDGES)
    %     ylabel('LEFT CP')
    %     nexttile
    %     histogram(nonzeros(m1000_maskedcl),EDGES)
    %     nexttile
    %     histogram(nonzeros(m2000_maskedcl),EDGES)
    %     nexttile
    %     histogram(nonzeros(m3000_maskedcl),EDGES)
    %     nexttile
    %     histogram(nonzeros(m4000_maskedcl),EDGES)
    %     ylabel('CSFL')
    %     nexttile
    %     histogram(nonzeros(m1000_maskedcr),EDGES)
    %     nexttile
    %     histogram(nonzeros(m2000_maskedcr),EDGES)
    %     nexttile
    %     histogram(nonzeros(m3000_maskedcr),EDGES)
    %     nexttile
    %     histogram(nonzeros(m4000_maskedcr),EDGES)
    %     ylabel('CSFR')
    
    %% First try a bi fit
    
    
     opts = optimoptions('lsqcurvefit','Display','off');
%     
%     %F = @(x,xdata) x(1)*exp(-xdata/x(2)) + x(3); % MONOEXP
%     F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP
%     
%     
%     %x0 = [1 40 0.05];
%     x02 = [1 40 100 0.05 ];
%     
%     %[x1,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y,[],[],opts);
%     [x2,resnorm2,~,exitflag2,output2] = lsqcurvefit(F2,x02,t,y(:,ii),[],[],opts);
%     
%     
%     figure
%     scatter(t,y,'ko')
%     hold on
%     
%     %plot(t,F(x1,t),'-k','Linewidth',2)
%     plot(t,F2(x2,t),'-r','Linewidth',2)
%     xlabel('TI (ms)')
%     ylabel('M')
%     legend([{'Data'},{'Bi Fit'}])
    
    
    
    %% try fitting a slightly different equation now
    
    T1a = 1.9; %longitudinal relaxation of arterial blood (ms) at 9.4 T 2.4s human at 3.0 T = 1.9 s
    Mo = 1;
    
    R1a = 1/T1a;
    R1app = 1/1.7; %seconds
    tau = 1.7; % temporal length of tagged bolus seconds
    BB_lambda = 0.9;
    CBF = 70; % adult mice 191 mL/100g/min - for human brain 70 ml/100g/min
    CBF=CBF/6000;
    artTT = 0.400; %typical 500ms to arrive
    Moa = 1; % assume magnetization recovers to 1
    inv_eff = 0.9; %inversion efficiency
    %TI_artTT = [0.2 0.3 0.4 0.5];
    %TE_artTT = 0.01;
    %TR_artTT = 10; % seconds
    
    %theTIs = [0.2 0.75 1.5 2.75 4 6.5];
    
    % for these data, we only have one TI
    theTIs = [1; 2; 3; 4];
    
    A = 2.*inv_eff.*Moa.*(CBF/BB_lambda);
    
    tissueTT = 0.5; % GUESS
    dR = R1app - R1a;
    
    % T2iv800 = 20.6; % ms
    % T2iv1500 = 14.3;
    % T2ev800 = 37.1;
    % T2ev1500 = 34.5;
    %
    % T2iv = [T2iv800, T2iv1500];
    % T2ev = [T2ev800, T2ev1500];
    
    
    
    
    % equation 10
    dMiv = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1a).*(min(artTT-theTIs+tau,0)-artTT)-(min(tissueTT-theTIs+tau,0)-tissueTT));
    
    % equation 11
    dMev = ((2.*Mo.*CBF)./BB_lambda) .*(exp(-theTIs.*R1app).*(exp(min(theTIs,tissueTT+tau).*dR) - exp(tissueTT.*dR)) ./ dR);
    
    %equation 9
    IV_fraction = dMiv ./ (dMiv + dMev);
    % this is equation 8 from Ohene
    %dMc = dMiv.*exp(-(TEs./T2iv)) + dMev.*exp(-(TEs./T2ev));
    %%
    TE = 400;
    
    
    %F2 = @(x,xdata) x(1).*exp(-xdata/x(2))+(1-x(1)).*exp(-xdata/x(3)) +x(4); % BIEXP
    
    % We're trying to the fit the dMiv and the dMev bit, one part goes up, the
    % other goes down
    
    %F3 = @(x,data) x(1).*exp(-dMiv/x(2))+x(3).*exp(-dMev/x(4)) + x(5);
    F3 = @(x,data) x(1).*exp(-dMiv/x(2))+(1-x(1)).*exp(-dMev/x(4)) + x(5);
    
    %F3 = @(x,xdata) dMiv.*exp(-TE/x(1))+dMev.*exp(-TE/x(2)) +x(3); % BIEXP
    % F3b = @(x,xdata) dMiv(2).*exp(-xdata/x(1))+dMev(2).*exp(-xdata/x(2)) +x(3); % BIEXP
    % F3c = @(x,xdata) dMiv(3).*exp(-xdata/x(1))+dMev(3).*exp(-xdata/x(2)) +x(3); % BIEXP
    % F3d = @(x,xdata) dMiv(4).*exp(-xdata/x(1))+dMev(4).*exp(-xdata/x(2)) +x(3); % BIEXP
    
    %x03 = [1 1 0.1];
    x03 = [1 1 1 1 0.05 ];
    
    [x3,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y,[],[],opts);
    [x3L,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y2,[],[],opts);
    [x3csfl,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y3,[],[],opts);
    [x3csfr,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3,x03,t,y4,[],[],opts);
    
    
    % [x3b,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3b,x03,t,y,[],[],opts);
    % [x3c,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3c,x03,t,y,[],[],opts);
    % [x3d,resnorm3,~,exitflag3,output3] = lsqcurvefit(F3d,x03,t,y,[],[],opts);
    %%

    map1 = [0 0.4470 0.7410];
    map2 = [0.8500 0.3250 0.0980];
    map3 = [0.9290 0.6940 0.1250];
    map4 = [0.4940 0.1840 0.5560];

    figure('Position',[100 100 1000 600])
    scatter(t,y,'MarkerEdgeColor',map1,'MarkerFaceColor',map1)
    hold on
    scatter(t,y2,'MarkerEdgeColor',map2,'MarkerFaceColor',map2)
    scatter(t,y3,'MarkerEdgeColor',map3,'MarkerFaceColor',map3)
    scatter(t,y4,'MarkerEdgeColor',map4,'MarkerFaceColor',map4)
    
    plot(t,F3(x3,t),'Color',map1,'Linewidth',2)
    plot(t,F3(x3L,t),'Color',map2,'Linewidth',2)
    plot(t,F3(x3csfl,t),'Color',map3,'Linewidth',1)
    plot(t,F3(x3csfr,t),'Color',map4,'Linewidth',1)
    
    
    % plot(t,F3b(x3b,t),'-k','Linewidth',2)
    % plot(t,F3c(x3c,t),'-k','Linewidth',2)
    % plot(t,F3d(x3d,t),'-k','Linewidth',2)
    
    xlabel('TI (ms)')
    ylabel('M')
    %legend([{'Data RIGHT CP'},{'Data LEFT CP'},{'Data CSFL'},{'Data CSFR'},{'FitR'},{'FitL'}, {'FitCSFL'}, {'FitCSFR'}])
    legend([{'Data RIGHT CP'},{'Data LEFT CP'},{'Data CSFL'},{'Data CSFR'},{'FitR'},{'FitL'}, {'FitCSFL'}, {'FitCSFR'}],'Location','bestoutside','NumColumns',1)
    title(sprintf('GBPERM-%s',subOrder{ii}))
    
    %print('-dpdf', [savedir 'fit-GBPERM-' subOrder{ii}])

    filename2 = fullfile(savedir, ['fit-GBPERM-' subOrder{ii} '.pdf']);
    set(gcf, 'PaperOrientation', 'landscape');
    print(gcf, filename2, '-dpdf', '-r300', '-bestfit');


    
    ygroup(:,1,ii) = y;
    ygroup(:,2,ii) = y2;
    ygroup(:,3,ii) = y3;
    ygroup(:,4,ii) = y4;

    fgroup(:,1,ii) = F3(x3,t);
    fgroup(:,2,ii) = F3(x3L,t);
    fgroup(:,3,ii) = F3(x3csfl,t);
    fgroup(:,4,ii) = F3(x3csfr,t);


end

