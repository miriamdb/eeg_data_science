% preprocess EEG data

% Prerequisites:
% 1. The CompPsyLab EEGLAB Toolbox (for the automatic rejection of ICA
%    components).

% This code is partly a modification of Aviv Dotan's work

%%
% Clear the workspace, figures and command line.
clear all;
close all;
clc;


%% Set paths and extentions

% Input files
inputs_path = 'raw_data';
%channels_path = '\Miscellaneous\chanlocs32.sfp';

% Output path
out_path = '..\Results';
make_path(out_path)


% Output files
data_path = [out_path '\1.Preprocessed'];
ica_path = [out_path '\2.ICA'];
clean_path = [out_path '\3.Clean'];

% Log files
clean_log = '.\clean_log.txt';

% Plots files
%tmp_ps_file = '.\_tmp.ps';
%pdf_file = '.\Aviv_SD_Results.pdf';

% Extentions
data_ext = 'mat';
eeglab_ext = 'set';

% Toolboxes 
eeglab_path = 'C:\\Users\\Miriam\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\toolboxes\\eeglab2021.0'; 


%% parameters
down_srate = 250;       % down sample rate for EEG

%% Start EEGLAB

% add path?
eeglab nogui;

%% Preprocess

make_path(data_path);

files = get_file_names(inputs_path);

for f_num =  1 : length(files)
    
    fname = files{f_num};
    disp(fname);
    
    % load eeg file
    eeg_type = strsplit(fname, '.');
    eeg_type = eeg_type{end};
    switch eeg_type
        case 'cnt'
            EEG = pop_loadcnt(fullfile(inputs_path, fname));
        case 'edf'
            EEG = pop_biosig(fullfile(inputs_path, fname));
        otherwise
            disp('please use eeglab to load your data');
            eeglab
    end
    
    %downsample data
    if EEG.srate>300
        EEG = pop_resample(EEG, down_srate);
    end
     EEG = eeg_checkset(EEG);

    % Clean the electricity line frequency
    EEG = pop_cleanline(EEG, ...
        'linefreqs', [50, 100], ...
        'computepower', 0, ...
        'VerboseOutput',0);
    EEG = eeg_checkset(EEG);

    % Filter the data (between 1-40 Hz):
    EEG = pop_eegfiltnew(EEG, 1, 40);
    EEG = eeg_checkset(EEG);

    % Rereference the data to average reference:
    EEG = pop_reref(EEG, []);
    EEG = eeg_checkset(EEG);
    
    % add locaion 
    EEG = pop_chanedit(EEG, 'lookup', fullfile(eeglab_path, 'plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp'));
    EEG = eeg_checkset( EEG );

    % remove bad channels & interpulate 
    full_EEG = EEG; 
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
    EEG = eeg_checkset( EEG );

    EEG = pop_interp(EEG, full_EEG.chanlocs, 'spherical');
    EEG = eeg_checkset( EEG );

    pop_saveset(EEG, ...
        'filename', fname, ...
        'filepath', data_path);
end


%% ICA

make_path(ica_path);

files = get_file_names(data_path, eeglab_ext);


for f_num =  1 : length(files)
    
    fname = files{f_num};
    
    % Load the data
    EEG = pop_loadset(...
        'filename', fname, ...
        'filepath', data_path);
    
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




