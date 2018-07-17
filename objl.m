function a=objl(b)
    %returns array of lengths of cell array

a=zeros(length(b),1);

for l=1:length(b);
p=size(b{l});
if(intersection(p,1)), a(l)=1;else a(l)=max(p);end
end

