function det_index=INDEX_DET_WINDOW(arr,t_detect,signature,N)
det_index=[];
L=139;
y=0;
% T=max(t_detect);
%% Experimantal
if signature==1
    y=(sqrt(L)).^2.*N;
elseif signature == 2
    y=(2*sqrt(L+1) + log2(L+1)).^2.*N;
elseif signature == 3
    y= (2*sqrt(L)).^2.*N;
elseif signature == 4
    y= (2*sqrt(L+1) + log2(L+1)).^2.*N;
end
%%
y=0;
[r_arr,c_arr,p_arr]=size(arr);
for i=1:p_arr
    for j=1:r_arr
        if arr(j,1,i) > (t_detect(j)+y)
%              if arr(j,1,i) > (t_detect+y)
            x=((j-1)*p_arr)+i;
            det_index=[det_index;x arr(j,2,i)];
            end
    end
end
end
