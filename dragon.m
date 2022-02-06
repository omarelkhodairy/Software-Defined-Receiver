function x_corr = dragon(y)
head = letters2pam('A0Oh well whatever Nevermind');
c=xcorr(head, y);                 % do cross correlation
[m,indx]=max(abs(c));                        % location of largest correlation 
headstart=length(y)-indx+1;          % place where header starts
headstart = mod(headstart, (112+400))
x_corr=y(headstart +104+400:end);
extras = mod(length(x_corr), 512)
x_corr=y(1:end - extras);
frames = length(x_corr)/512
%disp(headstart);
h = 1; d =113; w = 512;
num = 400*frames

for j=1:frames
    pos = 1+((j-1)*400):1:400*j;
    hed = d:1:w;
   header = x_corr(h:d-1);
    data(pos) = x_corr(hed);
    n=9; f=zeros(n,1);           % initialize equalizer at 0
    f(1)=1;
    mu=.2; delta=2;             % stepsize and delay delta
    r = header;
    for i=n+1:112                  % iterate
        rr=r(i:-1:i-n+1)';         % vector of received signal
        e=head(i-delta)-rr'*f;        % calculate error
        f=f+mu*e*rr;               % update equalizer coefficients
    end
    
    mu=.024;                       % stepsize
    r = data(pos);
    for i=n+1:400                  % iterate
        rr=r(i:-1:i-n+1)';         % vector of received signal
        e=quantalph(f'*rr,[-3 -1 1 3])-f'*rr;       % calculate error
        f=f+mu*e*rr;               % update equalizer coefficients
        %data(pos) = rr'*f;
    end
    h = h +512
    d = d+512
    w = w+512
end

x_corr = filter(f,1,data);    

figure,
subplot(3,1,1), stem(head)             % plot header
title('Header')
subplot(3,1,2), stem(x_corr)             % plot data sequencetitle('Data with embedded header')
subplot(3,1,3), stem(c)                % plot correlation
title('Correlation of header with data')