#!/bin/bash

SECUREDIR=/DESTDIR/bk-`date +%Y%m%d`
NAME=mybk-`date +%Y%m%d`
LLAVE=123456
MYHOME=/home/user

case $1 in
    e)
	if [ ! -d $SECUREDIR ]
	then
	    mkdir $SECUREDIR
	fi
        NOMBRE=$2
        NAME=$2
        NAME=`basename $NAME`
        NAME=`echo $NAME | sed s'/.gpg//'`
	echo "extract $NOMBRE"
        echo "to \"$SECUREDIR/$NAME\""
        gpg -o $SECUREDIR/$NAME -d $NOMBRE
	#tar xvf $SECUREDIR/$NAME 
	;;
    *)
	echo "usage \"NAME_FILE_SCRIPT e\" FILE_GPG"
	;;
esac
