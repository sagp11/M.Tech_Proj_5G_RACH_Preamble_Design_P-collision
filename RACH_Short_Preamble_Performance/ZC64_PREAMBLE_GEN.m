%% Function to generate 64 preamble sequences based on given
% zeroCorrelationZoneConfig [zCZC]

%% input
% zCZC:- zeroCorrelationZoneConfig parameter related to the cyclic shift
%        see function ZC64_PREAMBLE_GEN.

%% output
%ZC_64:- set of 64 preamble sequences from which transmitted sequences are
%        to be selected
%Ncs:- cyclic shift values corresponding to the zCZC parameter
%ZC_root:- set root sequences corresponding to the 64 sequences
%ZC_ALL:- set of sequences with all root sequences.

%%

function [ZC_64,Ncs,ZC_root,ZC_ALL]=ZC64_PREAMBLE_GEN(zCZC)

Lra=139;k=0:138; u=1:138;
% zCZC_values=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
Ncs_values=[0,2,4,6,8,10,12,13,15,17,19,23,27,34,46,69];% NCs values ...
%corresponding to zCZC values

%relation between logical index and root index.
%below section generates mapping of logical_index to root_index
% DEFINED in 3GPP standards
logical_index=0:137;
count=1;
root_index_map=zeros(1,Lra-1);
for i=1:2:138
    root_index_map(i)=count;
    root_index_map(i+1)=139-count;
    count=count+1;
end

%This section genrates possible values of cyclis shifts for a given zCZC
zCZC_index=zCZC+1;
Ncs=Ncs_values(zCZC_index);
if(Ncs)
    v=0:1:floor(Lra/Ncs)-1;
else
    v=0;
end
Cv=v*Ncs;

%generate ZC seq with all root-indexes[ZC_ALL]:-
ZC_ALL=exp((-1j.*(root_index_map')*pi.*k.*(k+1))/Lra);

%To generate 64 ZC sequences for a given zCZC
logical_index_to_gen=floor(64/length(Cv));
vary_root_index=0:logical_index_to_gen;
ZC_64=[];
ZC_root=[];
count=0;
for i=1:length(vary_root_index)
    ZC_root=[ZC_root;ZC_ALL(i,:)];
    for j=1:length(Cv)
        ZC_64=[ZC_64;circshift(ZC_ALL(i,:),-Cv(j),2)];
        count=count+1;
        if count==64
            return;
        end
    end
    
end
% ZC_64=ZC_64((1:64),:);
end
