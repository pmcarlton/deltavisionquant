function [hdr,raw_hdr,buf,prec,arch,exthdr]=mrcReadFullDetails(fn)

%fn is the filename/pathname of the Deltavision file you want to read.
%program attempts to read everything relevant
%020100907pmc

%apparently handles endianness okay?
%TODO: COMPLEX numbers, it's two successive datas in MRC file, with flag set
%(will have to handle writing them as well.)
%TODO: read extended header info into another variable? good for time series, multi-point, etc

%20160604 -- mrcreadDetails.m
% struct with everything in it
%20180405 -- mrcReadFullDetails.m
% include raw header to be able to write/modify easily
% 20181010 -- no name change
% read the extended header too!

dtypes={'uchar','int16','float32','int16','float32','int16','uint16','int32'};
endi={'ieee-be','ieee-le'};

a=fopen(fn,'r'); % raw file open...let's read some bytes

%Check Endianness...a bit hacky, relying on first few bytes of MRC files being same
fseek(a,0);endicheck=fread(a,10,'int32',endi{1});endicheck=endicheck(4);
if(endicheck>=0 & endicheck<7), endian=endi{1};
else
fseek(a,0);endicheck=fread(a,10,'int32',endi{2});endicheck=endicheck(4);
if(endicheck>=0 & endicheck<7), endian=endi{2};
else
    disp('Something is jacked up; could not calculate endianness');
end
end

%read entire header now
fseek(a,0);
hdr.ncol       =fread(a,1,"*int32",endian);
hdr.nrow       =fread(a,1,"*int32",endian);
hdr.nsecs      =fread(a,1,"*int32",endian);
hdr.pixtype    =fread(a,1,"*int32",endian);
hdr.mxst       =fread(a,1,"*int32",endian);
hdr.myst       =fread(a,1,"*int32",endian);
hdr.mzst       =fread(a,1,"*int32",endian);
hdr.mx         =fread(a,1,"*int32",endian);
hdr.my         =fread(a,1,"*int32",endian);
hdr.mz         =fread(a,1,"*int32",endian);
hdr.dx         =fread(a,1,"*float32",endian);
hdr.dy         =fread(a,1,"*float32",endian);
hdr.dz         =fread(a,1,"*float32",endian);
hdr.alpha      =fread(a,1,"*float32",endian);
hdr.beta       =fread(a,1,"*float32",endian);
hdr.gamma      =fread(a,1,"*float32",endian);
hdr.colax      =fread(a,1,"*int32",endian);
hdr.rowax      =fread(a,1,"*int32",endian);
hdr.secax      =fread(a,1,"*int32",endian);
hdr.pxmin      =fread(a,1,"*float32",endian);
hdr.pxmax      =fread(a,1,"*float32",endian);
hdr.pxmean     =fread(a,1,"*float32",endian);
hdr.nspg       =fread(a,1,"*int32",endian);
hdr.next       =fread(a,1,"*int32",endian);
hdr.dvid       =fread(a,1,"*int16",endian);
hdr.nblank     =fread(a,1,"*int16",endian);
hdr.ntst       =fread(a,1,"*int32",endian);
hdr.blank      =fread(a,24,"*schar",endian);
%hdr.blank      ="";
hdr.numints    =fread(a,1,"*int16",endian);
hdr.numfloats  =fread(a,1,"*int16",endian);
hdr.sub        =fread(a,1,"*int16",endian);
hdr.zfac       =fread(a,1,"*int16",endian);
hdr.min2       =fread(a,1,"*float32",endian);
hdr.max2       =fread(a,1,"*float32",endian);
hdr.min3       =fread(a,1,"*float32",endian);
hdr.max3       =fread(a,1,"*float32",endian);
hdr.min4       =fread(a,1,"*float32",endian);
hdr.max4       =fread(a,1,"*float32",endian);
hdr.imtype     =fread(a,1,"*int16",endian);
hdr.lensnum    =fread(a,1,"*int16",endian);
hdr.n1         =fread(a,1,"*int16",endian);
hdr.n2         =fread(a,1,"*int16",endian);
hdr.v1         =fread(a,1,"*int16",endian);
hdr.v2         =fread(a,1,"*int16",endian);
hdr.min5       =fread(a,1,"*float32",endian);
hdr.max5       =fread(a,1,"*float32",endian);
hdr.ntimes     =fread(a,1,"*int16",endian);
hdr.imgseq     =fread(a,1,"*int16",endian);
hdr.xtilt      =fread(a,1,"*float32",endian);
hdr.ytilt      =fread(a,1,"*float32",endian);
hdr.ztilt      =fread(a,1,"*float32",endian);
hdr.nwaves     =fread(a,1,"*int16",endian);
hdr.wv1        =fread(a,1,"*int16",endian);
hdr.wv2        =fread(a,1,"*int16",endian);
hdr.wv3        =fread(a,1,"*int16",endian);
hdr.wv4        =fread(a,1,"*int16",endian);
hdr.wv5        =fread(a,1,"*int16",endian);
hdr.z0         =fread(a,1,"*float32",endian);
hdr.x0         =fread(a,1,"*float32",endian);
hdr.y0         =fread(a,1,"*float32",endian);
hdr.ntitles    =fread(a,1,"*int32",endian);
rr=fread(a,800);rr=reshape(rr,80,10)';rr(find(rr<32))=32;rr(find(rr>127))=32;
hdr.title=char(rr);

%read raw header bytes into another variable
fseek(a,0);raw_hdr=fread(a,1024,'char',endian);
exthdr=fread(a,hdr.next); %char assumed, so endian not relevant I think 20181010pmc

%Check Datatype
fseek(a,0);es=fread(a,64,'int32',endian);
e=double(es(1:4));
dtype=e(4)+1;
dt=dtypes{dtype};

disp(strcat(endian,', ',dt));
data=zeros(e(1),e(2),e(3)); %good to pre-clear memory--can't believe I didn't do until now, 020120705pmc
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
%for l=1:e(3);data(:,:,l)=(buf(:,:,l));end

arch=endian;
prec=dt;
