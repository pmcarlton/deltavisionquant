function out=mrcsubtractsec(datafile, subtractsectionfile)

%subtracts "subtractsectionfile" from every section of "datafile", writing new "datafile" with same header
%020100909pmc

subme = mrcread(subtractsectionfile); %thank goodness for that
subme=double(subme(:));

outfile = strcat(datafile,'.MinusDark.mrc');

dtypes={'uchar','int16','float32','int16','float32','int16','uint16','int32'};
dlen=[1,2,4,2,4,2,2,4];
endi={'ieee-be','ieee-le'};

fout=fopen(outfile,'w');

a=fopen(datafile,'r');

header_to_copy=fread(a,1024);
fseek(a,0);

fwrite(fout,header_to_copy);

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
dtlen=dlen(dtype);
disp(strcat(endian,', ',dt));

%get and copy extended header
start=double(es(24));
fseek(a,1024);
exthdr=fread(a,start);
fwrite(fout,exthdr);

len=prod(e(1:2)); %length of a single section only!

%set complex data flag if needed
cplx=0;
if ((dtype==4) | (dtype==5)), len=len*2; cplx=1; disp("complex"); end


%Seek to beginning of data

%Start looping over sections in datafile
for secnum=0:(e(3)-1),                                      %% starting the read-write loop
start2=len*secnum*dtlen;
fseek(a,start+start2+1024);

%Read one section of datafile
buf=fread(a,len,dt,endian);

%Take care of complex numbers, if needed
if (cplx),
buf = buf(1:2:end) + (j.* (buf(2:2:end)));
end

outsec=(buf - subme);
fwrite(fout,outsec,dt,0,endian);

end                                                     %% ending the loop

fclose(a);
fclose(fout);
