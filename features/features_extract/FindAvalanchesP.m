function [AvalancheResults] = FindAvalanchesP(params, y_dev,t, plot_flag, est_sigma_flag, fname)

% FindAvalanches - Segment data to avalanches.
% INPUT:
% y_dev - N_chan-by-N_times matrix of channel data
% t - 1-by-N_times vector with time stamps
% tau - time scale for the avalanche analysis
% std_TH - threshold for event detection (default = 3)
% est_sigma_flag - binary flag for estimation of sigma (default = 0)
% plot_flag - flag for plotting options. 0 = no plot. 1 = standard plot. (default = 1)
% main output is a matrix (av_raster) from which one can extract which channels were active in each time bin.
% There is also a vector (av_label) which has 0 in all silent bins and the serial number of the avalanche in all other bins

% Version 4 - plot_flag option added

ES_min = params.ES_min; 
ES_max = params.ES_max; 
ES_edges = params.ES_edges;
tau_vec = params.tau_vec;
maxmin_str = params.MaxMin;
std_TH = params.std_TH; 
est_sigma_flag = params.est_sigma_flag;

%{
if nargin<7
    plot_flag = 1;
    if nargin<6,
        est_sigma_flag = 0;
        if nargin<5,
            std_TH = 3;
        end
    end
end
%}

N_chan = size(y_dev,1); % number of channels
chan_set = 1:N_chan;
TH_vec = [-std_TH std_TH];
t_end = t(end);
dt = t(2)-t(1); % time step of recording

xSize = 7; ySize = 9.5; xLeft = (8.5 - xSize)/2; yTop = (11 - ySize)/2;%Graphic parameters

% Output
AvalancheResults = struct('av_raster',[], 'av_label', [], 'av_size_vec', [], 'sigma_vec', []);


%% build raster (at a temporal resolution of dt)
%tau = tau_vec(1);
t_grid = (0:dt:t_end); % creat a grid with bins of size tau
% t_grid = (0:tau:t_end); % creat a grid with bins of size tau
N_tau = length(t_grid); % number of bins of size tau
av_raster = zeros(N_chan,N_tau); % initialize raster matrix

for ch = chan_set,
    y1 = y_dev(ch,:); % extract single channel
    ind_peaks = FindEvents(y1,TH_vec,maxmin_str); % detect events in this channel
    t1_events = t(ind_peaks); % times of events in this channel
    av_raster(ch,:) = histc(t1_events,t_grid); % find number of events from this channel in each bin
end % loop over single channels


%% loop over time scales of analysis
for tau_count=1:length(tau_vec)
    tau = tau_vec(tau_count);
    t_grid = (0:tau:t_end); % creat a grid with bins of size tau
    N_tau = length(t_grid); % number of bins of size tau
    
    % reshape raster of smallest tau into rasters for larger dt
    if tau_count>1 %Reshaping only from the second tau
        CutPoint = size(av_raster,2)-mod(size(av_raster,2),tau_count); % Take length relevant to tau and truncate the residue
        M1=av_raster(:,1:CutPoint); M2=av_raster(:,CutPoint+1:end); %M2 is the samples in the end of the signal, not inculded in M1
        RasterM1 = reshape(M1',tau_count,numel(M1)/tau_count); %  reshape M1  so row  Concatunate the channels, 
        RasterM2 = sum(RasterM1);
        Raster = reshape(RasterM2,size(M1,2)/tau_count,N_chan)';
        Raster = [Raster sum(M2,2)];
        AvalancheResults(tau_count).av_raster = Raster;
    else %When tau=tau_vec(1), don't reshape av_raster
        Raster = av_raster;
        AvalancheResults(tau_count).av_raster = av_raster;
    end
    
    % avalanche segmentation
    tp = sum(Raster); % find number of events from all channels in each bin
    tp_bin = tp>0; % create a binary vector of empty vs. non-empty bins
    tp_edges = diff(tp_bin); % find edges of avalanches (1 when avalanche starts, -1 when avalanche ends)
    ind_first1 = find(tp_edges==1,1,'first'); % find starting point of the first avalanche
    tp_edges(1:(ind_first1-1))=0; % set everything before the first avalanche to 0 (in case we had the end of a previous avalanche)
    ind_av_start = find(tp_edges==1)+1; % bins where avalanches start
    ind_av_end = find(tp_edges==-1); % bins where avalanches end
    N_avalanches = min([length(ind_av_start) length(ind_av_end)]); % number of avalanches
    ind_av_start = ind_av_start(1:N_avalanches); % indices where avalanches start
    ind_av_end = ind_av_end(1:N_avalanches); % indices where avalanches end
    
    av_label = zeros(1,N_tau);
    sigma_vec = zeros(1,N_avalanches);
    av_size_vec = zeros(1,N_avalanches);
    av_dur_vec = zeros(1,N_avalanches);
    for n_av = 1:N_avalanches, % loop over avalanches
        av_bin1 = ind_av_start(n_av); % first bin
        av_bin2 = ind_av_end(n_av); % last bin
        av_label(av_bin1:av_bin2) = n_av; % label all the bins of this avalanche with the serial number of this avalanche
        av_size_vec(n_av) = sum(tp(av_bin1:av_bin2)); % sum events from all bins in this avalanche to calculate the size
        av_dur_vec(n_av) = sum(tp_bin(av_bin1:av_bin2)); % find duration of avalanche
        if est_sigma_flag, % estimate sigma
            N_peaks1 = tp(av_bin1); % number of events in first bin ("ancestors")
            N_peaks2 = tp(av_bin1+1); % number of events in second bin ("decendants")
            sigma_vec(n_av) = N_peaks2/N_peaks1; % ratio of decendants to ancestors
        end
    end
    AvalancheResults(tau_count).av_label = av_label;
    AvalancheResults(tau_count).av_size_vec = av_size_vec;
    AvalancheResults(tau_count).av_dur_vec = av_dur_vec;
    AvalancheResults(tau_count).sigma_vec = sigma_vec;
    
    AvalancheResults(tau_count).alpha = estimateParamML(ES_min,ES_max,'zeta',1.5,av_size_vec);
    AvalancheResults(tau_count).sigma = mean(sigma_vec);
    %     num_of_av =  length(av_size_vec);
    disp('----------------');
    
    R = sum(AvalancheResults(tau_count).av_raster,2)/t(end); % rate of events in each channel
    %     [R_sort,ind_R_sort] = sort(R,1,'descend');
    
    if plot_flag
        % show raster
        
        figure;set(gcf,'Color','w');
        set(gcf,'PaperUnits','inches');
        set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        set(gcf,'Position',[570 40 xSize*75 ySize*75])
        
        fname = strrep(fname, '_', ' ');
        fname = split(fname, 'eeg');
        fname = fname{1}; 
        
        suptitle(fname)

        
        
        subplot(2,2,1);
        RasterPlot(AvalancheResults(tau_count).av_raster,params.Fs,tau);title(['tau = ' num2str(tau) ' - Raster']);
        drawnow
        
        
        subplot(2,2,2)
        % plot(y_dev(4,:))
        RasterPlot(av_raster,params.Fs,tau,[params.t1 params.t2]);title('zoom in');
        drawnow
        
        
        % show channel rates
        subplot(2,2,3);
        stem(R); set(gca,'XLim',[1 N_chan]);
        title('Event rate in each channel');
        xlabel('Channel #');
        ylabel('Events/sec');
        %     [ind_R_sort(1:5) R_sort(1:5)];    disp(' ')
        
        % calculate avalanche distribution
        [size_dist, ES_edges1] = NormalizedDist(av_size_vec,ES_edges);
        
        
        subplot(2,2,4); title('Avalanche distribution');
        loglog(ES_edges1,size_dist,'LineWidth',2); hold on;
        xx = 1:300; yy = xx.^(-1.5);loglog(xx,yy,'k--','LineWidth',3)
        set(gca,'XLim',[0 310]);
        xlabel('S');ylabel('P(S)');
        title(['\tau = ' num2str(1000*tau) ' ms' ', \alpha = ' num2str(AvalancheResults(tau_count).alpha) ...
            ', \sigma = ' num2str(AvalancheResults(tau_count).sigma)]);
        drawnow
        snapnow
        
        %         figure; set(gcf,'Color','w');
        %         loglog(ES_edges1,size_dist,'LineWidth',2); hold on;
        %         xx = 1:60; yy = xx.^(-1.5);
        %         loglog(xx,yy,'k--','LineWidth',3)
        %         set(gca,'FontSize',14);
        %         xlabel('S (avalanche size)','FontSize',16);ylabel('P(S)','FontSize',16);
        
        %     figure;set(gcf,'Color','w');
        %     loglog(ES_edges1,size_dist,'LineWidth',3);hold on;
        %     xx = 1:60; yy = xx.^(-1.5);
        %     loglog(xx,yy,'k--','LineWidth',3)
        %     set(gca,'FontSize',18,'TickLength', 1.6*[0.0100    0.0250])
        %     xlabel('S');ylabel('P(S)');
        %     box off
    end
    
end
