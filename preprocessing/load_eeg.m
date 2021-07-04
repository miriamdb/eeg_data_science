function EEG = load_eeg(params, fname)

eeg_path = fullfile(params.paths.raw_data, fname);

eeg_type = strsplit(fname, '.');
setname  = eeg_type{1};
eeg_type = eeg_type{end};
switch eeg_type
    case 'cnt'
        EEG = pop_loadcnt(eeg_path);
    case 'edf'
        EEG = pop_biosig(eeg_path);
    otherwise
        fprintf('this file type - %s - is not sopported\n', eeg_type);
        eeglab
end

EEG.setname = setname;
end