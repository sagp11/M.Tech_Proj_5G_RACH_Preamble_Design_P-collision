%% DECRIPTION of function
% [AllTop]=AllTop_seq_gen(Lra,l,lambda,w)

%% input
% Lra:- length of sequence 
% l,lambda,w :- parameters of sequence
%% output
% AllTop:- generated sequence

%%

function [AllTop]=AllTop_seq_gen(Lra,l,lambda,w)
n=0:Lra-1; 
% lambda=0:138; 
% w=0:138; 
% l=1:138;

%conditions on parameters
if (0<=lambda) &&(lambda<=138) && (0<=w) && (w<=138) && (0<=l) &&(l<=138)
    
    % according to the definition of AllTOP sequences define in 
    %Pitaval et al
W=exp((-1j*2*pi)/Lra);
AllTop= (W.^((n+w).^3)).*(W.^(lambda.*n));
AllTop=(AllTop).^l;

% All_1_19= (W.^((n+w(20)).^3)).*(W.^(lambda(2).*n));
% 
% All_1_0= (W.^((n+w(1)).^3)).*(W.^(lambda(2).*n));
% All_10_0= (W.^((n+w(1)).^3)).*(W.^(lambda(11).*n));

end %end conditions on parameters
end %end FUNCTION
