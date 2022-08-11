clc
clear 
close all

%% With the help of this code we can generate complete sets of different types
% of sequences and calculate their PAPR, CUBIC METRIC.
Lra=139;zCZC=11;
Ncs=2;
 v=0:1:floor(Lra/Ncs)-1;
 Cv=v*Ncs;
 
 
%% generating ZC set
[ZC_64,Ncs,ZC_root,ZC_ALL]=ZC64_PREAMBLE_GEN(zCZC);
Ncs_values=[0,2,4,6,8,10,12,13,15,17,19,23,27,34,46,69];
v=0:1:floor(Lra/Ncs)-1;
 Cv=v*Ncs;
[r,c]=size(ZC_ALL);
ZC_subset=[];
for i=1:r
%     ZC_root=[ZC_root;ZC_ALL(i,:)];
    for j=1:length(Cv)
        ZC_subset=[ZC_subset;circshift(ZC_ALL(i,:),-Cv(j),2)];
    end   
end
% load('ZC_subset.mat');

%% FUNCTION TO OBTAIN TIME DOMAIN REPRESENTATION OF TRANSMITTED PREAMBLE
ZC_time_subset=TD_PREAMBLE(ZC_subset);
%%  CCDF of ZC seq
load('ZC_set.mat')
load('ZC_time_subset.mat')
tic

%% FUNCTION TO OBTAIN PAPR FROM TIME DOMAIN TRANSMITTED SEQUNECE
P=PAPR(ZC_time_subset);
toc

%% TO OBTAIN CCDF OF PAPR OF ZC SEQUNECE
papr=-1:0.1:10;
for i=1:length(papr)
    ZC_PAPR_CCDF(i)=sum(P>papr(i),'all');
end
plot(papr,ZC_PAPR_CCDF);

%% M-SET generation
M_set=[];
M=M_seq_gen(139);
for i=0:length(M)-1
    M_set=[M_set;circshift(M,i)];
end


lag=0:138;    
figure;
P=PERIODIC_CORR(M_set(1,:),M_set(139,:));
plot(lag,P,'-s'); hold on;

%% Generating ZCm set:-
load('M_set.mat');
load('ZC_subset');
ZCm_subset=[];
ZCm_subset=[ZCm_subset;ZC_subset];
for i=1:2:139
    T=M_set(i,:).*ZC_subset;
    ZCm_subset=[ZCm_subset;T];
end

% load('ZCm_subset')
ZCm_time_subset=TD_PREAMBLE(ZCm_subset);
% CCDF of ZCm seq
load('ZC_set.mat')
load('ZCm_time_subset.mat')
tic
P=PAPR(ZCm_time_subset);
toc
papr=-1:0.1:10;
for i=1:length(papr)
    ZCm_PAPR_CCDF(i)=sum(P>papr(i),'all');
end
plot(papr,ZCm_PAPR_CCDF);

%
load('ZC_PAPR_CCDF');

load('ZCm_PAPR_CCDF');
papr=-1:0.1:10;
figure;
plot(papr,ZC_PAPR_CCDF/828); hold on;
plot(papr,ZCm_PAPR_CCDF/58788); hold on;
grid on;
figure;
semilogy(papr,ZC_PAPR_CCDF/828); hold on;
semilogy(papr,ZCm_PAPR_CCDF/58788); hold on;
grid on;

% generating M-time set
load('M_set.mat');
M_time_set=TD_PREAMBLE(M_set);
tic
P=PAPR(M_time_set);
toc
papr=-1:0.1:10;
for i=1:length(papr)
    M_PAPR_CCDF(i)=sum(P>papr(i),'all');
end
semilogy(papr,M_PAPR_CCDF/139); hold on;

%
s_rms=rms(ZC_time_subset,2);
v_norm=abs(ZC_time_subset)./s_rms;
v_norm_rms=rms((v_norm.^3),2);
CM=((20.*log10(v_norm_rms))-1.52)./(1.56);

cm=-3:0.1:5;
for i=1:length(cm)
    ZC_CM_CCDF(i)=sum(CM>cm(i),'all');
end
figure;
plot(cm,ZC_CM_CCDF/828); hold on;

% AllTop set generation
AllTop_set=[];
for i=1:138
    AllTop_set=[AllTop_set;AllTop_seq_gen(Lra,i,0,0)];
end

% Generating ZCa set:-
load('M_set.mat');
load('ZC_subset');
ZCa_subset=[];
ZCa_subset=[ZCa_subset;ZC_subset];
for i=1:2:138
    T=AllTop_set(i,:).*ZC_subset;
    ZCa_subset=[ZCa_subset;T];
end

% load('ZCa_subset')
ZCa_time_subset=TD_PREAMBLE(ZCa_subset);

%
tic
load('ZC_time_subset.mat')
[CM,ZC_CM_CCDF,cm]=CUBIC_METRIC(ZC_time_subset);
[P,ZC_P_CCDF,papr]=PAPR(ZC_time_subset);
figure;
plot(cm,1-ZC_CM_CCDF,'-*r'); hold on;
plot(cm,1-ZC_P_CCDF,'-sr'); hold on;

load('ZCm_time_subset.mat')
[CM,ZCm_CM_CCDF,cm]=CUBIC_METRIC(ZCm_time_subset);
[P,ZCm_P_CCDF,papr]=PAPR(ZCm_time_subset);
% figure;
plot(cm,1-ZCm_CM_CCDF,'-*g'); hold on;
plot(cm,1-ZCm_P_CCDF,'-sg'); hold on;

load('ZCa_time_subset.mat')
[CM,ZCa_CM_CCDF,cm]=CUBIC_METRIC(ZCa_time_subset);
[P,ZCa_P_CCDF,papr]=PAPR(ZCa_time_subset);
% figure;
plot(cm,1-ZCa_CM_CCDF,'-*b'); hold on;
plot(cm,1-ZCa_P_CCDF,'-sb'); hold on;


load('AllTop_time_set.mat')
[CM,A_CM_CCDF,cm]=CUBIC_METRIC(AllTop_time_set);
[P,A_P_CCDF,papr]=PAPR(AllTop_time_set);
% figure;
plot(cm,1-A_CM_CCDF,'-*c'); hold on;
plot(cm,1-A_P_CCDF,'-sc'); hold on;

load('M_time_set.mat')
[CM,M_CM_CCDF,cm]=CUBIC_METRIC(M_time_set);
[P,M_P_CCDF,papr]=PAPR(M_time_set);
% figure;
plot(cm,1-M_CM_CCDF,'-*y'); hold on;
plot(cm,1-M_P_CCDF,'-sy'); hold on;
toc

%
load('A_CCDF.mat')
load('M_CCDF.mat')
load('ZC_CCDF.mat')
load('ZCa_CCDF.mat')
load('ZCm_CCDF.mat')
load('MALL_CCDF.mat')
figure;
plot(papr,1-A_CM_CCDF,'-*c','DisplayName','AllTop'); hold on;
P1=plot(papr,1-A_P_CCDF,'-sc','DisplayName','AllTop'); hold on;

plot(papr,1-M_CM_CCDF,'-*y'); hold on;
P2=plot(papr,1-M_P_CCDF,'-sy','DisplayName','M'); hold on;

plot(papr,1-ZC_CM_CCDF,'-*r'); hold on;
P3=plot(papr,1-ZC_P_CCDF,'-sr','DisplayName','ZC'); hold on;

plot(papr,1-ZCa_CM_CCDF,'-*g'); hold on;
P4=plot(papr,1-ZCa_P_CCDF,'-sg','DisplayName','ZCa'); hold on;

plot(papr,1-ZCm_CM_CCDF,'-*b'); hold on;
P5=plot(papr,1-ZCm_P_CCDF,'-sb','DisplayName','ZCm'); hold on;

plot(papr,1-MALL_CM_CCDF,'-*m'); hold on;
P6=plot(papr,1-MALL_P_CCDF,'-sm','DisplayName','MAll'); hold on;
legend([P1,P2,P3,P4,P5,P6],{'AllTop','M','ZC','ZCa','ZCm','M-All'})


% AllTop set generation
AllTop_set=[];
for i=1:20:138
    for j=1:20:138
        for k=1:20:138
    AllTop_set=[AllTop_set;AllTop_seq_gen(Lra,i,0,0)];
        end
    end
end

% Generating ZCa set:-
load('M_set.mat');
% load('AllTop_set');
M_All_subset=[];
M_All_subset=[M_All_subset;AllTop_set];
for i=1:1:138
    T=M_set(i,:).*AllTop_set;
    M_All_subset=[M_All_subset;T];
end

load('M_All_subset')
M_All_time_subset=TD_PREAMBLE(M_All_subset);
load('M_All_time_subset.mat');
[P,PAPR_CCDF,papr] = PAPR(M_All_time_subset);
load('ZCm_time_subset.mat');
load('ZC.mat');
F=fftshift(fft(ZC));
plot(abs(F));

load('M_All_CCDF')
[CM,M_All_CM_CCDF,cm]=CUBIC_METRIC(M_All_time_subset);


[ZC_64,Ncs,ZC_root,ZC_ALL]=ZC64_PREAMBLE_GEN(zCZC);
X=TD_PREAMBLE(ZC_ALL(1,:));
F=fftshift(fft(X));
figure;
semilogy(abs(F))




