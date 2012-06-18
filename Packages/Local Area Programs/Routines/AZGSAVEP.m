AZGSAVEP ;IHS/CAO/DAY;SAVE GLOBAL TO DOS MEDIA; [ 11/10/91  4:29 PM ]
 ;;1.4;AUGS;*0*;OCT 16, 1991
 S AUUF="C:\EXPORT"
 G:$D(AUMED) NOSELT
ASK R !!,"Copy transaction file to ('^' TO EXIT WITHOUT SAVING)",!!?10,"[D]iskette, or [F]ile   F// ",AUMED:DTIME S AUMED=$E(AUMED_"F")
 I "^"[AUMED S AUFLG(1)="Job Terminated by Operator at Device Select",AUFLG=-1 G END
 G HELP:"?"[AUMED,ASK:"DdFf"'[AUMED
NOSELT S IOP=$I D ^%ZIS K IOP D CURRENT^%ZIS S X=0 X ^%ZOSF("RM")
 S IO=AUIO,%DEV=IO D DISK:"Dd"[AUMED D DOS:"Ff"[AUMED
 Q
HELP W !!,"This option saves the ' ",AUNAR," ",AUGL,"' transaction file to either a floppy",!,"diskette, or a Dos file on the Hard Disk. The default is to a Dos file",!,"in the ",AUUF," directory."
 W !,"Enter either a ""D"" for floppy disk, or an ""F"" for Dos file."
 G ASK
DISK ;TRANSFER TX GLOBAL TO FLOPPY DISK
 S X="^" U IO(0) W !!,"Insert a FORMATTED Floppy Diskette, 'WRITE ENABLED' ",*7,!,"Press RETURN When Ready  or ""^"" to Exit WITHOUT SAVING " R X:DTIME I X["^" S AUFLG(1)="Job Aborted by Operator During Floppy Mount",AUFLG=-1 G END
 S AUUF="A:"
DOS ;TRANSFER TX GLOBAL TO DOS FILE.
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S JULDATE=X+1
 S PRE=$E(AUGL,2,5),ASUFAC=$P(^AUTTLOC(DUZ(2),0),"^",10),X=""
 I '$D(ZTQUEUED) U IO(0) W !!,"DOS File Being Created' ",*7
 O IO:(AUUF_"\"_PRE_$E(ASUFAC,3,6)_"."_JULDATE:"W"):0 E  S ERRMSG="DOS File" G ERRMESS
 U IO(0) W !,"Please Standby - Copying Data to DOS File "_PRE_$E(ASUFAC,3,6)_"."_JULDATE,! D ^AZGSAV1M
 G CLOSE
ERRMESS U IO(0) W !,ERRMSG," NOT AVAILABLE" S AUFLG(1)=ERRMSG_" Not Available",AUFLG=-1 G END
CLOSE C:IO'=IO(0) IO
END K PRE,ASUFAC,OUTDATA,INDATA,DEVICE,MESSAGE,IO,ERRMSG,X,Y
 Q
