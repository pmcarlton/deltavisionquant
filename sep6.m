function y=sep6(x);

%makes structure, y, out of data in x..
%highly customized for complementary strand FUZZNUC dumps..

b=diff(x);
b=find(b<0);
b=b(2:2:end);
b=[0;b;length(x)];

for o=1:(length(b)-1);
	y{o}=x(b(o)+1:b(o+1));
	end;
	
