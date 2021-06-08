% preprocess EEG data

% Prerequisites:
%  The CompPsyLab EEGLAB Toolbox 

% This code is partly a modification of Aviv Dotan's work

%%
% Clear the workspace, figures and command line.
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

%% Preprocess

files = get_file_names(params.paths.raw_data);

for f_num =  1 : length(files)
    
    fname = files{f_num};
    disp(fname);
        
    EEG = load_eeg(params, fname);
    EEG = basic_clean(params, EEG);
    EEG = run_ica(params, EEG); 
    
end


%% ICA


files = get_file_names(pre_path, eeglab_ext);


for f_num =  1 : length(files)
    
    fname = files{f_num};
    
    % Load the data
    EEG = pop_loadset(...
        'filename', fname, ...
        'filepath', pre_path);
    
    % ICA
    %{
    EEG = pop_runica(EEG, ...
        'extended', 10, ...
        'pca', EEG.nbchan - 1, ...
        'weights', randn(EEG.nbchan - 1)./EEG.nbchan, ...
        'block', ceil(sqrt(EEG.pnts)), ...
        'anneal', 0.9, ...
        'reset_randomseed', 'no', ...
        'interupt', 'off');
    %}
    
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','off');
    EEG = eeg_checkset( EEG );

    
    % Save ICA results
    pop_saveset(EEG, ...
        'filename', file_names{f}, ...
        'filepath', ica_path);
    clear EEG;
    
end

%% Clean




