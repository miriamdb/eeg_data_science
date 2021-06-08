function EEG = load_eeg(params, fname) 

     eeg_path = fullfile(params.paths.raw_data, fname);

% load eeg file
    eeg_type = strsplit(fname, '.');
    eeg_type = eeg_type{end};
    switch eeg_type
        case 'cnt'
            EEG = pop_loadcnt(eeg_path);
        case 'edf'
            EEG = pop_biosig(eeg_path);
        otherwise
            disp('please use eeglab to load your data');
            eeglab
    end
    
end 