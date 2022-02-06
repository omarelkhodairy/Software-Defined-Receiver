%% Select one of the Receieved Signals
in=input('please select a mystery using 1, 2 or 3 ');    % Select a mystery
switch(in)
    case 1
  load('mysteryA.mat');
  SRRCLength = 3;                         % Square Root Raised Cosine Length
  SRRCrolloff = 0.35;                      % Square Root Raised Cosing Rolloff factor (beta)
  fs = 820e3;                             % Sampling Frequency
  Tt = 9e-6;                              % Symbol Period
  fif = 1.88e6;                            % Intermediate Frequency
    case 2
  load('mysteryB.mat');
  SRRCLength = 4;
  SRRCrolloff = 0.3;
  fs = 680e3;
  Tt = 7.3e-6;
  fif = 1.92e6;
    case 3
  load('mysteryC.mat');
  SRRCLength = 5;                         
  SRRCrolloff = 0.25;                     
  fs = 760e3;                            
  Tt = 8.2e-6;                          
  fif = 2.4e6;                         
end
upsampling_ratio= fs*Tt;                                % upsampling ratio
N_freq= fs/2;                                           % Nyquest frequency
r = r';
figure, plotspec(r, 1/fs);
savefig('received signal.fig');

%% Calculate the carrier frequency
f0 = getCarrierFrequency(fif, fs);

%% Noise reduction filter
x_bp= filt(r,fs,f0);

%% Carrier recovery  
carest = DCL(x_bp, fs, f0);

%% Demodulation
x_demodulated= mixer(x_bp, carest, fs,0.2);

%% Clock recovery
x_cr= CRPO(x_demodulated, upsampling_ratio, SRRCLength,SRRCrolloff);

%% Header correlation and frame extraction
x_corr = hcorr(x_cr);

%% Equalizer
x_eq=Equalizer(x_corr);
%% Data quantization
x_quant=quantalph(x_eq,[-3,-1,1,3])';
%% reconstruct message
x_rec=pam2letters(x_quant);

%% display message
disp(x_rec);
