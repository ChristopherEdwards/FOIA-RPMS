AZGSAVED ;RPMS/TJF/MLQ;SAVE GLOBAL TO TAPE; DSM SPECIFIC 
 ;;1.4;AUGS;*0*;OCT 16, 1991
 G:$D(AUMED) NOSELT
ASK R !!,"Copy transaction file to ('^' To Exit Without Saving)",!!?10,"[T]ape, [C]artridge  C// ",AUMED:DTIME S AUMED=$E(AUMED_"C")
 I "^"[AUMED S AUFLG(1)="Job Terminated by Operator at Device Select",AUFLG=-1 G END
 G HELP:"?"[AUMED,ASK:"CcTt"'[AUMED
NOSELT S IOP=$I D ^%ZIS K IOP D CURRENT^%ZIS S X=0 X ^%ZOSF("RM")
 S IO=AUIO D TAPE:"Tt"[AUMED D CART:"Cc"[AUMED
 Q
HELP W !!,"This option saves the ' ",AUNAR," ",AUGL,"' transaction file to either a Cartridge",!,"or 9-Track Tape.  The default is to a 9-Track Tape."
 W !,"Enter either a ""C"" for Cartridge Tape or a ""T"" for 9-Track Tape."
 G ASK
CART S AUIO=47,MESSAGE="Cartridge" G PROCESS
TAPE S AUIO=48,MESSAGE="9-Track"
 ;PROCESS CARTRIDGE OR TAPE
PROCESS S IOP=AUIO D ^%ZIS K IOP S:'$D(AUPAR) AUPAR=IOPAR I IO="" S AUFLG(1)=MESSAGE_" Drive Not Available",AUFLG=-1 U IO(0) W !,AUFLG(1) G END
 U IO X ^%ZOSF("MAGTAPE") W @%MT("REW") U IO(0) W !!,"Mount The ",MESSAGE," Tape 'WRITE ENABLED' And "
RETRY R !,?10,"Press RETURN When Ready  - ""^"" to Exit ",X:DTIME I X="^"!('$T) S AUFLG(1)="Job Aborted by Operator During Tape Mount",AUFLG=-1 G CLOSE
 S $ZT="ERROR^AZGSAVED"
 U IO X ^%ZOSF("MTONLINE") I 'Y U IO(0) W !!,"WAITING FOR TAPE"
 F I=1:1:75 U IO X ^%ZOSF("MTONLINE") G S9:Y U IO(0) W "." H 5
 U IO(0) S AUFLG(1)="Job Aborted, Tape not Ready",AUFLG=-1 W !!,AUFLG(1)," After 6 Minutes" G END
S9 U IO X ^%ZOSF("MTWPROT") G WRITPROT:Y
 U IO(0) W !,"Please Standby - Copying Data to ",MESSAGE D ^AZGSAV1D Q:$D(AUFLG)  G EXIT
WRITPROT U IO(0) W *7,!!,"  The Tape Is WRITE PROTECTED. Please Remove The Tape,"
 W !,"  And Re-position The Write Protect/Enable Switch.",!,"  "
 G RETRY
EXIT ;
 X ^%ZOSF("MAGTAPE") U IO W @%MT("WTM") W @%MT("REW") U IO(0) W !!,"Rewinding tape. <WAIT>" F L=1:1:150 U IO X ^%ZOSF("MTBOT") G:Y GOODREW  U IO(0) W "." H 2
 S AUFLG=-1,AUFLG(1)="Tape not rewound" U IO(0) W !!,AUFLG(1),*7 G CLOSE
GOODREW U IO(0) W !!,"Remove the tape... Press RETURN when Ready:" R X:DTIME
CLOSE C IO U IO(0)
END Q
ERROR S ZA=$ZA C IO I $ZE?1"<MTERR>".E U IO(0) S AUFLG=-1,AUFLG(1)="Mag Tape Error "_ZA W !!,*7,AUFLG(1)
 D ^%ET S $ZT="ERR^ZU"
 Q
