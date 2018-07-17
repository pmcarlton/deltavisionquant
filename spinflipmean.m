function y = spinflipmean(x)

%makes y the mean of all (2D) rotations+reflections of x

y1=(x+fliplr(x));
y2=(y1+rot90(rot90(y1)));
y3=y2+rot90(y2);
y = y3 ./ 8;
