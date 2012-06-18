ACDVIMP ;IHS/ADC/EDE/KML - UNIX OR DOS IMPORT;  [ 11/03/1999  12:09 PM ]
 ;;4.1;CHEMICAL DEPENDENCY MIS;**3**;MAY 11, 1998
 ;;
 ;***************************************************************
 ;Read files to reconstruct the ^ACDVTMP global onto
 ;the area/hq machines.
 ;This globals holds/transmits cdmis visit data and the associated
 ;data from the link files
 ;*************************************************************
EN ;EP
 ;//[ACD SUPER0]
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
 I $D(^ACDV1TMP) W !!,*7,*7,"But an incomplete import exists due to a corrupt location table.",!,"I will try again to complete the import..." D EN^ACDVIMP1,K Q
 ;
 ;Initialize ^ACDVTMP to reconstruct on area/hq machine
 I $D(^ACDVTMP) W !!,*7,*7,"It appears an import is presently running." D K Q
 K ^ACDVTMP ;         kill of scratch global  SAC EXEMPTION (2.3.2.3  KILLING of unsubscripted globals is prohibited)
 ;
 W @IOF,!!,*7,*7,"Please note that I will not allow you to import your own",!,"extract and will automatically delete the file for you...",!!
 W !!,"It is advisable to capture the upcomming terminal screens to a printer.",!,"Please open a log file or turn on 'PRINT SCREEN'."
 F  W !!,"Ok to Continue: " S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 ;
F ;File import from
 ;Gather all files into a list for display/selection
 K ACDF
 S Y=$$LIST^%ZISH(ACDIR,"ACDV*",.ACDF) D ERROR^ACDWUTL
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
 K ACDFILES
 S ACDIFC=0
 F ACDI=1:1 K ACDOWN S ACDFNA=$P(ACDLIST,",",ACDI) Q:ACDFNA=""  S ACDFNA=ACDF(ACDFNA) D L1
 I 'ACDIFC W !!,"No data to update",! Q
 W !!,"Now updating CDMIS files with imported data....." D EN^ACDVIMP1
 W !!,"Now purging files and setting audit trail",!
 K ACDOWN
 S ACDFNA=""
 F  S ACDFNA=$O(ACDFILES(ACDFNA)) Q:ACDFNA=""  D  D PASS2
 . F I=1:1:4 S ACDHEAD(I)=ACDFILES(ACDFNA,I)
 . Q
 W !!!?20,"Finished........."
 D K Q
 ;
 ;
L1 ;Open file to read from
 S Y=$$OPEN^%ZISH(ACDIR,ACDFNA,"R") I Y W !,"Error code: ",Y," detected." D K Q
 ;
IN ;Read in from the imported file to build ^ACDVTMP
 U IO(0) W !!,"Now importing data from file: ",ACDFNA
 F I=1:1:4 U IO R ACDHEAD(I):DTIME
 ;Start of Patch *3*  IHS/DSD/HJT ACD*4.1*3 10/20/1999
 ; The following code checks record 4 to see if created by NT machine
 ;    and makes the proper adjustment if so.
 S XACDLN=$L(ACDHEAD(4))
 I $A($E(ACDHEAD(4),XACDLN))=13 S ACDHEAD(4)=$E(ACDHEAD(4),1,XACDLN-1)
 ;End of Patch *3*
 ;
 I $P(ACDHEAD(4),U,20)'="IMPORT FILE" U IO(0) W !,"Not a Import file...I will skip it" D ^%ZISC Q
 U IO(0) W !,"FACILITY: ",ACDHEAD(2)
 S ACDNODE=ACDHEAD(2)_","_$P(ACDHEAD(4),U)_","_$P(ACDHEAD(4),U,2)
 I $D(^ACDVTMP4(ACDNODE)) U IO(0) W !!,"It appears that the data from this file has already been imported once.",! S ACDOWN=1 G PASS
 I $P(^DIC(4,DUZ(2),0),U)=$E(ACDHEAD(2),2,9999),$E(ACD6DIG)'=9 U IO(0) W !!,*7,*7,*7,*7,"** You are trying to import your own extract. NOT ALLOWED **." S ACDOWN=1 G PASS
 I $P(^DIC(4,DUZ(2),0),U)=$E(ACDHEAD(2),2,9999),$E(ACD6DIG)=9 W !!,"OK,Headquarters is importing an archive created at Headquarters.",!!
 S ACDIFC=ACDIFC+1
 ;Start of Patch *3* IHS/DSD/HJT ACD*4.1*3 10/20/1999
 S ^ACDVTMP4(ACDNODE)=""
 N ACDQUIT S ACDQUIT=0
 F I=1:1 U IO R ACD(1):DTIME,ACD(2):DTIME  D  Q:ACDQUIT
 .I ACD(1)="**" S ACDQUIT=1 Q
 .I ACD(1)["**"&($A($E(ACD(1),$L(ACD(1))))=13) S ACDQUIT=1 Q
 .;   If source is NT, a CR [$A(...)=13] is inserted at end of each line
 .;   The following code removes it
 .F IJ=1,2 S XACDLN=$L(ACD(IJ)) I $A($E(ACD(IJ),XACDLN))=13 S ACD(IJ)=$E(ACD(IJ),1,XACDLN-1)  ;HJT
 .;End of Patch *3* 
 .S @ACD(1)=ACD(2)
 .I '(I#50) U IO(0) W "."
 .Q
 S ACDFILES(ACDFNA)=""
 F I=1:1:4 S ACDFILES(ACDFNA,I)=ACDHEAD(I)
 D ^%ZISC
 Q
PASS ;Skip when user tries to import their own extract
 ;Skip when data to import is a duplicate
 D ^%ZISC
PASS2 ; FOR PURGING FILES AFTER DATA INSTALLED
 W !,"Deleting ",ACDFNA," from your system now..."
 S Y=$$DEL^%ZISH(ACDIR,ACDFNA) D ERROR^ACDWUTL
 I $D(ACDOWN) U IO(0) W !,"No Updating has occurred for this file."
 ;
XMD ;Audit trail
 D EN^ACDVXMD(ACDFNA,.ACDHEAD)
 Q
 ;
K ;kill variables
 K ACDFILES,ACDIFC
 K ACD,ACDF,ACDIOP,DIR,XMY,ACDLINE,ACDBWP,ACDCS,ACDDA,ACDDUZ,ACDFNA,ACDHEAD,ACDI,ACDIIF,ACDLIST,ACDN,ACDPG,ACDRNG,ACDRUG,ACDTDC,ACDUSER,ACDV,ACDNODE,XACDLN
 Q
