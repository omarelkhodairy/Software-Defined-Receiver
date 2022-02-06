function x_corr = headerCorrx1(y)
head = letters2pam('A0Oh well whatever Nevermind');
c=xcorr(head, y);                 % do cross correlation
[m,indx]=max(abs(c));                        % location of largest correlation 
headstart=length(y)-indx+1;          % place where header starts
headstart = mod(headstart, (112+400));
x_corr=y(headstart:end);
num = mod(length(x_corr),512)
num2 = mod(length(x_corr),2)
x_corr=x_corr(505:length(x_corr)-num-(num2*512));

z1=1:1:(length(x_corr)/2)-256;
c1=xcorr(head, x_corr(z1));                 % do cross correlation
m=max(c1);                      % location of largest correlation
m1=min(c1);  
if m<abs(m1)                       % check headers direction
   x_corr(z1)=x_corr(z1)*-1;     % correct header direction
end



figure,
subplot(3,1,1), stem(head)             % plot header
title('Header')
subplot(3,1,2), stem(y)             % plot data sequencetitle('Data with embedded header')
subplot(3,1,3), stem(c)                % plot correlation
title('Correlation of header with data')