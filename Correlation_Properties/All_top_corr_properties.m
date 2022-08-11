clc
clear all
close all
Lra=139;
n=0:138;
lambda=0:138; w=0:138; k=0:138; u=1:138; l=1:138;

ZC_20=exp((-j*u(20)*pi.*k.*(k+1))/Lra);
ZC_30=exp((-j*u(30)*pi.*k.*(k+1))/Lra);
ZC_100=exp((-j*u(100)*pi.*k.*(k+1))/Lra);

W=exp((-j*2*pi)/Lra);
All_1_0= (W.^((n+w(1)).^3)).*(W.^(lambda(2).*n));
All_1_19= (W.^((n+w(20)).^3)).*(W.^(lambda(2).*n));

[lag,value]=CXCORR(All_1_0,All_1_19);
figure;
plot(lag,abs(value));xlabel('lag');ylabel('Absolute value of Correlation');
hold on;

All_1_0= (W.^((n+w(1)).^3)).*(W.^(lambda(2).*n));
All_10_0= (W.^((n+w(1)).^3)).*(W.^(lambda(11).*n));

[lag,value]=CXCORR(All_1_0,All_10_0);
plot(lag,abs(value));xlabel('lag');ylabel('Absolute value of Correlation');
hold on;
legend('RI=1,CS=19','RI=1,10');
title('Alltop correlation for CS and different RIs');

%ZC All top combined
figure;
comb_A_Z_1_20= ((All_1_0).^l(1)).*ZC_20;
comb_A_Z_10_20= ((All_1_0).^l(10)).*ZC_20;
comb_A_Z_10_30= ((All_1_19).^l(10)).*ZC_20;

[lag,value]=CXCORR(comb_A_Z_1_20,comb_A_Z_1_20);
lag=-69:69;
plot(lag,fftshift(abs(value)),'-s');
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;

[lag,value]=CXCORR(comb_A_Z_1_20,comb_A_Z_10_20); lag=-69:69;
plot(lag,fftshift(abs(value)),'-d');
xlabel('lag');
ylabel('Absolute value of Correlation');
hold on;

[lag,value]=CXCORR(comb_A_Z_10_20,comb_A_Z_10_30); lag=-69:69;
plot(lag,fftshift(abs(value)),'-o');
xlabel('cyclic shift');
ylabel('Absolute value of Correlation');
hold on;
grid on;
% max(abs(value))
legend('l,\lambda,w,\mu,v=(1,1,1,20,0)','(1,1,1,20,0),(10,1,1,20,0)','(10,1,1,20,0)(10,1,19,20,0)')
title('Auto-corr and cross-corr for combined aZC sequence')




% %% seeing effect of varying SNR for different cyclic shifts
% SNR=-10:1:10;
% CS=10:30:130;
% iter=100;
% figure;
% for i=1:length(CS)
%     max_val=zeros(1,length(SNR));
%     for j=1:length(SNR)
%         temp=zeros(1,iter);
%         for k=1:iter
%             comb_A_Z_1_shifted=CIRC_SHIFT(comb_A_Z_1_20,-CS(i));
%             comb_A_Z_1_shifted=awgn(comb_A_Z_1_shifted,SNR(j),'measured');
%             [lag,value]=CXCORR(comb_A_Z_1_20,comb_A_Z_1_shifted);
%             temp(k)=abs(max(value));
%         end
%         max_val(j)=mean(temp);
%     end
%     subplot(2,1,1)
%     plot(SNR,(max_val)); hold on; xlabel("SNR dB"); ylabel("peak value");
%     subplot(2,1,2)
%     plot(SNR,abs(139-max_val)); hold on; xlabel("SNR dB"); ylabel("Deviation");
% end
% legend("CS=10","CS=40","CS=70","CS=100","CS=130");%,"110","130");%,"60","70","80","","","","","","","","")
% 
% 
% 
% 
% 
