function ds=sim_sphere_clumpiness(npts, cl);

% npts = number of points
% cl = "clumpiness factor" (0 = uniform, 1 = clumpy as hell)
% sphere radius of 1

p=zeros(npts,3);

d=1-cl;

for l=1:npts;
	phi=rand*2*pi;
	psi=asin(rand-0.5)*2;
	r=d+atan(rand);
	%MORE LATER

