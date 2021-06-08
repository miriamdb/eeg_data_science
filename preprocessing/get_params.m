function params = get_params()

% paths 
params.paths.raw_data = 'raw_data'; 
params.paths.out = '..\Results'; 
params.paths.pre = '\1.Preprocessed'; 
params.paths.ica = '\2.ICA'; 
params.paths.clean = '\3.Clean'; 
params.paths.eeglab = '..\..\..\Documents\MATLAB\eeglab2019_1'; 

% parameters for cleaning eeg 
params.eeg.down_srate = 250;       % down sample rate for EEG   [Hz]
params.eeg.rej_time = 10;          % time to reject at begening [sec]
params.eeg.linefreqs = [50, 100];  % DC
params.eeg.highpass = 1; 
params.eeg.lowpass = 40; 
params.eeg.chanlocs = 'plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp';

% extentions
params.ext.data = 'mat';
params.ext.eeglab = 'set';

end 