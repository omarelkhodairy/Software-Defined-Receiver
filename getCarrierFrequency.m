function fc = getCarrierFrequency(fif, fs)
while abs(fif-fs) < fif                     
    fif=abs(fif-fs);
end
fc=fif;