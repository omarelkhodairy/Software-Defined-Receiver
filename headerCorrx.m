function x_corr = headerCorrx(y)
head = letters2pam('A0Oh well whatever Nevermind');
x=y(105:end);   %trim the first header
c=xcorr(head,x);
h_length=112; d_length=400; f_length=512; 
f_no=floor(length(x)/512);
f_end= floor(length(x)*d_length/f_length);
x_frames=zeros(1,f_end);

fcounter=0;
for i=1:f_length:length(x)
    
    if i<((length(x)/2))
        frame=x(i:i+f_length-1);
       
        c2=xcorr(head,frame);
        m=max(c2);                       % value of largest correlation
        m1=min(c2);                      % value of minimum correlation
        
        if (m<abs(m1) &&fcounter<(f_no/2))        % check headers direction
            x_frames(i-(h_length*fcounter):i+d_length-1-(h_length*fcounter))=x(i:i+d_length-1)*-1;
        else
            x_frames(i-(h_length*fcounter):i+d_length-1-(h_length*fcounter))=x(i:i+d_length-1);
        end
       
    else
        x_frames(i-(h_length*fcounter):i+d_length-1-(h_length*fcounter))=x(i:i+d_length-1);
    end
     fcounter=fcounter+1;
end
x_corr=x_frames;

figure,
subplot(3,1,1), stem(head)             % plot header
title('Header')
subplot(3,1,2), stem(y)             % plot data sequencetitle('Data with embedded header')
subplot(3,1,3), stem(c)                % plot correlation
title('Correlation of header with data')