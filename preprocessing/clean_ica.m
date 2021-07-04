function  EEG = clean_ica(params, EEG)

% TODO
% try runica and visualise the icas 
% then use this line EEG.etc.ic_classification.ICLabel.classes{1} to see
% how it's represents and find the good ICAs 




 % Perform IC rejection using ICLabel scores and r.v. from dipole fitting.
 % from https://sccn.ucsd.edu/pipermail/eeglablist/2021/016294.html
EEG       = IClabel(EEG, 'default');
 brainIdx  = find(EEG.etc.ic_classification.ICLabel.classifications(:,1)>= 0.7);
 rvList    = [EEG.dipfit.model.rv];
 goodRvIdx = find(rvList < 0.15);
 goodIcIdx = intersect(brainIdx, goodRvIdx);
 EEG = pop_subcomp(EEG, goodIcIdx, 0, 1);
 EEG.etc.ic_classification.ICLabel.classifications = ...
     EEG.etc.ic_classification.ICLabel.classifications(goodIcIdx,:);
 
 
 
 % from https://github.com/sccn/ICLabel
 EEG = iclabel(EEG);
EEG.etc.ic_classification.ICLabel.classes{1} %brain

 
end 