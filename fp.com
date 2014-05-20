#!/bin/sh
#Setting run time environment...
{ test -r '/opt/IVE4.2.9/priism-4.2.9/Priism_setup.sh' && . '/opt/IVE4.2.9/priism-4.2.9/Priism_setup.sh' ; } || exit 1
#command file for FindPoints

(time FindPoints $1) > $1.log 2>&1

b=`echo $1 | sed 's/.pars/.pts/'`
sed -i 's/^[WL]/#W/' $b
