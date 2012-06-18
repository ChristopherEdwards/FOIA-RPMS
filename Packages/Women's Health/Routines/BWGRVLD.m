BWGRVLD ; IHS/CMI/LAB - delete vgen/pgen custom report ;15-Feb-2003 21:53;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;
 ;This routine will do a DIC lookup into the lister report
 ;temporary file and delete the entry.
 ;
EN ;EP - called from an option
 W !!,"This option enables the user to delete a WH Procedure or Patient",!,"General Retrieval report definition.",!!
 D GETRPT
 G:'BWGRRPT XIT ;no report selected
 D DELETE
 D XIT
 Q
GETRPT ;get report entry - only allow lookup on own reports
 S BWGRRPT=""
 S DIC="^BWGRTRPT(" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 Q:Y=-1
 S BWGRRPT=+Y
 Q
DELETE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^BWGRTRPT(BWGRRPT,0),U,3)_" report definition",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 W !,"Report Definition ",$P(^BWGRTRPT(BWGRRPT,0),U)," deleted.",!
 S DA=BWGRRPT,DIK="^BWGRTRPT(" D ^DIK
 Q
XIT ;
 K BWGRRPT
 K DA,DIK,D0
 Q
