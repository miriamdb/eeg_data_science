% EEGLAB history file generated on the 08-Jun-2021
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','sub-01_ses-1_eyes-closed_eeg_pp_rej_ica.set','filepath','C:\\Users\\Miriam\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\pre_process\\preproc_data\\pp_rej_ica\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw;
