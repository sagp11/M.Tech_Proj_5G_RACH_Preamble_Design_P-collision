clc
clear all
close all
%GENERATING ZC Sequence:
Lra=139;
k=0:138;
u=1:138;
ZC_seq_20=exp((-j*u(20)*pi.*k.*(k+1))/Lra); %Generating odd length ZC sequence
ZC_seq_shifted=CIRC_SHIFT(ZC_seq_20,-10); %circularly shifting ZC seq
[lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
figure;
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
% figure;
% plot(abs(xcorr(ZC_seq,ZC_seq_shifted)./length(ZC_seq)));
ZC_seq_shifted=CIRC_SHIFT(ZC_seq_20,-25); %circularly shifting ZC seq
[lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
ZC_seq_shifted=CIRC_SHIFT(ZC_seq_20,-130); %circularly shifting ZC seq
[lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
ZC_seq_shifted=CIRC_SHIFT(ZC_seq_20,-80); %circularly shifting ZC seq
[lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
title('ZC sequence with root=20');
% legend('CS=10','CS=25','CS=-130','CS=80');


%CROSS CORRELATION FOR DIFFERENT ROOT INDEX

ZC_seq_10=exp((-j*u(10)*pi.*k.*(k+1))/Lra);
ZC_seq_138=exp((-j*u(138)*pi.*k.*(k+1))/Lra);
ZC_seq_65=exp((-j*u(65)*pi.*k.*(k+1))/Lra);

[lag,value]=CXCORR(ZC_seq_20,ZC_seq_10);% Periodic or circular
%correlation of ZC sequence with different root index 
plot(lag,abs(value),'o');
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
[lag,value]=CXCORR(ZC_seq_65,ZC_seq_138);% Periodic or circular
%correlation of ZC sequence with different root index 
plot(lag,abs(value),'s');
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
legend('CS=10','CS=25','CS=-130','CS=80','RI=20,10','RI=65,138');
% [lag,value]=CXCORR(ZC_seq_65,ZC_seq_138);% Periodic or circular
% %correlation of ZC sequence with different root index 
% plot(lag,abs(value));
% xlabel('lag');
% ylabel('Absolute value of Correlation');
% hold on;


%with AWGN
figure;
ZC_seq_shifted=CIRC_SHIFT(ZC_seq_20,-80); %circularly shifting ZC seq
ZC_seq_shifted=awgn(ZC_seq_shifted,10,'measured');
[lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;

ZC_seq_135=exp((-j*u(135)*pi.*k.*(k+1))/Lra);
ZC_seq_69=exp((-j*u(69)*pi.*k.*(k+1))/Lra);
ZC_seq_135=awgn(ZC_seq_135,10,'measured');
ZC_seq_69=awgn(ZC_seq_69,10,'measured');
[lag,value]=CXCORR(ZC_seq_135,ZC_seq_69);% Periodic or circular
%correlation of ZC sequence with same root index but cyclically shifted.
plot(lag,abs(value));
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;
legend('RI=20 CS=80','RI=135,69');
title('ZC correlation for AWGN SNR=10dB')


%% seeing effect of varying SNR for different cyclic shifts
SNR=-10:1:10;
CS=10:30:130;
iter=100;
figure;
for i=1:length(CS)
    max_val=zeros(1,length(SNR));
    for j=1:length(SNR)
        temp=zeros(1,iter);
        for k=1:iter
            ZC_seq_shifted=CIRC_SHIFT(ZC_seq_10,-CS(i));
            ZC_seq_shifted=awgn(ZC_seq_shifted,SNR(j),'measured');
            [lag,value]=CXCORR(ZC_seq_20,ZC_seq_shifted);
            temp(k)=abs(max(value));
        end
        max_val(j)=mean(temp);
    end
%     subplot(2,1,1)
    plot(SNR,(max_val)); hold on; xlabel("SNR dB"); ylabel("peak value");
    legend("CS=10","CS=40","CS=70","CS=100","CS=130")
%     subplot(2,1,2)
%     plot(SNR,abs(139-max_val)); hold on; xlabel("SNR dB"); ylabel("Deviation");
%     legend("CS=10","CS=40","CS=70","CS=100","CS=130")
end
sgtitle({'ZC seq peak values';'varying SNR from -10 to 10 dB for different cyclic shifts'});
        
        
        











