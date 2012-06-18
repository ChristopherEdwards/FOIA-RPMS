BMCRLD ; IHS/PHXAO/TMJ - delete vgen/pgen custom report ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;This routine will do a DIC lookup into the lister report 
 ;temporary file and delete the entry.
 ;
EN ;EP - called from an option 
 W !!,"This option enables the user to delete an RCIS",!,"General Retrieval report definition.",!!
 D GETRPT
 G:'BMCRPT XIT ;no report selected
 D DELETE
 D XIT
 Q
GETRPT ;get report entry - only allow lookup on own reports
 S BMCRPT=""
 S DIC="^BMCRTMP(" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 Q:Y=-1
 S BMCRPT=+Y
 Q
DELETE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^BMCRTMP(BMCRPT,0),U,3)_" report definition",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 W !,"Report Definition ",$P(^BMCRTMP(BMCRPT,0),U)," deleted.",!
 S DA=BMCRPT,DIK="^BMCRTMP(" D ^DIK
 Q
XIT ;
 K BMCRPT
 K DA,DIK,D0
 Q
