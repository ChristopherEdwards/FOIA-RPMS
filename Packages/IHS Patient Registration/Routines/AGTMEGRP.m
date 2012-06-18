AGTMEGRP ; IHS/ASDS/EFG - Add/Edit Group Insurance ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 K DIC,AGEL
 S DIC="^AUTNEGRP(",DIC(0)="QEAML" D ^DIC
 Q:+Y<1!$D(DTOUT)!$D(DUOUT)
 S AGEL("EGRP")=+Y
 I '$P(Y,U,3) W ! S DIE="^AUTNEGRP(",DA=+Y,DR=".01Modify GROUP NAME (if Desired): " D ^DIE Q:$D(Y)
 W !!?5,"NOTE: Some Insurers assign different Group Numbers based upon the",!?11,"particular type of visit (dental, outpatient, etc.) that",!?11,"occurred."
 W ! K DIR S DIR("B")="N",DIR(0)="Y",DIR("A")="Do the Group Numbers vary depending on Visit Type (Y/N)"
 S DIR("B")=$S($D(^AUTNEGRP(AGEL("EGRP"),11)):"Y",1:"N") D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)  W !
 I Y=0 S DIE="^AUTNEGRP(",DA=AGEL("EGRP"),DR=".02R~[5a] Group Number.....: " D ^DIE K ^AUTNEGRP(AGEL("EGRP"),11) Q
 S DA=AGEL("EGRP"),DIE="^AUTNEGRP(",DR="11" D ^DIE
XIT K AGEL
 Q
