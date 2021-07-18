%{
extracts features from set (EEGLAB) file
%}

%% set path
close all; 
clear all; 
clc; 

this_path = pwd;
this_path = this_path(1:end-16);

filepath = strcat(this_path, 'pre_process\preproc_data\pp_rej_ica\');
files = dir(fullfile(filepath, '*.set'));

load eeg_freqs;

%% spectral features - power

for i = 1:numel(files)
    filename = files(i).name;
    sub = filename(1:end-19);
    sub_mat = strcat('features\\',sub,'_power.mat');
    
    % check if the analysis was already done for this measurement
    if ~isfile(sub_mat)
        
        EEG = pop_loadset('filename',filename,'filepath',filepath);
        
        chan_len = size(EEG.data,1);
        
        % a matrix with 30 (each channel + all)
        % * 5 (delta, theta, alpha, beta, gamma)
        power_matrix = nan(chan_len+1, 5);
        for chan = 1:chan_len
            power_matrix(chan,:) = SpectralFeats(EEG, chan);
        end
        power_matrix(end,:) = SpectralFeats(EEG, 'all');
        
    end
    
    save(sub_mat,'power_matrix');
end

%% connectivity featrues

filename_array = {};
eyes = {};
freqs_array = {};
freqs_names = fieldnames(freqs);

i = 1;

% loop through all recordings
for recording = 1 : numel(files)
    
    filename = files(recording).name;
    sub = filename(1:end-19);
    
    EEG = pop_loadset('filename',filename,'filepath',filepath);
    
    % loop through 5 EEG frequencies
    for f = 1 : numel(freqs_names)
        
        filename_array{i} = sub;
        subject(i)  = str2num(sub(5:6));
        session(i)  = str2num(sub(12));
        eyes{i}  = sub(19:end);
        
        this_freq = freqs.(freqs_names{f}); % numbers
        
        ord = 100; % the order control how tight the filtering is
        
        EEG_filt = eeg_emptyset;
        EEG_filt.data = bfilty(EEG.data', ord, this_freq, EEG.srate, 'b')';
        EEG_filt.srate = EEG.srate;
        EEG_filt.nbchan = EEG.nbchan;
        
        [kappa, alpha, av_degree, av_clustcoef, char_path, small_worldness] = ConnFeats(EEG_filt);
        
        freqs_array{i} = freqs_names{f};
        kappa_array(i) = kappa;
        alpha_array(i)  = alpha;
        av_degree_array(i)  = av_degree;
        av_clustcoef_array(i)  = av_clustcoef;
        char_path_array(i)  = char_path;
        small_worldness_array(i)  = small_worldness;
        
        i = i + 1;
    end
end

VariableNames = {'filename', 'subject', 'session', 'eyes', 'freq',...
    'kappa', 'alpha', 'av_degree', 'av_clustcoef', 'char path', 'small_worldness'};

conn_feats = table(filename_array', subject', session', eyes', freqs_array',...
    kappa_array', alpha_array', av_degree_array', av_clustcoef_array',...
    char_path_array', small_worldness_array');

conn_feats.Properties.VariableNames = VariableNames;


% save data as a csv
now = datetime;
now.Format = 'dd-MM-yyyy';
str_date = string(now);
tableame = strcat( 'features/conn_feats_', str_date, '.csv');
writetable(conn_feats, tableame);

fprintf('DONE! data is saved under the name %s.\n', tableame);
