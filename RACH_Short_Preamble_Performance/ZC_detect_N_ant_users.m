%% DESCRIPTION OF FUNCTION
% [P_T,P_false,P_detect,P_trial,t_detect,det_index,PDP,T_mean]= ...
%     ZC_detect_N_ant_users(zCZC,ALPHA,iter,N,users,SNR,signature,method,CFO)

%% input
% zCZC:- zeroCorrelationZoneConfig parameter related to the cyclic shift
%        see function ZC64_PREAMBLE_GEN.
% ALPHA:- constant related to threshold setting corresponding to number of antennas
% iter:- number of iterations to be used in simulation
% N:- number of antennas
% users:- number of users
% SNR:- the range of SNR under study
% signature:- represents the type of sequence under study where
%             '1' represents pure ZC sequence
%             '2' represents mZC sequence
%             '3' represents aZC sequence
%             '4' represents mALL sequence
% method:- '1' represents the reception of a transmitted sequence
%          '2' represents reception of noise only for ALPHA calculation
% CFO:- is the Carrier frequency offset.         

%% output
% P_T:- gives the probability of mis-detection when input is noise only i.e
%       method '2'
% P_false:- gives the probability of false detection
% P_detect:- probability of correct detection
% P_trial:- give the probability of mis-detection 
% t_detect,det_index,PDP,T_mean:- these are extra parameters extracted to
%                                 study and debug the code

%%


function [P_T,P_false,P_detect,P_trial,t_detect,det_index,PDP,T_mean]= ...
    ZC_detect_N_ant_users(zCZC,ALPHA,iter,N,users,SNR,signature,method,CFO)
% tic
Lra=139; %initiate the length of sequence


if signature==1 %start condition on sequence under study
[ZC64,Ncs,ZC_root]=ZC64_PREAMBLE_GEN(zCZC); %for pure ZC
elseif signature==2
    [ZC64,Ncs,ZC_root]=ZC_M_64_PREAMBLE_GEN(zCZC); % for mZC
elseif signature==3
    [ZC64,Ncs,ZC_root]=ZC_A_64_PREAMBLE_GEN(zCZC); %for aZC
elseif signature==4
    [ZC64,Ncs,ZC_root]=M_ALL_64_PREAMBLE_GEN(zCZC); % for mALL
end %end condition of sequnce under study

% NOTE:- the functions (1)ZC64_PREAMBLE_GEN, (2)ZC_M_64_PREAMBLE_GEN, 
% (3)ZC_A_64_PREAMBLE_GEN and (4)M_ALL_64_PREAMBLE_GEN are very similar and
% only a part of code is modified to obtain the required signature sequence

if signature ==1 && N == 1
    ALPHA=13.7;
end


for i=1:length(SNR) %start SNR loop
    %initialisations of different counts
    count=0; %count for mis-detections at noise only
    count1=0; %count for mis-detections
    false_count=0; %count for false detetions
    det=0; % count for correct detections
%     i
    T_d=[];
    for j=1:iter %start iteration loop for a given SNR
%         j
        t_rand=randi(64); %generate random interger from 1-64
        
        %for multiple users we didnt want to choose same sequence hence the
        %for loop.
        for n=1:users
            t_rand=t_rand+13;
            choose(n)=mod(t_rand,64)+1;
            %here 'choose' array contains the index of sequences from 1-64 
            %chosen to be transmitted 
%             TX_arr(n,:)=ZC64(choose(n),:);
        end
        
        
        TX_arr=ZC64(choose,:); %choose sequences to be transmitted
        TX=zeros(1,Lra);
        for n=1:users
            TX=TX+TX_arr(n,:); %add sequences at the receiver
        end
%         CFO=0.25;

%% Introducing CFO
%         TX=upsample(TX,128);
        nmo=0:length(TX)-1;
        CFO_phase= exp((-1i*2*pi*CFO.*nmo)/Lra);
        TX= TX.*CFO_phase;
%         TX=downsample(TX,128);
     %%
     
        PDP=zeros(zCZC,Lra);
%          PDP=zeros(64,Lra);

        for m=1:N  % start loop for number of antennas
            
            if method==1 %for normal reception of signal
                
%             TX1=awgn(TX,SNR(i),'measured');
            
               noise = complex(randn(1,Lra), randn(1,Lra)); %noise sequence
               np=sum((abs(noise)).^2)/Lra; % noise power
               
%                sp= sum((abs(TX)).^2)/Lra;
               snr=db2pow(SNR(i)); 
               req_pow= snr*np; %get receive power of signal to achive sequired SNR
               TX1=sqrt(req_pow).*TX + noise; %add noise the the received signal
               
%                sp= sum((abs(TX1)).^2)/Lra;
               
               
               
            elseif method==2 %for reception of noise only 
                TX1= (1/sqrt(2)).*(randn(1,Lra)+1i*randn(1,Lra)); 
                
            end %end condition for method
            
            temp_PDP=PERIODIC_CORR(TX1,ZC_root); %calculate PDP for given received sequence
            %and root sequences present at receiver. See function
            %PERIODIC_CORR

%             temp_PDP=PERIODIC_CORR(TX1,ZC64);  %CHANGED EDIT
            
            PDP=PDP+temp_PDP; %equal gain combining
             
        end %end loop for number of antennas
        
        [t_detect,arr,mcv]=T_DETECT(PDP,Ncs,ALPHA,N,zCZC,signature); %calculate the threshold for detection
        %SEE function T_DETECT
        
        T_d=[T_d,mcv];
        
        det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N); %obtain the indexes of sequences where
        %the peak value is greater than threshold. See function
        %INDEX_DET_WINDOW

%         det_index=NEW_DETECTION_64(PDP,Ncs,ALPHA,signature,N); %CHANGED EDIT  
        
        [r,c]=size(det_index);
        if method==1 %for normal reception
            if r==0 %if no sequence is detected count mis-detection
                count1=count1+users;
            else 
                G=sum(det_index(:,1)==choose,'all'); %number of sequences detected from 
                %chose sequences
                
                det=det+G; % count towards correct detection
                
                count1=count1+users-G; %number of users - correct detections to be calculated as 
                                       %mis-detection
                
                if (r-G)>=1 
                   %correct detection and extra detection to be counted towards false alarm (AMBIGUOUS)
%                  false_count=false_count+(r-G);
                    false_count=false_count+1; 
                end
                
            end %end condition 
        elseif method==2 %for recetion of noise only 
            if r>0 %if any sequence is detected count it towards mis-detection
                count=count+1;
            end
            
        end %end condition for method again
        
    end % end iteration loop
    

%     if method==1


% FINDING PROBABILITIES
    P_false(i)=false_count/(iter*users);
    P_detect(i)=det/(users*iter);
    P_trial(i)=count1/(users*iter);
%     elseif method==2
        P_T(i)= count/iter;
        T_mean(i)=mean(T_d,'all');
%     end

end %end SNR loop

% toc

end %end FUNCTION
