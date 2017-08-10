#!/bin/bash

function xyz_find {
if test $(hexdump -e '/4 "%i\n"' -s 92 -n 2 $1) -gt 0;
then
echo -n "pixel sizes for xyz: "
od -j 40  -v -N 12 -f $1 | awk '{print $2,$3,$4}' | head -n 1
echo -n "stage offsets in microns: "
od -j 1064  -v -N 12 -f $1 | awk '{print $2,$3,$4}' | head -n 1
else echo $1:"no extended header, aborting." 1>&2;
fi
}

function gettiles {
echo $@;
for i in "$@";
do xyz_find $i | \
    perl -ane 'if(eof){print $F[4]/$a," ",$F[5]/$a," ",$F[6]/$b,"\n";}$a=$F[4];$b=$F[6];'; \
done | \
    perl -ane 'if($a==0){$x=$F[0];$y=$F[1];$z=$F[2]};$a=1;print $F[0]-$x," ",$F[1]-$y," ",$F[2]-$z,"\n";' 
}

cat <<EOF
# Define the number of dimensions we are working on
dim = 3

# Define the image coordinates
EOF

gettiles $@ | perl -ne 'if($c==0){@b=split;$c=1;}else{$q=$_;$q=~s/^/\(/;$q=~s/$/\)/;$q=~s/ /, /g;print $b[$a++],"; ;",$q;}'
