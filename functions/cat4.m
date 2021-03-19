function cat4(outfile, infiles)

str = ['fslmerge -t ', outfile];

for n = 1:size(infiles,1)
    str = [str, ' ', infiles{n}];
end

unix(str);

end