function EEG = run_ica(params, EEG)

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','off');
EEG = eeg_checkset(EEG);

pop_saveset(EEG, ...
    'filename', EEG.setname, ...
    'filepath', params.paths.ica_dir);

end