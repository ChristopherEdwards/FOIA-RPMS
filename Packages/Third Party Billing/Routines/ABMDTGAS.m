ABMDTGAS ; IHS/ASDST/DMJ - Remap Group Names for an Employer ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;
 ; this enables the mass changes of group names for all
 ; policies associated with one employer
 ; select Employer to remap
 ; select New Group name
 ; scan all policies for that employer and change the group name
 ; to the one selected
S ;
 W !!,"This utility allows for the mass assignment of a specified Group Plan to the",!,"policies of each employee for a selected Employer.",!
 K DIR S DIR(0)="Y",DIR("A")="Do you wish to run this utility program"
 D ^DIR Q:'$G(Y)
SEL W ! K DIC S DIC="^AUTNEMPL(",DIC(0)="AEQMZ" D ^DIC I Y'>0 W !,"NONE SELECTED EXITING OPTION",!,*7 H 3 G XIT ;--->
 S ABMEMP=+Y,ABMEMPNM=Y(0,0)
 W ! K DIC S DIC="^AUTNEGRP(",DIC("A")="Select GROUP PLAN: ",DIC(0)="AEQMZ" D ^DIC I Y'>0 W *7 G END ;--->
 S ABMGRP=+Y,ABMGRPNM=Y(0,0)
 W !!,"You have selected to assign all employees of: ",ABMEMPNM
 W !?29," the Group Plan: ",ABMGRPNM
 W ! K DIR S DIR(0)="Y",DIR("A")="Is this Correct (Y/N)" D ^DIR G XIT:$D(DIRUT)!$D(DIROUT),END:Y=0 ;--->
 ;
SCAN1 ;EP scan "AE" of policy holder file
 S ABMDA=0,DIE="^AUPN3PPH(",DR=".06////"_ABMGRP
 F ABMC1=0:1 S ABMDA=$O(^AUPN3PPH("AE",ABMEMP,ABMDA)) Q:'ABMDA  D  Q:$D(ABM("DIE-FAIL"))
 .I '$D(ZTQUEUED),(ABMC1#100) W "."
 .S DA=ABMDA D ^ABMDDIE
 ;
SCAN2 ;EP scan the patient file to pick up those policies that have   
 ;registration links (the employer pointer is not stored in the Policy file
 S ABMDFN=0,DIE="^AUPN3PPH(",DR=".06////"_ABMGRP,ABMC3=0
 I $D(^AUPNPAT("AF",ABMEMP)) F ABMC2=0:1 S ABMDFN=$O(^AUPNPAT("AF",ABMEMP,ABMDFN)) Q:'ABMDFN  D  Q:$D(ABM("DIE-FAIL"))
 .I '$D(ZTQUEUED),(ABMC2#100) W "."
 .I $D(^AUPN3PPH("C",ABMDFN)) S DA=$O(^(ABMDFN,0)) D ^ABMDDIE S ABMC3=ABMC3+1
 ;
 I '$D(ZTQUEUED) W !!,?10,"POLICIES CHANGED: ",ABMC1+ABMC3,!
END ;EP
 W !
 K DIR S DIR(0)="YO",DIR("A")="Do you wish to Select another Employer" D ^DIR I Y=1 G SEL
XIT K ABMEMP,ABMEMPNM,ABMGRP,ABMGRPNM,ABMC1,ABMC2,ABMC3,ABMDA,ABMDFN,DA
 Q
