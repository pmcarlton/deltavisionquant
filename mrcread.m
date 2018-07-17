function out=mrcread(fn)

%fn is the filename; attempts to read everything relevant and handle everything
%about freaking time, 020100907pmc

%apparently does endian okay
%TODO: COMPLEX numbers, it's two successive datas in MRC file, with flag set
%(will have to handle writing them as well.)

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

disp(strcat(endian,', ',dt));
out=zeros(e(1),e(2),e(3)); %needed to pre-clear memory--can't believe I didn't do until now, 020120705pmc
%Seek to beginning of data
len=prod(e(1:3));
start=double(es(24))+1024;
fseek(a,start);

%set complex data flag if needed
cplx=0;
if ((dtype==4) | (dtype==5)), len=len*2; cplx=1; disp("complex"); end

%Read all the data
buf=fread(a,len,dt,endian);
fclose(a);

%Take care of complex numbers, if needed
if (cplx),
buf = buf(1:2:end) + (j.* (buf(2:2:end)));
end

%Rearrange into the right shape
buf=reshape(buf,[e(1) e(2) e(3)]);
%printf("Size = [ %i %i %i ]\n" ,e(2),e(1),e(3));
for l=1:e(3);out(:,:,l)=(buf(:,:,l));end
