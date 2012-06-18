PSOMLLDT ;BIR/RTR-Copay date routine ;15-Mar-2010 13:01;SM
 ;;7.0;OUTPATIENT PHARMACY;**71,157,1009**;DEC 1997
 ;
 ; Modified - IHS/MSC/PLS - 03/15/10 - DT+2 - Force return a zero
DT() ;function for Copay date
 ;0 means Copay not in effect, 1 means Copay in effect
 Q 0  ; IHS/MSC/PLS - 03/15/10
 N PSOMILDT
 S PSOMILDT=3020101
 I '$G(DT) S DT=$$DT^XLFDT
 Q $S(DT<PSOMILDT:0,1:1)
 ;
 Q
 ;New Copay questions, require if a Renewal
 ;PSOFLAG=1 for New, PSOFLAG=0 for Renewal
MST ;Military Sexual Trauma Question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A")="Is this Rx for treatment of Military Sexual Trauma"
 S DIR("?")=" ",DIR("?",1)="Enter 'Yes' if this prescription is being used to treat a condition related",DIR("?",2)="to Military Sexual Trauma. This response will be used to determine whether or"
 S DIR("?",3)="not a copay should be applied to the prescription."
 I '$G(PSOFLAG) S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"MST"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"MST"))=1:"Y",1:"") I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) I $G(PSOANSQD("MST"))=0!($G(PSOANSQD("MST"))=1) S DIR("B")=$S($G(PSOANSQD("MST"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .I Y["^"!($D(DUOUT))!($D(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .S PSOANSQ("MST")=Y
 .I $G(PSONEWFF) S PSOANSQD("MST")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment of Military",!,"Sexual Trauma." D MESSM D PAUSE Q
 .S PSOANSQ(PSOX("IRXN"),"MST")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"MST")=Y
 Q
VEH ;Vietnam-Era Herbicide Question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A",1)="Is this Rx for treatment of Vietnam-Era Herbicide",DIR("A")="(Agent Orange) exposure"
 S DIR("?")=" ",DIR("?",1)="Enter 'Yes' if this prescription is being used to treat a condition due to",DIR("?",2)="Vietnam-Era Herbicide (Agent Orange) exposure. This response will be used to"
 S DIR("?",3)="determine whether or not a copay should be applied to the prescription."
 I '$G(PSOFLAG) S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"VEH"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"VEH"))=1:"Y",1:"") I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) I $G(PSOANSQD("VEH"))=0!($G(PSOANSQD("VEH"))=1) S DIR("B")=$S($G(PSOANSQD("VEH"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .I Y["^"!($D(DUOUT))!($D(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .S PSOANSQ("VEH")=Y
 .I $G(PSONEWFF) S PSOANSQD("VEH")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment of Vietnam-Era",!,"Herbicide (Agent Orange) exposure." D MESSV D PAUSE Q
 .S PSOANSQ(PSOX("IRXN"),"VEH")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"VEH")=Y
 Q
RAD ;Radiation question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A")="Is this Rx for treatment of ionizing radiation exposure"
 S DIR("?")=" ",DIR("?",1)="Enter 'Yes' if this prescription is being used to treat a condition due to",DIR("?",2)="ionizing radiation exposure during military service. This response will be used"
 S DIR("?",3)="to determine whether or not a copay should be applied to the prescription."
 I '$G(PSOFLAG) S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"RAD"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"RAD"))=1:"Y",1:"") I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) I $G(PSOANSQD("RAD"))=0!($G(PSOANSQD("RAD"))=1) S DIR("B")=$S($G(PSOANSQD("RAD"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .I Y["^"!($D(DUOUT))!($G(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .S PSOANSQ("RAD")=Y
 .I $G(PSONEWFF) S PSOANSQD("RAD")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment of ionizing",!,"radiation exposure." D MESSM D PAUSE Q
 .S PSOANSQ(PSOX("IRXN"),"RAD")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"RAD")=Y
 Q
PGW ;Persian Gulf War question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A",1)="Is this Rx for treatment of environmental contaminant exposure during the",DIR("A")="Persian Gulf War"
 S DIR("?")=" ",DIR("?",1)="Enter 'Yes' if this prescription is being used to treat a condition due to",DIR("?",2)="environmental contaminant exposure during the Persian Gulf War. This response"
 S DIR("?",3)="will be used to determine whether or not a copay should be applied to the",DIR("?",4)="prescription."
 I '$G(PSOFLAG) S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"PGW"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"PGW"))=1:"Y",1:"") I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) I $G(PSOANSQD("PGW"))=0!($G(PSOANSQD("PGW"))=1) S DIR("B")=$S($G(PSOANSQD("PGW"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .I Y["^"!($D(DUOUT))!($D(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .S PSOANSQ("PGW")=Y
 .I $G(PSONEWFF) S PSOANSQD("PGW")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment of",!,"environmental contaminant exposure during the Persian Gulf War." D MESS D PAUSE Q
 .S PSOANSQ(PSOX("IRXN"),"PGW")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"PGW")=Y
 Q
HNC ;Head or Neck Cancer question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A")="Is this Rx related to treatment of Head and/or Neck Cancer"
 S DIR("?")=" ",DIR("?",1)="Enter 'Yes' if this prescription is being used to treat Head and/or Neck Cancer",DIR("?",2)="due to nose or throat radium treatments while in the military. This response"
 S DIR("?",3)="will be used to determine whether or not a copay should be applied to the",DIR("?",4)="prescription."
 I '$G(PSOFLAG) S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"HNC"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"HNC"))=1:"Y",1:"") I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) I $G(PSOANSQD("HNC"))=0!($G(PSOANSQD("HNC"))=1) S DIR("B")=$S($G(PSOANSQD("HNC"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .I Y["^"!($D(DUOUT))!($D(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .S PSOANSQ("HNC")=Y
 .I $G(PSONEWFF) S PSOANSQD("HNC")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment related to",!,"Head and/or Neck Cancer." D MESSV D PAUSE Q
 .S PSOANSQ(PSOX("IRXN"),"HNC")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"HNC")=Y
 Q
CV ; Combat Veteran Question
 N PSOUFLAG S PSOUFLAG=0
 K DIR S DIR(0)="Y"
 S DIR("A")="Is this Rx potentially for treatment related to Combat"
 S DIR("?")=" "
 S DIR("?",1)="Enter 'Yes' if this prescription is being used to treat a condition due to"
 S DIR("?",2)="active duty in a theater of combat operations during a period of war after the"
 S DIR("?",3)="Gulf War. This response will be used to determine whether or not a copay should"
 S DIR("?",4)="be applied to the prescription."
 I '$G(PSOFLAG) D
 .  S (DIR("B"),PSOUFLAG)=$S($G(PSORX(+$G(PSORENW("OIRXN")),"CV"))=0:"N",$G(PSORX(+$G(PSORENW("OIRXN")),"CV"))=1:"Y",1:"")
 .  I DIR("B")="" K DIR("B") S PSOUFLAG=0
 I $G(PSOFLAG),$G(PSONEWFF) D
 .  I $G(PSOANSQD("CV"))=0!($G(PSOANSQD("CV"))=1) D
 .  .  S DIR("B")=$S($G(PSOANSQD("CV"))=1:"Y",1:"N")
 W ! D ^DIR K DIR
 I $G(PSOFLAG) W ! D  Q
 .  I Y["^"!($D(DUOUT))!($G(DTOUT)) S PSOCPZ("DFLG")=1 Q
 .  S PSOANSQ("CV")=Y
 .  I $G(PSONEWFF) S PSOANSQD("CV")=Y
 I Y["^"!($D(DUOUT))!($D(DTOUT)) D
 .  W !!,"This Renewal has been designated as"_$S($G(PSOUFLAG)="Y":"",1:" NOT")_" being used for treatment of military"
 .  W !,"combat service." D MESSM D PAUSE Q
 .  S PSOANSQ(PSOX("IRXN"),"CV")=$S($G(PSOUFLAG)="Y":1,1:0)
 S PSOANSQ(PSOX("IRXN"),"CV")=Y
 Q
PAUSE ;
 K DIR W ! S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 Q
MESS ;
 W !,"Please use the 'Reset Copay Status/Cancel Charges' option to make corrections.",!
 Q
MESSM ;
 W " Please use the 'Reset Copay Status/Cancel Charges' option",!,"to make corrections.",!
 Q
MESSV ;
 W " Please use the 'Reset Copay Status/Cancel",!,"Charges' option to make corrections.",!
