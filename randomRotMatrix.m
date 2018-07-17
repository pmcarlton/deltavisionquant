function y=randomRotMatrix(x);

%returns 3x3 rotation matrix for 3d rotation.
%x is a dummy..


x=x/1;

a=rand*2*pi;
g=rand*2*pi;
b=acos(2*(rand-0.5));

cosa=cos(a);sina=sin(a);cosb=cos(b);sinb=sin(b);cosg=cos(g);sing=sin(g);

y(1,1)=cosg*cosa-sing*cosb*sina;
y(1,2)=cosg*sina+sing*cosb*cosa;
y(1,3)=sing*sinb;
y(2,1)=(-sing)*cosa-cosg*cosb*sina;
y(2,2)=(-sing)*sina+cosg*cosb*cosa;
y(2,3)=cosg*sinb;
y(3,1)=sinb*sina;
y(3,2)=(-sinb)*cosa;
y(3,3)=cosb;

