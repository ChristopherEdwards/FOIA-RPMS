ABMDTGRP ; IHS/ASDST/DMJ - Add/Edit Group Insurance ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 K DIC,ABM
 W ! S DIC="^AUTNEGRP(",DIC(0)="QEAML" D ^DIC
 Q:+Y<1!$D(DTOUT)!$D(DUOUT)
 S ABM("EGRP")=+Y
 I '$P(Y,U,3) W ! S DIE="^AUTNEGRP(",DA=+Y,DR=".01Modify GROUP NAME (if Desired): " D ^ABMDDIE Q:$D(Y)!$D(ABM("DIE-FAIL"))
 W !!?5,"NOTE: Some Insurers assign different Group Numbers based upon the",!?11,"particular type of visit (dental, outpatient, etc.) that",!?11,"occurred."
 W ! K DIR S DIR("B")="N",DIR(0)="Y",DIR("A")="Do the Group Numbers vary depending on Visit Type (Y/N)"
 S DIR("B")=$S($D(^AUTNEGRP(ABM("EGRP"),11)):"Y",1:"N") D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)  W !
 I Y=0 S DIE="^AUTNEGRP(",DA=ABM("EGRP"),DR=".02R~[5a] Group Number.....: " D ^ABMDDIE K ^AUTNEGRP(ABM("EGRP"),11) Q
 S DA=ABM("EGRP"),DIE="^AUTNEGRP(",DR="11" D ^ABMDDIE
 ;
XIT K ABM,DIR,DR,DIE
 Q
