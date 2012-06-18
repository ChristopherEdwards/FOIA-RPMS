ZIBGSVEP ; IHS/ADC/GTH - SAVE GLOBAL TO DOS MEDIA ; [ 07/21/2005  3:22 PM ]
 ;;3.0;IHS/VA UTILITIES;**8,9,10,11**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH - 12-07-00 - Protect U IO(0) and WRITE's in background.
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache', NT, and system mods.
 ;
 ;S XBUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT") ;LINE COMMENTED OUT AND REPLACED BY NEXT LINE - AEF/08/08/03
 ;S:'$G(XBUF) XBUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT") ;XB*3*10
 G:$D(XBMED) NOSELT
ASK ;
 R !!,"Copy transaction file to ('^' TO EXIT WITHOUT SAVING)",!!?10,"[D]iskette, or [F]ile   F// ",XBMED:DTIME
 S XBMED=$$UP^XLFSTR($E(XBMED_"F"))
 I U[XBMED S XBFLG(1)="Job Terminated by Operator at Device Select",XBFLG=-1 G END
 G HELP:"?"[XBMED,ASK:"DF"'[XBMED
NOSELT ;
 S IO=XBIO
 D DISK:"D"[XBMED,DOS:"F"[XBMED
 Q
 ;
HELP ;
 W !!,"This option saves the ' ",XBNAR," ",XBGL,"' transaction file to either a floppy",!,"diskette, or a Dos file on the Hard Disk. The default is to a Dos file",!,"in the ",XBUF," directory."
 W !,"Enter either a ""D"" for floppy disk, or an ""F"" for Dos file."
 G ASK
 ;
DISK ;TRANSFER TX GLOBAL TO FLOPPY DISK
 F  R !,"Select the drive (A,B,C):  B//",Y:DTIME S Y=$$UP^XLFSTR($E(Y_"B")) Q:"ABC"[Y  W:'(U[Y) "  ??" I U[Y!('$T) S XBFLG(1)="Abort at drive select",XBFLG=-1 G END
 S XBUF=Y_":"
 W !!,"Insert a FORMATTED Floppy Diskette into drive '",XBUF,"', 'WRITE ENABLED' ",*7,!,"Press RETURN When Ready  or ""^"" to Exit WITHOUT SAVING "
 R X:DTIME
 I X[U!('$T) S XBFLG(1)="Job Aborted by Operator During Floppy Mount",XBFLG=-1 G END
DOS ;TRANSFER TX GLOBAL TO DOS FILE.
 I '$D(ZTQUEUED) U IO(0) W !!,"DOS File Being Created' ",*7
 I '$D(XBFN) D
 .; if you're on NT put the full location code to be compatible with
 .; area unix boxes
 .;I ^%ZOSF("OS")["Windows NT" S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S X=X+1,XBFN=$E(XBGL,2,5)_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_X Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 .I ^%ZOSF("OS")["NT" S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S X=X+1,XBFN=$E(XBGL,2,5)_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_X Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 .S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S X=X+1,XBFN=$E(XBGL,2,5)_$E($P(^AUTTLOC(DUZ(2),0),U,10),3,6)_"."_X
 S XBPAFN=XBUF_"\"_XBFN
 I $$OPEN^%ZISH(XBUF_"\",XBFN,"W") S XBERRMSG="DOS File" G ERRMESS
 ; U IO(0) ; XB*3*8
 I '$D(ZTQUEUED) U IO(0) ; XB*3*8
 ; W !,"Please Standby - Copying Data to DOS File ",XBUF,"\",XBFN ; XB*3*8
 I '$D(ZTQUEUED) W !,"Please Standby - Copying Data to DOS File ",XBUF,"\",XBFN ; XB*3*8
 U IO
 D SAVEMSM^ZIBGSVEM
 G END
 ;
UUCPQ ;EP - auto queue to sendto and ftp, must have system id in RPMS SITE file ; IHS/SET/GTH XB*3*9 10/29/2002
 I $$JOBWAIT^%HOSTCMD("sendto "_XBQTO_" "_XBUF_"\"_XBFN) S XBFLG=-1,XBFLG(1)="Queue of File to uucp Failed"
 ; E  W:'$D(ZTQUEUED) !,"Export file ",XBUF,"/",XBFN," queued up to be sent to ",XBQTO,"...",! ; IHS/SET/GTH XB*3*9 10/29/2002
 ;E  W:'$D(ZTQUEUED) !,"Export file ",XBUF,"\",XBFN," queued up to be sent to ",XBQTO,"...",! ; IHS/SET/GTH XB*3*9 10/29/2002 ;LINE COMMENTED OUT AND REPLACED BY NEXT LINE - AEF/08/08/03
 E  I '$D(ZTQUEUED) U IO(0) W !!,"Export file ",XBUF,"\",XBFN," queued up to be sent to ",XBQTO,"...",! ;XB*3*10
 Q
 ;
ERRMESS ;
 S XBFLG(1)=XBERRMSG_" Not Available",XBFLG=-1
 ; U IO(0) ; XB*3*8
 ; W !,XBFLG(1) ; XB*3*8
 I '$D(ZTQUEUED) U IO(0) W !,XBFLG(1) ; XB*3*8
END ;
 ; I '$D(AUFLG),$P(^AUTTSITE(1,0),"^",14)]"" D UUCPQ ;IHS/MFD added line ; XB*3*8
 I '$D(XBFLG),XBQ="Y" D UUCPQ ; XB*3*8
 D ^%ZISC,HOME^%ZIS
 KILL XBERRMSG
 Q
