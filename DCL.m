%% The code is based on costasloop.m from SDR package.
function carest = DCL(r, fs, f0)

t = (1/fs):(1/fs):((length(r)/fs));                  % Initialize Time Vector

% LPF characteristics For the costas loops
fl=100; ff=[0 .01 .02 1]; fa=[1 1 0 0];
h=firpm(fl,ff,fa);                        % design the Low pass filter

mu1=.04;                                  % algorithm stepsize
theta1=zeros(1,length(r)); theta1(1)=0;   % initialize estimate vector 1
zs1=zeros(1,fl+1); zc1=zeros(1,fl+1);       % initialize first buffers for LPFs


mu2=.0004;                                 % algorithm stepsize
theta2=zeros(1,length(r)); theta2(1)=0;   % initialize estimate vector 2
zs2=zeros(1,fl+1); zc2=zeros(1,fl+1);     % initialize second buffers for LPFs

% carrier estimate vector
carest=zeros(1,length(r));

for k=1:length(r)-1                       
  % Frequency tracking loop
  zs1=[zs1(2:fl+1), 2*r(k)*sin(2*pi*f0*t(k)+theta1(k))];
  zc1=[zc1(2:fl+1), 2*r(k)*cos(2*pi*f0*t(k)+theta1(k))];
  lpfs1=fliplr(h)*zs1'; lpfc1=fliplr(h)*zc1'; % new filters output
  theta1(k+1)=theta1(k)-mu1*lpfs1*lpfc1;    %  update algorithm
  
  % Phase tracking loop
  zs2=[zs2(2:fl+1), 2*r(k)*sin(2*pi*f0*t(k)+theta1(k) + theta2(k))];
  zc2=[zc2(2:fl+1), 2*r(k)*cos(2*pi*f0*t(k)+theta1(k) + theta2(k))];
  lpfs2=fliplr(h)*zs2'; lpfc2=fliplr(h)*zc2'; % new filters output
  theta2(k+1)=theta2(k)-mu2*lpfs2*lpfc2;      %  update algorithm
  
  carest(k)=cos(2*pi*f0*t(k)+theta1(k)+theta2(k)); % Updating the carrier estimate
end
figure,
subplot(2,1,1), plot(t,theta1)              % Plot theta1
title('frequency tracking loop')
ylabel('\theta1')
subplot(2,1,2), plot(t,theta2)              % Plot theta2
title('phase tracking loop')
ylabel('\theta2')
savefig('output of DCL.fig');