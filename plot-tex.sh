#!/bin/sh
secs=`date +%s`
gpname=/tmp/gp${secs}.plt
texname=/tmp/gnp${secs}.tex
count=0

cat - >> $texname << EOF

\documentclass{article}
\usepackage{texdraw}
\usepackage{graphicx}
\usepackage{geometry}
\begin{document}
\begin{texdraw}

EOF

for txtname in "$@"
do
    echo $txtname
    ttl=`echo $txtname | rev | cut -c 11- | rev`
    count=$((${count}+1));
    pltname=/tmp/gp${secs}.${count}.tex

echo "set terminal epslatex; set output \"$pltname\"; set title \"$ttl\";set xlabel \"Shell distance (microns)\"; set ylabel \"Mean intensity\"; plot \"${txtname}\" u 1:2 w lp pt 7 t 'wav1', \"${txtname}\" u 4:5 w lp pt 7 t 'wav2', \"${txtname}\" u 7:8 w lp pt 7 t 'wav3', \"${txtname}\" u 10:11 w lp pt 7 t 'wav4'" > ${gpname}
/usr/local/bin/gnuplot ${gpname} 2>/dev/null
cat $pltname >> $texname
done

echo "\end{texdraw}" >> $texname
echo "\end{document}" >> $texname

echo $texname done..maybe
