AZGSAVEM ;RPMS/TJF/MLQ;SAVE GLOBAL TO UNIX MEDIA;  [ 03/11/94  7:42 AM ]
 ;;1.4;AUGS;**1**;OCT 16, 1991
 I ^%ZOSF("OS")["PC"!($P($G(^AUTTSITE(1,0)),U,21)=2) G ^AZGSAVEP
 G:$D(AUMED) NOSELT
ASK R !!,"Copy transaction file to  ('^' TO EXIT WITHOUT SAVING)",!!?10,"[T]ape, [C]artridge, [D]iskette, or [F]ile   F// ",AUMED:DTIME S AUMED=$E(AUMED_"F")
 I "^"[AUMED S AUFLG(1)="Job Terminated by Operator at Device Select",AUFLG=-1 G END
 G HELP:"?"[AUMED,ASK:"CcDdFfTt"'[AUMED
NOSELT I '$D(ZTQUEUED) S IOP=$I D ^%ZIS K IOP S IOP="HOME" D ^%ZIS S X=0 X ^%ZOSF("RM") ;IHS/THL 'CURRENT' CHANGED TO 'HOME'
 S IO=AUIO,%DEV=IO D TAPE:"Tt"[AUMED D CART:"Cc"[AUMED D DISK:"Dd"[AUMED D UNIX:"Ff"[AUMED
 Q
HELP W !!,"This option saves the ' ",AUNAR," ",AUGL,"' transaction file to either a tape,",!,"a floppy diskette, or a Unix file. The default is to a unix file",!,"in the ",AUUF," directory."
 W !,"Enter either a ""C"" for tape cartridge, a ""T"" for 9-track tape, a ""D"" for floppy disk, or an ""F"" for Unix file."
 G ASK
DISK ;
 S X="^" U IO(0) W !!,"Mount a FORMATTED Floppy Diskette, 'WRITE ENABLED' ",*7,!,"Press RETURN When Ready  or ""^"" to Exit WITHOUT SAVING " R X:DTIME I X["^" S AUFLG(1)="Job Aborted by Operator During Floppy Mount",AUFLG=-1 G END
 O IO:("/dev/fd0":"W"):0 E  S ERRMSG="Floppy Disk" G ERRMESS
 U IO I $ZA<0 U IO(0) W !!,"Please",*7 G DISK
 U IO(0) W !,"Please Standby - Copying Data to Floppy",! D ^AZGSAV1M
 C:IO'=IO(0) IO
 U IO(0) R !!,"Remove the Floppy... Press RETURN when Ready:",X:DTIME G END
UNIX ;
HFS ;
 S AZGT1=$P($H,",",2)
HFS1 F %DEV=51:1:54 O %DEV::0 Q:$T
 I '$T,$P($H,",",2)<(AZGT1+10) G HFS1
 I '$T,$P($H,",",2)>(AZGT1+9) S ERRMSG="All Host File Servers Busy!" G ERRMESS
 S PRE=$E(AUGL,2,5),ASUFAC=$S('$D(AUSUFAC):$P(^AUTTLOC(DUZ(2),0),"^",10),1:AUSUFAC),X=""
 I '$D(ZTQUEUED) U IO(0) W !!,"UNIX File Being Created' ",*7 ;IHS/THL ADDED CHECK FOR BACKGROUND
 S %FN=AUUF_"/"_$S('$D(AUFN):PRE_ASUFAC_"."_AUCARTNO,1:AUFN)
 O %DEV:(%FN:"W"):0 E  S ERRMSG="UNIX File" G ERRMESS
 I '$D(ZTQUEUED) U IO(0) W !,"Please Standby - Copying Data to UNIX File ",$S('$D(AUFN):PRE_ASUFAC_"."_AUCARTNO,1:AUFN),! ;IHS/THL ADDED CHECK FOR BACKGROUND
 D ^AZGSAV1M
 G CLOSE
TAPE S DEVICE="/dev/rmt0",MESSAGE="9-Track" G TAPETST
CART S DEVICE="/dev/rct",MESSAGE="Cartridge"
 ;
TAPETST R !,"Do you want to test the TAPE DRIVE? (Y/N) Y//",Y:DTIME S Y=$E(Y_"Y") I "Yy"[Y D TAPETEST G:$D(AUFLG) CLOSE I Y["^" S AUFLG(1)="Job Aborted by Operator During Tape Test",AUFLG=-1 G END
S U IO(0) W !!,"Mount ",MESSAGE," Tape, 'WRITE ENABLED' ",*7
 R !,"Press RETURN When Ready  - ""^"" to Exit ",X:DTIME I X["^" S AUFLG(1)="Job Terminated By Operator at Mount Message",AUFLG=-1 G CLOSE
MAGOPEN O IO:(DEVICE:"W"):0 E  S ERRMSG="Magtape Device" G ERRMESS
 U IO I $ZA<0 U IO(0) W !!,"Please",*7 G S
 U IO(0) W !,"Please Standby - Copying Data to Tape",!
 D ^AZGSAV1M G EXIT
SW U IO(0) W *7,!!,"  The Tape Is WRITE PROTECTED. Please Remove The Tape,"
 W !,"  And Re-position The Write Protect/Enable Switch.",!,"  "
 G MAGOPEN
ERRMESS I '$D(ZTQUEUED) U IO(0) W !,ERRMSG," NOT AVAILABLE" ;IHS/THL ADDED CHECH FOR BACKGROUND
 S AUFLG(1)=ERRMSG_" Not Available",AUFLG=-1 G END
EXIT U IO:(DEVICE) C:IO'=IO(0) IO U IO(0) W !!,"Rewinding tape. <WAIT>" W "." H 2
 U IO(0) W !!,"Remove the tape... Press RETURN when Ready:" R X:DTIME
 G END
CLOSE C:IO'=IO(0) IO,%DEV
END ; uncomment the line below to get data file queued for uucp
 ;I '$D(AUFLG),$P(^AUTTSITE(1,0),"^",14)]"" D UUCPQ ;IHS/MFD added line
 K PRE,ASUFAC,OUTDATA,INDATA,DEVICE,MESSAGE,IO,ERRMSG,X,Y,%FN
 Q
TAPETEST U IO(0) W !!,"TAPE TEST...Mount ",MESSAGE," Tape, 'WRITE ENABLED' ",*7
 R !,"TAPE TEST...Press RETURN When Ready  - ""^"" to Exit ",X:DTIME
 I X["^" S AUFLG(1)="Job Aborted by Operator during Tape Test",AUFLG=-1 Q
 W !,"TAPE TEST...Opening tape drive." H 1
 O IO:(DEVICE:"W"):0 E  G TESTERR
 U IO I $ZA<0 U IO(0) W !!,"Please",*7 G TAPETEST
 U IO(0) W !,"TAPE TEST...Tape drive opened.",!,"TAPE TEST...Writing test data to tape." H 1
WRITE S OUTDATA="TEST DATA RECORD WRITTEN TO TAPE ON "_AUDT U IO W OUTDATA,!
 W "**",!,"**",!!
 U IO(0) W !,"TAPE TEST...Data written." C:IO'=IO(0) IO H 6 U IO(0) W !,"TAPE TEST...Reading test data from tape.",! H 1
 O IO:(DEVICE:"R"):0 E  G TESTERR
 U IO R INDATA:DTIME C:IO'=IO(0) IO W !,"WROTE : '",OUTDATA,"'",!," READ : '",INDATA,"'"
 I INDATA=OUTDATA W !,"TAPE TEST...Successful."
 E  W !,"TAPE TEST...FAILED...$#@!" S AUFLG(1)="Tape Test Failed During Testing",AUFLG=-1 Q
 Q
TESTERR S AUFLG(1)="Device Not Available During Tape Testing",AUFLG=-1
 U IO(0) W !,*7,AUFLG(1),*7 Q
UUCPQ ;
 S AUUUCP=$P(^AUTTSITE(1,0),"^",14)
 S AUUUCPQ="/usr/bin/sendto "_AUUUCP_" /usr/spool/uucppublic/"_PRE_ASUFAC_"."_AUCARTNO
 S AUUUCPQ=$$JOBWAIT^%HOSTCMD(AUUUCPQ) ; AUGS*1.4*1
 I AUUUCPQ S AUFLG=-1,AUFLG(1)="Queue of File to uucp Failed" ; AUGS*1.4*1
 E  W:'$D(ZTQUEUED) !,"Export file ",PRE,ASUFAC,".",AUCARTNO," queued up to be sent to ",AUUUCP,"...",! ; AUGS*1.4*1
 K AUUUCP,AUUUCPQ ; AUGS*1.4*1
 Q
