% EEGLAB history file generated on the 03-Mar-2021
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','sub-01_ses-1_eyes-closed_eeg_pp_rej_ica.set','filepath','C:\\Users\\cognitive\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\pre_process\\preproc_data\\pp_rej_ica\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','sub-01_ses-1_eyes-closed_eeg_pp_rej_ica.mat','filepath','C:\\Users\\cognitive\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\pre_process\\preproc_data\\pp_rej_ica\\');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
pop_export(EEG,'C:\\Users\\cognitive\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\pre_process\\preproc_data\\pp_rej_ica\\sub-01_ses-1_eyes-closed_eeg_pp_rej_ica.mat','transpose','on','precision',4);
EEG = eeg_checkset( EEG );
pop_export(EEG,'C:\\Users\\cognitive\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\pre_process\\preproc_data\\pp_rej_ica\\sub-01_ses-1_eyes-closed_eeg_pp_rej_ica.xls','transpose','on','precision',4);
eeglab redraw;
