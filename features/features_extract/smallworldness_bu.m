function S = smallworldness_bu(W,RW)

% source: GrapthVar toolbox 

% W = my network 
% RW = some random networks with the same degree distribution 
% as the original brain functional network

cm = zeros(length(RW),1);
cp = zeros(length(RW),1);

for i=1:length(RW)
    cm(i) =  clusterMean_bu(RW{i});
    cp(i) =  charpath_B(RW{i});
end
S = (clusterMean_bu(W)/mean(cm))/(charpath_B(W)/mean(cp));

% S = (C/C_random)/(L/L_random)
% C is  average clustering coefficient 
% L is characteristic path length

end