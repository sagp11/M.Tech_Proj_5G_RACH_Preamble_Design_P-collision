 %% DESCRIPTION of function:- [count]=SECTOR_CHNG_RATE(TracePoints)

%% input: 
% TracePoints:- Array of complex numbers representing the position of a
%               moving UE in the restricted area.
%% output:
% count:- sector change rate

%%
function [count]=SECTOR_CHNG_RATE(TracePoints)
Nbeam=64; %number of beams
step=2*pi/Nbeam; 
SectorAngle=-pi:step:pi; %dividing angles based on number of sectors
PathAngles=angle(TracePoints); %angles of tracepoints of UE

%calculating the sector number for a given tracepoint by first dividing the
%angle of a given tracepoint by step size and then ceiling and flooring
%based on the quadrant.
FractionAngles=PathAngles./step;
for i=1:length(FractionAngles)
    if FractionAngles(i)>=0
        Sector(i)=ceil(FractionAngles(i));
    else
        Sector(i)=floor(FractionAngles(i));
    end
end

% Finding changes in sector wrt previous stage
count=0;
temp=Sector(1);
for i=2:length(Sector)
    if Sector(i)~=temp
        count=count+1;
    end
    temp=Sector(i);
end

end %end FUNCTION