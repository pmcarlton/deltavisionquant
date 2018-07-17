function im = readTifSeq(basename1,basename2,n);

%need to provide basename in two parts, before and after the iterator (from 0 to n)
%i.e. = filename = strcat(basename1,sprintf("%0.3i",l),basename2);
%n is number of sections, not index of last section (if 0~11, then n=12)

sprl=ceil(log10(n));
fs=strcat('%0.',num2str(sprl),'i');

d=strcat(basename1,sprintf(fs,0),basename2);

test=imread(d);
[rows,cols]=size(test);

im=zeros(rows,cols,n);

for li=0:(n-1);
	fname=strcat(basename1,sprintf(fs,li),basename2);
	im(:,:,li+1)=flipud(imread(fname)); %flipud because tiff/mrc difference
	end

	disp(strcat('read up to:',fname));
