function y=maximizerotmatrix(rotm,point)

point=point*rotMatrix(rotm(1),rotm(2),rotm(3));
%y=point(3)./sum(point(1:2));
y=(point(3));
end

