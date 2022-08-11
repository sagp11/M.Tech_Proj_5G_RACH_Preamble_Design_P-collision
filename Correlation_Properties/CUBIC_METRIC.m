%% decription of function
% [CM,CM_CCDF,cm]=CUBIC_METRIC(sig)

%% input
% sig:- time domain representation of set of the sequence transmitted

%% output:-
% CM:- cubic metric value in dB for each time domain signal 
% CM_CCDF:- the CCDF of the signal
% cm:- varying cm values used for plotting  in dB


%%
function [CM,CM_CCDF,cm]=CUBIC_METRIC(sig)
[r,~]=size(sig);
s_rms=rms(sig,2);
v_norm=abs(sig)./s_rms;
v_norm_rms=rms((v_norm.^3),2);
CM=((20.*log10(v_norm_rms))-1.52)./(1.56); %calculated according to the definition

cm=-3:0.1:10;
for i=1:length(cm)
    CM_CCDF(i)=sum(CM>cm(i),'all');
end
CM_CCDF=CM_CCDF./r;
% figure;
% plot(cm,CCDF/828); hold on;
end