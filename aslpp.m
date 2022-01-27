function [diffav_calib_file, inputs_str] = aslpp(label_fn, m0_fn, varargin)
% Usage: aslpp(label_fn, m0_fn, Options)
% Rich Dury - richard.dury@nottingham.ac.uk
%
% Required Inputs:
%  - label_fn:          filename of either label 1 or label 2. Both need to be in the same folder with 'label1' and 'label2' in thier filename.
%  - m0_fn:             filename of M0 image for calibration.
%
% Optional Inputs:
% - 'FieldStrength'     Field strength in Tesla of MR scanner. Used to define T2* of blood, grey matter, white matter and CSF. Allowed 1.5, 3, 7. Default = 7.
% - 'Subtraction'       Subtraction method of label 1 and label 2. Allowed 'Pairwise1', 'Pairwise2', 'Surround', 'Running', 'Sinc'. Default = 'Surround'
% - 'MC'                Perform motion correction using MCFLIRT. 1=Yes, 0=No. Default = 1.
% - 'FSLMO'             Identify motion outliers using FSL_MOTION_OUTLIERS and discard. 1=Yes, 0=No. Default = 1.
% - 'MCRefVol'          Reference volume for motion correction. Default = 0.
% - 'MCDoF'             Degrees of Freedom for motion correction. Allowed = 6, 7, 9, 12. Default = 12.
% - 'MCCost'            Cost function for motion correction. Allowed = 'corratio', 'mutualinfo', 'normmi', 'normcorr', 'leastsquares', 'woods'. Default = normmi.
% - 'MCBins'            Number of histogram bins used in motion correction. Default = 256.
% - 'MCSmooth'          Amount of smoothing applied to cost function for motion correction. Default = 0.
% - 'MCInit'            Filename of inital transform to apply with motion correction.
% - 'MCDiscardThresh'   Any volume to move more than this distance in mm from motion correction is discared. Default = inf (off).
% - 'BETLabel'          Brain extract labels using FSL BET. 1=Yes, 0=No. Deafault = 1.
% - 'BETLabelf'         Fractional intensity threshold of label brain extraction (0 to 1).
% - 'BETLabelg'         Vertical gradient in fractional intensity threshold (-1 to 1).
% - 'M0Label'           Brain extract M0 using FSL BET. 1=Yes, 0=No. Default = 1.
% - 'M0Labelf'          Fractional intensity threshold of M0 brain extraction (0 to 1).
% - 'M0Labelg'          Vertical gradient in fractional intensity threshold (-1 to 1).
% - 'OutlierMethod'     Choose outlier detection method following subtraction. Allowed = 'None', 'Tan', 'Maumet', 'Rich'. Default = 'Tan'.
% - 'TanThreshold'      If 'Tan' is chosen for OutlierMethod, choose the threshold for discarding. Default =  2.5.
% - 'CalibMethod'       Choose method of calibration. Allowed = 'None', 'BBB', 'GM', 'WM', 'CSF', 'PVMaps'. Default = 'BBB'.
% - 'CalibMap'          If 'GM', 'WM', 'CSF' is chosen, supply filename of its respective mask. If 'PVMaps' is chosen, supply the filename of 4D concatinated PV maps for GM, WM, and CSF.
% - 'CalibTE'           Echo time of sequence in ms. Needed for calibration using tissue tyoes.
% - 'BBBval'            Blood-brain barrier partition coefficient. Default = 0.98.
% - 'OutputDir'         Directory where images will be saved. Default name chosen from label filename
% - 'Verbose'           Output progress to command window. 1=Yes, 0=No. Default = 1.
% - 'ReportHTML'        Output report to HTML for review. 1=Yes, 0=No. Default = 1.


%% ADD PATH FOR ALL FUNCTIONS
functions_path = [fileparts(mfilename('fullpath')), filesep, 'functions'];
addpath(functions_path);


%% INPUT PARSER AND VALIDATION
p = inputParser;

% FIELD STRENGTH VALIDATION
def_FieldStrength = 7; % Choose field strength so correct T1/T2/T2* can be chosen: 1.5, 3, 7.
val_FieldStrength = [1.5, 3, 7];
che_FieldStrength = @(x) ismember(x, val_FieldStrength);

% SUBTRACTION VALIDATION
def_Subtraction = 'Surround'; % Subtraction method: 'Pairwise1', 'Pairwise2', 'Surround', 'Running', 'Sinc'.
val_Subtraction = {'Pairwise1', 'Pairwise2', 'Surround', 'Running', 'Sinc'};
che_Subtraction = @(x) ismember(x, val_Subtraction);

% MOTION CORRECTION VALIDATION
def_MC = 1; % Turn motion correction on/off: 1 = on, 0 = off.
val_MC = [0 1];
che_MC = @(x) ismember(x, val_MC);

% FSL MOTION OUTLIERS VALIDATION
def_FSLMO = 1; % Turn motion correction on/off: 1 = on, 0 = off.
val_FSLMO = [0 1];
che_FSLMO = @(x) ismember(x, val_FSLMO);

% MOTION CORRECTION REFERENCE VOLUME VALIDATION
def_MCRefVol = 0; % Motion correction reference volume: Integer between 0 and number of repeats.
che_MCRefVol = @(x) isnumeric(x) | strcmp(x,'middle');

% MOTION COORECTION DEGREES OF FREEDOM VALIDATION
def_MCDoF = 12; % Degrees of freedom of motion correction: 3, 6, 7, 9, 12.
val_MCDoF = [6, 7, 9, 12];
che_MCDoF = @(x) ismember(x, val_MCDoF);

% MOTION CORRECTION COST FUNCTION VALIDATION
def_MCCost = 'corratio'; % Cost function for motion correction: 'corratio', 'mutualinfo', 'normmi', 'normcorr', 'leastsquares', 'woods'.
val_MCCost = {'corratio', 'mutualinfo', 'normmi', 'normcorr', 'leastsquares', 'woods'};
che_MCCost = @(x) ismember(x, val_MCCost);

% MOTION CORRECTION COST SMOOTHING VALIDATION
def_MCSmooth = 0; % Smoothing of motion correction cost function.

% MOTION CORRECTION BINS VALIDATION
def_MCBins = '256'; % Number of histogram bins in motion correction.
che_MCBins = @(x) x>=0;

% MOTION CORRECTION INITIAL TRANSFORM VALIDATION
def_MCInit = [functions_path, filesep, 'I.mat']; % Filename of initial transform to apply to motion correction.

% MOTION CORRECTION THRESHOLD
def_MCDiscardThreshold = inf; % Discard repeat with translation greater than threshold (mm). Set to inf to turn off.

% BRAIN EXTRACT LABEL VALIDATION
def_BETLabel = 0; % Turn on/off brain extraction on labels: 1 = on, 0 = off.
val_BETLabel = [0 1];
che_BETLabel = @(x) ismember(x, val_BETLabel);

% BRAIN EXTRACT LABEL FIT VALIDATION
% default here is 0.2 MICHAEL 
def_BETLabelf = 0.2; % Fractional intensity threshold of label brain extraction (0 to 1).
che_BETLabelf = @(x) x>=0 & x<=1;

% BRAIN EXTRACT LABEL VGFIT VALIDATION
def_BETLabelg = 0.2; % Vertical gradient in fractional intensity threshold (-1 to 1). 0.2
che_BETLabelg = @(x) x>=-1 & x<=1;

% BRAIN EXTRACT M0 VALIDATION
def_BETM0 = 1; % Turn on/off brain extraction on M0: 1 = on, 0 = off.
val_BETM0 = [0 1];
che_BETM0 = @(x) ismember(x, val_BETM0);

% BRAIN EXTRACT M0 FIT VALIDATION
def_BETM0f = 0.2; % Fractional intensity threshold of label brain extraction (0 to 1).
che_BETM0f = @(x) x>=0 & x<=1;

% BRAIN EXTRACT LABEL VGFIT VALIDATION
def_BETM0g = 0.2; % Verticle gradient in fractional intensity threshold (-1 to 1).
che_BETM0g = @(x) x>=-1 & x<=1;

% OUTLIER DETECTION METHOD VALIDATION
def_OutlierMethod = 'Tan'; % Choose outlier detection method: 'None', 'Tan', 'Maumet', 'Rich'.
val_OutlierMethod = {'None', 'Tan', 'Maument', 'Rich'};
che_OutlierMethod = @(x) ismember(x, val_OutlierMethod);

% TAN OUTLIER DETECTION THRESHOLD VALIDATION
def_TanThreshold = 2.5; % Tuning parameter for Tan discarding method (2.5 recommended)

% CALIBRATION METHOD VALIDATION
def_CalibMethod = 'BBB'; % Choose calibration method: 'CSF', 'PVMaps', 'GM', 'BBB'.
val_CalibMethod = {'BBB', 'CSF', 'PVMaps', 'GM', 'WM', 'None'};
che_CalibMethod = @(x) ismember(x, val_CalibMethod);

% CALIBRATION BBB VALIDATION
def_BBBval = 0.98;

% CALIBRATION PV MAPS VALIDATION
def_CalibPVMap = 'None'; % Filename of PV maps: 4D matrix with GM, WM, CSF PV maps stored in 4th dimension that order.

% CALIBARTION ECHO TIME VALIDATION
def_CalibTE = 0; % Echo time in ms.

% OUTPUT DIRECTION VALIDATION
k = strfind(label_fn, 'label');
labels_pre = label_fn(1:k-2);
def_OutputDir = [labels_pre '_aslpp']; % Output directory, will later automatically add '+' if folder already exists.

% VERBOSE VALIDATION
def_Verbose = 1; % Output progress to command window.
val_Verbose = [0 1];
che_Verbose = @(x) ismember(x, val_Verbose);

% REPORT HTML VALIDATION
def_html = 1; % Output progress to command window.
val_html = [0 1];
che_html = @(x) ismember(x, val_html);

% VERBOSE VALIDATION
def_Overwrite = 1; % Output progress to command window.
val_Overwrite = [0 1];
che_Overwrite = @(x) ismember(x, val_Overwrite);

% FINAL IMAGE ONLY
def_FinalOnly = 0;
val_FinalOnly = [0 1];
che_FinalOnly = @(x) ismember(x, val_FinalOnly);


% ADD INPUTS AND VALIDATE
addRequired(p, 'label_fn', @ischar);
addRequired(p, 'm0_fn', @ischar);
addOptional(p, 'FieldStrength', def_FieldStrength, che_FieldStrength);
addOptional(p, 'Subtraction', def_Subtraction, che_Subtraction);
addOptional(p, 'MC', def_MC, che_MC);
addOptional(p, 'MCRefVol', def_MCRefVol, che_MCRefVol);
addOptional(p, 'MCDoF', def_MCDoF, che_MCDoF);
addOptional(p, 'MCCost', def_MCCost, che_MCCost);
addOptional(p, 'MCSmooth', def_MCSmooth, @isnumeric);
addOptional(p, 'MCBins', def_MCBins, che_MCBins);
addOptional(p, 'MCInit', def_MCInit, @ischar);
addOptional(p, 'MCDiscardThreshold', def_MCDiscardThreshold, @isnumeric);
addOptional(p, 'FSLMO', def_FSLMO,  che_FSLMO);
addOptional(p, 'BETLabel', def_BETLabel, che_BETLabel);
addOptional(p, 'BETLabelf', def_BETLabelf, che_BETLabelf);
addOptional(p, 'BETLabelg', def_BETLabelg, che_BETLabelg);
addOptional(p, 'BETM0', def_BETM0, che_BETM0);
addOptional(p, 'BETM0f', def_BETM0f, che_BETM0f);
addOptional(p, 'BETM0g', def_BETM0g, che_BETM0g);
addOptional(p, 'OutlierMethod', def_OutlierMethod, che_OutlierMethod);
addOptional(p, 'TanThreshold', def_TanThreshold, @isnumeric);
addOptional(p, 'CalibMethod', def_CalibMethod, che_CalibMethod);
addOptional(p, 'CalibPVMap', def_CalibPVMap, @ischar);
addOptional(p, 'CalibTE', def_CalibTE, @isnumeric);
addOptional(p, 'BBBval', def_BBBval, @isnumeric);
addOptional(p, 'OutputDir', def_OutputDir, @ischar);
addOptional(p, 'Verbose', def_Verbose, che_Verbose);
addOptional(p, 'HTML', def_html, che_html);
addOptional(p, 'Overwrite', def_Overwrite, che_Overwrite);
addOptional(p, 'FinalOnly', def_FinalOnly, che_FinalOnly);


% PARSE INPUTS
parse(p,label_fn, m0_fn, varargin{:});


%% GET FILE NAMES

% GET LABEL 1 AND LABEL 2 FILE NAMES
label1_fn = label_fn; label1_fn(k+5)='1';
label2_fn = label_fn; label2_fn(k+5)='2';

% CHECK IF LABEL 1 EXISTS
if exist(label1_fn, 'file')==0
    disp('Label 1 does not exist. Script stopped.');
    return;
end

% CHECK IF LABEL 2 EXISTS
if exist(label2_fn, 'file')==0
    disp('Label 2 does not exist. Script stopped.');
    return;
end

% CHECK IS M0 EXISTS
if exist(m0_fn, 'file')==0
    disp('M0 does not exist. Script stopped.');
    return;
end


%% MAKE OUTPUT DIRECTORY
if p.Results.Verbose == 1
    fprintf('Making output directory...');
end

if p.Results.Overwrite == 0
    dir_name = p.Results.OutputDir;
    while exist(dir_name, 'dir')==7
        dir_name = [dir_name, '+'];
    end
    mkdir(dir_name);
else
    if exist(p.Results.OutputDir, 'dir') ==7
        unix(['rm -r ' p.Results.OutputDir]);
    end
    mkdir(p.Results.OutputDir)
    dir_name = p.Results.OutputDir;
end

if p.Results.Verbose == 1
    fprintf(' Done.\n');
end


%% VERBOSE INPUTS
on_off_str = {'Off', 'On'};
inputs_str = 'None';
if p.Results.Verbose==1
%     disp(' ');
%     disp('Filenames:');
%     disp([' - Label 1 filename:        ', label1_fn]);
%     disp([' - Label 2 filename:        ', label2_fn]);
%     disp([' - M0 filename:             ', m0_fn]);
%     disp(' ');
%     disp(['Montion correction:         ', on_off_str{p.Results.MC+1}]);
%     if p.Results.MC == 1
%         disp([' - Cost function:           ', p.Results.MCCost]);
%         disp([' - DOF:                     ', num2str(p.Results.MCDoF)]);
%         disp([' - Smooth:                  ', num2str(p.Results.MCSmooth)]);
%         disp([' - Bins:                    ', num2str(p.Results.MCBins)]);
%         disp([' - RefVol:                  ', num2str(p.Results.MCRefVol)]);
%         disp([' - Discard Threshold:       ', num2str(p.Results.MCDiscardThreshold)]);
%         disp([' - Initial matrix:          ', p.Results.MCInit]);
%     end
%     disp(' ');
%     disp(['Brain extract labels:       ', on_off_str{p.Results.BETLabel+1}]);
%     if p.Results.BETLabel == 1
%         disp([' - FIT:                     ', num2str(p.Results.BETLabelf)]);
%         disp([' - FIT gradient:            ', num2str(p.Results.BETLabelg)]);
%     end
%     disp(' ');
%     disp(['Brain extract M0:           ', on_off_str{p.Results.BETM0+1}]);
%     if p.Results.BETLabel == 1
%         disp([' - FIT:                     ', num2str(p.Results.BETM0f)]);
%         disp([' - FIT gradient:            ', num2str(p.Results.BETM0g)]);
%     end
%     disp(' ');
%     disp(['Subtraction:                ', p.Results.Subtraction]);
%     disp(' ');
%     disp(['Outlier detection:          ', p.Results.OutlierMethod]);
%     if strcmp(p.Results.OutlierMethod, 'Tan')
%         disp([' - Tan Threshold:           ', num2str(p.Results.TanThreshold)]) ;
%     end
%     disp(' ');
%     disp(['Calibration:                ', p.Results.CalibMethod]);
%     switch p.Results.CalibMethod
%         case 'BBB'
%             disp([' - BBB coefficient:         ', num2str(p.Results.BBBval)]);
%         case 'PVMaps'
%             disp([' - Echo time (ms):          ', num2str(p.Results.CalibTE)]);
%             disp([' - Map file:                ', p.Results.CalibPVMap]);
%         case {'GM', 'WM', 'CSF'}
%             disp([' - Echo time (ms):          ', num2str(p.Results.CalibTE)]);
%     end
%     disp(' ');
%     disp(['Output Directory:           ', dir_name]);
%     disp(' ');
%     disp(['HTML report:                ', on_off_str{p.Results.HTML+1}]);
%     disp(' ');
    
    inputs_str = char('Filenames:', ...
        [' - Label 1 filename:        ', label1_fn], ...
        [' - Label 2 filename:        ', label2_fn], ...
        [' - M0 filename:             ', m0_fn], ...
        ' ', ...
        ['Montion correction:         ', on_off_str{p.Results.MC+1}]);
    if p.Results.MC == 1
        inputs_str = char(inputs_str, ...
            [' - Cost function:           ', p.Results.MCCost], ...
            [' - DOF:                     ', num2str(p.Results.MCDoF)], ...
            [' - Smooth:                  ', num2str(p.Results.MCSmooth)], ...
            [' - Bins:                    ', num2str(p.Results.MCBins)], ...
            [' - RefVol:                  ', num2str(p.Results.MCRefVol)], ...
            [' - Discard Threshold:       ', num2str(p.Results.MCDiscardThreshold)], ...
            [' - Initial matrix:          ', p.Results.MCInit]);
    end
    inputs_str = char(inputs_str, ...
        ' ', ...
        ['Brain extract labels:       ', on_off_str{p.Results.BETLabel+1}]);
    if p.Results.BETLabel == 1
        inputs_str = char(inputs_str, ...
            [' - FIT:                     ', num2str(p.Results.BETLabelf)], ...
            [' - FIT gradient:            ', num2str(p.Results.BETLabelg)]);
    end
    inputs_str = char(inputs_str, ...
        ' ', ...
        ['Brain extract M0:           ', on_off_str{p.Results.BETM0+1}]);
    if p.Results.BETLabel == 1
        inputs_str = char(inputs_str, ...
            [' - FIT:                     ', num2str(p.Results.BETM0f)], ...
            [' - FIT gradient:            ', num2str(p.Results.BETM0g)]);
    end
    inputs_str = char(inputs_str, ...
        ' ', ...
        ['Subtraction:                ', p.Results.Subtraction], ...
        ' ', ...
        ['Outlier detection:          ', p.Results.OutlierMethod]);
    if strcmp(p.Results.OutlierMethod, 'Tan')
        inputs_str = char(inputs_str, ...
            [' - Tan Threshold:           ', num2str(p.Results.TanThreshold)]);
    end
    inputs_str = char(inputs_str, ...
        ' ', ...
        ['Calibration:                ', p.Results.CalibMethod]);
    switch p.Results.CalibMethod
        case 'BBB'
            inputs_str = char(inputs_str, ...
                [' - BBB coefficient:         ', num2str(p.Results.BBBval)]);
        case 'PVMaps'
            inputs_str = char(inputs_str, ...
                [' - Echo time (ms):          ', num2str(p.Results.CalibTE)], ...
                [' - Map file:                ', p.Results.CalibPVMap]);
        case {'GM', 'WM', 'CSF'}
            inputs_str = char(inputs_str, ...
                [' - Echo time (ms):          ', num2str(p.Results.CalibTE)]);
    end
    inputs_str = char(inputs_str, ...
        ' ', ...
        ['Output Directory:           ', dir_name], ...
        ' ', ...
        ['HTML report:                ', on_off_str{p.Results.HTML+1}]);
    disp(inputs_str);
    
end


%% CHECK THAT ALL FILES EXIST OF THEY ARE BEING USED AND PARAMETERS ARE VALID

if p.Results.Verbose == 1
    fprintf('Checking that script can run with given inputs...');
end

% READ IN LABEL1, LABEL2 AND M0
label1_nii = load_untouch_nii(label1_fn);
label2_nii = load_untouch_nii(label2_fn);
m0_nii = load_untouch_nii(m0_fn);

% CHECK IF MOTION CORRECTION MATRIX EXISTS
if exist(p.Results.MCInit, 'file')==0 && p.Results.MC == 1
    disp('Motion correction initial transform matrix does not exits. Script stopped.');
    return;
end

% CHECK IF PARTIAL VOLUME MAPS FOR CALIBRATION EXISTS IF THAT METHOD IS CHOSEN
if strcmp(p.Results.CalibMethod, 'PVMaps') && exist(p.Results.CalibPVMap, 'file')==0
    disp(['Partial volume maps for calibration does not exist. Script stopped. File chosen: ', p.Results.CalibPVMaps]);
    return;
end

% CHECK IF ECHO TIME IS DEFINE IF CSF, PVMAPS OR GM CALIBRATION METHOD IS CHOSEN.
if ismember(p.Results.CalibMethod, {'PVMaps', 'GM', 'CSF'}) && p.Results.CalibTE==0
    disp(['Echo time needs defining for ' p.Results.CalibMethod, ' calibration method.']);
    return;
end

% CHECK IF LABEL1 AND LABEL2 HAVE THE SAME DIMENSIONS
if isequal(label1_nii.hdr.dime.dim(2:5), label2_nii.hdr.dime.dim(2:5))==0
    disp(['Label 1 and Label 2 have different image dimensions. Label 1 = ', num2str(label1_nii.hdr.dime.dim(2:5)), ' and Label 2 = ', num2str(label2_nii.hdr.dime.dim(2:5))]);
    return;
end

% CHECK IF LABELS AND M0 HAVE THE SAME IMAGE DIMENSIONS
m0_hdr = load_untouch_header_only(m0_fn);
if isequal(m0_nii.hdr.dime.dim(2:4), label1_nii.hdr.dime.dim(2:4))==0
    disp(['Labels and M0 have different image dimensions. Labels = ', num2str(label1_nii.hdr.dime.dim(2:5)), ' and M0 = ', num2str(m0_nii.hdr.dime.dim(2:5))]);
    return;
end

% CHECK IF MOTION CORRECTION REFERENCE VOLUME IS VALID
if p.Results.MC == 1 && p.Results.MCRefVol < 0 && p.Results.MCRefVol >= label1_nii.hdr.dime.dim(5)
    disp(['Motion correction reference volume outside allowed range. Script stopped. Chosen reference volume: ' num2str(p.Results.MCRefVol)]);
    return;
end

if p.Results.Verbose == 1
    fprintf(' Done.\n');
end


%% MAKE REPORT HTML FILE

html.heading_pre = '<FONT SIZE=3 FACE="ARIAL">';
html.normal_pre = '<FONT SIZE=1 FACE="ARIAL">';
html.font_post = '</FONT>';

html.report = char('<HTML><BODY>', ...
    [html.heading_pre, 'Inputs', html.font_post, '<br>'], ...
    [html.normal_pre, 'Label 1 filename: ', label1_fn, html.font_post, '<br>'], ...
    [html.normal_pre, 'Label 2 filename: ', label2_fn, html.font_post, '<br>'], ...
    [html.normal_pre, 'M0 filename: ', m0_fn, html.font_post, '<br><br><br>']);


%% MOTION CORRECTION

if p.Results.Verbose == 1 && p.Results.MC == 1
    fprintf('Performing motion correction...');
end

[label1_nii, label2_nii, html] = aslpp_motioncorrection(label1_nii, label2_nii, p, html, dir_name);

if p.Results.Verbose == 1 && p.Results.MC == 1
    fprintf(' Done.\n');
end


%% BRAIN EXTRACT LABELS

if p.Results.Verbose == 1 && p.Results.BETLabel == 1
    fprintf('Performing brain extraction on labels...');
end

[label1_nii, label2_nii, html] = aslpp_betlabel(label1_nii, label2_nii, p, html, dir_name);

if p.Results.Verbose == 1 && p.Results.BETLabel == 1
    fprintf(' Done.\n');
end


%% BRAIN EXTRACT M0

if p.Results.Verbose == 1 && p.Results.BETM0 == 1
    fprintf('Performing brain extraction on M0...');
end

[m0_nii, html] = aslpp_betm0(m0_nii, p, html, dir_name);

if p.Results.Verbose == 1 && p.Results.BETM0 == 1
    fprintf(' Done.\n');
end


%% SUBTRACTION

if p.Results.Verbose == 1
    fprintf('Performing subtraction...');
end

[diff_nii, html] = aslpp_subtraction(label1_nii, label2_nii, p, html, dir_name);

if p.Results.Verbose == 1
    fprintf(' Done.\n');
end


%% OUTLIER DETECTION

if p.Results.Verbose == 1 && ~strcmp(p.Results.OutlierMethod,'None')
    fprintf('Performing outlier detection...');
end

[diffav_nii, html] = aslpp_outliers(diff_nii, p, html, dir_name);

if p.Results.Verbose == 1 && ~strcmp(p.Results.OutlierMethod,'None')
    fprintf(' Done.\n');
end


%% CALIBRATION

if p.Results.Verbose == 1
    fprintf('Performing calibration...');
end

[~, html] = aslpp_calibration(diffav_nii, m0_nii, p, html, dir_name);

if p.Results.Verbose == 1
    fprintf(' Done.\n');
end


%% END HTML REPORT

disp(' ');
disp('All processes finished.');
disp(' ');

html.report = char(html.report, '</BODY></HTML>');
if p.Results.HTML==1
    dlmwrite([dir_name, filesep, 'report.html'], html.report, 'delimiter', '');
end

%% FINAL RESULTS ONLY

if p.Results.FinalOnly == 1
    [~, file, ~] = fpmri(label_fn); k = strfind(file, 'label');
    copyfile([p.Results.OutputDir, filesep, 'diffav_calib.nii.gz'], [fileparts(p.Results.OutputDir), filesep, file(1:k-2), '_diffav_calib.nii.gz']);
    unix(['rm -r ', p.Results.OutputDir]);
    diffav_calib_path = [fileparts(p.Results.OutputDir), filesep];
    diffav_calib_file = [diffav_calib_path, filesep, file(1:k-2), '_diffav_calib.nii.gz'];
else
   diffav_calib_path = p.Results.OutputDir; 
   diffav_calib_file = [diffav_calib_path, filesep, 'diffav_calib.nii.gz'];
end


end


%% MOTION CORRECTION FUNCTION

function [label1_nii, label2_nii, html] = aslpp_motioncorrection(label1_nii, label2_nii, p, html, dir_name)
% MOTION CORRECT LABEL1 AND LABEL2

if p.Results.MC == 1
    
    labels = cat(4, label1_nii.img, label2_nii.img);
    labels_nii = label1_nii; labels_nii.hdr.dime.dim(5) = labels_nii.hdr.dime.dim(5)*2;
    labels_nii.img = labels;
    save_untouch_nii(labels_nii, [dir_name, filesep, 'labels.nii.gz']);
    
    mc_txt = ['mcflirt -in ', dir_name, filesep, 'labels.nii.gz', ...
        ' -refvol ', num2str(p.Results.MCRefVol), ...
        ' -smooth ', num2str(p.Results.MCSmooth), ...
        ' -bins ', num2str(p.Results.MCBins), ...
        ' -cost ', p.Results.MCCost, ...
        ' -dof ', num2str(p.Results.MCDoF), ...
        ' -init ', p.Results.MCInit, ...
        ' -plots'];
    [~,~] = unix(mc_txt);
    
    params = load([dir_name, filesep, 'labels_mcf.par']);
    label1_trans = params(1:end/2, 4:6); label1_trans = sqrt(label1_trans(:,1).^2 + label1_trans(:,2).^2 + label1_trans(:,3).^2);
    label2_trans = params((end/2+1):end, 4:6); label2_trans = sqrt(label2_trans(:,1).^2 + label2_trans(:,2).^2 + label2_trans(:,3).^2);
    
    disc = label1_trans < p.Results.MCDiscardThreshold | label2_trans < p.Results.MCDiscardThreshold;
    
    dlmwrite([dir_name, filesep, 'label_trans.txt'], [label1_trans,label2_trans], 'delimiter', '\t');
    dlmwrite([dir_name, filesep, 'label_trans_legend.txt'], char('Label 1', 'Label 2'), 'delimiter', '');
    
    
    unix(['fsl_tsplot -i ', dir_name, filesep, 'label_trans.txt -o ' dir_name, filesep, 'label_trans.png ', ...
        '-l ' dir_name, filesep, 'label_trans_legend.txt -x Volune -y ''Translation (mm)'' ']);
    
    labels_mcf_nii = load_untouch_nii([dir_name filesep 'labels_mcf.nii.gz']);
    label1 = labels_mcf_nii.img(:,:,:,1:label1_nii.hdr.dime.dim(5));
    label2 = labels_mcf_nii.img(:,:,:,(label2_nii.hdr.dime.dim(5)+1):end);
    
    label1_nii.img = label1(:,:,:,disc);
    label1_nii.hdr.dime.dim(5) = size(label1,4);
    label2_nii.img = label2(:,:,:,disc);
    label2_nii.hdr.dime.dim(5) = size(label2,4);
    
    save_untouch_nii(label1_nii, [dir_name, filesep, 'label1_mcf.nii.gz']);
    save_untouch_nii(label2_nii, [dir_name, filesep, 'label2_mcf.nii.gz']);
    
    delete([dir_name filesep 'labels_mcf.nii.gz']);
    delete([dir_name filesep 'labels.nii.gz']);
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Motion Correction:', html.font_post, '<br>'], ...
        [html.normal_pre, 'Reference Volume: ', num2str(p.Results.MCRefVol)], ...
        [', Cost function: ', p.Results.MCCost], ...
        [', DoF: ', num2str(p.Results.MCDoF)], ...
        [', Smooth: ', num2str(p.Results.MCSmooth)], ...
        [', Bins: ', num2str(p.Results.MCBins)], ...
        [', Discard Thresold:', num2str(p.Results.MCDiscardThreshold)], ...
        [', Volumes discarded: ', num2str(sum(~disc)), html.font_post, '<br><br>'], ...
        '<img src="label_trans.png"><br><br>');
    
    delete([dir_name, filesep, 'label_trans.txt']);
    delete([dir_name, filesep, 'label_trans_legend.txt']);
    
else
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Motion Correction:', html.font_post, '<br>'], ...
        [html.normal_pre, 'No motion correction performed.<br><br>', html.font_post]);
    
end

end


%% BRAIN EXTRACT LABELS FUNCTIONS

function [label1_nii, label2_nii, html] = aslpp_betlabel(label1_nii, label2_nii, p, html, dir_name)

if p.Results.BETLabel==1
    
    save_untouch_nii(label1_nii, [dir_name, filesep, 'label1_tmp.nii.gz']);
    save_untouch_nii(label2_nii, [dir_name, filesep, 'label2_tmp.nii.gz']);
    
    label1_bet_unix = ['bet2 ' dir_name, filesep, 'label1_tmp.nii.gz ' ...
        dir_name, filesep, 'label1_tmp_brain.nii.gz -f ' num2str(p.Results.BETLabelf) ...
        ' -g ' num2str(p.Results.BETLabelg) ' -m -n'];
    unix(label1_bet_unix);
    
    unix(['fslmaths ' dir_name, filesep, 'label1_tmp.nii.gz -mul ' ...
        dir_name, filesep, 'label1_tmp_brain_mask.nii.gz ', ...
        dir_name, filesep, 'label1_brain.nii.gz']);
    
    unix(['fslmaths ' dir_name, filesep, 'label2_tmp.nii.gz -mul ' ...
        dir_name, filesep, 'label1_tmp_brain_mask.nii.gz ', ...
        dir_name, filesep, 'label2_brain.nii.gz']);
    
    unix(['slices ', dir_name, filesep, 'label1_brain.nii.gz ', ...
        dir_name, filesep, 'label1_tmp_brain_mask.nii.gz ', ...
        '-o ', dir_name, filesep, 'label1_bet.png']);
    
    delete([dir_name, filesep, 'label1_tmp.nii.gz']);
    delete([dir_name, filesep, 'label2_tmp.nii.gz']);
    delete([dir_name, filesep, 'label1_tmp_brain_mask.nii.gz']);
    
    label1_nii = load_untouch_nii([dir_name, filesep, 'label1_brain.nii.gz']);
    label2_nii = load_untouch_nii([dir_name, filesep, 'label2_brain.nii.gz']);
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Brain Extract Labels:', html.font_post, '<br>'], ...
        [html.normal_pre, 'Fractional Intensity Threshold: ', num2str(p.Results.BETLabelf)], ...
        [html.normal_pre, ', Vertical Gradient on Fractional Intensity Threshold: ', num2str(p.Results.BETLabelg), html.font_post, '<br><br>'], ...
        '<img src="label1_bet.png"><br><br><br>');
    
else
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Brain Extract Labels:', html.font_post, '<br>'], ...
        [html.normal_pre, 'No motion correction performed.<br><br><br>', html.font_post]);
    
end

end


%% BRAIN EXTRACT M0 FUNCTIONS

function [m0_nii, html] = aslpp_betm0(m0_nii, p, html, dir_name)

if p.Results.BETLabel==1
    
    save_untouch_nii(m0_nii, [dir_name, filesep, 'm0_tmp.nii.gz']);
    
    m0_bet_unix = ['bet ' dir_name, filesep, 'm0_tmp.nii.gz ' ...
        dir_name, filesep, 'm0_brain.nii.gz -f ' num2str(p.Results.BETM0f) ...
        ' -g ' num2str(p.Results.BETM0g), ' -m'];
    unix(m0_bet_unix);
    
    
    unix(['slices ', dir_name, filesep, 'm0_tmp.nii.gz ', ...
        dir_name, filesep, 'm0_brain_mask.nii.gz ', ...
        '-o ', dir_name, filesep, 'm0_bet.png']);
    
    delete([dir_name, filesep, 'm0_tmp.nii.gz']);
    delete([dir_name, filesep, 'm0_brain_mask.nii.gz']);
    
    m0_nii = load_untouch_nii([dir_name, filesep, 'm0_brain.nii.gz']);
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Brain Extract M0:', html.font_post, '<br>'], ...
        [html.normal_pre, 'Fractional Intensity Threshold: ', num2str(p.Results.BETM0f)], ...
        [html.normal_pre, ', Vertical Gradient on Fractional Intensity Threshold: ', num2str(p.Results.BETM0g), html.font_post, '<br><br>'], ...
        '<img src="m0_bet.png"><br><br><br>');
    
else
    
    html.report = char(html.report, ...
        [html.heading_pre, 'Brain Extract M0:', html.font_post, '<br>'], ...
        [html.normal_pre, 'No motion correction performed.<br><br><br>', html.font_post]);
    
end


end


%% SUBTRACTION FUNCTION

function [diff_nii, html] = aslpp_subtraction(label1_nii, label2_nii, p, html, dir_name)
% SUBTRACT LABEL1 AND LABEL 2 USING SPECIFIED METHOD

switch p.Results.Subtraction
    
    case 'Pairwise1'
        
        diff = label1_nii.img-label2_nii.img;
        
    case 'Pairwise2'
        
        diff = label1_nii.img(:,:,:,2:end)-label2_nii.img(:,:,:,1:end-1);
        
    case 'Surround'
        
        diff = (label1_nii.img(:,:,:,1:end-1)+label1_nii.img(:,:,:,2:end))/2 - label2_nii.img(:,:,:,1:end-1);
        
    case 'Running'
        
        l = [2:label1_nii.hdr.dime.dim(5); 2:label1_nii.hdr.dime.dim(5)]; l = [1; l(:)]';
        c = [1:label1_nii.hdr.dime.dim(5)-1; 1:label1_nii.hdr.dime.dim(5)-1]; c = [c(:); label1_nii.hdr.dime.dim(5)]';
        diff = label1_nii.img(:,:,:,l) - label2_nii.img(:,:,:,c);
        
    case 'Sinc'
        
        reps = label1_nii.hdr.dime.dim(5);
        nvox = label1_nii.hdr.dime.dim(2)*label1_nii.hdr.dime.dim(3)*label1_nii.hdr.dime.dim(4);
        xi = 1.5:1:(reps-0.5);
        label1_rs = reshape(label1_nii.img, nvox, reps);
        label1_sinc_rs = zeros(nvox, reps-1);
        for n = 1:nvox
            if isequal(label1_rs(n,:), zeros(1,reps))==0
                label1_sinc_rs(n,:) = interp1_sinc(label1_rs(n,:), 1:reps, xi);
            end
        end
        
        label1_sinc = reshape(label1_sinc_rs, [label1_nii.hdr.dime.dim(2), label1_nii.hdr.dime.dim(3), label1_nii.hdr.dime.dim(4), label1_nii.hdr.dime.dim(5)-1]);
        diff = label1_sinc - label2_nii.img(:,:,:,1:end-1);
        
end

diff_nii = label1_nii; diff_nii.img = diff;
save_untouch_nii(diff_nii, [dir_name, filesep, 'diff.nii.gz']);

html.report = char(html.report, ...
    [html.heading_pre, 'Subtraction:', html.font_post, '<br>'], ...
    [html.normal_pre, p.Results.Subtraction, '<br><br><br>', html.font_post]);


end


%% OUTLIER DETECTION

function [diffav_nii, html] = aslpp_outliers(diff_nii, p, html, dir_name)

diffav = mean(diff_nii.img,4);
lims = prctile(nonzeros(diffav), [2 98]);
diffav_nii = diff_nii; diffav_nii.hdr.dime.dim(5)=1;
diffav_nii.img = diffav;
save_untouch_nii(diffav_nii, [dir_name, filesep, 'diffav.nii.gz']);
unix(['slices ', dir_name, filesep, 'diffav.nii.gz ', ...
    '-o ', dir_name, filesep, 'diffav_before.png', ...
    ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
delete([dir_name, filesep, 'diffav.nii.gz']);
clear diffav_nii diffav;


switch p.Results.OutlierMethod
    
    case 'None'
        
        diffav = mean(diff_nii.img,4);
        diffav_nii = diff_nii; diffav_nii.hdr.dime.dim(5)=1;
        diffav_nii.img = diffav;
        save_untouch_nii(diffav_nii, [dir_name, filesep, 'diffav.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'diffav.nii.gz ', ...
            '-o ', dir_name, filesep, 'diffav.png -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Outlier Detection:', html.font_post, '<br>'], ...
            [html.normal_pre, 'No Outlier detection performed.<br><br>', html.font_post], ...
            'Before and after.<br><img src="diffav_before.png">');
        
        
    case 'Tan'
        
        vols = size(diff_nii.img,4);
        m = zeros(1,vols); u = zeros(1,vols);
        
        for n = 1:vols
            m(n) = mean(nonzeros(diff_nii.img(:,:,:,n)));
            u(n) = std(nonzeros(diff_nii.img(:,:,:,n)));
        end
        
        M_m = mean(m);
        M_u = std(m);
        U_m = mean(u);
        U_u = std(u);
        
        if log(max(u)-min(u))>=1
            M_disc = abs(m) > M_m + p.Results.TanThreshold*M_u;
            U_disc = u > U_m + p.Results.TanThreshold*U_u;
            keep = ~M_disc | ~U_disc;
        else
            keep = ones(length(m))==1;
        end
        
        diffav = mean(diff_nii.img(:,:,:,keep),4);
        diffav_nii = diff_nii; diffav_nii.hdr.dime.dim(5)=1;
        diffav_nii.img = diffav;
        save_untouch_nii(diffav_nii, [dir_name, filesep, 'diffav.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'diffav.nii.gz ', ...
            '-o ', dir_name, filesep, 'diffav.png -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Outlier Detection:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Tan et al., (2009) outlier detection method using threshold of ', num2str(p.Results.TanThreshold), '. Volume discarded: ',  num2str(sum(~keep)),'<br><br', html.font_post], ...
            'Before and after.<br><img src="diffav_before.png"> <img src="diffav.png"><br><br><br>');
        
        
    case 'Maumet'
        
        dims = size(diff_nii.img);
        nvox = dims(1)*dims(2)*dims(3);
        diff_rs = reshape(diff_nii.img, [nvox, dims(4)]);
        diffav_rs = zeros(nvox,1);
        
        for n = 1:dims(4)
            if isequal(diff_rs(n,:), zeros(1,dims(4)))==0
                diffav_rs(n) = hubermest(diff_rs(n,:));
            end
        end
        
        diffav = reshape(diffav_rs, [dims(1), dims(2), dims(3)]);
        diffav_nii = diff_nii; diffav_nii.hdr.dime.dim(5)=1;
        diffav_nii.img = diffav;
        save_untouch_nii(diffav_nii, [dir_name, filesep, 'diffav.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Outlier Detection:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Maumet et al., (2014) outlier detection method.<br><br', html.font_post], ...
            'Before and after.<br><img src="diffav_before.png"> <img src="diffav.png"><br><br><br>');
        
        
    case 'Rich'
        
        diffav = mean(diff_nii.img,4);
        diffav_nii = diff_nii; diffav_nii.hdr.dime.dim(5)=1;
        diffav_nii.img = diffav;
        save_untouch_nii([dir_name, filesep, 'diffav.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Outlier Detection:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Not finished Rich outlier yet. None performed.<br><br><br>', html.font_post]);
        
end


end


%% CALIBRATION METHOD

function [calib_nii, html] = aslpp_calibration(diffav_nii, m0_nii, p, html, dir_name)

lims = prctile(nonzeros(m0_nii.img), [2 98]);
unix(['slices ', m0_nii.fileprefix, ...
    ' -o ', dir_name, filesep, 'm0_before.png', ...
    ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);


switch p.Results.CalibMethod
    
    case 'BBB'
        
        m0_calib_nii = m0_nii; m0_calib_nii.img = m0_calib_nii.img*p.Results.BBBval;
        save_untouch_nii(m0_calib_nii, [dir_name, filesep, 'm0_calib.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'm0_calib.nii.gz', ...
            ' -o ', dir_name, filesep, 'm0_calib.png', ...
            ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        calib = 6000*(diffav_nii.img./(m0_calib_nii.img));
        calib(isnan(calib) | isinf(calib)) = 0;
        calib(calib<0 | calib>1e4)=0;
        calib_nii = diffav_nii; calib_nii.img = calib;
        save_untouch_nii(calib_nii, [dir_name, filesep, 'diffav_calib.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Calibration:', html.font_post, '<br>'], ...
            [html.normal_pre, 'BBB partition coefficient = ', num2str(p.Results.BBBval), '.<br>', html.font_post], ...
            'Before and after.<br><img src="m0_before.png"> <img src="m0_calib.png"><br><br><br>');
        
        
    case 'GM'
        
        gm_R = 0.98;
        switch p.Results.FieldStrength
            case 1.5
                gm_T2s = 89;
                b_T2s = 140;
            case 3
                gm_T2s = 60;
                b_T2s = 50;
            case 7
                gm_T2s = 33;
                b_T2s = 16;
        end
        
        m0_calib = gm_R.*m0_nii.img.*exp(p.Results.CalibTE./gm_T2s - p.Results.CalibTE./b_T2s);
        m0_calib_nii = m0_nii; m0_calib_nii.img = m0_calib;
        save_untouch_nii(m0_calib_nii, [dir_name, filesep, 'm0_calib.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'm0_calib.nii.gz', ...
            ' -o ', dir_name, filesep, 'm0_calib.png', ...
            ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        calib = 6000*(diffav_nii.img./(m0_calib_nii.img));
        calib(isnan(calib) | isinf(calib)) = 0;
        calib(calib<0 | calib>1e4)=0;
        calib_nii = diffav_nii; calib_nii.img = calib;
        save_untouch_nii(calib_nii, [dir_name, filesep, 'diffav_calib.nii.gz']);
        
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Calibration:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Calibrate GM only. T2* of grey matter: ', num2str(gm_T2s), ', T2* of blood: ', num2str(b_T2s), ', GM/blood proton density ratio: ', num2str(gm_R), '.<br>', html.font_post], ...
            'Before and after.<br><img src="m0_before.png"> <img src="m0_calib.png"><br><br><br>');
        
        
    case 'WM'
        
        
        wm_R = 1.19;
        switch p.Results.FieldStrength
            case 1.5
                wm_T2s = 71;
                b_T2s = 140;
            case 3
                wm_T2s = 54;
                b_T2s = 50;
            case 7
                wm_T2s = 27;
                b_T2s = 16;
        end
        
        m0_calib = wm_R.*m0_nii.img.*exp(p.Results.CalibTE./wm_T2s - p.Results.CalibTE./b_T2s);
        m0_calib_nii = m0_nii; m0_calib_nii.img = m0_calib;
        save_untouch_nii(m0_calib_nii, [dir_name, filesep, 'm0_calib.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'm0_calib.nii.gz', ...
            ' -o ', dir_name, filesep, 'm0_calib.png', ...
            ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        calib = 6000*(diffav_nii.img./(m0_calib_nii.img));
        calib(isnan(calib) | isinf(calib)) = 0;
        calib(calib<0 | calib>1e4)=0;
        calib_nii = diffav_nii; calib_nii.img = calib;
        save_untouch_nii(calib_nii, [dir_name, filesep, 'diffav_calib.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Calibration:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Calibrate WM only. T2* of white matter: ', num2str(wm_T2s), ', T2* of blood: ', num2str(b_T2s), ', WM/blood proton density ratio: ', num2str(wm_R), '.<br>', html.font_post], ...
            'Before and after.<br><img src="m0_before.png"> <img src="m0_calib.png"><br><br><br>');
        
        
    case 'CSF'
        
        csf_R = 0.87;
        switch p.Results.FieldStrength
            case 1.5
                csf_T2s = 1000;
                b_T2s = 140;
            case 3
                csf_T2s = 500;
                b_T2s = 50;
            case 7
                csf_T2s = 75;
                b_T2s = 16;
        end
        
        m0_calib = csf_R.*m0_nii.img.*exp(p.Results.CalibTE./csf_T2s - p.Results.CalibTE./b_T2s);
        m0_calib_nii = m0_nii; m0_calib_nii.img = m0_calib;
        save_untouch_nii(m0_calib_nii, [dir_name, filesep, 'm0_calib.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'm0_calib.nii.gz', ...
            ' -o ', dir_name, filesep, 'm0_calib.png', ...
            ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        calib = 6000*(diffav_nii.img./(m0_calib_nii.img));
        calib(isnan(calib) | isinf(calib)) = 0;
        calib(calib<0 | calib>1e4)=0;
        calib_nii = diffav_nii; calib_nii.img = calib;
        save_untouch_nii(calib_nii, [dir_name, filesep, 'diffav_calib.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Calibration:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Calibrate CSF only. T2* of CSF: ', num2str(csf_T2s), ', T2* of blood: ', num2str(b_T2s), ', CSF/blood proton density ratio: ', num2str(csf_R), '.<br>', html.font_post], ...
            'Before and after.<br><img src="m0_before.png"> <img src="m0_calib.png"><br><br><br>');
        
        
    case 'PVMaps'
        
        pvmaps_nii = load_untouch_nii(p.Results.CalibPVMap);
        
        gm_R = 0.98;
        wm_R = 1.19;
        csf_R = 0.87;
        
        switch p.Results.FieldStrength
            case 1.5
                gm_T2s = 89;
                wm_T2s = 71;
                csf_T2s = 1000;
                b_T2s = 140;
            case 3
                gm_T2s = 60;
                wm_T2s = 54;
                csf_T2s = 500;
                b_T2s = 50;
            case 7
                gm_T2s = 33;
                wm_T2s = 27;
                csf_T2s = 75;
                b_T2s = 16;
        end
        
        gm_calib = pvmaps_nii.img(:,:,:,1).*gm_R.*exp(p.Results.CalibTE/gm_T2s - p.Results.CalibTE/b_T2s);
        wm_calib = pvmaps_nii.img(:,:,:,2).*wm_R.*exp(p.Results.CalibTE/wm_T2s - p.Results.CalibTE/b_T2s);
        csf_calib = pvmaps_nii.img(:,:,:,3).*csf_R.*exp(p.Results.CalibTE/csf_T2s - p.Results.CalibTE/b_T2s);
        
        m0_calib = m0_nii.img.*(gm_calib+wm_calib+csf_calib);
        m0_calib_nii = m0_nii; m0_calib_nii.img = m0_calib;
        save_untouch_nii(m0_calib_nii, [dir_name, filesep, 'm0_calib.nii.gz']);
        
        unix(['slices ', dir_name, filesep, 'm0_calib.nii.gz', ...
            ' -o ', dir_name, filesep, 'm0_calib.png', ...
            ' -i ', num2str(lims(1)), ' ', num2str(lims(2))]);
        
        calib = 6000*(diffav_nii.img./(m0_calib_nii.img));
        calib(isnan(calib) | isinf(calib)) = 0;
        calib(calib<0 | calib>1e4)=0;
        calib_nii = diffav_nii; calib_nii.img = calib;
        save_untouch_nii(calib_nii, [dir_name, filesep, 'diffav_calib.nii.gz']);
        
        html.report = char(html.report, ...
            [html.heading_pre, 'Calibration:', html.font_post, '<br>'], ...
            [html.normal_pre, 'Using partial volume maps of GM, WM and CSF.'], ...
            [' T2* of GM: ', num2str(gm_T2s), ', GM/blood proton density ratio: ', num2str(gm_R)], ...
            [', T2* of WM: ', num2str(wm_T2s), ', WM/blood proton density ratio: ', num2str(wm_R)], ...
            [', T2* of CSF: ', num2str(csf_T2s), ', CSF/blood proton density ratio: ', num2str(csf_R), '.<br>', html.font_post], ...
            'Before and after.<br><img src="m0_before.png"> <img src="m0_calib.png"><br><br><br>');
        
end

unix(['slices ', dir_name, filesep, 'diffav_calib.nii.gz', ...
    ' -o ', dir_name, filesep, 'diffav_calib.png']);

html.report = char(html.report, ...
    [html.heading_pre, 'Final PWIs:', html.font_post, '<br>'], ...
    '<br><img src="diffav_calib.png"><br><br><br>');

end


%% FPMRI

function [path, file, ext] = fpmri(file)

if strcmp(file((end-6):end), '.nii.gz')
    file = file(1:end-7);
    [path, file] = fileparts(file);
    ext = '.nii.gz';
elseif strcmp(file((end-4):end), '.nii')
    file = file(1:end-4);
    [path, file] = fileparts(file);
    ext = '.nii';
elseif strcmp(file((end-4):end), '.img')
    file = file(1:end-4);
    [path, file] = fileparts(file);
    ext = '.img';
elseif strcmp(file((end-4):end), '.hdr')
    file = file(1:end-4);
    [path, file] = fileparts(file);
    ext = '.hdr';
end

end