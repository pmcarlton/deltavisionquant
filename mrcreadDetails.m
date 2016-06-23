function [hdr,buf]=mrcreadDetails(fn)

%This is a function that enables GNU Octave (which should work in MATLAB too) to read "MRC" file format
%(DeltaVision and other related image formats). 
%Peter Carlton, Kyoto University
%This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/

%20160604 -- mrcreadDetails.m
% provide two return values: 'hdr' containing all the header info, and 'dat' containing the raw pixels

% call this way: [hdr,dat]=mrcreadDetails(FILENAME);

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

%read entire header now 
%explanation of byte offsets and field values here:
%https://gist.github.com/pmcarlton/11276810 or
%http://msg.ucsf.edu/IVE/IVE4_HTML/IM_ref2.html#Image Header

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
hdr.blank      ="";
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
rr     =fread(a,800);rr=reshape(rr,80,10)';rr(find(rr<32))=32;rr(find(rr>127))=32;
hdr.title=char(rr);



%Check Datatype
fseek(a,0);es=fread(a,64,'int32',endian);
e=double(es(1:4));
dtype=e(4)+1;
dt=dtypes{dtype};

disp(strcat(endian,', ',dt));
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
%printf("Size = [ %i %i %i ]" ,e(2),e(1),e(3));
