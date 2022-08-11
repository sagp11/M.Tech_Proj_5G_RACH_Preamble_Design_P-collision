%% DESCRIPTION of function:- 
% [Path_fail_time,PathBreak,PathFailure,R,X]=FAILURE_COUNT(PathLoss)
%% input: 
% PathLoss:- Pathloss in dB associated with each instance based on the LOS and NLOS
%% output:
% Path_fail_time:- number of times a beam failure occurs
% PathBreak:- Conidtions where pathloss goes beyond threshold of 120dB

%%
function [Path_fail_time,PathBreak,PathFailure,R,X]=FAILURE_COUNT(PathLoss)
% Threshold=P_LOSS(250,30,0);  
Threshold=120;
PathBreak=PathLoss>=Threshold;
PathFailure=[];
Len=length(PathBreak);
temp_count=0;
R=[];
X=[];
for j=1:Len
    if PathBreak(j)==1
        break;
    else 
        PathFailure=[PathFailure,0];
        X=[X,0];
    end
end
if j<=Len && PathBreak(j)==1
for i=j:Len
    if PathBreak(i)==1
        temp_count=temp_count+1;
        X=[X,0];
    elseif PathBreak(i)==0
        PathFailure=[PathFailure,temp_count];
        if PathBreak(i-1) == 1 && i>1 && temp_count>=2
            R=[R,i];
            X=[X,1];
        elseif temp_count<=1
            X=[X,0];
        end        
        temp_count=0;
    end 
end
% elseif j==Len
%     X=[X,0];
end
if ~isempty(PathBreak)
if  PathBreak(end)==1
    PathFailure=[PathFailure,temp_count];
end
end
Path_fail_time=sum(PathFailure>=2);
end


