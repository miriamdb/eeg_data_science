% preprocess EEG data

% Prerequisites:
%  The CompPsyLab EEGLAB Toolbox 

%%
clear all;
close all;
clc;

%% Load parameters 

params = get_params(); 

%% Create paths 

params.paths = create_dirs(params.paths); 

%% Start EEGLAB

addpath(params.paths.eeglab); 
eeglab nogui;

%% clean data

files = get_file_names(params.paths.raw_data);

for f_num = 1 : length(files)
    
    fname = files{f_num};
    fprintf('Started working on the file: %s\n', fname);
        
    EEG = load_eeg(params, fname);
    EEG = basic_clean(params, EEG);
    EEG = run_ica(params, EEG); 
    EEG = clean_ica(params, EEG); 
    
end




