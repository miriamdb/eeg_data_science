% define eeg frequncies for the analysis 
% from EEGLAB recommendation online 

clear all;

eeg_freqs = struct;

eeg_freqs.delta = [1 4]; 
eeg_freqs.theta = [4 8];
eeg_freqs.alpha = [8 13];
eeg_freqs.beta = [13 30];
eeg_freqs.gamma = [30 80];

save('eeg_freqs', 'eeg_freqs');