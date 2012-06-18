ZIBGSVEM ; IHS/ADC/GTH - SAVE GLOBAL TO MSM UNIX ; [ 09/14/2004  4:57 PM ]
 ;;3.0;IHS/VA UTILITIES;**9,10**;FEB 07, 1997
 ;
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["Windows NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) G ^ZIBGSVEP ;COMMENTED OUT AND REPLACE BY NEXT LINE - AEF/08/08/03
 I $$VERSION^%ZOSV(1)["Windows" G ^ZIBGSVEP ;XB*3*10  TASSC/MFD  8/15/03
 G:$D(XBMED) NOSELT
ASK ;
 R !!,"Copy transaction file to  ('^' TO EXIT WITHOUT SAVING)",!!?10,"[T]ape, [C]artridge, [D]iskette, or [F]ile   F// ",XBMED:DTIME
 S XBMED=$$UP^XLFSTR($E(XBMED_"F"))
 I U[XBMED S XBFLG(1)="Job Terminated by Operator at Device Select",XBFLG=-1 G END
 G HELP:"?"[XBMED,ASK:'("CDFT"[XBMED)
NOSELT ;
 S (IO,XBZDEV)=XBIO
 D TAPE:"T"[XBMED,CART:"C"[XBMED,DISK:"D"[XBMED,UNIX:"F"[XBMED
 Q
 ;
HELP ;
 W !!,"This option saves the ' ",XBNAR," ",XBGL,"' transaction file to either a tape,",!,"a floppy diskette, or a Unix file. The default is to a unix file",!,"in the ",XBUF," directory."
 W !,"Enter either a ""C"" for tape cartridge, a ""T"" for 9-track tape, a ""D"" for floppy disk, or an ""F"" for Unix file."
 G ASK
 ;
DISK ; -----  Transfer TX Global to floppy disk.
 U IO(0)
 W !!,"Mount a FORMATTED Floppy Diskette, 'WRITE ENABLED' ",*7,!,"Press RETURN When Ready  or ""^"" to Exit WITHOUT SAVING "
 R X:DTIME
 I X[U!('$T) S XBFLG(1)="Job Aborted by Operator During Floppy Mount",XBFLG=-1 G END
 I $$OPEN^%ZISH("/dev/","fd0","W") S XBERRMSG="Floppy Disk" G ERRMESS
 U IO
 I $$STATUS^%ZISH U IO(0) W !!,"Please",*7 G DISK
 U IO(0)
 W !,"Please Standby - Copying Data to Floppy",!
 U IO
 D SAVEMSM
 D ^%ZISC
 U IO(0)
 R !!,"Remove the Floppy... Press RETURN when Ready:",X:DTIME
 G END
 ;
UNIX ; -----  Transfer TX Global to unix file.
 S XBPRE=$E(XBGL,2,5),XBASUFAC=$S('$D(XBSUFAC):$P(^AUTTLOC(DUZ(2),0),U,10),1:XBSUFAC)
 S XBFN=$S('$D(XBFN):XBPRE_XBASUFAC_"."_XBCARTNO,1:XBFN)
 S XBTEMPFN=XBUF_"/"_XBFN
 S XBPAFN=XBTEMPFN
 S %=$$OPEN^%ZISH(XBUF_"/",XBFN,"W")
 I % S XBERRMSG=$S(%=1:"All Host File Servers Busy!",1:"UNIX File") G ERRMESS
 I '$D(ZTQUEUED) U IO(0) W !,"Please Standby - Copying Data to UNIX File ",XBTEMPFN,!
 S X=$$JOBWAIT^%HOSTCMD("chmod 666 "_XBUF_"/"_XBFN)
 U IO
 D SAVEMSM
 G CLOSE
 ;
TAPE ;
 S XBDEV="rmt0",XBMSG="9-Track"
 G TAPETST
CART ;
 S XBDEV="rct",XBMSG="Cartridge"
 ;
TAPETST ; -----  Transfer global to cartridge or 9-track.
 W !,"Do you want to test the ",XBMSG," DRIVE? (Y/N) Y//"
 R Y:DTIME
 S Y=$E(Y_"Y")
 I "Yy"[Y D TAPETEST G:$D(XBFLG) CLOSE I Y[U S XBFLG(1)="Job Aborted by Operator During Tape Test",XBFLG=-1 G END
S ;
 U IO(0)
 W !!,"Mount ",XBMSG," Tape, 'WRITE ENABLED' ",*7
 R !,"Press RETURN When Ready  - ""^"" to Exit ",X:DTIME
 I X[U S XBFLG(1)="Job Terminated By Operator at Mount Message",XBFLG=-1 G CLOSE
MAGOPEN ;
 I $$OPEN^%ZISH("/dev/",XBDEV,"W") S XBERRMSG="Magtape Device" G ERRMESS
 U IO
 I $$STATUS^%ZISH U IO(0) W !!,"Please",*7 G S
 U IO(0)
 W !,"Please Standby - Copying Data to Tape",!
 U IO
 D SAVEMSM
 G EXIT
 ;
SW ;
 U IO(0)
 W *7,!!,"  The Tape Is WRITE PROTECTED. Please Remove The Tape,"
 W !,"  And Re-position The Write Protect/Enable Switch.",!,"  "
 G MAGOPEN
 ;
ERRMESS ;
 S XBFLG(1)=XBERRMSG_" Not Available",XBFLG=-1
 I '$D(ZTQUEUED) U IO(0) W !,XBFLG(1)
 G END
 ;
EXIT ;
 D ^%ZISC
 U IO(0)
 W !!,"Rewinding tape. <WAIT>."
 H 2
 W !!,"Remove the tape... Press RETURN when Ready:"
 R X:DTIME
 G END
 ;
CLOSE ;
 D ^%ZISC
END ;
 I XBMED="F",'$D(XBFLG),XBQ="Y" D UUCPQ
 D HOME^%ZIS
 KILL XBPRE,XBASUFAC,XBOUTDAT,XBINDATA,XBDEV,XBMSG,XBERRMSG,XBTEMPFN,XBZDEV
 Q
 ;
TAPETEST ;
 U IO(0)
 W !!,"TAPE TEST...Mount ",XBMSG," Tape, 'WRITE ENABLED' ",*7
 R !,"TAPE TEST...Press RETURN When Ready  - ""^"" to Exit ",X:DTIME
 I X[U S XBFLG(1)="Job Aborted by Operator during Tape Test",XBFLG=-1 Q
 W !,"TAPE TEST...Opening tape drive."
 H 1
 I $$OPEN^%ZISH("/dev/",XBDEV,"W") G TESTERR
 U IO
 I $$STATUS^%ZISH U IO(0) W !!,"Please",*7 G TAPETEST
 U IO(0)
 W !,"TAPE TEST...Tape drive opened.",!,"TAPE TEST...Writing test data to tape."
 H 1
WRITE ;
 S XBOUTDAT="TEST DATA RECORD WRITTEN TO TAPE ON "_XBDT
 U IO
 W XBOUTDAT,!,"**",!,"**",!!
 U IO(0)
 W !,"TAPE TEST...Data written."
 D ^%ZISC
 H 6
 U IO(0)
 W !,"TAPE TEST...Reading test data from tape.",!
 H 1
 I $$OPEN^%ZISH("/dev/",XBDEV,"R") G TESTERR
 U IO
 R XBINDATA:DTIME
 D ^%ZISC
 U IO(0)
 W !,"WROTE : '",XBOUTDAT,"'",!," READ : '",XBINDATA,"'"
 I XBINDATA=XBOUTDAT W !,"TAPE TEST...Successful."
 E  W !,"TAPE TEST...FAILED...$#@!" S XBFLG(1)="Tape Test Failed During Testing",XBFLG=-1
 Q
 ;
TESTERR ;
 S XBFLG(1)="Device Not Available During Tape Testing",XBFLG=-1
 U IO(0)
 W !,*7,XBFLG(1),*7
 Q
 ;
UUCPQ ;EP - auto queue to uucp subroutine, must have system id in RPMS SITE file ; IHS/SET/GTH XB*3*9 10/29/2002
 I $$JOBWAIT^%HOSTCMD("/usr/bin/sendto "_XBQTO_" "_XBUF_"/"_XBFN) S XBFLG=-1,XBFLG(1)="Queue of File to uucp Failed"
 E  W:'$D(ZTQUEUED) !,"Export file ",XBUF,"/",XBFN," queued up to be sent to ",XBQTO,"...",!
 Q
 ;
SAVEMSM ;EP - $QUERY thru global, write to output.
 K XBQUIT
 I '$G(XBFLT) W XBDT,!,XBTLE,!
 S X=XBGL_XBF_")"
 F  D  Q:$G(XBQUIT)
 .S X=$Q(@X)
 .I X="" S XBQUIT=1 Q
 .S Y=$P($P($P(X,")",1),"(",2),",",1)
 .I XBE=+XBE,Y'=+Y S XBQUIT=1 Q
 .I ($L(XBE)&($$FOLLOW(Y,XBE))) S XBQUIT=1 Q
 .I $D(XBCON)&('(Y=+Y)) S XBQUIT=1 Q
 .S Y=X
 .S:$E(Y,2)="[" Y=U_$P(Y,"]",2,999)
 .W:'$G(XBFLT) Y,!
 .W @X,!
 I '$G(XBFLT) W "**",!,"**",!!
 K XBQUIT
 Q
 ;
FOLLOW(Y,XBE) ; If Y follows XBE return 1.  Else return 0.
 N Z
 I '(Y=+Y) D
 .S Z=(Y]XBE)
 I Y=+Y D
 .S Z=(Y>XBE)
 Q Z
 ;
