clc
clear all
close all
%% MAIN CODE FOR GETTING DETECTION PERFORMANCE vs SNR

zCZC=11; %zeroCorrelationZoneConfig parameter related to cyclic shift

ALPHA=[10,8,6,4]; %the threshold parameter for N=1,2,4,8 antennas

iter=100; %initialise number of iterations 
N=[1,2,4,8]; %number of antennas

users=1; %number of users

CFO=0; %det carrier frequency offset

SNR=-20:1:2; %SNR variation

for k=1:length(CFO) %start loop for CFO
%     tic
for j=1:length(N) %start loop for number of antennas
tic
%CALL FUNCTION [P_T,P_false,P_detect,P_trial,t_detect,det_index,PDP,T_mean]= ...
%              ZC_detect_N_ant_users(zCZC,ALPHA,iter,N,users,SNR,signature,...
%              method,CFO)
%where signature refers to the type of sequence, method refers to the
%reception of sequence or only noise.

[P_miss,P_false_ZC(k,:,j),P_detect_ZC(k,:,j),P_miss_ZC(k,:,j),t_detect_ZC,~,~,T_mean_ZC(k,:,j)]=...
    ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,1,1,CFO(k));
[P_miss,P_false_ZCM(k,:,j),P_detect_ZCM(k,:,j),P_miss_ZCM(k,:,j),t_detect_ZCM,~,~,T_mean_ZCM(k,:,j)]=...
    ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,2,1,CFO(k));
[P_miss,P_false_ZCA(k,:,j),P_detect_ZCA(k,:,j),P_miss_ZCA(k,:,j),t_detect_ZCA,~,~,T_mean_ZCA(k,:,j)]=...
    ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,3,1,CFO(k));
[P_miss,P_false_MA(k,:,j),P_detect_MA(k,:,j),P_miss_MA(k,:,j),t_detect_MA,~,~,T_mean_MA(k,:,j)]=...
    ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,4,1,CFO(k));
toc
end
% toc
end

% figure;
% semilogy(SNR,P_false_ZC(1,:,:),'--o'); hold on;
% semilogy(SNR,P_false_ZCM(1,:,:),'-.s'); hold on;
% semilogy(SNR,P_false_ZCA(1,:,:),'--+'); hold on;
% semilogy(SNR,P_false_MA(1,:,:),'--d'); hold on;
% 
% figure;
% semilogy(SNR,P_miss_ZC(1,:,:),'--o'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,:),'-.s'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,:),'--+'); hold on;
% semilogy(SNR,P_miss_MA(1,:,:),'--d'); hold on;


%% DIAGRAMS 

figure;
for i=1:4
    subplot(2,2,i)
semilogy(SNR,P_miss_ZC(1,:,i),'--o'); hold on;
semilogy(SNR,P_miss_ZCM(1,:,i),'-.s'); hold on;
semilogy(SNR,P_miss_ZCA(1,:,i),'--+'); hold on;
semilogy(SNR,P_miss_MA(1,:,i),'--d'); hold on;
grid on;
xlabel('SNR dB'); ylabel('P-miss');
title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
end
legend('ZC','ZC-M','ZC-A');
sgtitle(['P-misdetection For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
temp=['p-miss-11-users-',num2str(1),'.jpg'];
% saveas(gca,temp);

figure;
for i=1:4
    subplot(2,2,i)
semilogy(SNR,P_detect_ZC(1,:,i),'--o'); hold on;
semilogy(SNR,P_detect_ZCM(1,:,i),'-.s'); hold on;
semilogy(SNR,P_detect_ZCA(1,:,i),'--+'); hold on;
semilogy(SNR,P_detect_MA(1,:,i),'--d'); hold on;
grid on;
xlabel('SNR dB'); ylabel('P-detect');
title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
end
legend('ZC','ZC-M','ZC-A');
sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
temp=['p-detect-11-users-',num2str(2),'.jpg'];
% saveas(gca,temp);


figure;
for i=1:4
    subplot(2,2,i)
semilogy(SNR,P_false_ZC(1,:,i),'--o'); hold on;
semilogy(SNR,P_false_ZCM(1,:,i),'-.s'); hold on;
semilogy(SNR,P_false_ZCA(1,:,i),'--+'); hold on;
semilogy(SNR,P_false_MA(1,:,i),'--d'); hold on;
grid on;
xlabel('SNR dB'); ylabel('P-false');
title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
end
legend('ZC','ZC-M','ZC-A');
sgtitle(['P-False For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
temp=['p-false-11-users-',num2str(3),'.jpg'];

% 
% % figure;
% % semilogy(SNR,P_detect_ZC(1,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% % semilogy(SNR,P_detect_ZCM(1,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% % semilogy(SNR,P_detect_ZCA(1,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% % semilogy(SNR,P_detect_MA(1,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% % 
% % semilogy(SNR,P_detect_ZC(1,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% % semilogy(SNR,P_detect_ZCM(1,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% % semilogy(SNR,P_detect_ZCA(1,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% % semilogy(SNR,P_detect_MA(1,:,3),'-dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% % 
% % semilogy(SNR,P_detect_ZC(1,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% % semilogy(SNR,P_detect_ZCM(1,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% % semilogy(SNR,P_detect_ZCA(1,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% % semilogy(SNR,P_detect_MA(1,:,4),'-dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% % 
% % 
% % grid on;
% % xlabel('SNR dB'); ylabel('P-detect');
% % title('N_{ant} = 2,4,8');
% 
% 
% % legend('ZC','mZC','aZC');
% % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% legend('Location','southeast')
% 
% 
% figure;
% semilogy(SNR,P_miss_ZC(1,:,1),'-.or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,1),'-.sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,1),'-.+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% semilogy(SNR,P_miss_MA(1,:,1),'-.dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% 
% semilogy(SNR,P_miss_ZC(1,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% semilogy(SNR,P_miss_MA(1,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% 
% semilogy(SNR,P_miss_ZC(1,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% semilogy(SNR,P_miss_MA(1,:,3),':dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% 
% semilogy(SNR,P_miss_ZC(1,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% semilogy(SNR,P_miss_MA(1,:,4),'--dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% 
% 
% grid on;
% xlabel('SNR dB'); ylabel('P-miss');
% title('N_{ant} = 2,4,8');
% % legend('ZC','mZC','aZC');
% % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% legend('Location','southeast')
% 
% 
% 
% 
% 
% 
% figure;
% semilogy(SNR,T_mean_ZC(1,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% semilogy(SNR,T_mean_ZCM(1,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% semilogy(SNR,T_mean_ZCA(1,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% semilogy(SNR,T_mean_MA(1,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% 
% semilogy(SNR,T_mean_ZC(1,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% semilogy(SNR,T_mean_ZCM(1,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% semilogy(SNR,T_mean_ZCA(1,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% semilogy(SNR,T_mean_MA(1,:,3),':dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% 
% semilogy(SNR,T_mean_ZC(1,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% semilogy(SNR,T_mean_ZCM(1,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% semilogy(SNR,T_mean_ZCA(1,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% semilogy(SNR,T_mean_MA(1,:,4),'--dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% 
% 
% grid on;
% xlabel('SNR dB'); ylabel('P-miss');
% title('N_{ant} = 2,4,8');
% % legend('ZC','mZC','aZC');
% % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% legend('Location','southeast')
% 
% 
% 
% figure;
% plot(SNR,T_mean_ZC(1,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% plot(SNR,T_mean_ZCM(1,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% plot(SNR,T_mean_ZCA(1,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% plot(SNR,T_mean_MA(1,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% 
% plot(SNR,T_mean_ZC(1,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% plot(SNR,T_mean_ZCM(1,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% plot(SNR,T_mean_ZCA(1,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% plot(SNR,T_mean_MA(1,:,3),':dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% 
% plot(SNR,T_mean_ZC(1,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% plot(SNR,T_mean_ZCM(1,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% plot(SNR,T_mean_ZCA(1,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% plot(SNR,T_mean_MA(1,:,4),'--dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% 
% 
% grid on;
% xlabel('SNR dB'); ylabel('P-miss');
% title('N_{ant} = 2,4,8');
% 
% 
% 
% % figure;
% % for i=1:4
% %     subplot(2,2,i)
% % semilogy(SNR,P_miss_ZC(:,:,i),'--o'); hold on;
% % semilogy(SNR,P_miss_ZCM(:,:,i),'-.s'); hold on;
% % semilogy(SNR,P_miss_ZCA(:,:,i),'--+'); hold on;
% % semilogy(SNR,P_miss_MA(:,:,i),'--d'); hold on;
% % grid on;
% % xlabel('SNR dB'); ylabel('P-miss');
% % title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% % end
% % legend('ZC','ZC-M','ZC-A');
% % sgtitle(['P-misdetection For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
% % temp=['p-miss-11-users-',num2str(1),'.jpg'];
% % % saveas(gca,temp);
% % 
% % figure;
% % for i=1:4
% %     subplot(2,2,i)
% % semilogy(SNR,P_detect_ZC(:,:,i),'--o'); hold on;
% % semilogy(SNR,P_detect_ZCM(:,:,i),'-.s'); hold on;
% % semilogy(SNR,P_detect_ZCA(:,:,i),'--+'); hold on;
% % semilogy(SNR,P_detect_MA(:,:,i),'--d'); hold on;
% % grid on;
% % xlabel('SNR dB'); ylabel('P-detect');
% % title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% % end
% % legend('ZC','ZC-M','ZC-A');
% % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% % % saveas(gca,temp);
% % 
% % 
% % figure;
% % for i=1:4
% %     subplot(2,2,i)
% % semilogy(SNR,P_false_ZC(:,:,i),'--o'); hold on;
% % semilogy(SNR,P_false_ZCM(:,:,i),'-.s'); hold on;
% % semilogy(SNR,P_false_ZCA(:,:,i),'--+'); hold on;
% % semilogy(SNR,P_false_MA(:,:,i),'--d'); hold on;
% % grid on;
% % xlabel('SNR dB'); ylabel('P-false');
% % title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% % end
% % legend('ZC','ZC-M','ZC-A');
% % sgtitle(['P-False For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
% % temp=['p-false-11-users-',num2str(3),'.jpg'];
% % 
% % 
% % % figure;
% % % semilogy(SNR,P_detect_ZC(1,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% % % semilogy(SNR,P_detect_ZCM(1,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% % % semilogy(SNR,P_detect_ZCA(1,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% % % semilogy(SNR,P_detect_MA(1,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% % % 
% % % semilogy(SNR,P_detect_ZC(1,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% % % semilogy(SNR,P_detect_ZCM(1,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% % % semilogy(SNR,P_detect_ZCA(1,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% % % semilogy(SNR,P_detect_MA(1,:,3),'-dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% % % 
% % % semilogy(SNR,P_detect_ZC(1,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% % % semilogy(SNR,P_detect_ZCM(1,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% % % semilogy(SNR,P_detect_ZCA(1,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% % % semilogy(SNR,P_detect_MA(1,:,4),'-dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% % % 
% % % 
% % % grid on;
% % % xlabel('SNR dB'); ylabel('P-detect');
% % % title('N_{ant} = 2,4,8');
% % 
% % 
% % % legend('ZC','mZC','aZC');
% % % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% % legend('Location','southeast')
% % 
% % 
% % figure;
% % semilogy(SNR,P_miss_ZC(:,:,2),'-or','LineWidth',1.5,'DisplayName','1-Tx,2-Rx ZC'); hold on;
% % semilogy(SNR,P_miss_ZCM(:,:,2),'-sg','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mZC'); hold on;
% % semilogy(SNR,P_miss_ZCA(:,:,2),'-+b','LineWidth',1.5,'DisplayName','1-Tx,2-Rx aZC'); hold on;
% % semilogy(SNR,P_miss_MA(:,:,2),'-dk','LineWidth',1.5,'DisplayName','1-Tx,2-Rx mALL'); hold on;
% % 
% % semilogy(SNR,P_miss_ZC(:,:,3),':or','LineWidth',1.5,'DisplayName','1-Tx,4-Rx ZC'); hold on;
% % semilogy(SNR,P_miss_ZCM(:,:,3),':sg','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mZC'); hold on;
% % semilogy(SNR,P_miss_ZCA(:,:,3),':+b','LineWidth',1.5,'DisplayName','1-Tx,4-Rx aZC'); hold on;
% % semilogy(SNR,P_miss_MA(:,:,3),'-dk','LineWidth',1.5,'DisplayName','1-Tx,4-Rx mALL'); hold on;
% % 
% % semilogy(SNR,P_miss_ZC(:,:,4),'--or','LineWidth',1.5,'DisplayName','1-Tx,8-Rx ZC'); hold on;
% % semilogy(SNR,P_miss_ZCM(:,:,4),'--sg','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mZC'); hold on;
% % semilogy(SNR,P_miss_ZCA(:,:,4),'--+b','LineWidth',1.5,'DisplayName','1-Tx,8-Rx aZC'); hold on;
% % semilogy(SNR,P_miss_MA(:,:,4),'-dk','LineWidth',1.5,'DisplayName','1-Tx,8-Rx mALL'); hold on;
% % 
% % 
% % grid on;
% % xlabel('SNR dB'); ylabel('P-miss');
% % title('N_{ant} = 2,4,8');
% % % legend('ZC','mZC','aZC');
% % % sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% % % temp=['p-detect-11-users-',num2str(2),'.jpg'];
% % legend('Location','southeast')
% % 
% % 
% % 
% % 
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_detect_ZC(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_detect_ZC(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_detect_ZC(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_detect_ZC(:,:,4)); grid on;
% % sgtitle('ZC')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % 
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_detect_ZCM(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_detect_ZCM(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_detect_ZCM(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_detect_ZCM(:,:,4)); grid on;
% % sgtitle('ZCM')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_detect_ZCA(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_detect_ZCA(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_detect_ZCA(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_detect_ZCA(:,:,4)); grid on;
% % sgtitle('ZCA')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_detect_MA(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_detect_MA(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_detect_MA(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_detect_MA(:,:,4)); grid on;
% % sgtitle('MA')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % 
% % 
% % %% FALSE ALARM FIGURES
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_false_ZC(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_false_ZC(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_false_ZC(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_false_ZC(:,:,4)); grid on;
% % sgtitle('ZC')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % 
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_false_ZCM(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_false_ZCM(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_false_ZCM(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_false_ZCM(:,:,4)); grid on;
% % sgtitle('ZCM')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_false_ZCA(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_false_ZCA(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_false_ZCA(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_false_ZCA(:,:,4)); grid on;
% % sgtitle('ZCA')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % figure;
% % subplot(2,2,1)
% % plot(SNR,P_false_MA(:,:,1)); grid on;
% % subplot(2,2,2)
% % plot(SNR,P_false_MA(:,:,2)); grid on;
% % subplot(2,2,3)
% % plot(SNR,P_false_MA(:,:,3)); grid on;
% % subplot(2,2,4)
% % plot(SNR,P_false_MA(:,:,4)); grid on;
% % sgtitle('MA')
% % legend('-0.5','-0.25','0','0.25','0.5')
% % 
% % 
% % 






