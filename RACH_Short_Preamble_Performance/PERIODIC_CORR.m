%% DESCRIPTIO of function
% [PDP]=PERIODIC_CORR(TX,ZC_root)
%% input
% TX:- received sequence
% ZC_roots:- root sequences present at receiver antenna

%% output
% PDP:- power delay profile after calculating the periodic corrrelation and
%       taking absolute squared of the samples corresponding to each root sequence 

%%
function [PDP]=PERIODIC_CORR(TX,ZC_root)
TX=(fft(TX,[],2)); % fft of received sequence row wise

[r,c]=size(ZC_root);

TX=conj((repmat(TX,r,1))); %repeating the fft to get match the dimension to multipl with root sequence set

%Calculating periodic correlation by multiplying fft of received sequences
%with each root sequence and then taking IFFT.
P_CORR=ifft(fft(ZC_root,[],2).*(TX),[],2);%./length(TX);

PDP=abs(P_CORR).^2; %taking absolute squared value to get PDP

% PDP_AVG=(1/length(TX)).*(sum(PDP,2));
% PDP_NORM=PDP./PDP_AVG;
% PDP_NORM_AVG=(1/length(TX)).*(sum(PDP_NORM,2));
end



