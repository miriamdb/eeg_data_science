function params = get_params_criticality()

%%
params.dir_name = '..\pre_process\preproc_data\pp_rej_ica'; 
params.res_dir = '.\Results';
params.res_name = '01'; %TODO 
params.ext = 'set'; 

%%
%TODO - feels like anatoher function? 
D = dir(fullfile(params.dir_name, sprintf('*.%s',params.ext))); % find all datasets in the directory
EEG = pop_loadset('filename',D(1).name,'filepath',params.dir_name); %SET

%%
params.N_chan = EEG.nbchan; 
params.Fs = EEG.srate; %sampling rate
params.MaxMin = 'maxmin'; %threshold for max, min or both 
% data to analyse (sampling srate )
params.Start = 0 ; 
data_len = 3; %minutes
params.End = data_len * 60 * params.Fs; 

%%
% range of avalanche (event) sizes
params.ES_min = 1;
params.ES_max = max([100 (floor(params.N_chan*2/100))*100]); 
params.ES_edges = unique(ceil(logspace(0,log10(params.ES_max),25))); % log spaced bins

params.dt = 1/params.Fs; 
params.est_sigma_flag = 1;
params.std_TH = 3.0;

% times for raster plot
params.t1 = 4; % sec
params.t2 = 8; % sec

params.tau_vec = (1:6)*params.dt;
%(1:5)*params.dt; % array with delta t values for avalanche analysis

end 