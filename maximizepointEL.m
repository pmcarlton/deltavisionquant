function y=maximizepointEL(rotm,points)

points=points*rotMatrix(rotm(1),rotm(2),rotm(3));
[az,el,ra]=cart2sph(points(:,1),points(:,2),points(:,3));
%y=log(abs(prod(el)./prod(az)));
%y=(point(3));
%y=mean(el);
y=min(el)/var(el);
end

