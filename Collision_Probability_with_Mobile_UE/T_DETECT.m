function [t_detect,arr]=T_DETECT(PDP,Ncs,ALPHA,N,zCZC)
Lra=139;
[r_pdp,c_pdp]=size(PDP);
if Ncs~=0
    no_of_windows=floor(c_pdp/Ncs);
elseif Ncs==0
    Ncs=139;
    no_of_windows=1;
end
index=1;
arr=zeros(r_pdp,2,no_of_windows);
for i=1:no_of_windows
    [M,I]=max(PDP(:,(index:index+Ncs-1)),[],2);
    index=index+Ncs;
    arr(:,:,i)=[M I];
end
%%
% t_factor=chi2inv(0.999,2*N);
% t_factor=chi2inv(0.999,1);

mcv=mean(PDP,2);

%% EXPERIMENTAL to calculate mcv
% for i=1:r_pdp
%     temp1=zeros(zCZC,Lra);
%     temp1(i,:)=PDP(i,:);
%     temp2=mean(PDP-temp1,'all');
%     mcv(i)=temp2;
% end
% 
% for i=1:r_pdp
%     
%     mcv(i)=temp2;
% end
    
%%
% temp1=PDP<ALPHA.*mcv;
% temp2=sum(temp1,2);
% temp3=PDP.*temp1;
% mn=(1./temp2).*sum(temp3,2);
% t_detect=t_factor.*mn;
% temp=max(t_detect);
% for i=1:r_pdp
%     t_detect(i,:)=temp;
% end

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

end