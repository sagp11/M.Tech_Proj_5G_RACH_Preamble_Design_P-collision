clc
clear
close all

Instances=1000; %can be changed
Obs= 5:20:200; %can be changes
Mean_S=1:10; %can be changed
Alpha=linspace(0.1,0.99,10); %can be changes 

LOS_dist1=[];
for l=1:length(Alpha) %loop for tuning parameter
for k=1:length(Mean_S) %loop for mean speed
  tic
for j=1:length(Obs) %loop for obstacle density (number of buildings)
PNLOS1=0;    Failure1=0;    PLOS1=0;

for i=1:10 %loop for running different obstacle placements for a given obstacle density
    
 %Generate obstacles using the function: [A,RestrictAngles,RestrictDistance]=OBSTRUCTIONS(Obs(j))
 %where A:- All the points to represent buildings
[A,RestrictAngles,RestrictDistance]=OBSTRUCTIONS(Obs(j)); 

%Function [TracePoints]=MOBILITY_MODEL(Alpha(l),Mean_S(k),Instances) gives
%us all the trace points traversed by UE in 2-D using Tuning parameter
%Alpha, mean speed and number of instances
[TracePoints]=MOBILITY_MODEL(Alpha(l),Mean_S(k),Instances);

%Function count=SECTOR_CHNG_RATE(TracePoints) give us the sector change
%rate for 64 beams
count=SECTOR_CHNG_RATE(TracePoints);

% Function [PathLoss,PathStatus]=CORRECT_NLOS_STATUS(TracePoints,RestrictAngles,RestrictDistance)
%gives us the PathLoss experienced by UE at a particular instance and
%PathStatus gives us the status for NLOS and LOS status where 1 represents
%NLOS and 0 represents LOS.
[PathLoss,PathStatus]=CORRECT_NLOS_STATUS(TracePoints,RestrictAngles,RestrictDistance);

%Function [Path_fail_time,PathBreak]=FAILURE_COUNT(PathLoss) returns
%Path_fail_time as number of times the UE remains beyond a threshold of
%120dB path loss for more than or equal to two instances.
[Path_fail_time,PathBreak]=FAILURE_COUNT(PathLoss);


LOS_dist1= [LOS_dist1;abs(TracePoints.*abs(PathStatus-1))]; %

PLOS1=PLOS1 + sum(abs(PathStatus-1)); %calculating total LOS status
PNLOS1=PNLOS1+ sum(PathStatus); %calculating total NLOS status
Failure1=Failure1+Path_fail_time; %calculating total beam failure status

end %end loop for given obstalce density

PNLOS2(k,j,l)=PNLOS1/(Instances*i); %calculating NLOS probability
Failure2(k,j,l)=Failure1/(Instances*i); %calculating Failure probability

end %end loop for obstacle density 
toc
% PNLOS3(k,:)=PNLOS2;
% Failure3(k,:)=Failure2;

end %end loop for mean speed

% PNLOS4(:,:,l)=PNLOS3;
% Failure4(:,:,l)=Failure3;

end %end loop for tuning parameter



%DIAGRAMS representation
L_dist=nonzeros(LOS_dist1);
figure;
histogram(L_dist,300);

figure;
scatter(real(A),imag(A),'r','filled'); hold on;
plot(0,0,'db','LineWidth',10); hold on;
plot(real(TracePoints(1,:)),imag(TracePoints(1,:)),'-k','LineWidth',2); hold on;
axis([-250,250,-250,250]); grid on;
xlabel('meters'); ylabel('meters')


figure;
plot(Obs,PNLOS2(1,:,1),'-o','DisplayName','\alpha = 0.1','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,2),'-+','DisplayName','\alpha = 0.2','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,3),'-*','DisplayName','\alpha = 0.3','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,4),'-x','DisplayName','\alpha = 0.4','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,5),'-|','DisplayName','\alpha = 0.5','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,6),'-s','DisplayName','\alpha = 0.6','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,7),'-d','DisplayName','\alpha = 0.7','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,8),'-p','DisplayName','\alpha = 0.8','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(1,:,9),'-h','DisplayName','\alpha = 0.9','LineWidth',1.25); hold on; grid on;
legend('Location','southeast')
xlabel({'Number of Buildings in 0.5 \times 0.5 km area','Mean Speed = 1 m/s'});
ylabel('P-NLOS');

figure;
plot(Obs,Failure2(1,:,1),'-o','DisplayName','\alpha = 0.1','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,2),'-+','DisplayName','\alpha = 0.2','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,3),'-*','DisplayName','\alpha = 0.3','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,4),'-x','DisplayName','\alpha = 0.4','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,5),'-|','DisplayName','\alpha = 0.5','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,6),'-s','DisplayName','\alpha = 0.6','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,7),'-d','DisplayName','\alpha = 0.7','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,8),'-p','DisplayName','\alpha = 0.8','LineWidth',1.25); hold on;
plot(Obs,Failure2(1,:,9),'-h','DisplayName','\alpha = 0.9','LineWidth',1.25); hold on; grid on;
legend('Location','southeast')
xlabel({'Number of Buildings in 0.5 \times 0.5 km area','Mean Speed = 1 m/s'});
ylabel('P-failure');


figure;
plot(Obs,PNLOS2(1,:,1),'-o','DisplayName','$\overline{S}$ = 1','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(2,:,1),'-+','DisplayName','$\overline{S}$ = 2','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(3,:,1),'-*','DisplayName','$\overline{S}$ = 3','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(4,:,1),'-x','DisplayName','$\overline{S}$ = 4','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(5,:,1),'-|','DisplayName','$\overline{S}$ = 5','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(6,:,1),'-s','DisplayName','$\overline{S}$ = 6','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(7,:,1),'-d','DisplayName','$\overline{S}$ = 7','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(8,:,1),'-p','DisplayName','$\overline{S}$ = 8','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(9,:,1),'-h','DisplayName','$\overline{S}$ = 9','LineWidth',1.25); hold on;
plot(Obs,PNLOS2(10,:,1),'-^','DisplayName','$\overline{S}$= 10','LineWidth',1.25); hold on;
grid on;
legend('Location','southeast','Interpreter','latex')
xlabel({'Number of Buildings in 0.5 \times 0.5 km area','\alpha = 0.9'},'FontWeight','bold');
ylabel('P-NLOS','FontWeight','bold');

figure;
plot(Obs,Failure2(1,:,1),'-o','DisplayName','$\overline{S}$ = 1','LineWidth',1.25); hold on;
plot(Obs,Failure2(2,:,1),'-+','DisplayName','$\overline{S}$ = 2','LineWidth',1.25); hold on;
plot(Obs,Failure2(3,:,1),'-*','DisplayName','$\overline{S}$ = 3','LineWidth',1.25); hold on;
plot(Obs,Failure2(4,:,1),'-x','DisplayName','$\overline{S}$ = 4','LineWidth',1.25); hold on;
plot(Obs,Failure2(5,:,1),'-|','DisplayName','$\overline{S}$ = 5','LineWidth',1.25); hold on;
plot(Obs,Failure2(6,:,1),'-s','DisplayName','$\overline{S}$ = 6','LineWidth',1.25); hold on;
plot(Obs,Failure2(7,:,1),'-d','DisplayName','$\overline{S}$ = 7','LineWidth',1.25); hold on;
plot(Obs,Failure2(8,:,1),'-p','DisplayName','$\overline{S}$ = 8','LineWidth',1.25); hold on;
plot(Obs,Failure2(9,:,1),'-h','DisplayName','$\overline{S}$ = 9','LineWidth',1.25); hold on;
plot(Obs,Failure2(10,:,1),'-^','DisplayName','$\overline{S}$ = 10','LineWidth',1.25); hold on;
grid on;
legend('Location','southeast','Interpreter','latex')
xlabel({'Number of Buildings in 0.5 \times 0.5 km area','\alpha = 0.9'},'FontWeight','bold');
ylabel('P-failure','FontWeight','bold');



Alpha_str=string(Alpha);
Speed_str=string(Mean_S);
Obs_str=string(Obs);
figure;
for i=1:length(Mean_S)
    subplot(3,4,i)
    for j=1:length(Alpha)
    semilogy(Obs,PNLOS2(i,:,j),'DisplayName',Alpha_str(j)); hold on; title('Speed= ',num2str(Mean_S(i)));
    end
    grid on; xlabel('Obstacle Density'); ylabel('P-NLOS');
%     legend('Alpha= 0.1','0.3','0.5','0.7','0.9');
end
sgtitle('NLOS Probability'); 
legend

figure;
for i=1:length(Mean_S)
    subplot(3,4,i)
    for j=1:length(Alpha)
    semilogy(Obs,Failure2(i,:,j),'DisplayName',Alpha_str(j)); hold on; title('Speed= ',num2str(Mean_S(i)));
    end
    grid on; xlabel('Obstacle Density'); ylabel('P-failure');
%     legend('Alpha= 0.1','0.3','0.5','0.7','0.9');
end
sgtitle('failure Probability'); legend%('Alpha= 0.1','0.3','0.5','0.7','0.9');

figure;
for i=1:length(Mean_S)  
    semilogy(Obs,Failure2(i,:,length(Alpha)),'DisplayName',Speed_str(i)); hold on;  
    grid on; xlabel('Obstacle Density'); ylabel('P-failure');
%     legend('Alpha= 0.1','0.3','0.5','0.7','0.9');
end
title('Failure Probability varying Speed and Alpha= 0.9' ); 
legend%('Speed= 0.1','0.86','1.63','2.40','3.16','3.93','4.7','5.46','6.23','7');

figure;
for i=1:length(Obs)
plot(Mean_S,Failure2(:,i,length(Alpha)),'DisplayName',Obs_str(i)); hold on;  
    grid on; xlabel('Speed'); ylabel('P-failure');
%     legend('Alpha= 0.1','0.3','0.5','0.7','0.9');
end
title('Failure Probability varying Obstacles and Alpha= 0.9' ); 
legend%('Obs= 5','26.67','48.33','70','91.67','113.33','135','156.67','178.33','200');


