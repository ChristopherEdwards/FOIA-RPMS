ABMDTCPT ; IHS/ASDST/DMJ - Table Maintenance of CPT CODES ; 
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ;
ENT K ABM
 ;K DIR S DIR(0)="SO^1:EDIT EXISTING CPT CODE;2:ADD NEW CPT CODE",DIR("A")="Select DESIRED ACTION",DIR("B")=1 D ^DIR K DIR G XIT:'Y!$D(DIRUT),ADD:Y=2  ;abm*2.6*3 NOHEAT
 ;
SEL W !! K DIC S DIC="^ICPT(",DIC("A")="Select CPT CODE to Edit: ",DIC(0)="QEAM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G SEL
 S ABM("DFN")=+Y,ABM("MODE")=0
 I '$D(ABM("PROT")) G EDIT
 ;S DIE="^ICPT(",DR="W !;5T;4;9999999.01;9999999.02" D ^ABMDDIE K DR  ;abm*2.6*3 NOHEAT
 S DIE="^ICPT(",DR="W !;9999999.02" D ^ABMDDIE K DR  ;abm*2.6*3 NOHEAT
 G SEL
 ;
ADD S (ABM("DFN"),ABM,ABM("LOCK"))=0,ABM("MODE")=1
 W ! K DIR S DIR(0)="FO^5:6",DIR("A")="Enter the CPT CODE" D ^DIR K DIR G XIT:$D(DIRUT) S ABM("DFN")=X
 I $D(^ICPT("B",X)) W *7,!!,"The CPT CODE '",X,"' already exists!" G PAZ
 I X?5.6AN
 E  W !!?10,*7,"ERROR: Improper Format, code must be 5 or 6 Alphanumeric Characters." G ADD
 W !,*7 K DIR S DIR(0)="Y",DIR("A")="Do you want to Add '"_ABM("DFN")_"' as a New CPT CODE" D ^DIR K DIR G ENT:$D(DUOUT)!$D(DTOUT),ENT:Y<1
 W !,"OK, adding..."
 S X=ABM("DFN")
 S DIC="^ICPT(",DIC(0)="LX" D ^DIC
 I +Y<1 W *7,!!,"ERROR: CPT CODE ENTRY NOT CREATED!",! G PAZ
 S ABM("DFN")=+Y
 ;
EDIT ;S DA=ABM("DFN"),DIE="^ICPT(",DR="W !;2R" D ^ABMDDIE G KILL:$D(Y)!$D(ABM("DIE-FAIL"))  ;abm*2.6*3 NOHEAT
 I ABM("MODE") D  G KILL:Y<1
 .S DA(1)=ABM("DFN"),DIC="^ICPT("_DA(1)_",""D"",",DIC(0)="LE"
 .K DD,DO,DINUM
 .I '$D(@(DIC_"0)")) S @(DIC_"0)")="^81.01A"
 .D FILE^DICN
 S DIE="^ICPT("  ;abm*2.6*3 NOHEAT
 S DA=ABM("DFN")
 S DR="W !;9999999.02" D ^ABMDDIE
 G XIT
 ;
PAZ W ! K DIR S DIR(0)="E" D ^DIR
XIT K ABM,DIC,DIE
 Q
KILL I ABM("MODE") W !!,*7,"<Data Incomplete: Entry Deleted>" S DIK=DIE D ^DIK G PAZ
 G XIT
 Q
