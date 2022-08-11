%% DECRIPTION of function 
% [P_T,T_mean]= ZC_determine_threshold(zCZC,ALPHA,iter,N,signature)
% This function is designed to obtain a tuned value for threshold constant
% where the input signal is noise only

%% THIS FUNCTION PERFORMS VERY SIMILARY TO THE FUNCTION 'ZC_detect_N_ant_users'
%% input:- 
% zCZC:- cyclic shift parameter
% ALPHA:- threshold constant (will be variable)
% iter:- number of iterations >=10000
% N:- number of antennas
% signature:- type of sequence

%% output:-
%P_T:- probability of mis-detection when input is noise only
% T_mean:- for study purpose and debug (mean threshold value)

%%

function [P_T,T_mean]= ...
    ZC_determine_threshold(zCZC,ALPHA,iter,N,signature)
% tic
Lra=139;
if signature==1
[ZC64,Ncs,ZC_root]=ZC64_PREAMBLE_GEN(zCZC);
elseif signature==2
    [ZC64,Ncs,ZC_root]=ZC_M_64_PREAMBLE_GEN(zCZC);
elseif signature==3
    [ZC64,Ncs,ZC_root]=ZC_A_64_PREAMBLE_GEN(zCZC);
elseif signature==4
    [ZC64,Ncs,ZC_root]=M_ALL_64_PREAMBLE_GEN(zCZC);
end
% PDP=zeros(11,Lra);
    count=0;  
    T_d=[];
for j=1:iter 
    
    PDP=zeros(height(ZC_root),Lra);
        for ant=1:N
%             TX1= (1/sqrt(2)).*(randn(1,Lra)+1i*randn(1,Lra));

            TX1 = complex(randn(1,Lra), randn(1,Lra)); % received NOISE signal only
            PDP=PDP+PERIODIC_CORR(TX1,ZC_root);
        end
        [t_detect,arr,mcv]=T_DETECT(PDP,Ncs,ALPHA,N,zCZC,signature);
        det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N);
        T_d=[T_d,mcv];
%         det_index=NEW_DETECTION_64(PDP,Ncs,ALPHA);
        [r,~]=size(det_index);
       
            if r>0
                count=count+1;
            end
    
end
P_T= count/iter;
T_mean=mean(T_d,'all');
end
