% source https://sccn.ucsd.edu/pipermail/eeglablist/2018/014182.html

%{
EEG = eeg_emptyset;

EEG.srate = 500;
EEG.xmin = 0;
EEG.nbchan = 1;
EEG.trials = 1;
EEG.pnts = 3301;
EEG.xmax = 9.998;
EEG.data = zeros( EEG.nbchan, EEG.pnts );
EEG.data( 1, 1651 ) = 1;
%}

% Firstly, I band-pass filtered my non-epoched EEG data from 0.5 to 80Hz
EEG = pop_eegfiltnew( EEG, 'locutoff',  0.5, 'hicutoff',  80, 'filtorder', 3300 );

b = {};
% then I filtered this data version 5 several times (0.5-4 , 4-8, 8-13, 13-30 , 30-80)
[ TMPEEG(1), com, b{ 1 } ] = pop_eegfiltnew( EEG, 'locutoff',  0.5, 'hicutoff',  4, 'filtorder', 3300 );
[ TMPEEG(2), com, b{ 2 } ] = pop_eegfiltnew( EEG, 'locutoff',  4,   'hicutoff',  8, 'filtorder',  826 );
[ TMPEEG(3), com, b{ 3 } ] = pop_eegfiltnew( EEG, 'locutoff',  8,   'hicutoff', 13, 'filtorder',  826 );
[ TMPEEG(4), com, b{ 4 } ] = pop_eegfiltnew( EEG, 'locutoff', 13,   'hicutoff', 30, 'filtorder',  508 );
[ TMPEEG(5), com, b{ 5 } ] = pop_eegfiltnew( EEG, 'locutoff', 30,   'hicutoff', 80, 'filtorder',  220 );

b_eff = zeros( 8192, 1 );
data = zeros( EEG.nbchan, EEG.pnts );
figure
subplot( 2, 2, 1 )
for iBand = 1:5
    [ h, f ] = freqz( b{ iBand }, 1, 8192, EEG.srate ); % Get frequency response
    plot( f, abs( h ) )
    hold all
    b_eff = b_eff + abs( h ); % Sum over bands in frequency domain
    data = data + TMPEEG( iBand ).data; % Sum over bands in time domain
end

plot( f, b_eff )
xlim( [ 0 100 ] ), ylim( [ 0 2 ] ), xlabel( 'Frequency (Hz)' ), ylabel( 'Magnitude' )
title( 'Frequency response' )
legend( '0.5-4', '4-8', '8-13', '13-30', '30-80', 'sum' )

% I expected that the sum of these 5 time-domain versions would be equal to the initial waveform (0.5-80Hz), but this was not noticed.
subplot( 2, 2, 2 )
plot( ( 0:EEG.pnts - 1 ) / EEG.srate, [ EEG.data' data' ] )
xlim( [ 2.5 4 ] ), xlabel( 'Time (s)' ), ylabel( 'Amplitude' )
title( 'Impulse response' )
legend( 'data', 'sum of band-filtered data' )

b = {};
% Order = 3300 at fs = 500 gives a transition band width of 0.5 Hz
[ TMPEEG(1), com, b{ 1 } ] = pop_eegfiltnew( EEG,                    'hicutoff',  3.75, 'filtorder', 3300 ); % Data are already 0.5 Hz high-pass filtered
[ TMPEEG(2), com, b{ 2 } ] = pop_eegfiltnew( EEG, 'locutoff',  4.25, 'hicutoff',  7.75, 'filtorder', 3300 );
[ TMPEEG(3), com, b{ 3 } ] = pop_eegfiltnew( EEG, 'locutoff',  8.25, 'hicutoff', 12.75, 'filtorder', 3300 );
[ TMPEEG(4), com, b{ 4 } ] = pop_eegfiltnew( EEG, 'locutoff', 13.25, 'hicutoff', 29.75, 'filtorder', 3300 );
[ TMPEEG(5), com, b{ 5 } ] = pop_eegfiltnew( EEG, 'locutoff', 30.25,                    'filtorder', 3300 ); % Data are already 80 Hz low-pass filtered

b_eff = zeros( 8192, 1 );
data = zeros( EEG.nbchan, EEG.pnts );
subplot( 2, 2, 3 )
for iBand = 1:5
    [ h, f ] = freqz( b{ iBand }, 1, 8192, EEG.srate ); % Get frequency response
    plot( f, abs( h ) )
    hold all
    b_eff = b_eff + abs( h ); % Sum over bands in frequency domain
    data = data + TMPEEG( iBand ).data; % Sum over bands in time domain
end

plot( f, b_eff )
xlim( [ 0 100 ] ), ylim( [ 0 2 ] ), xlabel( 'Frequency (Hz)' ), ylabel( 'Magnitude' )
title( 'Frequency response' )
legend( '4 lowpass', '4-8', '8-13', '13-30', '30 highpass', 'sum' )

subplot( 2, 2, 4 )
plot( ( 0:EEG.pnts - 1 ) / EEG.srate, [ EEG.data' data' ] )
xlim( [ 2.5 4 ] ), xlabel( 'Time (s)' ), ylabel( 'Amplitude' )
title( 'Impulse response' )
legend( 'data', 'sum of band-filtered data' )

max(abs(EEG.data-data))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://www.researchgate.net/post/How_to_perform_band_pass_filtering_on_EEG_signal_using_Matlab

sampleRate = 256; % Hz
lowEnd = 3; % Hz
highEnd = 30; % Hz
inputData = EEG.data;
filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
filteredData = filtfilt(b, a, inputData); % Apply filter to data using zero-phase filtering



sum(sum(EEG.data-filteredData))
