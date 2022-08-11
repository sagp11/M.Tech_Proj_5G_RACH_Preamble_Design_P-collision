%% function to calculate periodic correlation of two signals 'a' and 'b'

function [x,c]=CXCORR(a,b)
na=norm(a);
nb=norm(b);
% a=a/na; %normalization
% b=b/nb;
for k=1:length(b)
    c(k)=a*b';
    b=[b(end),b(1:end-1)]; %circular shift
end
x=[0:length(b)-1]; %lags
end
