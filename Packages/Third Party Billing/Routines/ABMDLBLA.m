ABMDLBLA ; IHS/ASDST/DMJ - PRINT LABEL ALIGNMENT TEST PATTERN ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
TST I '$D(IO("S")) U IO(0)
 E  D SLV
 K DIR,%P S DIR(0)="Y",DIR("A",1)="         (NOTE: Mailing Labels should be loaded in the printer.)",DIR("A",2)="",DIR("A")="PRINT TEST ALIGNMENT PATTERN",DIR("B")="N" D ^DIR K DIR
 I $D(DIRUT) S Y=0
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y=0)
 ;
LBL I '$D(IO("S")) U IO(0)
 E  X ABM("CLOSE")
 W !!?10,"(Printing Alignment Test)",!
 I '$D(IO("S")) U IO
 E  X ABM("OPEN")
MARG I $D(^ABMDPARM(DUZ(2),1,0)) S ABM("LM")=$P(^(0),U,11),ABM("TM")=$P(^(0),U,12)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM=1:1:ABM("TM") W !
 F ABM=1:1:5 D
 .F ABM("L")=1:1:3 W !?ABM("LM"),"******************************"
 .F ABM("L")=3:1:ABM("LINES") W !
 I '$D(IO("S")) U IO(0)
 E  X ABM("CLOSE")
 W ! S DIR(0)="Y",DIR("A")="IS THE ALIGNMENT CORRECT",DIR("B")="Y" D ^DIR K DIR
 I $D(DIRUT) S Y=1
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y=1)
ADJ W ! S DIR("?")="Enter the desired left tab margin",DIR("A")="LEFT MARGIN",DIR(0)="N^0:20:0",DIR("B")=$P(^ABMDPARM(DUZ(2),1,0),U,11) D ^DIR K DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".11////"_Y D ^ABMDDIE
 W ! S DIR("?")="Enter the number of lines to skip prior to printing",DIR("A")="TOP MARGIN",DIR(0)="N^0:20:0",DIR("B")=$P(^ABMDPARM(DUZ(2),1,0),U,12) D ^DIR K DIR
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".12////"_Y D ^ABMDDIE
 G LBL
 ;
XIT Q
 ;
SLV S ABM("OPEN")=$P(^%ZIS(2,IO("S"),10),"^"),ABM("CLOSE")=$P(^%ZIS(2,IO("S"),11),"^") X ABM("CLOSE")
 Q
