function p = jumpdistDiffusion(r,D,t)

    %uses equation from David Grunwald et al 2008 BiophysJ V94 p2847
    %specify r, D for probability of having a particle within sphere of radius r after timestep of t (1) w diffusion const D

    q1=1./(2.*D.*t);
    q2=r.*r; %change second r to dr for spherical shell of width dr
    q3=exp(-(r.*r)./(4.*D.*t));

    p = q1 .* q2 .* q3;

    end

    
