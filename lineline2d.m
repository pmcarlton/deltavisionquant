function retval=lineline2d(l1,l2)

%returns the 2d point of intersection (if the lines intersect)
% 0 (if the lines are parallel)
% 1 (if the lines are coextensive)
% 2 (if the lines intersect, but not within the given segments)

%l1 = [x1 y1;x2 y2]
%l2 = [x3 y3;x4 y4]


x1=l1(1,1);x2=l1(2,1);
y1=l1(1,2);y2=l1(2,2);
x3=l2(1,1);x4=l2(2,1);
y3=l2(1,2);y4=l2(2,2);

denom=((y4-y3)*(x2-x1))-((x4-x3)*(y2-y1));
uanum=((x4-x3)*(y1-y3))-((y4-y3)*(x1-x3));
ubnum=((x2-x1)*(y1-y3))-((y2-y1)*(x1-x3));

if (denom==0),
    if (uanum==0 && ubnum==0),
        retval=1;
    else
    retval=0;
    end
else
    ua=uanum/denom;
    ub=ubnum/denom;
    if(ua<0 | ua>1 | ub<0 | ub>1),
        retval=2;
    else
        xint=x1+(ua*(x2-x1));
        yint=y1+(ua*(y2-y1));
        retval=[xint yint];
    end
end
