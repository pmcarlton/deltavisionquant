function v = minimizeradiusvar(subtraction,x)

    % subtracts 'subtraction' from x, then finds variance of radius in polar coords
    % minimizing var(r) should show best circle
    %20090427  pmc
    %
    %it works! --call this way:
        %  [x,out]=fmins('minimizeradius',mean(c2),[0,1e-8],[],c2);
        %
        %  this starts the center at the mean position. [mean1 mean2] is optimized; c2 is the point data supplied as a parameter

x-=repmat(subtraction,[length(x) 1]);
[t,r]=cart2pol(x(:,1),x(:,2));
v = var(r);

