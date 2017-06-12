BLRENTRY ; IHS/MSC/MKK - Monitor for Debug Global ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;LR;**1033**;NOV 01, 1997
 ;
EEP ; EP - Ersatz Entry
 D EEP^BLRGMENU
 Q
 ;
 ; Make sure ^BLRENTRY global doesn't get too large
CHKENTRY ; EP
 Q       ; For now, don't do this.
 ;
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S CURDIR=$$SUCICDIR()
 ;
 S GLOBAL="BLRENTRY"
 ;
 ; GLOSIZE returned as # of blocks.
 S X=##class(%Library.GlobalEdit).GetGlobalSize(CURDIR,GLOBAL,.GLOSIZE,,1)
 ;
 ; MBSIZE = Global size in megabytes.  Assumes standard configuration of 1 block = 8 KB = 8192 Bytes
 S MBSIZE=(GLOSIZE*8192)/(1024*1024)
 ;
 Q:+$G(MBSIZE)<=10        ; 10 MB is the maximum allowed
 ;
 ; ^BLRENTRY size is > 10 MB, start over
 S GLOBAL="^BLRENTRY"
 K @GLOBAL
 ;
 D KEEPTRAK(CURDIR,MBSIZE)
 ;
 Q
 ;
SUCICDIR() ; Set UCI's Current DIRectory
 NEW CURNAME,SUCICDIR
 ;
 S SUCICDIR=$G(^BLRENTRY("A"))
 Q:$L(SUCICDIR) SUCICDIR       ; If already stored, skip rest of code
 ;
 S CURNAME=$NAMESPACE          ; Get UCI Namespace name
 ;
 ; The following is necessary because a Cache system can be setup to
 ; have a default directory that IS NOT the cache.dat file's direc-
 ; tory.  If the S $NAMESPACE= command is not made, the GetDirectory()
 ; call does NOT return the cache.dat file's directory, but the "default"
 ; "file output" directory.
 S $NAMESPACE="%SYS"      ; "Change directory" to %SYS, which will ALWAYS exist
 S $NAMESPACE=CURNAME     ; "Change directory" back to Namespace directory
 ;
 ; GetDirectory() will now retrieve cache.dat file directory
 S SUCICDIR=##class(%File).GetDirectory()
 ;
 ; Store cache.dat directory
 S ^BLRENTRY("A")=SUCICDIR
 ;
 Q SUCICDIR
 ;
 ;
KEEPTRAK(CURDIR,MBSIZE) ; EP - Keep track of resets
 NEW CNT,NOWDATE
 ;
 ; Store cache.dat directory
 S ^BLRENTRY("A")=CURDIR
 ;
 S NOWDATE=$$DT^XLFDT
 ;
 ; Setup ^XTMP per SAC, if necessary
 I $L($G(^XTMP("BLRENTRY",0)))<1 D
 . S $P(^XTMP("BLRENTRY",0),"^",2)=$$DT^XLFDT
 . S $P(^XTMP("BLRENTRY",0),"^",3)="Debug Global ^BLRENTRY Report"
 ;
 ; Set/Reset "purge" date
 S $P(^XTMP("BLRENTRY",0),"^")=$$HTFM^XLFDT(+$H+90)
 ;
 S CNT=1+$O(^XTMP("BLRENTRY","GLOSIZE",NOWDATE,"A"),-1)
 S ^XTMP("BLRENTRY","GLOSIZE",NOWDATE,CNT)=MBSIZE_"^"_$$HTE^XLFDT($H,"2MZ")
 ;
 D:CNT=2 TWICEDAY(NOWDATE)
 D:CNT>5 STOPIT(NOWDATE)  ; Reset 'Take Snapshots' field
 ;
 Q
 ;
TWICEDAY(NOWDATE) ; EP - If Twice in one day, alert folks once a day
 Q:$D(^XTMP("BLRENTRY","GLOSIZE",NOWDATE,"ALERTED"))
 ;
 NEW STR,INDENT
 ;
 S ^XTMP("BLRENTRY","GLOSIZE",NOWDATE,"ALERTED",$H)=""
 ;
 S INDENT=$J("",5)
 S STR(1)=INDENT_$$MAKBANNR("BLRENTRY Global Reset Twice In One Day!",50,">","<")
 S STR(2)=" "
 S STR(3)=INDENT_"The BLRENTRY Global has been Reset twice Today."
 S STR(4)=" "
 S STR(5)=INDENT_"Such an event is indicative of a runaway process."
 S STR(6)=" "
 S STR(7)=INDENT_"Please Contact the Site Manager and inform them"
 S STR(8)=INDENT_"of this e-mail IMMEDIATELY."
 ;
 D MAILALMI^BLRUTIL3("BLRENTRY Global Too Large",.STR,"BLRENTRY Monitor",1)
 Q
 ;
STOPIT(NOWDATE) ; EP - BLRENTRY Global reset.  Emergency STOP.
 NEW ERRS,FDA,INDENT,STR
 ;
 ; Set 'Take Snapshots' Field to NO
 D ^XBFMK
 S FDA(9009029,DUZ(2)_",",1)=0
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS) D  Q     ; If errors, store and quit
 . S ^TMP("BLRENTRY",$J,DUZ(2),"1")=0
 . M ^TMP("BLRENTRY",$J,DUZ(2),"ERRS")=ERRS
 . S ^TMP("BLRENTRY",$J,DUZ(2),"FORCED 'TAKE SNAPSHOTS' TO OFF **FAILED**",$H)=""
 ;
 S ^XTMP("BLRENTRY","GLOSIZE",NOWDATE,"FORCED 'TAKE SNAPSHOTS' TO OFF",$H)=$G(DUZ(2))
 ;
 S INDENT=$J("",5)
 ;
 S STR(1)=INDENT_$$MAKBANNR("BLR MASTER CONTROL File Reset!",50,">","<")
 S STR(2)=" "
 S STR(3)=INDENT_"The 'TAKE SNAPSHOTS' field of the BLR MASTER"
 S STR(4)=INDENT_"CONTROL file for Entry "_DUZ(2)_" has been"
 S STR(5)=INDENT_"forcibly set to OFF."
 S STR(6)=" "
 S STR(7)=INDENT_"This event was caused by the BLRENTRY MONITOR"
 S STR(8)=INDENT_"process when the ^BLRENTRY global was reset more"
 S STR(9)=INDENT_"than 5 times in one day."
 S STR(10)=" "
 S STR(11)=INDENT_"It is indicative of a runaway process."
 S STR(12)=" "
 S STR(13)=INDENT_"Please Contact the Site Manager and inform them"
 S STR(14)=INDENT_"of this e-mail IMMEDIATELY."
 ;
 D MAILALMI^BLRUTIL3("BLR MASTER CONTROL FILE 'TAKE SNAPSHOTS' FIELD RESET",.STR,"BLRENTRY Monitor",1)
 ;
 Q
 ;
MAKBANNR(ASTR,RM,LF,RF) ; EP - MaKe a BANNeR string
 NEW HALFLEN,LEFT,TMPSTR,RIGHT
 ;
 ; Make certain Right Margin (RM) is set
 S:+$G(RM)<1 RM=$G(IOM,80)
 ;
 ; Adjust RM, if necessary
 S:$L($G(ASTR))>RM RM=$L(ASTR)+4
 ;
 ; Make certain LF and RF variables set
 I $G(LF)="",$G(RF)="" S (LF,RF)="="
 I $G(RF)="",$G(LF)'="" S RF=LF
 I $G(LF)="",$G(RF)'="" S LF=RF
 ;
 ; Set the midpoint variable, minus half the length of the string
 S HALFLEN=(RM\2)-(($L(ASTR))\2)
 ;
 S $P(LEFT,LF,HALFLEN)=""      ; Left side of the string
 S $P(RIGHT,RF,HALFLEN)=""     ; Right side of the string
 ;
 ; Make the Banner string
 S:$L(ASTR) TMPSTR=LEFT_" "_ASTR_" "_RIGHT
 S:$L(ASTR)<1 TMPSTR=LF_LEFT_RIGHT_RF
 ;
 ; If necessary, adjust Banner string's length
 S:$L(TMPSTR)<RM TMPSTR=TMPSTR_RF
 S:$L(TMPSTR)>RM TMPSTR=$E(TMPSTR,1,RM)
 ;
 Q TMPSTR
 ;
TESTSHOW ; EP - Test -- Just SHOW the size
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S CURDIR=$$SUCICDIR()
 ;
 S GLOBAL="BLRENTRY"
 ;
 ; GLOSIZE returned as # of blocks.
 S X=##class(%Library.GlobalEdit).GetGlobalSize(CURDIR,GLOBAL,.GLOSIZE,,1)
 ;
 ; MBSIZE = Global size in megabytes.  Assumes standard configuration of 1 block = 8 KB = 8192 Bytes
 S MBSIZE=(GLOSIZE*8192)/(1024*1024)
 ;
 S GLOSTR=$FN(GLOSIZE,"",2)
 S MBSTR=$FN(MBSIZE,"",2)
 S JUSTSIZE=$S($L(GLOSTR)>$L(MBSTR):$L(GLOSTR),$L(MBSTR)>$L(GLOSTR):$L(MBSTR),1:$L(GLOSTR))
 ;
 W !!,"Size of ^BLRENTRY",!,?4,"GLOSIZE = ",$J(GLOSTR,JUSTSIZE)," blocks",!,?5,"MBSIZE = ",$J(MBSTR,JUSTSIZE)," MB",!!
 Q
