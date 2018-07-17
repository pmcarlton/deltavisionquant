function res=split3(mat);

s=size(mat);
z=s(3);
z=z/3;

res{1}=mat(:,:,1:z);
res{2}=mat(:,:,(z+1):2*z);
res{3}=mat(:,:,(2*z+1):3*z);

