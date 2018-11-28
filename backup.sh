#!/bin/bash

BKDIR=/DESTDIR/`date +%Y%m%d`
NAME=mybk-`date +%Y%m%d`
KEY=1234456
MYHOME=/home/user

make-list(){
    THOME=$1
    NEWNAME=$NAME$2
    if [ -e $THOME ]
    then
	find $THOME > $BKDIR/$NEWNAME.list
	bzip2 -z $BKDIR/$NEWNAME.list
	echo "end $BKDIR/$NEWNAME.list.bz2"
    else
	echo "func:make-list: $1 not exist"
    fi
}

make-list-gpg(){
    THOME=$1
    NEWNAME=$NAME$2
    if [ -e $THOME ]
    then
	find $THOME > $BKDIR/$NEWNAME.list
	bzip2 -z $BKDIR/$NEWNAME.list
	gpg -r $KEY -e -o $BKDIR/$NEWNAME.list.bz2.gpg $BKDIR/$NEWNAME.list.bz2
	shred -u $BKDIR/$NEWNAME.list.bz2
	echo "end $BKDIR/$NEWNAME.list.bz2.gpg"
    else
	echo "func:make-list-gpg: $1 not exist"
    fi
}


if [ ! -e $BKDIR ]
then
    mkdir $BKDIR
fi


case $1 in
    o)#hidden
	OFILE=$BKDIR/$NAME-ocultos.tar.bz2.gpg
	tar cvjf - \
	    --exclude $MYHOME/Music \
	    --exclude $MYHOME/.cache \
	    --exclude $MYHOME/.config/google-chrome \
	    $MYHOME | gpg -r $KEY -e -o $OFILE
	md5sum $OFILE > $OFILE.md5
	make-list-gpg $MYHOME "-ocultos"
	;;

    m)#mail
	OFILE=$BKDIR/$NAME-mail.tar.bz2.gpg
	tar cvjf - \
	    $MYHOME/.mutt | gpg -r $KEY -e -o $OFILE
	md5sum $OFILE > $OFILE.md5
	make-list-gpg $MYHOME/mail "-mail"
    ;;

    d)#documents
	OFILE=$BKDIR/$NAME-documents.tar.bz2.gpg
	tar cvjf - \
	    $MYHOME/Documents | gpg -r $KEY -e -o $OFILE
	md5sum $OFILE > $OFILE.md5
	make-list-gpg $MYHOME/Documents "-documents"
	;;

    img)
	##images
	OFILE=$BKDIR/$NAME-images.tar.bz2.gpg
	tar cvjf - \
	    $MYHOME/Images | gpg -r $KEY -e -o $OFILE
	md5sum $OFILE > $OFILE.md5
	make-list-gpg $MYHOME/Images "-images"

	;;

    dir)
	DIR=$2
	FULLPATH=$MYHOME/$DIR
	if [ -d $FULLPATH ] && [ ! -z $DIR ]
	then
	    OFILE=$BKDIR/$NAME-$DIR.tar.bz2.gpg
	    tar cvjf - \
		$FULLPATH | gpg -r $KEY -e -o $OFILE
	    md5sum $OFILE > $OFILE.md5
	    make-list-gpg $FULLPATH "-$DIR"
	else
	    echo "opt dir: \"$DIR\" not exist"
	fi
	;;
    *) echo "use o - m - d - img - dir NAME_DIR";;
esac

