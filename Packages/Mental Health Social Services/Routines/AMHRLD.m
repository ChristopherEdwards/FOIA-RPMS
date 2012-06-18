AMHRLD ; IHS/CMI/LAB - delete vgen/pgen custom report ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;This routine will do a DIC lookup into the lister report 
 ;temporary file and delete the entry.
 ;
EN ;EP - called from an option 
 W !!,"This option enables the user to delete a PCC Visit or Patient",!,"General Retrieval report definition.",!!
 D GETRPT
 G:'AMHRPT XIT ;no report selected
 D DELETE
 D XIT
 Q
GETRPT ;get report entry - only allow lookup on own reports
 S AMHRPT=""
 S DIC="^AMHTRPT(" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 Q:Y=-1
 S AMHRPT=+Y
 Q
DELETE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^AMHTRPT(AMHRPT,0),U,3)_" report definition",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 W !,"Report Definition ",$P(^AMHTRPT(AMHRPT,0),U)," deleted.",!
 S DA=AMHRPT,DIK="^AMHTRPT(" D ^DIK
 Q
XIT ;
 K AMHRPT
 K DA,DIK,D0
 Q
