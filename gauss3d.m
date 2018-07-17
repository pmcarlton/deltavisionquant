function g=gauss3d(sz,sg);

%creates 3-d gaussian of size SZ and sigma SG

e=edm3d(sz);
g=exp(-e/(2*sg.^2));
