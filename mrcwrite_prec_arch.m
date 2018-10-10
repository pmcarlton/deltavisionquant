function result=mrcwrite_prec_arch(array,fname,prec,arch,hdr,exthdr);

%writes a freaking MRC file in floating point format. It's about freaking time.
%020100903 hey it beats writing Wakate-A, pmc

%020180416 can actually specify header from struct now
%020181010 can actually write the extended header and not bork the image

%determine if it's complex...
cplx=0;
if(iscomplex(array)), cplx=1;end

[retval,uuid]=system('uuidgen');
timestr=strftime(" 0%Y%m%d %H:%M:%S",localtime(time));
str1=strcat("Created on Octave, ",timestr);
[retval,uid]=system('echo ${USER}@${HOSTNAME}');
str1(end+1:80)=0;
disp (str1);
uid(end)=[];
uid(end+1:80)=0;
disp (uid);
uuid(end)=[];
uuid(end+1:80)=0;
disp (uuid);

s=size(array);
l=length(s);
nx=s(2);ny=s(1);
nt=1;
nz=1;
nsec=1;
if(l>2),nz=s(3);
  nsec*=nz;
  if(l>3),nt=s(4);
	nsec*=nt;
  end
  end

arr=single(array(:));
arrmin=min(arr);
arrmax=max(arr);

fout=fopen(fname,'w');
hdrcell=struct2cell(hdr);
for it=1:numel(hdrcell); fwrite(fout,hdrcell{it},class(hdrcell{it}),0,arch); end

fseek(fout,224);
fwrite(fout,str1);
fwrite(fout,uid);
fwrite(fout,uuid);
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));

if(cplx),arr2=zeros(1,length(arr)*2);
  arr2(1:2:end)=real(arr);
  arr2(2:2:end)=imag(arr);
  arr=arr2;
end

fseek(fout,1024);
res1=fwrite(fout,exthdr);
result=fwrite(fout,arr,prec,0,arch);
fflush(fout);
fclose(fout);
printf("%i records written to extended header of %s \n",res1,fname);
printf("%i records written to %s \n",result,fname);

