% EEGLAB history file generated on the 01-Jul-2021
% ------------------------------------------------

EEG.etc.eeglabvers = '2019.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_biosig('C:\Users\Miriam\Google Drive\eeg_data_science\preprocessing\raw_data\hel-01_ses-1_eyes-closed_eeg.edf');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\Miriam\\Documents\\MATLAB\\eeglab2019_1\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp');
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
EEG = eeg_checkset( EEG );
pop_selectcomps(EEG, [1:36] );
EEG = eeg_checkset( EEG );
pop_ADJUST_interface(  );
