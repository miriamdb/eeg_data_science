function A = net2graph(eeg_net, kappa)

A = eeg_net - diag(diag(eeg_net));              % zero self connections
A = abs(A);                                     % make grpah not signed 

[A, TH] = threshold_proportional(A, kappa);     % find TH and zero

A(A >= TH) = 1;                                 % binarize graph

% A = abs(eeg_net);
% A(A >= TH) = 1;
% A(A < TH) = 0;

end 