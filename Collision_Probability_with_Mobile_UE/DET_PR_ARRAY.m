%% DESCRIPTION of function 
%[detected_PR_array,chosen_PR_array] = DET_PR_ARRAY(rach_instances,PathLoss,users)

%% input:
% rach_instance:- instances at which beam recovery is attempted by
%                transmitting a preamble where rows represent for each user and columns
%                represent the time instances.
% PathLoss:- Pathloss experienced by users at any given instances
% users:- total number of users

%% output:-
% detected_PR_array:- array of preamble indexes detected at receivers considering the pathlosses
% chosen_PR_array:- array of preamble indexes chosen tobe transmitted when attempting
%                   beam recovery

%%

function [detected_PR_array,chosen_PR_array] = DET_PR_ARRAY(rach_instances,PathLoss,users)

PathLoss_RACH=PathLoss.*rach_instances; %path losses at rach instances only
Threshold_dB=120;
Lra=139;    
zCZC=11; 
ALPHA=6;
N=4;
% For each instance transmitt a PRACH selected randomly:-
[ZC_64,~,ZC_root,~]=ZC64_PREAMBLE_GEN(zCZC); %generate 64 preambles
[r,c]=size(rach_instances);
for i=1:c %loop for each time instance
    if sum(rach_instances(:,i),'all') %check if instances are empty or not
    for j=1:r   %loop for each user    
            if rach_instances(j,i) == 1 %condition for beam recovery transmitt preamble
                choose_seq(j,1)=randi(64); %randomly choose preamble
                PR_trans(j,:)=ZC_64(choose_seq(j,1),:); %select random seq from 
                %64 preambles for valid RACH instance.
                SNR(j,1)= -10.2 + (120 - PathLoss_RACH(j,i)); %introduce SNR
                % at recieiver using receiver sensitivity
                PR_receive(j,:) = awgn(PR_trans(j,:),SNR(j,1),'measured');
            elseif rach_instances(j,i) == 0
                PR_receive(j,:)=zeros(1,Lra);
                choose_seq(j,1)=0;
            end   %end condition for beam recovery  
            
    end %end loop for each user
    
    %To detect index at receiver given by DET_IND
    [t_detect,det_index,PDP,DET_IND]= ...
    ZC_detect_for_RACH(ZC_root,ALPHA,N,PR_receive,users,choose_seq);

    chosen_PR_array(:,i)=choose_seq; %update array
    detected_PR_array(:,i)=DET_IND; %update array
    
    elseif ~sum(rach_instances(:,i),'all') %condition in absence of transmission of preamble
            chosen_PR_array(:,i)=zeros(r,1); %update array
            detected_PR_array(:,i)=zeros(r,1); %update array
    end %end condition for checking empty instances
    
end %end loop for each instance

end %end FUNCTION


