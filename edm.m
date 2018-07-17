function a=edm(b,c)
    %Euclidean distance map

rows=(linspace(-b/2,b/2,b))'*ones(1,c);
cols=(sqrt(-1).*ones(1,b))'*(linspace(-c/2,c/2,c));

a=abs(rows+cols);

