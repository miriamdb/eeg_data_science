% EEGLAB history file generated on the 30-May-2021
% ------------------------------------------------

EEG.etc.eeglabvers = '2021.0'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_loadcnt('C:\Users\Miriam\Google Drive\data_she_codes\b_preprocessing\raw_data\0035_022310_RestEyesClosed_RS_1.cnt' , 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\Miriam\\Dropbox (BGU)\\Miriam Dissen Ben Or\\code\\toolboxes\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
EEG = eeg_checkset( EEG );
