%% DESCRIPTION of function
% time_OFDM = TD_PREAMBLE(sig)
% This function translate the transmitted sequence into the time domain
% sequence


function time_OFDM = TD_PREAMBLE(sig)
% sig=ZC_set(1,:);
[r,c]=size(sig);
freq_ZC=(fft(sig,[],2)); %fft of signal 
rep=1;
freq_ZC=repmat(freq_ZC,1,rep);
m=(c*rep/2) -1;
freq_OFDM = zeros(r,4096);

%mapping of the fft of selected preamble to the centre of OFDM symbol
if rep==1
freq_OFDM(:,1979:2117)=freq_ZC;
else
freq_OFDM(:,2048-m:2048+m+1)=freq_ZC;
end
% figure; plot(abs(freq_OFDM));
freq_OFDM=fftshift(freq_OFDM); 
time_OFDM_before_cp = (ifft(freq_OFDM,[],2)); %iift to obtain time domain signal

cp=time_OFDM_before_cp(:,end-287:end); % cyclic prefix of the time domain singal
 
time_OFDM=[cp, time_OFDM_before_cp]; % appending the CP to the signal to obtain transmitted time domain signal

% figure; plot(abs(time_OFDM))

end %end FUNCTION
