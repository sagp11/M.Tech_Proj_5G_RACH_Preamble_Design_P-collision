%% M-sequence generator
% This specific m-seq is generates using the polynomial function gives ad
% follows:
% P^(7) + P^(1) + 1, this means XORing of the bits the 7th first and output
% of the LFSRs.

%%
function [M_seq]=M_seq_gen(Lra)
% level=2;
% power=7;
% length=(level^power)-1;
% Lra=139;

out=zeros(1,Lra);
a=0b1000000; %initiate bits at registers

% out(1)=bitget(a,7);% x7=bitget(a,7);% x1=bitget(a,1);% nxt=bitxor(x7,x1);

for i=1:Lra %loop for each sample 
    out(i)=bitget(a,1); %output first bit
    x7=bitget(a,7);
    x1=bitget(a,1);
    nxt=bitxor(x7,x1); %XOR 7th and 1st bit
    
    if nxt==1 %if output is 1 feeback it to the 7th bit
        a=bitshift(a,-1);
        a=bitset(a,7); %setting 7th bit as a feedback
        
    elseif nxt==0 %if output is 0 reset 7th bit (feedback)
        a=bitshift(a,-1);
        z=0b0111111;
        a=bitand(a,z); %resetting 7th bit as a feedback
    end %end feedback condition
    
end %end loop for sequence


%mapping '0' to '-1' and '1' to '1' as a BPSK signal 
for i=1:Lra
    if out(i)==1
        out(i)=+1;
    elseif out(i)==0
        out(i)=-1;
    end
end

M_seq=out; %output sequence

end  %end FUNCTION