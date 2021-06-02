function fnames = get_file_names (path, ext)

if nargin < 2
    ext = ''; 
    st = 3; 
else 
    ext = strcat('*.', ext); 
    st = 1; 
end 

files = dir(fullfile(path, ext));
files = files(st:end); %2 empty folders at the start in case we took all 
fnames = {}; 

for f = 1:length(files)
    fnames{f} = files(f).name; 
end

end 