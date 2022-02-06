function Eq= Equalizer(x_corr)
n=9; f=[0 1 0 0 0 0 0 0 0]';           % initialize equalizer
mu=.004;                       % stepsize
index = 1;
for i=n+1:length(x_corr)                  % iterate
  rr=x_corr(i:-1:i-n+1)';         % vector of received signal
  e=quantalph(f'*rr,[-3 -1 1 3])-f'*rr;       % calculate error
  f=f+mu*e*rr;               % update equalizer coefficients
  x_corr(index) = rr'*f;
  index = index +1;
  
end
 Eq=x_corr;
 figure, 
plot([1:length(Eq)],Eq,'.')
title('constellation diagram');
savefig('constellation.fig');