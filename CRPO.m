function y= CRPO(v, upsampling_ratio, SRRCLength,b)

n=round(length(v)/upsampling_ratio);              % number of data points
m=upsampling_ratio;                               % oversampling factor


% clockrecOP.m:  clock recovery maximizing output power
% run clock recovery algorithm

tnow=SRRCLength*m+1; tau=0; xs=zeros(1,n);           % initialize variables
tausave=zeros(1,n); tausave(1)=tau; i=0;
mu=0.02;                         % algorithm stepsize
delta=2;                         % time for derivative


while tnow<length(v)-2*SRRCLength*m                    % run iteration
    i=i+1;
    xs(i)=interpsinc(v,tnow+tau,SRRCLength,b);           % interpolated value at tnow+tau
    x_deltap=interpsinc(v,tnow+tau+delta,SRRCLength,b);  % get value to the right
    x_deltam=interpsinc(v,tnow+tau-delta,SRRCLength,b);  % get value to the left
    dx=x_deltap-x_deltam;                     % calculate numerical derivative  
    tau=tau+mu*dx*xs(i);                      % alg update (energy)
    tnow=tnow+m; tausave(i)=tau;              % save for plotting
end
y = 2.7.*xs(1:i);
% plot results
figure, 
subplot(2,1,1), plot(y(1:i-2),'b.')       % plot constellation diagram
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))       % plot trajectory of tau
ylabel('Timing offset'), xlabel('iterations')


