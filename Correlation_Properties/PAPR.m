%% DESCRIPTION
% This function is used to calculate the PAPR of the time domain signal
% transmitted

%% output:-
% P:- PAPR value in dB for each time domain signal 
% PAPR_CCDF:- the CCDF of the signal
% papr:- varying papr values used for plotting  in dB
%%

function [P,PAPR_CCDF,papr] = PAPR(sig)
% ifft_sig=ifft(sig);
[r,~]=size(sig);
% l=length(sig);
S=abs(sig).^2;
peak=max(S,[],2);
avgP=mean(S,2);
P=10.*log10(peak./avgP); %calculated according to definition

papr=-3:0.1:10;
% loop to obtain CCDF
for i=1:length(papr)
    PAPR_CCDF(i)=sum(P>papr(i),'all');
end

PAPR_CCDF=PAPR_CCDF./r;
end %end FUNCTION
