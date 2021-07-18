% Neuronal Avalanche analysis
% Analyze directory with datasets
% Computational Psychiatry Lab

clear all; close all; clc;

%%

addpath('..\..\..\AvalancheToolbox1.1'); 
addpath('..\..\..\AvalancheToolbox1.1\Avalanche statistics');
addpath('..\..\..\AvalancheToolbox1.1\Avalanche statistics\util');
addpath('..\toolboxes\eeglab2021.0');

eeglab nogui;

params = get_params_criticality(); 

%%

D = dir(fullfile(params.dir_name, sprintf('*.%s',params.ext))); % find all datasets in the directory
n_files = length(D);
disp(['Total number of datasets: ' num2str(n_files)]);

%% phase shuffling 
%TODO understand what is it? 
use_ps = 0; % default = 0;
if use_ps,
    ps_str = '_ps';
else
    ps_str = '';
end

%% Analysis by file
count = 0;
for n = 1:n_files 
    tic
    count = count + 1;
    fname = D(n).name; disp(fname)
    EEG = pop_loadset('filename',fname,'filepath',params.dir_name); %SET
    %EEG = pop_biosig(fullfile(dir_name, fname)); %EDF
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    DATA = EEG.data;
    
    % y_pre - Each row corresponds to a single channel and columns correspond to time samples
    y_pre = DATA; clear DATA;
    y_pre(:,1:params.Start) = []; y_pre(:,params.End:end) = []; %Removing initial and final samples.
    
    % normalize data (z-scoring)
    t = params.dt*(1:size(y_pre,2)); % time vector
    T = t(end);
    y_m = mean(y_pre,2); % a column vector with the mean of each channel
    y_std = std(y_pre,0,2); % a column vector with the SD of each channel
    y_dev = zeros(size(y_pre)); % initialize y_dev
    for k = 1:size(y_pre,1),
        y_dev(k,:) = (y_pre(k,:) - y_m(k))/y_std(k);
    end
    
    % perform avalanche analysis
    [Datasets(n).AvalancheResults]  = FindAvalanchesP(params, y_dev, t, 1, 1, fname);
    
    close all; 

    
    T1 = toc;
    T_left = (n_files-count)*T1/60;
    disp(['Time left: ' num2str(T_left) ' min']);
    

end

save (strcat('Results\Datasets_', date), 'Datasets');

%{
% F9
publish('CriticalityFeatures.m');
web('html/CriticalityFeatures.html');
%}
