%% DESCRIPTION of function:- [allPPP,RestrictAngles,RestrictDistance]=OBSTRUCTIONS(buildDensity)
%% input: 
%buildDensity:- number of expected building in a given area
%% output:
% allPPP:- all points to represent buildings in a area
% RestrictAngle:- an array of pairs of angles where between whom the status of UE is NLOS
% RestrictDistance:- distance of obstalce points where RestricAngles are calculated

%%
function [allPPP,RestrictAngles,RestrictDistance]=OBSTRUCTIONS(buildDensity)
allPPP=[];
RestrictAngles=[];
RestrictDistance=[];
Points=[];
numBuilding=poissrnd(buildDensity);
if numBuilding==0
    numBuilding=1;
end
% numBuilding=5;
% figure;
for i=1:numBuilding
lambda=5; %density for plot construction only (NO REAL USE)
Max=randi([10,20]); %random building size
xMin=0;xMax=Max;    yMin=0;yMax=Max; %setting size for building

% areaTotal=(xMax-xMin)*(yMax-yMin);
areaTotal=(xMax)*(yMax); %MODIFIED %Area of the building

numbPoints=poissrnd(areaTotal*lambda); %Poisson number of points
PPP=(xMax*(rand(1,numbPoints))) + 1i*(yMax*(rand(1,numbPoints))); 
%to generate points for building representation only

%random position for building
% x=randi([-10,10])*25;   y=randi([-10,10])*25;
x=randi([-100,100])*2.5;   y=randi([-100,100])*2.5;%MODIFIED

M=Max/2;
PPP=PPP-(M + 1i*M)+(x+1i*y); %points for PLOTS only

Points=[Points,[x+1i*y;M]]; %center points of buildings and their sizes 

allPPP=[allPPP PPP]; %for PLOTS only
% figure;  
% scatter(0,0,200,'d','filled'); hold on; 
% scatter(real(PPP),imag(PPP),'.'); grid on; hold on;
end

ObsAngles1=angle(Points(1,:)); %angles for buildings
ObsDistance1=abs(Points(1,:)); %distances of buildingd from center
ObsSize1=Points(2,:); %obstacle size array
ObsPoints1=Points(1,:); %obstacles center points

%sorting obstalce angles and rearranging obstacle center points according
%to the increasing angles.
[ObsAngles,I]=sort(ObsAngles1); 
for i=1:length(I)
    ObsDistance(i)=ObsDistance1(I(i));
    ObsSize(i)=ObsSize1(I(i));
    ObsPoints(i)=ObsPoints1(I(i));
end

for i=1:length(I) %loop for all obstacle center points
    Ang=ObsAngles(i);
    
if Ang>=0 && Ang<pi/2 %conditioning on quadrants
    
    %choosing corner points based on quadrant and center points of
    %buildings
    temp1=(ObsSize(i) - 1i*ObsSize(i)) + ObsPoints(i); 
    temp2=(-ObsSize(i) + 1i*ObsSize(i)) + ObsPoints(i);
    
    %deciding pairs of  restricted angles based on the placement of corner points
    if angle(temp1)<0
        RestrictAngles=[RestrictAngles,angle(temp1),0,0,angle(temp2)];
        RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i),ObsDistance(i),ObsDistance(i)];
    else
    RestrictAngles=[RestrictAngles,angle(temp1),angle(temp2)];
    RestrictDistance=[RestrictDistance,ObsDistance(i),ObsDistance(i)];
    end
    
elseif Ang>=pi/2 && Ang<=pi%conditioning on quadrants
    
    %choosing corner points based on quadrant and center points of
    %buildings
    temp1=(ObsSize(i) + 1i*ObsSize(i)) + ObsPoints(i);
    temp2=(-ObsSize(i) - 1i*ObsSize(i)) + ObsPoints(i);
    if angle(temp2)<0
        RestrictAngles=[RestrictAngles,angle(temp1),pi,-pi,angle(temp2)];
         RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i),ObsDistance(i),ObsDistance(i)];
    else
    RestrictAngles=[RestrictAngles,angle(temp1),angle(temp2)];
     RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i)];
    end
    
elseif Ang<0 && Ang>=-pi/2%conditioning on quadrants
    
    %choosing corner points based on quadrant and center points of
    %buildings
    temp1=(-ObsSize(i) - 1i*ObsSize(i)) + ObsPoints(i);
    temp2=(ObsSize(i) + 1i*ObsSize(i)) + ObsPoints(i);
    if angle(temp2)>0
        RestrictAngles=[RestrictAngles,angle(temp1),0,0,angle(temp2)];
         RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i),ObsDistance(i),ObsDistance(i)];
    else
    RestrictAngles=[RestrictAngles,angle(temp1),angle(temp2)];
     RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i)];
    end
   
elseif Ang<=-pi/2 && Ang>=-pi%conditioning on quadrants
    
    %choosing corner points based on quadrant and center points of
    %buildings
    temp1=(-ObsSize(i) + 1i*ObsSize(i)) + ObsPoints(i);
    temp2=(+ObsSize(i) - 1i*ObsSize(i)) + ObsPoints(i);
    if angle(temp1)>0
        RestrictAngles=[RestrictAngles,angle(temp1),pi,-pi,angle(temp2)];
         RestrictDistance=[RestrictDistance,ObsDistance(i),...
            ObsDistance(i),ObsDistance(i),ObsDistance(i)];
    else
    RestrictAngles=[RestrictAngles,angle(temp1),angle(temp2)];
    RestrictDistance=[RestrictDistance,ObsDistance(i),ObsDistance(i)];
    end
    
end %end conditions for quadrants

end %end loop for all obstalce points

end %end FUNCTION



