function [kappa, alpha, av_degree, av_clustcoef, char_path, S] = ConnFeats(EEG, kappa, alpha)

if nargin < 2 || isempty(kappa)
    kappa = 0.04;
end

if nargin < 3 || isempty(alpha)
    alpha = 0.5;
end


%{
General articles with explanations
https://www.sciencedirect.com/science/article/pii/S2467981X17300276
https://downloads.hindawi.com/journals/jhe/2010/707290.pdf
https://journals.sagepub.com/doi/pdf/10.1177/1073858406293182
%}

%% 1 - EEG 2 Network

N_CHAN = EEG.nbchan;
eegmat = EEG.data;
eegmat = eegmat';
srate = EEG.srate;

time = size(eegmat, 1);

win = srate;

epoch = 1;
rho = zeros(N_CHAN, N_CHAN, 1);

while (epoch * win) + win -1 < time
    eeg_epoch = eegmat(epoch * win : epoch * win + win - 1, :);
    %rho(:,:,epoch) = partialcorr(eeg_epoch);
    rho(:,:,epoch) = corr(eeg_epoch);
    % partial is recommended (JALILI & KNYAZEVA, 2011)
    
    if size(rho(:,:,epoch)) ~= N_CHAN
        error("network size is not as channels number")
    end
    
    epoch = epoch +1;
end

eeg_net = mean(rho,3);

A = net2graph(eeg_net, kappa); 



%% 2 - Extract measures of the network

% average degree
k = degree(A);
av_degree = mean(k);

% efficiency

% clustering coefficient
C = clustering_coef_bu(A);
av_clustcoef = mean(C);

%modularity

% small worldness
D = distance_bin(A);
[char_path,~, ~, ~] = charpath(D, 0, 0);       % not inclueding inf nodes = not connected nodes
N_RAND = 10;

RW = {};
for i = 1: N_RAND
    RW{i} = randomizer_bin_und(A,alpha);
end

S = smallworldness_bu(A,RW);

% mean node betweenness centraligy

% mean edge betweenness centraligy

% variance of node degrees

% assortativity

% 1 (number) /lambda2

% lambdaN / lambda2
end