clc
clear   
close all

%% TO STUDY THE CORRELATION PROPERTIES OF THE 'mALL' SEQUENCES

Lra=139;
l=1; lambda=1; w=1; t=1; %PARAMETERS
AllTop=AllTop_seq_gen(Lra,l,lambda,w); % GENERATE ALLTOP SEQUENCE
M=circshift(M_seq_gen(Lra),-t); %GENERATE M SEQUENCE
mALL_1111 = M.*AllTop; %MALL SEQUENCE

l=1; lambda=1; w=1; t=20;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M=circshift(M_seq_gen(Lra),-(t-1));
mALL_11120 = M.*AllTop;

l=1; lambda=1; w=10; t=1;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M=circshift(M_seq_gen(Lra),-(t-1));
mALL_11101 = M.*AllTop;

l=1; lambda=10; w=1; t=1;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M=circshift(M_seq_gen(Lra),-(t-1));
mALL_12511 = M.*AllTop;

l=15; lambda=1; w=1; t=1;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M=circshift(M_seq_gen(Lra),-(t-1));
mALL_15111 = M.*AllTop;

l=1; lambda=1; w=21; t=21;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M=circshift(M_seq_gen(Lra),-(t));
mALL_112121 = M.*AllTop;

% PERIODIC CORRELATIONS
[lag,P1] = CXCORR(mALL_1111,mALL_1111);
[lag,P2] = CXCORR(mALL_11120,mALL_1111);
[lag,P3] = CXCORR(mALL_11101,mALL_1111);
[lag,P4] = CXCORR(mALL_12511,mALL_1111);
[lag,P5] = CXCORR(mALL_15111,mALL_1111);
[lag,P6] = CXCORR(mALL_112121,mALL_1111);
lag=-69:69;

% PLOTS
figure;
plot(lag,fftshift(abs(P1)),'-*','DisplayName','l,\lambda,w,t = (1,1,1,1)'); hold on;
plot(lag,fftshift(abs(P2)),'-o','DisplayName','(1,1,1,20),(1,1,1,1)'); hold on;
plot(lag,fftshift(abs(P3)),'-+','DisplayName','(1,1,10,1),(1,1,1,1)'); hold on;
plot(lag,fftshift(abs(P4)),'-s','DisplayName','(1,25,1,1),(1,1,1,1)'); hold on;
plot(lag,fftshift(abs(P6)),'-h','DisplayName','(1,1,21,21),(1,1,1,1)'); hold on;
plot(lag,fftshift(abs(P5)),'-d','DisplayName','(15,1,1,1),(1,1,1,1)'); hold on;
xlabel('cyclic shift');
grid on;
ylabel('Absolute value of Correlation');
title('Auto-corr and cross-corr for combined mALL sequence')
legend



M=M_seq_gen(139);

l=1; lambda=1; w=1; t=1;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M1=circshift(M_seq_gen(Lra),-t);
mALL_1111 = M1.*AllTop;

l=1; lambda=1; w=20; t=1;
AllTop=AllTop_seq_gen(Lra,l,lambda,w);
M1=circshift(M,-(t));
mALL = M1.*AllTop;
                
% [~,P1] = CXCORR(mALL_1111,mALL);
[~,P1] = CXCORR(mALL_1111,circshift(mALL_1111,-22));
[~,P2] = CXCORR(mALL_1111,mALL);
max(abs(P1))
lag=-69:69;
% figure;
% plot(abs(P1)); hold on; plot(abs(P2)); hold on;
a=0;


% clear all;

%% to study THE CORRELATION PROPERTIES OF all 'mALL' sequences combinations
Lra=139;
l=1; lambda=1; w=1; t=1;
AllTop1=AllTop_seq_gen(Lra,l,lambda,w);
M1=circshift(M_seq_gen(Lra),-t);
mALL_1111 = M1.*AllTop1;
D=60;3*sqrt(139);
sum=0;
Ncs=23;
ind=[];
M=M_seq_gen(139);
for l=1:1:138
    tic
    T1=[];
    for lambda=1:1:138
        for w=1:1:138
            AllTop=AllTop_seq_gen(139,l,lambda,w);
            for t=1 %1:138
                M1=circshift(M,-t);
                X=M1.*AllTop;
%                 X=AllTop;
                [~,P]=CXCORR(X,mALL_1111);
        
%                 [~,P]=CXCORR(AllTop,AllTop1);
                T=max(abs(P));
                T1=[T1,T];
                if T>=D
                    sum=sum+1;
                    ind=[ind;l,lambda,w,t];
                end
            end
        end
    end
    T2(l+1,:)=T1;
    toc
end

% sum=0;
% Ncs=23;
% ind=[];
% X=[];
% M=M_seq_gen(139);
% for l=1:15:138
%     tic
%     for lambda=1:15:138
%         for w=1:23:138
%             AllTop=AllTop_seq_gen(139,l,lambda,w);
%             for t=1:15:138
%                 M1=circshift(M,-t);
%                 X=[X;M1.*AllTop];
% %                 [~,P]=CXCORR(X,mALL_1111);
% %                 T=max(abs(P));
% %                 if T>=120
% %                     sum=sum+1;
% %                     ind=[ind;l,lambda,w,t];
% %                 end
%             end
%         end
%     end
%     toc
% end
            






