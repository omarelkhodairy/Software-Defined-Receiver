function demodulate = mixer(r, carest, fs,lcut)
demodulate = r.*carest;

b=firpm(500,[0 lcut lcut+0.01 1],[1 1 0 0]);
demodulate=filtfilt(b,1,demodulate);
figure, plotspec(demodulate, 1/fs);
title('Demodulated signal')
