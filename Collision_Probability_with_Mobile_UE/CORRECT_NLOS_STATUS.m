%% DESCRIPTION of function:- 
% [PathLoss,PathStatus,R_Angle,R_Dist]=CORRECT_NLOS_STATUS(TracePoints,RestrictAngles,...
% RestrictDistance)
%% input: 
% RestrictAngle:- an array of pairs of angles where between whom the status of UE is NLOS
% RestrictDistance:- distance of obstalce points where RestricAngles are calculated
% TracePoints:- Array of complex numbers representing the position of a
%               moving UE in the restricted area.
%% output:
% PathLoss:- Pathloss in dB associated with each instance based on the LOS and NLOS
% PathStatus:- '1' represents NLOS and '0' represents LOS in an array for a given tracepoint.
% RAngle:- Reshaped version of RestrictAngles
% RDistance:- Reshaped version of RestrictDistance

%%

function [PathLoss,PathStatus,R_Angle,R_Dist]=CORRECT_NLOS_STATUS(TracePoints,RestrictAngles,...
    RestrictDistance)
PathDistance=abs(TracePoints); %distance of UE from center
PathAngles=angle(TracePoints); %angle of UE
Instances=length(TracePoints);
PathStatus=zeros(1,Instances); %initiate pathstatus to store status as NLOS or LOS
R_Angle=reshape(RestrictAngles,2,[])';
R_Dist=reshape(RestrictDistance,2,[])';
[r,~]=size(R_Angle);
for i=1:Instances %loop for all instances
    for j=1:r %loop to check for all restricted angles
        if PathAngles(i) > R_Angle(j,1) && PathAngles(i) < R_Angle(j,2) ...
                && PathDistance(i) >R_Dist(j,1) %condition to find NLOS status
            PathStatus(i)=1;
            break;
        end %end NLOS condition
    end %end loop for all restricted angles
end % end loop for all instances

PathLoss=zeros(1,Instances);

%Calculating PathLoss for each instance based on LOS and NLOS status
for i=1:Instances
    Status=PathStatus(i);
    %FUNCTION PathLoss(i)=P_LOSS(PathDistance(i),30,Status) calculate
    %pathloss in dB for a given distance and NLOS status.
         PathLoss(i)=P_LOSS(PathDistance(i),30,Status);
end

end %end FUNCTION