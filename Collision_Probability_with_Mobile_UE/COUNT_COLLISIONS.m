%% DESCRIPTION of function 
%[SUCCESSFUL_USERS,COLLIDED_USERS,COLLISIONS] = COUNT_COLLISIONS(detected_PR_array)

%% input:
% detected_PR_array:- array of preamble indexes detected at receivers considering the pathlosses

%% output:-
% SUCCESSFUL_USERS:-  %storing number of SUCCESSFUL users for a given time instance
% COLLIDED_USERS:-  %storing number of COLLIDED users for a given time instance

%%

function [SUCCESSFUL_USERS,COLLIDED_USERS,COLLISIONS] = COUNT_COLLISIONS(detected_PR_array)
count=0;    count1=0;   COLLISIONS=[0;0];
[r,c]=size(detected_PR_array);
for i=1:c %loop for a given time instance
    collision_count=0;
    
    if sum(detected_PR_array(:,i),'all') %check empty detected preamble columns
        arr=zeros(65,1);
        for j=1:r
            if (detected_PR_array(j,i))>0
            arr(detected_PR_array(j,i))= arr(detected_PR_array(j,i))+1; %frequency count
            end
            arr(65,1)=i; %append instance number to arr
        end
%         collision_count= sum(arr(1:64,1)>1,'all');
%         COLLISIONS(:,count) = [collision_count;arr(65,1)];
    
    temp1=arr(1:64) == 1; %for succesful users
    ARR1=[arr(1:64).*temp1;0];
    temp2=arr(1:64)>1; %for collided users
    ARR2=[arr(1:64).*temp2;0];
    successful_users=sum(ARR1,'all');
    collided_users=sum(ARR2,'all');
    
    collision_count = sum(arr(1:64,1)>1,'all');
    
    index=arr(65,1);
    count1=count1+1;
    
    %storing number of SUCCESSFUL and COLLIDED users for a given time
    %instance.
    COLLIDED_USERS(:,count1)=[collided_users;index];
    SUCCESSFUL_USERS(:,count1)=[successful_users;index];
    else
        count1=count1+1;
        COLLIDED_USERS(:,count1)=[0;i];
    SUCCESSFUL_USERS(:,count1)=[0;i];
    end 
    
    if collision_count
        count=count+1;
        COLLISIONS(:,count) = [collision_count;index];
%         COLLIDED_USERS(:,count)=[collided_users;index];
%         SUCCESSFUL_USERS(:,count)=[successful_users;index];
    end
end %end loop for a given time instance

end %end FUNCTION

