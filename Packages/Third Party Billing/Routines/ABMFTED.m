ABMFTED ; IHS/SD/SDR - Populate Effective Date for 3P Fee Table ;    
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 W !!,"This option will go through the Fee Schedules and prompt the user"
 W !,"for an effective date.  This effective date will be used during the install"
 W !,"of patch 3 to keep a history of fees for each fee schedule."
 ;
 W !!,"The following fee schedules are on your system:"
 W !,"Num",?4,"Title",?51,"Owner",?66,"Effective Date"
 ;
 S ABMT=0,ABMCNT=0
 F  S ABMT=$O(^ABMDFEE(ABMT)) Q:(+$G(ABMT)=0)  D
 .W !,$P($G(^ABMDFEE(ABMT,0)),U)
 .W ?4,$P($G(^ABMDFEE(ABMT,0)),U,2)
 .W:($P($G(^ABMDFEE(ABMT,0)),U,4)'="") ?51,$P($G(^AUTTLOC($P($G(^ABMDFEE(ABMT,0)),U,4),0)),U,2)
 .W ?66,$$SDT^ABMDUTL($P($G(^ABMDFEE(ABMT,0)),U,5))
 .S ABMCNT=+$G(ABMCNT)+1
 ;
 W !!,"If you continue you will be prompted for an effective date for each fee schedule"
 W !,"listed.  YOU CAN NOT EXIT OUT ONCE YOU START."
 ;
 K DIC,DIE,DIR,DA,DR,X,Y
 S DIR(0)="Y"
 D ^DIR K DIR
 I +Y=0 Q  ;don't continue
 ;
 S ABMT=0
 S DIE="^ABMDFEE("
 S DIE("NO^")=""
 F  S ABMT=$O(^ABMDFEE(ABMT)) Q:(+$G(ABMT)=0)  D
 .W !,$P($G(^ABMDFEE(ABMT,0)),U),?4,$P($G(^ABMDFEE(ABMT,0)),U,2)
 .S DR=".05//"
 .I $P($G(^ABMDFEE(ABMT,0)),U,4)="" S DR=DR_";.04//"
 .S DA=ABMT
 .D ^DIE
 Q
