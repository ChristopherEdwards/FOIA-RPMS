AFSHARC0 ; IHS/OIRM/DSD/JDM-ARCHIVE & JULIAN DATE CONVERSION RTN;    [ 10/27/2004   4:20 PM ]
 ;;3.0T1;PERSONNEL C.A.N. CORRECTION;**1,13**;FEB 02, 1999
 ;;MODIFIED FOR CACHE' COMPLIANCE ; ACR*2.1*9
 W !!,"NOT AN ENTRY POINT" Q
TARBKUP ;EP; DO 'TAR' BACKUP OF OPERATING SYSTEM FILE
 ;;%FN  = INPUT FILE NAME
 ;;%SDIR = UNIX SUBDIRECTORY LOCATION OF INPUT FILE
 ;;AFSHDTYE =  (Cartridge(C) or Tape (T) - default="C"
MEDIA ;
 I '$D(AFSHOPT(3)) S AFSHOPT(3)=$P(^AFSHPARM(DUZ(2),0),"^",4)
 I AFSHOPT(3)="N" S AFSHRTCD=0 Q
 I '$D(AFSHDTYE) S AFSHDTYE="C"
 ;I '$D(%SDIR) S %DIR="/usr/spool/afsdata" ;   ;ACR*2.1*13.06 IM14144
 I '$D(%SDIR) S %SDIR=$$ARMSDIR^ACRFSYS(1)      ;ACR*2.1*13.06 IM14144
 Q:%SDIR']""                                    ;ACR*2.1*13.06 IM14144
 S AFSHDTYP=$S(AFSHDTYE="C":"rmt0",AFSHDTYE="T":"rmt1")
 S AFSHDNME=$S(AFSHDTYE="C":"Cartridge Tape",AFSHDTYE="T":"9-Track Tape")
 I '$D(%FN) G ERROR
 S AFSHFNLN=$L(%FN)
TRYBK ;
 U IO(0) W !!,?10,"Backing up ",AFSHEXFN," to ",AFSHDNME,!
 S AFSHCMDR="cd "_%SDIR_"; tar -cvft /dev/"_AFSHDTYP_" "_%FN
 D HOSTCMD^AFSHCKZC U IO(0)
 S AFSHRTCD=X
 I X=0 W !!,?10,"Backup to ",AFSHDNME," was SUCCESSFUL" G TAREXIT
ERROR W *7,!!?10,"Backup to ",AFSHDNME," was NOT SUCCESSFUL -- NOTIFY SUPERVISOR"
TAREXIT ;S AFSHCMDR="cd /usr/spool/afsdata" D TCMD^ACRFUTL G ENDX^AFSHARC1 ;ACR*2.1*13.06 IM14144
 S AFSHCMDR="cd "_%SDIR D TCMD^ACRFUTL G ENDX^AFSHARC1 ;ACR*2.1*13.06 IM14144
 ;
ARCHLIST ;EP; LIST APPROPRIATE FILES IN OPERATING SYSTEM
 Q:$D(DUOUT)!$D(DTOUT)
 ;;%DEV =HFS (INITIALLY 51)
 ;;%FN  =INPUT FILE NAME
 ;;%OPT=0 -- NO OPERATOR INTERACTION (DEFAULT)
 ;;%OPT=1 -- ASK OPERATOR QUESTIONS
SETUP ;
 U IO(0) W !,"FILE: ",%FN
 I '$D(%FN) U IO(0) W "FILE NAME ERROR" G ENDX^AFSHARC1
 S AFSHFNLN=$L(%FN) K AFSHJFLG
 I '$D(%OPT) S %OPT=0
 S %FNSAV=%FN
 K AFSHFLES
 ;I '$D(%SDIR) S %DIR="/usr/spool/afsdata"         ;ACR*2.1*13.06 IM14144
 I '$D(%SDIR) S %SDIR=$$ARMSDIR^ACRFSYS(1)         ;ACR*2.1*13.06 IM14144
 Q:%SDIR']""
 S X1=DT,X2=$E(DT,1,3)_"0101" D ^%DTC S AFSHDTJL=$E(DT,2,3)_$E("000",1,3-$L(X+1))_(X+1)
LISTEM ;
 S AFSHCMDR="cd "_%SDIR_";rm afs.files; ls -l "_%FN_"*"_" | awk '{print $5,$9}' > afs.files"
 D TCMD^ACRFUTL(AFSHCMDR)
 ;S %FN=%SDIR_"/afs.files"                     ;ACR*2.1*13.06 IM14144
 S %FN="afs.files"                             ;ACR*2.1*13.06 IM14144
 ;S Y=0 D OPENHFS^AFSHCK1 I Y>0 D ERROR^AFSHCK1 G ABEND^AFSHARC1 ;ACR*2.1*13.06 IM14144
 S Y=0                                         ;ACR*2.1*13.06 IM14144
 D OPENHFS^AFSHCK1(%SDIR,%FN,.%DEV)            ;ACR*2.1*13.06 IM14144
 I $G(%DEV)']"" D ERROR^AFSHCK1 G ABEND^AFSHARC1  ;ACR*2.1*13.01 IM13574
 S AFSHFCNT=0,AFSHDCNT=0 F AFSHI=1:1 U %DEV R AFSHX:1 G DEVEOF:'$T G DEVEOF:$$STATUS^%ZISH=-1 D SUB1
DEVEOF S AFSHR=0
 G ENDX^AFSHARC1:%OPT=0
 U IO(0) W !!,"NUMBER OF PREVIOUSLY EXPORTED FILES = ",AFSHFCNT
 D SUB2
 I AFSHLDAT=0 G FILEDSP
 ;
 W ! K DIR S DIR("B")="N",DIR(0)="Y",DIR("A")="Delete ALL Previously EXPORTED Files Processed BEFORE "_Y D ^DIR
 I Y=1 G FILEDEL
 G:$D(DUOUT)!$D(DTOUT) ARCHLIST
FILEDSP W ! K DIR S DIR("B")="Y",DIR(0)="Y",DIR("A")="Do you want to LIST Previously EXPORTED FILES?" D ^DIR
 G:$D(DUOUT)!$D(DTOUT) ARCHLIST
 I Y'=1 G ENDX^AFSHARC1
A20 S AFSHR=0,AFSHRR=0,AFSHSEQ=0
 W !!,"SEQ #  ","# RCDS    EXPORT - DATE  FILE NAME - SFX  OK-TX?  COLOR",!!
FILEDSPA S AFSHR=$O(AFSHFLES("C",AFSHR)) G LISTEND:+AFSHR=0
FILEDSPB S AFSHRR=$O(AFSHFLES("C",AFSHR,AFSHRR)) G FILEDSPA:+AFSHRR=0
 S AFSHFNME=$P(AFSHFLES(AFSHRR),"^",2),AFSHXPT=0,AFSHXPT=$O(^AFSTXLOG(DUZ(2),1,"B",AFSHFNME,AFSHXPT))
 ;I +AFSHXPT<1 S AFSHEMSG="ERROR IN TX/EXPORT DATA STRUCTURE  -- NOTIFY SUPERVISOR",AFSHJFLG=1 G JCANCEL^AFSHARC1
 S AFSHXST="N",$P(AFSHFLES(AFSHRR),"^",3)="N" S:+AFSHXPT>0 AFSHXST=$P(^AFSTXLOG(DUZ(2),1,AFSHXPT,0),"^",4),AFSHCLRN=$P(^(0),"^",5),$P(AFSHFLES(AFSHRR),"^",3)=AFSHXST
 ;S AFSHCLRN=$S(AFSHCLRN="R":"RED",AFSHCLRN="B":"BLUE",1:"")
 S X=$P($P(AFSHFLES(AFSHRR),".",2),"^",1) D JDATECV
 S X=$P(AFSHFLES(AFSHRR),"^",1),AFSHSZ=X/81,X=$J(AFSHSZ,0,0)
 S AFSHSEQ=AFSHSEQ+1 W !,$J(AFSHSEQ,3),?6,$J(X,6),?17,Y
 S AFSHSZ=$P(AFSHFLES(AFSHRR),"^",2)
 S X=$P(AFSHSZ,".",1) W ?33,$E(X,1,AFSHFNLN),?45,$E(X,AFSHFNLN+1,AFSHFNLN+1),?51,AFSHXST
 G FILEDSPB
LISTEND W !,"****       END OF LIST        **** ",! H 3 K DIR S DIR(0)="E" D ^DIR I Y=0 S AFSHEMSG=$P($T(M9^AFSHCK1),";;",2),AFSHJFLG=1 G JCANCEL^AFSHARC1
 G ENDX^AFSHARC1
 ;
SUB1 ;
 S AFSHFCNT=AFSHFCNT+1
 S AFSHFLES(AFSHI)=$P(AFSHX," ",1)_"^"_$P(AFSHX," ",2),AFSHY=$P($P(AFSHX," ",2),".",2) Q:+AFSHY<1  I '$D(AFSHFLES("C",AFSHY)) S AFSHDCNT=AFSHDCNT+1
 S AFSHFLES("C",99999-AFSHY,AFSHI)=""
 S AFSHZ=$P($P(AFSHX," ",2),".",1)
 S AFSHFLES("N",AFSHY,AFSHZ,AFSHI)=""
 Q
SUB2 ;
 S AFSHR=0,AFSHLDAT=0,AFSHDCNT=0
SUB2A S AFSHR=$O(AFSHFLES("C",AFSHR)) G SUB2END:+AFSHR=0
 S AFSHDCNT=AFSHDCNT+1 S:AFSHDCNT=3 AFSHLDAT=99999-AFSHR
 G SUB2A
SUB2END S X=AFSHLDAT D JDATECV S AFSHDLDT=X
 Q
 ;
FILEDEL ;
 S AFSHR=0 W !
FILEDELA S AFSHR=$O(AFSHFLES(AFSHR)) G FILEDEX:+AFSHR=0
 S AFSHSZ=AFSHFLES(AFSHR)
 S (AFSHXSAV,X)=$P(AFSHSZ,".",2) D JDATECV S AFSHDSVE=X
 I $E(X,1,3)>280&(X<AFSHDLDT) G ZDEL
 G FILEDELA
ZDEL S AFSHFILN=$P(AFSHFLES(AFSHR),"^",2)
 ;S AFSHCMD="rm "_%SDIR_"/"_AFSHFILN              ;ACR*2.1*13.06 IM14144
 S X=$$DEL^%ZISH(%SDIR,AFSHFILN)                  ;ACR*2.1*13.06 IM14144
 I X'=0 G FILEDELA
 W !,AFSHFILN," UNIX FILE DELETED" K AFSHFLES("C",99999-AFSHXSAV,AFSHR),AFSHFLES("N",AFSHXSAV,$P(AFSHFILN,".",1),AFSHR),AFSHFLES(AFSHR)
 S AFSHXPT=0,AFSHXPT=$O(^AFSTXLOG(DUZ(2),1,"B",AFSHFILN,AFSHXPT))
 I +AFSHXPT>0 S DIK="^AFSTXLOG("_DUZ(2)_",1,",DA(1)=DUZ(2),DA=AFSHXPT D ^DIK
 G FILEDELA
FILEDEX G ENDX^AFSHARC1
 ;
JDATECV ;EP; JULIAN DATE CONVERSION
 ; beginning Y2K fix block
 ;S AFSHSZ=X ; X shoud be in the format YYJJJ where YY is a two digit year and JJJ is the julian date in the year. ;AFSH*3.0T1*1
 ;S AFSHSZ=$E("00000",1,5-$L(AFSHSZ))_AFSHSZ ;pad with zeroes if less than 5 digits ;AFSH*3.0T1*1
 ;I $L(X)=3 S X=$E(DT,1,3)-200_AFSHSZ S:AFSHSZ>AFSHDTJL X=$E(DT,1,3)-201_AFSHSZ
 ;S AFSHSZ=X
 ;I $L(X)'=5 S Y=-1 G JDATEQ
 ;S AFSHJYR=$E(X,1,2),AFSHJDD=$E(X,3,5)
 ;S AFSHZDT="0^31^59^90^120^151^181^212^243^273^304^334^365"
 ;I (1700+200_AFSHJYR)#4=0 F I=4:1:13 S $P(AFSHZDT,"^",I)=$P(AFSHZDT,"^",I)+1
 ;F I=1:1:13 Q:$P(AFSHZDT,"^",I)'<AFSHJDD
 ;S AFSHDA=AFSHJDD-$P(AFSHZDT,"^",I-1),AFSHDA=$E("00",1,2-$L(AFSHDA))_AFSHDA
 ;S AFSHMM=I-1,AFSHMM=$E("00",1,2-$L(AFSHMM))_AFSHMM,AFSHJYR=$E(DT,1,1)*100+AFSHJYR
 ;S (X,Y)=AFSHJYR_AFSHMM_AFSHDA D DD^%DT
 S AFSHSZ=X ;Y2000;AEF;AFSH*3.0T1*1
 I $L(X)=3 S AFSHSZ=$E(DT,2,3)_X ;Y2000;AEF;AFSH*3.0T1*1
 I $L(AFSHSZ)'=5 S Y=-1 G JDATEQ ;Y2000;AEF;AFSH*3.0T1*1
 S AFSHJYR=$E(AFSHSZ,1,2) ;Y2000 YY
 N %DT S X="0101"_AFSHJYR D ^%DT ;Y2000 get century
 S X=$$FMADD^XLFDT(Y,AFSHSZ-(AFSHJYR_"000")-1) ;Y2000 X-AFSHJYR = JJJ
 S Y=$$FMTE^XLFDT(X) ;Y2000 X is the internal date Y is the external
 ; end Y2K fix Block
JDATEQ K AFSHJYR,AFSHZDT,AFSHDA,AFSHMM,AFSHJDD,I Q
 Q