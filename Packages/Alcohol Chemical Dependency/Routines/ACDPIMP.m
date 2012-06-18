ACDPIMP ;IHS/ADC/EDE/KML - UNIX or DOS IMPORT 10:08; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;***************************************************************
 ;Read files to reconstruct the ^ACDPTMP global onto
 ;the area/hq machines.
 ;This global hold/transmits cdmis program data from the file
 ;^ACDQAN
 ;*************************************************************
EN ;EP
 ;//[ACD SUPER8]
 ;
 ;Check for black box
 I '$L($T(OPEN^%ZISH)) W !,"But you need to first install patch 25 of Kernel 7" Q
 ;
DIR ;Ask user for directory
 S DIR("B")=$S($P($G(^AUTTSITE(1,0)),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")
 S DIR(0)="F^1:100",DIR("A")="Directory to import from "
 W !
 D ^DIR K DIR
 I $D(DIRUT) D K Q
 S ACDIR=X
 ;
 ;
 ;Stop user if facility
 I $E(ACD6DIG)'=9,$E(ACD6DIG,3,4)'="00" W !!,*7,*7,"Facilities have no need to import data." D K Q
 ;
 ;Check for unfinished import
 I $D(^ACDP1TMP) W !!,*7,*7,"But an incomplete import exists due to a corrupt location table.",!,"I will try again to complete the import..." D EN^ACDPIMP1,K Q
 ;
 ;Initialize ^ACDPTMP to reconstruct on area/hq machine
 I $D(^ACDPTMP) W !!,*7,*7,"It appears an import is presently running." D K Q
 K ^ACDPTMP ;       kill of scratch global  SAC EXEMPTION (2.3.2.3 KILL of unsubscripted globals is prohibited)
 ;
 W @IOF
 W !!,"It is advisable to capture the upcomming terminal screens to a printer.",!,"Please open a log file or turn on 'PRINT SCREEN'."
 F  W !!,"Ok to Continue: " S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 ;
F ;File import from
 ;Gather all files into a list for display/selection
 K ACDF
 S Y=$$LIST^%ZISH(ACDIR,"ACDP*",.ACDF) D ERROR^ACDWUTL
 I '$O(ACDF(0)) W !!,*7,*7,"No CDMIS import files found in ",ACDIR
 I  W !,"Job terminated....." D K Q
 ;
 ;
 ;Display files available for the user to import
 S ACDN=0 F I=0:0 S I=$O(ACDF(I)) Q:'I  S ACDN=ACDN+1 W !,I," ",ACDF(I)
 S DIR(0)="L^1:"_ACDN,DIR("A")="Select the FILE to IMPORT"
 W !
 D ^DIR
 I $D(DIRUT) D K Q
 S ACDLIST=Y
 ;
 ;Process imported files one at a time
 S ACDIFC=0
 F ACDI=1:1 K ACDOWN S ACDFNA=$P(ACDLIST,",",ACDI) Q:ACDFNA=""  S ACDFNA=ACDF(ACDFNA) D L1
 I 'ACDIFC W !!,"No data for update",! Q
 W !!!!,"Now updating CDMIS files with imported data....." D EN^ACDPIMP1
 W !!!!?20,"Finished........."
 D K Q
 ;
 ;
L1 ;Open file to read from
 S Y=$$OPEN^%ZISH(ACDIR,ACDFNA,"R") I Y W !,"Error code: ",Y," detected." D K Q
 ;
IN ;Read in from the imported file to build ^ACDPTMP
 U IO(0) W !!!,"Now importing data from file: ",ACDFNA
 F I=1:1:4 U IO R ACDHEAD(I):DTIME
 I $P(ACDHEAD(4),U,20)'="IMPORT FILE" U IO(0) W !,"Not an Import file...I will skip it" D ^%ZISC Q
 U IO(0) W !,"FACILITY: ",ACDHEAD(2)
 S ACDNODE=ACDHEAD(2)_","_$P(ACDHEAD(4),U)_","_$P(ACDHEAD(4),U,2)
 S ACDIFC=ACDIFC+1
 F  U IO R ACD(1):DTIME,ACD(2):DTIME Q:ACD(1)="**"  D
 .S @ACD(1)=ACD(2)
 .U IO(0) W "."
 .Q
PASS ;Skip when user tries to import their own extract
 ;Skip when data to import is a duplicate
 D ^%ZISC
 W !,"Deleting ",ACDFNA," from your system now..."
 S Y=$$DEL^%ZISH(ACDIR,ACDFNA) D ERROR^ACDWUTL
 I $D(ACDOWN) U IO(0) W !,"No Updating has occurred for this file."
 ;
XMD ;Audit trail
 D EN^ACDPXMD(ACDFNA,.ACDHEAD)
 Q
 ;
K ;kill variables
 K ACDIFC
 K ACD,ACDF,ACDIOP,DIR,XMY,ACDLINE,ACDBWP,ACDCS,ACDDA,ACDDUZ,ACDFNA,ACDHEAD,ACDI,ACDIIF,ACDLIST,ACDN,ACDPG,ACDRNG,ACDRUG,ACDTDC,ACDUSER,ACDV,ACDNODE
 K ACDA,%X,%Y,ACDIR,DIK,DIC,ACDMSG,XMZ,XMDUZ
