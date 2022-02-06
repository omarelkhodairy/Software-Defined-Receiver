function x_bp = filt(r, fs, f0)
C_freq =2*f0/fs;
f1= C_freq-0.31;
f2= C_freq-0.3;
f3= C_freq+0.3;
f4= C_freq+0.31;

fl=500; ff=[0 f1 f2 f3 f4 1];       % Filter characteristics
fa=[0 0 1 1 0 0];                 
h=firpm(fl,ff,fa);                  % design BPF  via firpm function
x_bp=filtfilt(h,1,r);                  % do the filtering to give noise reduced signal
figure,
subplot(2,1,1), plotspec(x_bp,1/fs);
title('Noise reduced signal');
savefig('Noise reduced signal.fig');

