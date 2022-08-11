function [PDP]=PERIODIC_CORR(TX,ZC_root)
TX=(fft(TX,[],2));
[r,c]=size(ZC_root);
TX=conj((repmat(TX,r,1)));
P_CORR=ifft(fft(ZC_root,[],2).*(TX),[],2);%./length(TX);
PDP=abs(P_CORR).^2;
% PDP_AVG=(1/length(TX)).*(sum(PDP,2));
% PDP_NORM=PDP./PDP_AVG;
% PDP_NORM_AVG=(1/length(TX)).*(sum(PDP_NORM,2));
end



