function [prec,arch]=mrc_endicheck(fn)


%just for endian checking

dtypes={'uchar','int16','float32','int16','float32','int16','uint16','int32'};
endi={'ieee-be','ieee-le'};

a=fopen(fn,'r');

%Check Endianness
fseek(a,0);endicheck=fread(a,10,'int32',endi{1});endicheck=endicheck(4);
if(endicheck>=0 & endicheck<7), endian=endi{1};
else
fseek(a,0);endicheck=fread(a,10,'int32',endi{2});endicheck=endicheck(4);
if(endicheck>=0 & endicheck<7), endian=endi{2};
else 
disp("something is jacked up endianwise");
end
end

%Check Datatype
fseek(a,0);es=fread(a,64,'int32',endian);
e=double(es(1:4));
dtype=e(4)+1;
dt=dtypes{dtype};

%disp(strcat(endian,', ',dt));
prec=dt;
arch=endian;
end

