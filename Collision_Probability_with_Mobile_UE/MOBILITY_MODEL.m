%% DESCRIPTION of function:- [TracePoints]=MOBILITY_MODEL(Alpha,Mean_S,Instances)
%Based on Gauss-Markov mobility model
%% input: 
%Alpha:- tuning parameter
%Mean_S:- Mean speed
%Instances:- number of continuous instances to be simulated
%% output:
% TracePoints:- Array of complex numbers representing the position of a
%               moving UE in the restricted area.

%%
function [TracePoints]=MOBILITY_MODEL(Alpha,Mean_S,Instances)
% Alpha=0.99;
% Mean_S=0.833;
Mean_D=rand*2*pi; %randomly initiate mean direction
Init_S=rand*Mean_S; %randomly initiate initial speed 
Init_D=rand*2*pi;  %randomly initiate initial direction
Init_pos=[randi(500);randi(500)]; %uniformly choose start point of UE

TracePoints=zeros(1,Instances); %initiate trace points
xMin=0;xMax=500;yMin=0;yMax=500; %define boundaries of area


for i=1:Instances %start loop to calculate tracepoints
    
%     S=(Alpha*Init_S) + ((1-Alpha)*Mean_S) + (sqrt((1-Alpha^2))*normrnd(0,(Mean_S)));
%     D=(Alpha*Init_D) + ((1-Alpha)*Mean_D) + (sqrt((1-Alpha^2))*normrnd(0,(2*pi)));  

    %calculate SPEED and DIRECTION for next instance based on Gauss-MArkov mobility model
    S=(Alpha*Init_S) + ((1-Alpha)*Mean_S) + (sqrt((1-Alpha^2))*randn); 
    D=(Alpha*Init_D) + ((1-Alpha)*Mean_D) + (sqrt((1-Alpha^2))*randn); 
        
    %calculate position or tracepoint for next instance using calculate SPEED and direction    
    x=Init_pos(1) + S*cos(D);
    y=Init_pos(2) + S*sin(D);
    
    
    if x<xMin || x>xMax %employ boundary conditions to restrict the movement of UE
        x=Init_pos(1) - S*cos(D);
        Mean_D= pi - Mean_D;
        D=Mean_D;
    end
    if y<yMin || y>yMax
        y=Init_pos(2) - S*sind(D);
        Mean_D=-Mean_D;
        D=Mean_D;
    end %end boundary conditions
    
%    TracePoints(:,i)=[x;y]-[250;250];
    TracePoints(:,i)=(x + 1i*y)-(250 + 1i*250); %store trace points in form of complex number
    
    %update variables
    Init_S=S;
    Init_D=D;
    Init_pos=[x;y];
    
end %end loop to calculate tracepoints

% figure;
% plot(real(TracePoints),imag(TracePoints)); hold on;

end %end FUNCTION
