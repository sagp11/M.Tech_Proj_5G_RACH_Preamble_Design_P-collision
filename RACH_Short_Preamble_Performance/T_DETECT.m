%% DESCRIPTION OF FUNCTION
% [t_detect,arr,mcv]=T_DETECT(PDP,Ncs,ALPHA,N,zCZC,signature)

%% input
% PDP:- power delay profile obtained by periodic correlation at receiver
% Ncs:- the cyclic shift associated with zCZC parameter
% ALPHA:- the threshold constant associated with number of antenna 'N'
% N:- Number of antenna
% signature:- the type of sequence under study
% zCZC:- zeroCorrelationZoneConfig related to the cyclic shift

%% output
% t_detect:- detection threshold for each row of pdp
% arr:- max value of the samples is the window and it corresponding index array
%       This is three dimensional array where:-
%       ROWS:- correspond to each row of PDP
%       COLUMNS:- the index of max value of the window
%       PAGES:- correspond to moving the window to next Ncs samples (window number)
% mcv:- mean value (depends on method used)

%%

function [t_detect,arr,mcv]=T_DETECT(PDP,Ncs,ALPHA,N,zCZC,signature)
Lra=139;
[r_pdp,c_pdp]=size(PDP);

%calcuating the number of windows based on Ncs value
if Ncs~=0
    no_of_windows=floor(c_pdp/Ncs);
elseif Ncs==0
    Ncs=139;
    no_of_windows=1;
end


index=1;
arr=zeros(r_pdp,2,no_of_windows);

for i=1:no_of_windows
    [M,I]=max(PDP(:,(index:index+Ncs-1)),[],2); %from the windos of length Ncs
    %find the maximum value in a given window and its index and store them
    %into the 'arr'.
    index=index+Ncs;
    arr(:,:,i)=[M I]; %for each moving window stores the values in next page.
end
%%
% t_factor=chi2inv(0.999,2*N);
% t_factor=chi2inv(0.999,1);
% mcv=mean(PDP,2);

%% THIS SECTION IS EXPERIMENTAL ON TRIAL AND ERROR BASIS AND CAN BE EXPLORED 
% FURTHER TO FINE TUNE THE DETECTION THRESHOLD ACCORDING TO THE TYPE OF
% SEQUENCE UNDER STUDY TO ACHIEVE THE REQUIRE FALSE ALRAM RATE AND
% DETECTION PERFORMANCE


%NEW METHOD calculate mean 'mcv' based on the CFR thresholding.

for i=1:r_pdp
    temp1=PDP;
    temp1(i,:)=[];
    temp2=mean(temp1,2);
    temp3=mean(temp2);
    mcv(i)=temp3;
end

% temp1=sort(PDP,2,'descend');
% temp2=temp1(:,10:end);
% mcv=mean(temp2,2);

% ALPHA=2;

% temp1=PDP<ALPHA.*mcv;
% temp2=sum(temp1,2);
% temp3=PDP.*temp1;
% mn=(1./temp2).*sum(temp3,2);
% t_detect=t_factor.*mn;
% temp=max(t_detect);
% for i=1:r_pdp
%     t_detect(i,:)=temp;
% end




% ADAPTIVE SETTING OF ALPHA
if N==8
if signature==1
    ALPHA=ALPHA;
elseif signature == 2
    ALPHA=(5.*mcv + 12821)./6014;
elseif signature == 3
    ALPHA=ALPHA;
elseif signature==4
    ALPHA=(5.*mcv + 12821)./6014;
end
end

if N==4
if signature==1
    ALPHA=ALPHA;
elseif signature == 2
%     ALPHA=(3.*mcv + 14706)./3366;
    ALPHA=(3.*mcv + 15000)./3366;
elseif signature == 3
    ALPHA=ALPHA;
elseif signature==4
%     ALPHA=(3.*mcv + 14706)./3366;
    ALPHA=(3.*mcv + 15000)./3366;
end
end

if N==2
if signature==1
    ALPHA=ALPHA;
elseif signature == 2
%     ALPHA=(3.*mcv + 10333)./1502;
     ALPHA=(3.*mcv + 11000)./1502;
elseif signature == 3
    ALPHA=ALPHA;
elseif signature==4
%     ALPHA=(3.*mcv + 10333)./1502;
     ALPHA=(3.*mcv + 11000)./1502;
end
end






%%
mcv=mean(PDP,2); %***THIS LINE IS TO BE DELETED IF WE EMPLOY ABOVE EXPERIMENTAL METHOD*** 

%%
t_detect=ALPHA.*(mcv);

%%
% peak_sum=sum(arr(:,1,:),3);
% power_PDP=sum(PDP,2);
% noise_indexes=Lra-no_of_windows;
% noise_floor=(1/noise_indexes).*(power_PDP-peak_sum);
% alpha=1;
% noise_threshold=alpha.*noise_floor;
% max_peak=max(max(arr(:,1,:),[],3));
% beta=0.5;
% weak_threshold=beta.*max_peak;

end % end FUNCTION