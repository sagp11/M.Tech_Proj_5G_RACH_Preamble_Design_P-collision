clc
clear all
close all
%% TO FIND THE EFFECT OF CFO ON PERIODIC CORRELATION OF DIFFERENT TYPE OF SEQUENCES UNDER STUDY

zCZC=11; %cyclic shift parameter

for signature=1:4 %loop for all types of sequences
% Lra=139;
if signature==1
[ZC64,Ncs,ZC_root]=ZC64_PREAMBLE_GEN(zCZC);
elseif signature==2
    [ZC64,Ncs,ZC_root]=ZC_M_64_PREAMBLE_GEN(zCZC);
elseif signature==3
    [ZC64,Ncs,ZC_root]=ZC_A_64_PREAMBLE_GEN(zCZC);
elseif signature==4
    [ZC64,Ncs,ZC_root]=M_ALL_64_PREAMBLE_GEN(zCZC);
end

Lra=139;
k=0:Lra-1; mu=1;

test=ZC_root(2,:); %select one root sequence

%  test=exp((-1j*(mu)*pi.*k.*(k+1))/Lra);
sample=1;
test1=upsample(test,sample); 
vec=[];

CFO=-0.5:0.005:0.5; %vary CFO

tau=-(Lra-1)/2:(Lra-1)/2; %vary cyclic shift

for j=1:length(tau) %loop over cyclic shift
    
for i=1:length(CFO) %loop over CFO
    
      nmo=0:length(test1)-1;
        CFO_phase= exp((-1i*2*pi.*CFO(i).*nmo));
        x= test1.*CFO_phase; %introduce CFO into test signal
        
% %         PDP=PERIODIC_CORR(x,test);
%         [PDP,tau]=xcorr(x,test,69);
%         vec=[vec;PDP];

y=circshift(test,tau(j)); %circular shift by tau 
x=downsample(x,sample);
        vec(i,j)= ((abs(sum(y.*conj(x))))); %find inner product
        
end %end loop over CFO
end %end loop over cyclic shift 

vec=abs(vec);
% figure; plot(vec');
VECTOR(:,:,signature)=vec; %save the signal where each page corresponds to 
                           %each type of sequence
                           
%% ploting of the result                           
lag=-69:69;
% X=repmat(lag,139,1);
% Y=repmat(CFO',1,11);
% subplot(2,2,signature)
% [X,Y] = meshgrid(tau,CFO);
% surf(Y,X,(vec))

end

%%
[X,Y] = meshgrid(tau,CFO);
figure;
% subplot(2,2,1);
mesh(Y,X,VECTOR(:,:,1),'DisplayName','ZC','FaceAlpha',1,'FaceLighting','flat');
% colormap(jet);
xlabel('Normalised CFO (f_{0})'); ylabel('cyclic shift(\tau)'); zlabel('Absolute correlation value')
title('ZC')
colorbar

figure;
% subplot(2,2,2);
mesh(Y,X,VECTOR(:,:,2),'DisplayName','mZC','FaceAlpha',1,'FaceLighting','flat');
% colormap(jet);
xlabel('Normalised CFO (f_{0})'); ylabel('cyclic shift (\tau)'); zlabel('Absolute correlation value')
title('mZC')
colorbar

figure;
% subplot(2,2,3);
mesh(Y,X,VECTOR(:,:,3),'DisplayName','ZC','FaceAlpha',1,'FaceLighting','flat');
xlabel('Normalised CFO (f_{0})'); ylabel('cyclic shift (\tau)'); zlabel('Absolute correlation value')
title('aZC')
colorbar

figure;
% subplot(2,2,4);
mesh(Y,X,VECTOR(:,:,4),'DisplayName','mZC','FaceAlpha',1,'FaceLighting','flat');
xlabel('Normalised CFO (f_{0})'); ylabel('cyclic shift (\tau)'); zlabel('Absolute correlation value')
title('mALL')
colorbar

