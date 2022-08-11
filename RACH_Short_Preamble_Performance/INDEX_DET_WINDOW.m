%% DESCRIPTION of finction
% det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N)

%% input
% arr:- the arr which contain max value from each window of PDP
% t_detect:- the threshold value obtained for each row of PDP
% signature:- type of sequence under study
% N:- number of antennas at receiver

%%output
% det_index:- contains an array of the index of detected sequences where 
%             the max value in 'arr' is greated than threshold t_detect  


function det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N)
det_index=[];
L=139;
y=0;

T=max(t_detect); % EXPERIMENTAL

%THIS condition is EXPERIMENTAL
if signature==1
    y=(sqrt(L)).^2.*N;
elseif signature == 2
    y=(2*sqrt(L+1) + log2(L+1)).^2.*N;
elseif signature == 3
    y= (2*sqrt(L)).^2.*N;
elseif signature == 4
    y= (2*sqrt(L+1) + log2(L+1)).^2.*N;
end

 
y=0; % *** if above experimental method is used this line is to be commented 


[r_arr,c_arr,p_arr]=size(arr);


for i=1:p_arr  %loop for each window
    for j=1:r_arr %loop for each row corresponding to the row of PDP
        
        if arr(j,1,i) > (t_detect(j)+y) %compare with threshold for each row
%              if arr(j,1,i) > (t_detect+y)
            x=((j-1)*p_arr)+i;
            det_index=[det_index;x arr(j,2,i)]; %determine the index i.e. the index of 
            %transmitted sequence from a set of 64 sequences based on the
            %window number and row number.
            
        end % end condition for threshold comparision
    end %end loop for rows
end %end loop for window number
end %end FUNCTION
