BNIGVLD ; IHS/CMI/LAB - delete bni custom report ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
 ;This routine will do a DIC lookup into the lister report 
 ;temporary file and delete the entry.
 ;
EN ;EP - called from an option 
 W !!,"This option enables the user to delete a CPHAD General Retrieval report definition.",!!
 D GETRPT
 G:'BNIGRPT XIT ;no report selected
 D DELETE
 D XIT
 Q
GETRPT ;get report entry - only allow lookup on own reports
 S BNIGRPT=""
 S DIC="^BNIRTMP(" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 Q:Y=-1
 S BNIGRPT=+Y
 Q
DELETE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^BNIRTMP(BNIGRPT,0),U,3)_" report definition",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 W !,"Report Definition ",$P(^BNIRTMP(BNIGRPT,0),U)," deleted.",!
 S DA=BNIGRPT,DIK="^BNIRTMP(" D ^DIK
 Q
XIT ;
 K BNIGRPT
 K DA,DIK,D0
 Q
