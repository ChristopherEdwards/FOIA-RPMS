ABMDTFEF ; IHS/ASDST/DMJ - ADJUST FEE SCHED BY FACTOR ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
FEE ;G XIT:$P(^AUTTLOC(ABM("SITE"),0),U,10)'=30,XIT:$D(^ABMDPARM(DUZ(2),1,0))
 W !!?5,"This utility will adjust the IHS Standard Fee Schedule by the factor",!?5,"specified (if entered) in the following prompt."
 S ABM("OLD")=$S($P(^ABMDFEE(1,0),U,3):$P(^(0),U,3),1:1)
 W !!?10,"The Current Adjustment Factor = ",ABM("OLD"),!
 K DIR S DIR(0)="NO^.25:10:2",DIR("A")="Enter the Desired ADJUSTMENT FACTOR" D ^DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 S ABM("FAC")=+Y
 S ABM("FAC")=ABM("FAC")/ABM("OLD") G XIT:ABM("FAC")=1
 ;
ENT ;EP - for updating the fee schedule
 W !!,"Updating FEE SCHEDULE."
 S DA(1)=1 F ABM("S")=11,15,17,19,21,23,31 D  Q:$D(ABM("DIE-FAIL"))
 .S DA=0 F ABM("I")=1:1 S DA=$O(^ABMDFEE(1,ABM("S"),DA)) Q:'DA  D  Q:$D(ABM("DIE-FAIL"))
 ..S DIE="^ABMDFEE(1,"_ABM("S")_",",DR=".02////"_$FN($P(^ABMDFEE(1,ABM("S"),DA,0),U,2)*ABM("FAC"),"T",2) D ^ABMDDIE W:'(ABM("I")#20) "."
 S $P(^ABMDFEE(1,0),U,3)=ABM("FAC")
 ;
XIT K ABM
 Q
