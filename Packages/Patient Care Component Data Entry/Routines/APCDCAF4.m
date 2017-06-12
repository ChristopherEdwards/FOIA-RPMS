APCDCAF4 ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;; ;
 ;
DISP ;EP
 D FULL^VALM1
 D EN^XBNEW("DISP1^APCDCAF4","VALM*;APCDCAFP;APCDCAFO;APCDDFN")
 ;
 ;
DISPX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK^APCDCAF
 Q
DISP1 ;
 I $G(APCDCAFO) S APCDPAT=APCDDFN D  Q
 .D GETVISIT^APCDDISP
 .I '$G(APCDVSIT) W !!,"No visit selected." D PAUSE^APCDALV1 Q
 .D DSPLY^APCDDISP
 .D PAUSE^APCDALV1 Q
 D ^APCDDISP
 D PAUSE^APCDALV1
 Q
DISPO ;EP
 NEW APCDCAFO
 S APCDCAFO=1
 D DISP
 Q
RN ;EP
 D FULL^VALM1
 W !!,"You will be prompted to enter a Patient Name and visit date and then"
 W !,"will be given the opportunity to edit the chart audit note or completely"
 W !,"delete the note.",!
 D EN^XBNEW("RN1^APCDCAF4","VALM*;APCDCAFP;APCDCAFO;APCDDFN")
 ;
 ;
RNX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK^APCDCAF
 Q
RN1 ;
 I $G(APCDCAFO) S APCDPAT=APCDDFN D  Q
 .D GETVISIT^APCDDISP
 .I '$G(APCDVSIT) W !!,"No visit selected." D PAUSE^APCDALV1 Q
 .D DSPLY^APCDDISP
 .D PAUSE^APCDALV1 Q
 D GETPAT^APCDDISP
 I APCDPAT="" W !!,"No PATIENT selected!" Q
 D GETVISIT^APCDDISP
 I APCDVSIT="" W !!,"No VISIT selected!" Q
 Q
RNU ;EP 
 ;edit note or remove note
 I '$D(^AUPNCANT("B",APCDVSIT)) Q
 W !!,"Chart Audit Notes for this visit: ",!
 I '$D(^AUPNCANT("B",APCDVSIT)) W !!?4,"There are no Chart Audit Notes on file for this visit.",! D PAUSE^APCDALV1 Q
 S X=0 F  S X=$O(^AUPNCANT(APCDVSIT,11,X)) Q:X'=+X  W !,^AUPNCANT(APCDVSIT,11,X,0)
 W !
 D PAUSE^APCDALV1
 S DIR(0)="S^D:Delete the Chart Audit Notes from this visit;E:Edit the Chart Audit Notes;Q:No Audit Note Change",DIR("A")="Choose Action",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE^APCDALV1 Q
 I Y="E" S DIE="^AUPNCANT(",DR=1100,DA=APCDVSIT D ^DIE K DIE,DA,DR D PAUSE^APCDALV1 Q
 I Y="D" K ^AUPNCANT(APCDVSIT,11) W !!,"Notes removed." D PAUSE^APCDALV1 Q  ;kill off word processing field
 Q
RNO ;EP
 NEW APCDCAFO
 S APCDCAFO=1
 D RN
 Q
