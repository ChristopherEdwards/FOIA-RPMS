APCDEGP ; IHS/CMI/LAB - group preventive services group form ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
START ;
 D INIT
 G:APCDQUIT EOJ
 S APCDLOC="" F  D GETLOC Q:APCDLOC=""  S APCDTYPE="" F  D GETTYPE Q:APCDTYPE=""  S APCDCAT="" F  D GETCAT Q:APCDCAT=""  S APCDDATE="" F  D GETDATE Q:APCDDATE=""  D GETREST
 D EOJ
 Q
GETREST ;
 S APCDCLIN="" D GETCLN Q:'$D(APCDEGCL)  S APCDEGPR="" D PROV Q:APCDQUIT  S APCDPOV="" D POV Q:APCDQUIT  S APCDEDUC="" D EDUC Q:APCDQUIT
 D DISPLAY I APCDQUIT W !!,"Okay, start over and re-enter the information.",! D EOP G START
 K APCDEGP("FORMS")
 S APCDPAT="" F  D GETPAT Q:APCDPAT=""
 ;print forms?
PRINT ;
 Q:'$D(APCDEGP("FORMS"))
 W !! S DIR(0)="Y",DIR("A")="Do you wish to PRINT a hard copy encounter form for each patient in the group",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S XBRP="PRINT^APCDEGPP",XBRC="COMP^APCDEGPP",XBRX="XIT^APCDEGPP",XBNS="APCD"
 D ^XBDBQUE
 ;loop through all patients, records and print forms
 W !!!!
 Q
INIT ; Write Header
 D ^XBFMK K DIADD,DLAYGO
 W:$D(IOF) @IOF
 F APCDEGJ=1:1:5 S APCDEGX=$P($T(TEXT+APCDEGJ),";;",2) W !?80-$L(APCDEGX)\2,APCDEGX
 K APCDEGX,APCDEGJ
 W !!
 S APCDQUIT=""
 D ^APCDEIN
 I APCDFLG S APCDQUIT=1 Q
 S APCDMODE="A"
 K ^TMP("APCDEGP",$J)
 D KILL^AUPNPAT
 Q
EOJ ;
 K ^TMP("APCDEGP",$J)
 D EN2^APCDEKL
 D ^APCDEKL
 D EN^XBVK("APCD")
 K AUPNPAT,AUPNDAYS,AUPNSEX,AUPNDOB,AUPNDOD
 K %,%W,%Y,X,Y,DIR,DIRUT,DIC,DIE,DA,DR,DTOUT,DUOUT,%DT,DIU,DIV,DIW,DIPGM,DQ,DI,DIG,DIH,X1,X2,ZTSAVE
 Q
GETLOC ; GET LOCATION OF ENCOUNTER
 D ^XBFMK
 S APCDLOC=""
 S DIC("A")="LOCATION OF GROUP VISIT: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:Y<0
 S APCDLOC=+Y,APCDEGLC=$E($P(^AUTTLOC(APCDLOC,0),U,10),5,6)
 Q
 ;
GETTYPE ; GET TYPE OF ENCOUNTER
 K DIR,X,Y,DA
 S APCDTYPE=""
 S DIR(0)="9000010,.03O",DIR("A")="TYPE..................." D ^DIR K DIR
 Q:$D(DIRUT)
 I X="" Q
 S APCDTYPE=Y
 Q
GETCAT ; GET SERVICE CATEGORY
 S APCDCAT=""
 K DIR,DA,X,Y
 S DIR(0)="9000010,.07O",DIR("A")="SERVICE CATEGORY......." D ^DIR K DIR
 Q:$D(DIRUT)
 Q:X=""
 S APCDCAT=Y
 Q
 ;
GETDATE ; GET DATE OF ENCOUNTER
 S APCDDATE=""
 W !,"VISIT/ADMIT DATE.......: " R X:$S($D(DTIME):DTIME,1:300) S:'$T X=""
 Q:X=""!(X="^")
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S APCDDATE=X
GETTIME ;
 S APCDTIME="12:00"
 W !,"TIME OF VISIT..........: ",$S(APCDTIME]"":APCDTIME_"// ",1:"") R X:$S($D(DTIME):DTIME,1:300) S:'$T X="^" S:X="" X=APCDTIME
 S APCDTIME=""
 I X="^" S APCDDATE="" G GETDATE
 I X="" W APCDBEEP,"  Time Required!" G GETTIME
 I X["?" W !,"Enter time of visit, or 'D' for default." G GETTIME
 I X="D" S X="12:00" W "  ",X
EDTIME S APCDTIME=X,X=APCDDATE_"@"_APCDTIME
 X ^TMP("APCD",$J,"APCDDATE")
 I '$D(X) W APCDBEEP G GETDATE
 I X="-1" W ! G GETDATE
 S APCDDATE=X
 Q
GETCLN ;
 D ^XBFMK
 K APCDEGCL
 S APCDCLIN="",DIC="^DIC(40.7,",DIC(0)="AEMQ",DIC("A")="CLINIC.................: " D ^DIC K DIC,DA
 I Y=-1,X="" S APCDCLIN="" D CLNCHK Q
 I Y=-1,X="^" S APCDCLIN="" Q
 Q:Y<0
 S APCDCLIN="`"_+Y,APCDEGCL=""
 Q
CLNCHK ;
 I APCDCLIN="",APCDCAT="A","I6T"[APCDTYPE,APCDEGLC>0,APCDEGLC<50 W !,"WARNING:  No Clinic Type entered for this visit and clinic is required!",!,$C(7) Q
 S APCDEGCL=""
 Q
PROV ;
 K ^TMP("APCDEGP",$J,"PROV")
 S APCDQUIT=0
 S APCDEGC=0,(APCDEGPC,APCDEGPS,APCDEGPR)="" F  D PROV1^APCDEGP0 Q:APCDEGPR=""
 I 'APCDEGPS W $C(7),$C(7),!!,"NO PRIMARY PROVIDER INDICATED!!!",!! S APCDEGPR="",APCDQUIT=1 Q
 Q
POV ;
 K ^TMP("APCDEGP",$J,"POV")
 S APCDQUIT=0
 S APCDEGC=0,APCDPOV="" F  D POV1^APCDEGP0 Q:$D(DIRUT)!(APCDPOV="")
 I APCDEGC=0 W !!,$C(7),$C(7),"NO PURPOSE OF VISIT ENTERED" S APCDQUIT=1 Q
 Q
EDUC ;
 S DIR(0)="Y",DIR("A")="Any Patient Education to add to each patient's visit",DIR("B")="N" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:Y=0
 K ^TMP("APCDEGP",$J,"EDUC")
 S APCDQUIT=0
 S APCDEGC=0,APCDEDUC="" F  D EDUC1^APCDEGP0 Q:$D(DIRUT)!(APCDEDUC="")
 I APCDEGC=0 W !!,$C(7),$C(7),"NO EDUCATION ENTERED" G EDUC
 Q
GETPAT ; GET PATIENT
 S APCDPAT=""
 D GETPAT^APCDEA
 Q:APCDPAT=""
 I AUPNDOB]"" S X2=AUPNDOB,X1=APCDDATE D ^%DTC S AUPNDAYS=X ; re-set days of age to visit date-dob
PROCESS ;process visit
 D ^APCDEGP1
 Q
 ;
DISPLAY ;display all info and do you want to continue
 W !!!,"The following information will be used for the visits being created for",!,"this group form.  Please review the information for accuracy.",!
 W !,"Visit Date:",?14,$$FMTE^XLFDT(APCDDATE),?40,"Type: ",$$EXTSET^XBFUNC(9000010,.03,APCDTYPE)
 W !,"Location:",?14,$E($P(^DIC(4,APCDLOC,0),U),1,15),?40,"Service Category: ",$$EXTSET^XBFUNC(9000010,.07,APCDCAT)
 W !,"Clinic:",?14,$S(APCDCLIN]"":$P(^DIC(40.7,$E(APCDCLIN,2,99),00),U),1:"")
 S (X,C)=0 F  S X=$O(^TMP("APCDEGP",$J,"PROV",X)) Q:X'=+X  S C=C+1 D
 .I C=1 W !!,"Providers:"
 .S Y=$P(^TMP("APCDEGP",$J,"PROV",X,"APCDTPRV"),U),Y=$E(Y,2,99),Z=$P(^TMP("APCDEGP",$J,"PROV",X,"APCDTPRV"),U,2)
 .W ?14,$P(^VA(200,Y,0),U),?46,$S(Z="P":"PRIMARY",1:"SECONDARY"),! Q
 .;W ?14,$P(^DIC(16,Y,0),U),?46,$S(Z="P":"PRIMARY",1:"SECONDARY"),! Q
 S (X,C)=0 F  S X=$O(^TMP("APCDEGP",$J,"POV",X)) Q:X'=+X  S C=C+1 D
 .I C=1 W !,"POV's:"
 .S Y=$P(^TMP("APCDEGP",$J,"POV",X,"APCDTPOV"),U),Y=$E(Y,2,99),Z=$P(^TMP("APCDEGP",$J,"POV",X,"APCDTPOV"),U,2),Z=$E(Z,2,99)
 .W ?10,$P($$ICDDX^ICDCODE(Y),U,2),?18,"Narrative: ",$P(^AUTNPOV(Z,0),U),!
 S (X,C)=0 F  S X=$O(^TMP("APCDEGP",$J,"EDUC",X)) Q:X'=+X  S C=C+1 D
 .I C=1 W !,"Education topics:"
 .S Y=$P(^TMP("APCDEGP",$J,"EDUC",X,"APCDTTOP"),U),Y=$E(Y,2,99),Z=$P(^TMP("APCDEGP",$J,"EDUC",X,"APCDTTOP"),U,2),Z=$E(Z,2,99)
 .W ?20,$P(^AUTTEDT(Y,0),U),?55,"Minutes: ",$P(^TMP("APCDEGP",$J,"EDUC",X,"APCDTTOP"),U,2),!
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCDQUIT=1 Q
 I 'Y S APCDQUIT=1 Q
FORMID ;
 ;generate form id in file
 K DIC,DO,DD,D0 S X="XXX",DIC(0)="L",DIC="^APCDGRP(",DIADD=1,DLAYGO=9001002.3,DIC("DR")=".02////"_DUZ_";.03////"_DT_";.04////"_APCDDATE D FILE^DICN I Y=-1 D  Q
 .D ^XBFMK K DIADD,DLAYGO,DLAYGO,DR,DD S APCDQUIT=1 W !!,"Failure to create FORM ID.  Notify programmer.",! Q
 S APCDFID=+Y
 K DIADD,DLAYGO D ^XBFMK
 S DA=APCDFID,Z="G"_APCDFID,DIE="^APCDGRP(",DR=".01///"_Z D ^DIE K DIE,DR,DA
 W !!,"The form ID for this group form is ",$P(^APCDGRP(APCDFID,0),U),".",!,"Please make a note of this.  It will be needed if and when you need to ",!,"re-print forms.",!!
 Q
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
TEXT ;
 ;;PCC Data Entry Module
 ;;
 ;;************************************
 ;;* GROUP PREVENTIVE FORM ENTER Mode *
 ;;************************************
 ;
 ;
REPRINT ;EP - called from option
 D RXIT
 ;IHS/CMI/LAB - patch 5 added this subroutine to re-print group forms
 W:$D(IOF) @IOF
 W !!,"This option should be used to re-print group encounter forms.",!!,"You must know the group ID form number or the date of the group visit."
 W !!,"Only group forms entered after PCC Data Entry Patch 5 was installed",!,"are available for re-printing.",!!
 W !!,"Please enter the group ID form or the date of the visit.",!
 D ^XBFMK
 S DIC="^APCDGRP(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"No form selected" H 2 D RXIT Q
 S APCDFID=+Y
 S X=0 F  S X=$O(^APCDGRP(APCDFID,11,X)) Q:X'=+X  S APCDEGP("FORMS",X)=""
 I '$D(APCDEGP("FORMS")) W !!,"There are no visits to print.",! H 2 D RXIT Q
 W !,"The following visit forms will be printed: "
 S X=0 F  S X=$O(APCDEGP("FORMS",X)) Q:X'=+X  D
 .W !?5,$$VAL^XBDIQ1(9000010,X,.01),?30,$$VAL^XBDIQ1(9000010,X,.05),?65,$$CLINIC^APCLV(X,"E")
 D PRINT
 D ^%ZISC
 D RXIT
 Q
RXIT ;
 D EN^XBVK("APCD")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
