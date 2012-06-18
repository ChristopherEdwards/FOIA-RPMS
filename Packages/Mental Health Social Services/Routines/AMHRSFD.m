AMHRSFD ; IHS/CMI/LAB - reset flag field ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
RESET ;EP - called from option
 W !!,"This option will reset all patient flag fields to null.  This should be done",!,"each time you want to flag patients for a different reason.",!
AO ;all or one
 S AMHX="" S DIR(0)="S^A:ALL FLAGS;O:ONE PARTICULAR FLAG",DIR("A")="Reset which flags",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 S AMHAO=Y
 I AMHAO="A" G SURE
WHICH ;
 S AMHY="",DIR(0)="9002011.55,.09",DIR("A")="Which flag should be removed" K DA D ^DIR K DIR
 G:$D(DIRUT) AO
 S AMHY=Y
SURE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 G:'Y XIT
 W !,"Hold on... resetting data.."
 S AMHX=0 F  S AMHX=$O(^AMHPATR(AMHX)) Q:AMHX'=+AMHX  D
 .I AMHAO="O",AMHY'=$P(^AMHPATR(AMHX,0),U,9) Q
 .S DR=".09///@;.11///@",DIE="^AMHPATR(",DA=AMHX D ^DIE K DA,DR,DIE W AMHX,":"
XIT ;
 W !,"All done.",!
 K AMHX,DA,DIE,DIU,DIV,DIY,AMHAO,AMHY
 Q
