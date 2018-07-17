function a=reorder_shm(m,n)

%makes an "order array" based on a surface harmonic model containing M tiers of N lines each
%(a highly customized function depending on the particular output from SurfHarmMod)

%the order array is the order to output the individual points in order to make a triangular mesh of the surface

%seems to work, 20070111pmc

e=0;

for i = 1:2:(2*n-3)
    e=e+1;
    a(e,:)=[i,i+3,i+1]; %corrected from below:
    %a(e,:)=[i,i+1,i+3]; %this was the wrong handedness
    end

for b = ((2*n)+1:2*n:2*n*(m-1)) %loop over tiers
    for i=(b:b+(2*n-3)) %loop over points within a tier
        e=e+1;
        if mod(e,2), a(e,:)=[i,i+2,i+1]; end 
        if mod(e+1,2), a(e,:)=[i,i+1,i+2]; end 
        end
    end

for i = (((m-1)*2*n)+1:2:(2*m*n)-3)
    e=e+1;
    a(e,:)=[i,i+2,i+1]; %corrected from below:
    %a(e,:)=[i,i+1,i+2]; %this was wrong handedness
    end


