pathname ='/Volumes/ares/data/IBD/ASL/ASL_gita/Healthy/';

subjectlist={'001_H07_V1','001_H08_V1','001_H08_V2','001_H09_V1','001_H09_V2','001_H11_V1','001_H11_V2','001_H13_V1','001_H13_V2',...
    '001_H14_V1','001_H14_V2','001_H15_V1','001_H15_V2','001_H16_V1','001_H16_V2','001_H17_V1','001_H19_V1','001_H19_V2',...
    '001_H23_V1','001_H23_V2','001_H24_V1','001_H24_V2','001_H25_V1','001_H25_V2','001_H27_V1','001_H27_V2','001_H28_V1','001_H28_V2',...
    '001_H29_V1','001_H29_V2','001_H30_V1','001_H30_V2'};

subjectlistP={'001_P01_V1','001_P01_V2','001_P02_V1','001_P02_V2','001_P03_V1','001_P03_V2','001_P04_V1','001_P04_V2','001_P05_V1','001_P05_V2',...
	'001_P06_V1','001_P06_V2','001_P07_V1','001_P08_V1','001_P08_V2','001_P09_V1','001_P09_V2','001_P10_V1','001_P10_V2','001_P11_V1',...
	'001_P12_V1','001_P12_V2','001_P13_V2','001_P14_V1','001_P15_V1','001_P15_V2','001_P16_V1','001_P17_V1','001_P18_V1','001_P18_V2',...
	'001_P19_V1','001_P19_V2','001_P20_V1','001_P20_V2','001_P21_V1','001_P21_V2','001_P22_V1','001_P22_V2','001_P23_V1','001_P23_V2',...
	'001_P24_V1','001_P24_V2','001_P37_V1','001_P37_V2','001_P40_V1','001_P40_V2','001_P41_V1','001_P41_V2','001_P42_V1','001_P42_V2',...
	'001_P43_V1','001_P43_V2','001_P44_V1','001_P44_V2','001_P45_V1','001_P45_V2','004_P01_V1','004_P01_V2'};

cd(pathname)


%subjectlist = {'001_H07_V2'};
for ii = 1:length(subjectlist)
    cd([pathname subjectlist{ii}])
    % build a name
    % Get a list of all files in the folder with the desired file name pattern.
    myFolder = pwd; % Wherever you want.
    filePattern = fullfile(myFolder, '*label1*'); % Change to whatever pattern you need, for example *.m or whatever...
    theFiles = dir(filePattern); % Ask operating system for the directory information.
    % Extract only the filename part of the structure into its own variable.
    allFileNames = {theFiles.name};
    
    filePattern2 = fullfile(myFolder, '*base*');
    theFiles2 = dir(filePattern2);
    allFileNames2 = {theFiles2.name};
    
    
    for jj=1:length(allFileNames)
        
        aslpp(allFileNames{jj},allFileNames2{jj});
        
    end
    
    
    
   
    
    
   % aslpp(subjectlist(ii)
   
end