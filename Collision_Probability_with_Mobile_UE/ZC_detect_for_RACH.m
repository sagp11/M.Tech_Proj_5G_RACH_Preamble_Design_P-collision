%% DESCRIPTION of function 
% [t_detect,det_index,PDP,DET_IND]= ...
%     ZC_detect_for_RACH(ZC_root,ALPHA,N,PR_receive,users,choose_seq)

%% input:
% ZC_root:- root sequences present at receiver
% ALPHA:- threshold constant for detection
% N:- Number of Antennas
%PR_receive:- Received signal at the antenna
%users:- number of users
%choose_seq:- chosen sequence for comparison

%% output:-
% DET_IND:- detected index at receiver

%%

function [t_detect,det_index,PDP,DET_IND]= ...
    ZC_detect_for_RACH(ZC_root,ALPHA,N,PR_receive,users,choose_seq)
% tic
Lra=139; %length of sequence
signature=1;
        
        TX=zeros(1,Lra);
        
        %adding all signals received by different users at receiver
        for n=1:users
            TX=TX+PR_receive(n,:);
        end
        
        RX=TX; %received signal;
        PDP=zeros(height(ZC_root),Lra);
        
        %equal gain combining of all PDP at receiver for given number of
        %receive antennas
        for m=1:N
            temp_PDP=PERIODIC_CORR(TX,ZC_root); %calculating PDP
            PDP=PDP+temp_PDP;
        end
        
        %function to calculate the threshold for detection 
        [t_detect,arr]=T_DETECT(PDP,23,ALPHA,N,11);
        
        %function to calculate all detected sequences beyond the threshold
        det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N);
        [r,~]=size(det_index);
        DET_IND=zeros(users,1);
        
        % To calculate if the transmitted sequence is detected in the the
        % detected indexes.
        if r>0
            for i=1:height(choose_seq)
%                 D=det_index(:,1) == choose_seq(i);
                
                if sum(det_index(:,1) == choose_seq(i),'all')
                    DET_IND(i)=choose_seq(i);
                end
            end
        end
        
                
                
%             if r==0
%                 count1=count1+users;
%             else 
%                 G=sum(det_index(:,1)==choose,'all');
%                 det=det+G;
%                 count1=count1+users-G;
%                 if (r-G)>=1
%                     false_count=false_count+1;
%                 end
%                 
%             end
    
%        
  
%     P_miss(i)=count/iter;
%     if method==1
%     P_false(i)=false_count/iter;
%     P_detect(i)=det/(users*iter);
%     P_trial(i)=count1/(users*iter);
% %     elseif method==2
%         P_T(i)= count/iter;
%     e
end %end FUNCTION


