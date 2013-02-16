#!/bin/bash
mstr=""
for i in "$@"
do
    ms=`/opt/bin/find-midsection.sh "$i" | tail -n 1 | awk '{print $1}'`
    px=`/opt/bin/phd-nzs "$i" | tail -n 1`
    /opt/bin/sheledm5.m "$i" $ms $px
    mstr="${mstr} $i.shell.tif "
done
newmstr="montage -size 256x256 ${mstr} -thumbnail 200x200 -set caption %t -bordercolor GhostWhite -background gray20 -polaroid 1.5 +set label -background white -geometry +1+1 "

mstrpng="montage-${i}-`date +%H%M%S`.png"
$newmstr $mstrpng
display $mstrpng &
