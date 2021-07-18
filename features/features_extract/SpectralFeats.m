function [deltaPower, thetaPower, alphaPower, betaPower, gammaPower] = SpectralFeats(EEG, chan)

if chan == 'all'
    [spectra,freqs] = spectopo(EEG.data, 0, EEG.srate, 'plot', 'off');  
else 
    [spectra,freqs] = spectopo(EEG.data(chan,:,:), 0, EEG.srate, 'plot', 'off');
end 

% delta=1-4, theta=4-8, alpha=8-13, beta=13-30, gamma=30-80
deltaIdx = find(freqs>1 & freqs<4);
thetaIdx = find(freqs>4 & freqs<8);
alphaIdx = find(freqs>8 & freqs<13);
betaIdx  = find(freqs>13 & freqs<30);
gammaIdx = find(freqs>30 & freqs<80);

% compute absolute power
deltaPower = mean(10.^(spectra(deltaIdx)/10));
thetaPower = mean(10.^(spectra(thetaIdx)/10));
alphaPower = mean(10.^(spectra(alphaIdx)/10));
betaPower  = mean(10.^(spectra(betaIdx)/10));
gammaPower = mean(10.^(spectra(gammaIdx)/10));

end 
