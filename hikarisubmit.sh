#!/bin/sh

KEY="/etc/hikariconnect/$LOGNAME/dvg_id"
FNAME=$1
FNAMEMOD=$LOGNAME.`basename $FNAME`.`date +%Y-%m-%d.%H%M%S`
/usr/bin/perl -pi -e 's/opt\/IVE4..../share\/apps\/IVE/g;s/data2/share\/data2/;s/dv100/\/share\/apps\/IVE\/dv100/;s/dv60/\/share\/apps\/IVE\/dv60/;' $FNAME
mv $FNAME /data2/hikari-queue/$FNAMEMOD
FNAMEMOD="/share/data2/hikari-queue/$FNAMEMOD"
#echo $FNAMEMOD
#ssh -nx hikari /opt/gridengine/bin/lx26-amd64/qsub -cwd -l mem_free=80G -S /bin/sh $FNAMEMOD
ssh -i $KEY -nx dvguest@hikari qsub -cwd $FNAMEMOD
