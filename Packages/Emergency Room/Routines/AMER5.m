AMER5 ; IHS/ANMC/GIS - PRINT PATIENT ED MATERIALS ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
EN1 ; EP
 S DIR(0)="SO^A:ADULT;P:PEDIATRIC",DIR("A")="Print instructions for which age group" D ^DIR K DIR
 I '$D(DIRUT),'$D(DTOUT),'$D(DUOUT),$D(Y),$E(Y)'=U S AMERAGE=Y
 ;IHS/OIT/SCR 2/9/09 - AVOID UNDEFINED ERROR IF USER "^" PAST THIS PROMPT
 Q:$G(AMERAGE)=""
 K AMEROUT
TOPIC S DIC("A")="Enter "_$S($O(^TMP("AMER",$J,2,20,0)):"another ",1:"")_"patient education topic: "
 S DIC="^AMER(4,",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,3)="""_AMERAGE_""",$P(^(0),U)'[""FOLLOW"""
 D ^DIC K DIC S AMERAGE=+Y
ZIS ;
 ; CHOOSE THE NUMBER OF COPIES AND DEVICE
 S DIR(0)="N^1:10:0",DIR("A")="Enter the number of copies you would like to print"
 S DIR("B")=1
 D ^DIR K DIR S AMERNUM=Y
 S %ZIS="Q",%ZIS("A")="Print patient instructions on which device: "
 W *7,!!,"If you choose to send the output to your slave printer, print 1 copy at a time.",!
 D ^%ZIS Q:POP
 ; IF USER CHOOSES TO QUEUE THE OUTPUT
 I $D(IO("Q")) D
 .S ZTRTN="PRINT^AMER5"
 .S ZTIO=ION
 .S ZTDESC="Print patient instructions for ER system"
 .S ZTSAVE("*")=""
 .D ^%ZTLOAD I 1
 I  W !!,$S($D(ZTSK):"Request queued!",1:"Unable to queue job.  Request cancelled!") D ^%ZISC D EXIT Q
 D PRINT
 D EXIT
 K DIRUT,DTOUT,DUOUT,AMEREN1
 D ^%ZISC
 Q
PRINT ; EP
 U IO
 F AMERI=1:1:AMERNUM D
 .S NODE=0
 .S RECORD=0
 .F  S NODE=$O(^AMER(4,AMERAGE,NODE)) Q:'NODE!$D(AMEROUT)  D
 ..F  S RECORD=$O(^AMER(4,AMERAGE,NODE,RECORD)) Q:'RECORD!$D(AMEROUT)  D
 ...W !,$P(^AMER(4,AMERAGE,NODE,RECORD,0),U)
 ...I $E(IOST,1,2)="C-",IOSL-4<$Y D PAUSE W @IOF
 .I $E(IOST,1,2)'="C-" W @IOF
 .I $E(IOST,1,2)="C-" D PAUSE W @IOF
 Q
PAUSE ; EP
 K DIR,AMEROUT
 W !
 S DIR(0)="EOA"
 S DIR("A")="Press RETURN to continue or '^' to exit. "
 K DTOUT,DUOUT,AMEROUT
 D ^DIR
 S:$D(DIRUT)!$D(DIROUT)!$D(DUOUT) AMEROUT=""
 S:X="^^"!$D(DTOUT) AMEROUT=""
 S:$G(X)["^" AMEROUT=""
 K DIR,DIRUT,DIROUT,DUOUT,DTOUT
 Q
EXIT ; EP
 K X,AMER,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,AMERI,AMERNUM,NODE,RECORD
 K AMERAGE,AMEROPT,DIJ,DISYS,DIWF,DIWTC,DIWX,DP,P,W,DIWI
 Q
