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