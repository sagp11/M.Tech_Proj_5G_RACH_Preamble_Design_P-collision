clc
clear all
close all
%% TO FIND THE VALUE OF ALPHA WHICH SATISFIES THE REQUIRED FALSE ALARM RATE

% tic
zCZC=11;
% ALPHA=4;
ALPHA=1:0.5:16; %vary ALPHA 

iter=100; %iteration >=10000

% N=8;
N=[1,2,4,8]; %vary number of antennas

users=1;
SNR= 0;
for k=1:4 %loop over types of sequences
for j=1:length(N) %loop over number of antennas
    tic
    for i=1:length(ALPHA)  %loop over alpha
        % see FUNCTION ZC_determine_threshold
        [P_T(j,i,k),T_mean(j,i,k)]= ZC_determine_threshold(zCZC,ALPHA(i),iter,N(j),k);
        
        
% [P_T(j,i,k),P_false_ZC(j,i,k),P_detect_ZC(j,i,k),P_miss_ZC(1,i,k)]=...
%     ZC_detect_N_ant_users(zCZC,ALPHA(i),iter,N(j),users,SNR,k,1);
% [P_miss,P_false_ZCM(1,:,j),P_detect_ZCM(1,:,j),P_miss_ZCM(1,:,j)]=...
%     ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,2);
% [P_miss,P_false_ZCA(1,:,j),P_detect_ZCA(1,:,j),P_miss_ZCA(1,:,j)]=...
%     ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,3);
% [P_miss,P_false_MA(1,:,j),P_detect_MA(1,:,j),P_miss_MA(1,:,j)]=...
%     ZC_detect_N_ant_users(zCZC,ALPHA(j),iter,N(j),users,SNR,4);

    end %end loop for ALPHA
    toc
end % end loop for number of antennas

end %end loop for type of sequence

% figure;
% plot(ALPHA,P_detect_ZC); hold on; grid on;
% 
% figure;
% semilogy(ALPHA,P_detect_ZC); hold on; grid on;
% toc
figure;
subplot(2,1,1); plot(ALPHA,P_T(:,:,1)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(:,:,1)); hold on; grid on;

figure;
subplot(2,1,1); plot(ALPHA,P_T(:,:,2)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(:,:,2)); hold on; grid on;

figure;
subplot(2,1,1); plot(ALPHA,P_T(:,:,3)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(:,:,3)); hold on; grid on;

figure;
subplot(2,1,1); plot(ALPHA,P_T(:,:,4)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(:,:,4)); hold on; grid on;

figure;
for i=1:4
subplot(2,1,1); plot(ALPHA,P_T(1,:,i)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(1,:,i)); hold on; grid on;
end

figure;
for i=1:4
subplot(2,1,1); plot(ALPHA,P_T(2,:,i)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(2,:,i)); hold on; grid on;
end
figure;
for i=1:4
subplot(2,1,1); plot(ALPHA,P_T(3,:,i)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(3,:,i)); hold on; grid on;
end
figure;
for i=1:4
subplot(2,1,1); plot(ALPHA,P_T(4,:,i)); hold on; grid on;
subplot(2,1,2); semilogy(ALPHA,P_T(4,:,i)); hold on; grid on;
end

% load('FIND_THRESHOLD-NEW.mat');
figure;
semilogy(ALPHA,P_T(1,:,1),'-r*','DisplayName','ZC,N_{ant}=1','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(2,:,1),'-r+','DisplayName','ZC,N_{ant}=2','LineWidth',1.5);hold on;
semilogy(ALPHA,P_T(3,:,1),'-rd','DisplayName','ZC,N_{ant}=4','LineWidth',1.5); hold on; 
semilogy(ALPHA,P_T(4,:,1),'-rs','DisplayName','ZC,N_{ant}=8','LineWidth',1.5); hold on; grid on;

semilogy(ALPHA,P_T(1,:,2),'-g*','DisplayName','mZC,N_{ant}=1','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(2,:,2),'-g+','DisplayName','mZC,N_{ant}=2','LineWidth',1.5);hold on;
semilogy(ALPHA,P_T(3,:,2),'-gd','DisplayName','mZC,N_{ant}=4','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(4,:,4),'-gs','DisplayName','mZC,N_{ant}=8','LineWidth',1.5); hold on;grid on;

semilogy(ALPHA,P_T(1,:,3),'-b*','DisplayName','aZC,N_{ant}=1','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(2,:,3),'-b+','DisplayName','aZC,N_{ant}=2','LineWidth',1.5);hold on;
semilogy(ALPHA,P_T(3,:,3),'-bd','DisplayName','aZC,N_{ant}=4','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(4,:,3),'-bs','DisplayName','aZC,N_{ant}=8','LineWidth',1.5); hold on; grid on;

semilogy(ALPHA,P_T(1,:,4),'-k*','DisplayName','mALL,N_{ant}=1','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(2,:,4),'-k+','DisplayName','mALL,N_{ant}=2','LineWidth',1.5);hold on;
semilogy(ALPHA,P_T(3,:,4),'-kd','DisplayName','mALL,N_{ant}=4','LineWidth',1.5); hold on;
semilogy(ALPHA,P_T(4,:,4),'-ks','DisplayName','mALL,N_{ant}=8','LineWidth',1.5); hold on;grid on;

semilogy(ALPHA,ones(1,31).*10^(-3),'--m','DisplayName','P(false)= 10^{-3}'); hold on; grid on;

axis([0,inf,10^-4,1])
xlabel('Threshold','FontWeight','bold'); ylabel('P(false)','FontWeight','bold');
legend('NumColumns',4,'Location','southoutside');
% legend('boxoff')
% figure;
% for i=1:4
%     subplot(2,2,i)
% semilogy(SNR,P_miss_ZC(1,:,i),'--o'); hold on;
% semilogy(SNR,P_miss_ZCM(1,:,i),'-.s'); hold on;
% semilogy(SNR,P_miss_ZCA(1,:,i),'--+'); hold on;
% semilogy(SNR,P_miss_MA(1,:,i),'--d'); hold on;
% grid on;
% xlabel('SNR dB'); ylabel('P-miss');
% title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% end
% legend('ZC','ZC-M','ZC-A');
% sgtitle(['P-misdetection For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
% temp=['p-miss-11-users-',num2str(1),'.jpg'];
% % saveas(gca,temp);
% 
% figure;
% for i=1:4
%     subplot(2,2,i)
% semilogy(SNR,P_detect_ZC(1,:,i),'--o'); hold on;
% semilogy(SNR,P_detect_ZCM(1,:,i),'-.s'); hold on;
% semilogy(SNR,P_detect_ZCA(1,:,i),'--+'); hold on;
% semilogy(SNR,P_detect_MA(1,:,i),'--d'); hold on;
% grid on;
% xlabel('SNR dB'); ylabel('P-detect');
% title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% end
% legend('ZC','ZC-M','ZC-A');
% sgtitle(['P-detection For Users=',num2str(users), 'zCZC=',num2str(zCZC)]);
% temp=['p-detect-11-users-',num2str(2),'.jpg'];
% % saveas(gca,temp);
% 
% 
% figure;
% for i=1:4
%     subplot(2,2,i)
% semilogy(SNR,P_false_ZC(1,:,i),'--o'); hold on;
% semilogy(SNR,P_false_ZCM(1,:,i),'-.s'); hold on;
% semilogy(SNR,P_false_ZCA(1,:,i),'--+'); hold on;
% semilogy(SNR,P_false_MA(1,:,i),'--d'); hold on;
% grid on;
% xlabel('SNR dB'); ylabel('P-false');
% title(['For N-antenna=',num2str(N(i)),' ALPHA=',num2str(ALPHA(i))]);
% end
% legend('ZC','ZC-M','ZC-A');
% sgtitle(['P-False For Users=',num2str(users),' zCZC=',num2str(zCZC)]);
% temp=['p-false-11-users-',num2str(3),'.jpg'];

% [ZC64,Ncs,ZC_root]=ZC64_PREAMBLE_GEN(0);