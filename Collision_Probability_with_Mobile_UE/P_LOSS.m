%% DESCRIPTION of function:- 
% [PL]=P_LOSS(d_2D_out,fc,Status)
%% input: 
% d_2D_out:- distance of UE for gNB in 2D
% fc:- carrier frequency in GHz
% Status:- '1' for NLOS and '0' for LOS 
%% output:
% PL:- Path loss in dB

%%

function[PL]=P_LOSS(d_2D_out,fc,Status)

%CALCULATED based on Pathloss model defined by 3GPP
d_2D_in=0;
d_2D= d_2D_out;
h_BS=25; h_UT=1.5;
d_3D=sqrt((d_2D_out + d_2D_in).^2 + (h_BS - h_UT)^2);
d_BP= 4*h_BS*h_UT*fc*(10^9)/(3*(10^8));
% FOR LOS:-
PL_1= 28.0 + 22.*log10(d_3D) + 20.*log10(fc);
PL_2= 28.0 + 40.*log10(d_3D) + 20*log10(fc) - 9*log10(d_BP.^2 + (h_BS-h_UT).^2);
if d_2D>=10 && d_2D<=d_BP
    PL_UMa_LOS= PL_1;
elseif d_2D>=d_BP && d_2D<=5000
    PL_UMa_LOS= PL_2;
else
    PL_UMa_LOS=86;
end
% FOR NLOS
PL_UMa_NLOS1= 13.54 + 39.08*log10(d_3D) + 20*log10(fc) - 0.6*(h_UT-1.5);
PL_UMa_NLOS= max(PL_UMa_LOS,PL_UMa_NLOS1);
PL_UMa_LOS=PL_UMa_LOS+random('Normal',0,4); %considering shadowing effect
PL_UMa_NLOS=PL_UMa_NLOS+random('Normal',0,6); %considering shadowing effect

if Status==0 %condition of LOS
    PL=PL_UMa_LOS;
elseif Status==1 %condition for NLOS
    PL=PL_UMa_NLOS;
end

end %end function 