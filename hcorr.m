function x_corr = hcorr(y)
head = letters2pam('A0Oh well whatever Nevermind');
h_length=112; d_length=400; f_length=512; 
c2=xcorr(head, y);                 % do cross correlation
[n,indx]=max(abs(c2));                        % location of largest correlation 
headstart=length(y)-indx+1;          % place where header starts
headstart = mod(headstart, f_length);
x=y(headstart+h_length-8:end);   %trim the first header


f_end= floor(length(x)*d_length/f_length);

x_frames=zeros(1,f_end);
z1=1:1:(length(x)/2)-(f_length/2);

        c1=xcorr(head,x(z1));
        m=max(c1);                       % value of largest correlation
        m1=min(c1);                      % value of minimum correlation
        
        if m<abs(m1)     % check headers direction
            x(z1)=x(z1)*-1;  
        end
        
        fcounter=0;
for i=1:f_length:length(x)
    
    if i<length(x)
            x_frames(i-(h_length*fcounter):i+d_length-1-(h_length*fcounter))=x(i:i+d_length-1);
    end
     fcounter=fcounter+1;
end


x_corr=x_frames;
figure,
subplot(3,1,1), stem(head)             % plot header
title('Header')
subplot(3,1,2), stem(y)             % plot data sequencetitle('Data with embedded header')
subplot(3,1,3), stem(c2)                % plot correlation
title('Correlation of header with data')