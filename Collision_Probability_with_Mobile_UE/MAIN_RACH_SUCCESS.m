clc
clear 
close all
% tic;


Alpha=0.99;
Mean_S=7;
Instances=10;
% obs_density=50:50:400;
obs_density=5:50:550;
obs_instances=20;
tot_users=2:50:550;
% rach_inst=zeros(n_users,Instances);
for l=1:length(tot_users) %loop for number of users
    users=tot_users(l);
for k=1:length(obs_density) %loop for obstacle density
    tic
for j=1:obs_instances %loop for obstacle instances to avarage over obstacle density
    Obs=poissrnd(obs_density(k));
    
for i=1:users   %loop for generating tracepoints for each of the user for 
    %a given number of USERS and calculating thier NLOS status and beam
    %failure status.
    
[A,RestrictAngles,RestrictDistance]=OBSTRUCTIONS(Obs);
R_Angle=reshape(RestrictAngles,2,[])';
R_Dist=reshape(RestrictDistance,2,[])';
% [pathloss_matrix,F] = PATHLOSS_AREA(R_Angle,R_Dist);

TracePoints(i,:)=MOBILITY_MODEL(Alpha,Mean_S,Instances);

[PathLoss(i,:),PathStatus(i,:)]=CORRECT_NLOS_STATUS(TracePoints(i,:),RestrictAngles,RestrictDistance);

[Path_fail_time(i,:),PathBreak(i,:),PathFailure,r,x]=FAILURE_COUNT(PathLoss(i,:));

% R=INCORRECT_RACH_INST(PathFailure); 
% rach_inst1(i,:)= [R,zeros(1,Instances-length(R))];

rach_inst(i,:)= [r,zeros(1,Instances-length(r))];
rach_instances(i,:)= x; %instances at which the beam is recovered

end %end loop for each users for a given number of USERS

[detected_PR,chosen_PR] = DET_PR_ARRAY(rach_instances,PathLoss,users);
% [r,c]=size(detected_PR_array);
% load('try.mat');
[SUCCESSFUL_USERS,COLLIDED_USERS,COLLISIONS] = COUNT_COLLISIONS(detected_PR);
success_PR1(j) = sum(SUCCESSFUL_USERS(1,:),'all'); %sum all successfull
%                       preamble detection for a given obstacle density


total_PR1(j) = sum(rach_instances,'all'); %sum total preamble transmissions for a given obstalce density

end %end loop for averaging obstacle density

success_PR2(k,l)= sum(success_PR1,'all'); %overall successful detection for a given obstacle density
total_PR2(k,l)= sum(total_PR1,'all'); %oberall preamble transmission for a givne obstalce density
toc

end %end loop for obstacle density

end %end loop for number of users

figure;
plot(obs_density,success_PR2./total_PR2,'-o','LineWidth',1.5); xlabel('Obstacle density'); ylabel('success-prob');
grid on; title('USERS=10');

figure;
plot(tot_users,success_PR2./total_PR2,'-o','LineWidth',1.5); xlabel('users'); ylabel('success-prob');
grid on; title('obstacle desnity= 150');


% sum(rach_instances,'all')
% sum(chosen_PR>0,'all')
% sum(detected_PR>0,'all')
% sum(SUCCESSFUL_USERS(1,:),'all')
% sum(COLLIDED_USERS(1,:),'all')





%   rach_instances 


            
            
            
    
    
% [P_T,P_false,P_detect,P_trial,t_detect,det_index,PDP,choose,ZC64]= ...
% ZC_detect_N_ant_users(zCZC,ALPHA,iter,N,users,SNR,signature,method);



% % To find noise for 99% detection probability
% 
% SNR=-12:0.1:-9;   iter=1;  N=4;
% ALPHA=8;    users=1; signature=1; method=1; zCZC=11;
% [P_T,P_false,P_detect,P_trial,t_detect,det_index,PDP,choose,ZC64]= ...
%     ZC_detect_N_ant_users(zCZC,ALPHA,iter,N,users,SNR,signature,method);
% 
% figure;
% plot(SNR,P_detect); grid on; hold on;



% PathBreak
% figure;
% histogram(rach_inst,999);

% figure;
% scatter(real(A),imag(A),'filled'); hold on;
% plot(0,0,'d','LineWidth',10); hold on;
% plot(real(TracePoints(1,:)),imag(TracePoints(1,:))); hold on;
%  plot(real(TracePoints(2,:)),imag(TracePoints(2,:)));grid on;
% axis([-250,250,-250,250]);
%  
% figure;
% a=-249:1:250;
% [b,c]=meshgrid(a);
% mesh(b,c,pathloss_matrix','FaceAlpha',0.2,'EdgeAlpha',0.2); hold on;
% % plot(real(TracePoints(2,:)),imag(TracePoints(2,:)),'LineWidth',2);grid on;
% plot(real(TracePoints(1,:)),imag(TracePoints(1,:)),'LineWidth',2); hold on; grid on;
% colorbar;

% set(gca,'zscale','log')
% rach_inst1=RACH_INST(PathFailure1);

% toc
% 
% figure;
% a=-249:1:250;
% [b,c]=meshgrid(a);
% mesh(b,c,pathloss_matrix','FaceAlpha',0.2,'EdgeAlpha',0.2); hold on;
% % plot(real(TracePoints(2,:)),imag(TracePoints(2,:)),'LineWidth',2);grid on;
% plot(real(TracePoints(1,:)),imag(TracePoints(1,:)),'LineWidth',2); hold on; grid on;
% colorbar;