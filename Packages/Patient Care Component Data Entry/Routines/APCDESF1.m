APCDESF1 ; IHS/CMI/LAB - HS IN DATA ENTRY ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
EP ;EP - called from input template
 I $G(AUPNPAT)="" W !!,$C(7),$C(7),"Sorry I don't know the patient.",! Q
PROV ;
 D ^XBFMK
 S APCDSFDP=""
 W !! S DIC("A")="Enter the Provider who completed the Form: ",DIC="^VA(200,",DIC(0)="AEMQ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Provider Selected." D EXIT Q
 S APCDSFPR=+Y
GETDATE ;EP - GET DATE OF ENCOUNTER
 W !!
 S APCDSFDT="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter the DATE of the SUICIDE ACT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT G PROV
 S APCDSFDT=Y
 S APCDSFQT=""
 S APCDSFI=$$HAVEONE(AUPNPAT,APCDSFDT)
 I APCDSFI D  G:'APCDSFQT EDIT I APCDSFQT D EXIT Q
 .W !!,"There is already a suicide form on file for ",$P(^DPT(AUPNPAT,0),U)," on ",!,$$FMTE^XLFDT(APCDSFDT),"."
 .W !,"If this is an addition of a new form, Please notify ",$P(^VA(200,APCDSFPR,0),U)
 .W !,"that a form has already been entered by ",$$VAL^XBDIQ1(9002011.65,APCDSFI,.03),".",!!
 .K DIR S DIR(0)="Y",DIR("A")="Do you want to continue and EDIT this form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCDSFQT=1 Q
 .I 'Y S APCDSFQT=1 Q
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHPSUIC(",DLAYGO=9002011.65,DIADD=1,X=$$UPI(AUPNPAT,APCDSFDT),DIC("DR")=".06////"_APCDSFDT_";.04////"_AUPNPAT_";.03////"_APCDSFPR_";.18////"_DT_";.19////"_DUZ_";.21////"_DT_";.22////"_DUZ
 S DIC("DR")=DIC("DR")_";9901///1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Error creating Suicide form!! Deleting form.",! D EXIT Q
 S APCDSFI=+Y
EDIT ;
 W !!,"Please note:  If while entering the data from the suicide form you make"
 W !,"a mistake, you can edit the field by '^' jumping to that field."
 W !,"For example:  to go back to edit EMPLOYMENT STATUS after you have passed"
 W !,"              that field, type ^EMPLOY and you will be taken back to that"
 W !,"              field to edit it.",!
 S DA=APCDSFI,DIE="^AMHPSUIC(",DR="[APCD SF EDIT]" D ^DIE
 ;display form and ask if okay to save otherwise edit again
 D DISPLAY(APCDSFI)
 ;OKAY?
 K DIR S DIR(0)="S^Y:Yes, save it;N:No, I wish to edit the data",DIR("A")="Are you finished entering this suicide form",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y'="Y" G EDIT
 D EXIT
 Q
EXIT ;
 D EN^XBVK("APCD")
 D ^XBFMK
 Q
 ;
UPI(P,D) ;
 I '$G(P) Q ""
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 Q $P(^AUTTSITE(1,1),U,3)_$E(D,4,5)_$E(D,6,7)_(1700+$E(D,1,3))_$E("0000000000",1,10-$L(P))_P
 ;
HAVEONE(P,D) ;is there a suicide form on file for this patient, this date, pass back ien
 NEW Y
 S Y=$$UPI(P,D)
 I $D(^AMHPSUIC("B",Y)) Q $O(^AMHPSUIC("B",Y,0))
 Q ""
 ;
DISPLAY(APCDSF) ;
 W !!,"I will now display the form back to you so you can check"
 W !,"the accuracy of the entry of the data.",!
 K DIR S DIR(0)="E",DIR("A")="Press Enter to Continue" KILL DA D ^DIR KILL DIR
 S XBRP="VIEWR^XBLM(""PRINT^APCDESF1"")"
 S XBRC="",XBRX="EXIT1^APCDESF1",XBIOP=0 D ^XBDBQUE
 Q
EXIT1 ;
 D ^XBFMK
 Q
EP2(APCDSF) ;
 S DFN=$P(^AMHPSUIC(APCDSF,0),U,4)
 K ^TMP("APCDS",$J,"DCS")
 S ^TMP("APCDS",$J,"DCS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 S X="Suicide Reporting Form                  Date Printed:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Case #: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.01) D S(X)
 S X="Local Case #: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.02) D S(X)
 S X="COMMUNITY WHERE ACT OCCURRED: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.07) D S(X)
 S X="DATE OF ACT: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.06) D S(X)
 S X="PROVIDER FILLING OUT FORM: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.03) D S(X)
 S X="EMPLOYMENT STATUS: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.05) D S(X)
 S X="RELATIONSHIP STATUS: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.08) D S(X)
 S X="EDUCATION: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.11) D S(X)
 I $P(^AMHPSUIC(APCDSF,0),U,12)]"" S X=" IF LESS THAN 12 YEARS, HIGHEST GRADE: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.12) D S(X)
 S X="SELF DESTRUCTIVE ACT: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.13) D S(X)
 S X="LOCATION OF ACT: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.15) D S(X)
 I $P($G(^AMHPSUIC(APCDSF,14)),U)]"" S X="  LOCATION OF ACT, IF OTHER: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,1401) D S(X)
 S X="PREVIOUS ATTEMPTS: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.14) D S(X)
MET ;
 K APCDOD,APCDO S Y="",Z=0 F  S Z=$O(^AMHPSUIC(APCDSF,11,Z)) Q:Z'=+Z  S Y=Y_$$EXTSET^XBFUNC(9002011.6511,.01,$P(^AMHPSUIC(APCDSF,11,Z,0),U))_"  " D
 .I $P(^AMHPSUIC(APCDSF,11,Z,0),U,2)]"" S APCDO(Z)=$P(^AMHPSUIC(APCDSF,11,Z,0),U,2)
 .S A=0 F  S A=$O(^AMHPSUIC(APCDSF,11,Z,11,A)) Q:A'=+A  D
 ..S APCDOD(Z,A)=$P(^AMHTSDRG($P(^AMHPSUIC(APCDSF,11,Z,11,A,0),U),0),U)_"   "_$P(^AMHPSUIC(APCDSF,11,Z,11,A,0),U,2)
 ..Q
 S X="METHOD: ",$E(X,40)=Y D S(X)
 I $D(APCDO) S X="  OTHER METHOD: " D
 .S A=0 F  S A=$O(APCDO(A)) Q:A'=+A  S X=X_APCDO(A)_"  "
 .D S(X)
 I $D(APCDOD) D
 .S X="    DRUGS W/OVERDOSE: "
 .S Y=0 F  S Y=$O(APCDOD(Y)) Q:Y'=+Y  D
 ..S A=0 F  S A=$O(APCDOD(Y,A)) Q:A'=+A  S X=X_APCDOD(Y,A)_"  "
 .D S(X)
DRUG ;
 S X="SUBSTANCE USE INVOLVED: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.26) D S(X)
 I $P(^AMHPSUIC(APCDSF,0),U,26)=2 D
 .S X="    ALCOHOL OR DRUGS INVOLVED: "
 .S Y=0 F  S Y=$O(^AMHPSUIC(APCDSF,15,Y)) Q:Y'=+Y  D
 ..S A=$P(^AMHPSUIC(APCDSF,15,Y,0),U) I A S $E(X,40)=$P($G(^AMHTSSU(A,0)),U) D S(X)
 ..S X=$P(^AMHPSUIC(APCDSF,15,Y,0),U,2) I X]"" S X="     OTHER DRUG: "_X D S(X)
 S X="CONTRIBUTING FACTORS: " D S(X)
 S Z=0 F  S Z=$O(^AMHPSUIC(APCDSF,13,Z)) Q:Z'=+Z  S X="",$E(X,20)=$P(^AMHTSCF($P(^AMHPSUIC(APCDSF,13,Z,0),U),0),U) S:$P(^AMHPSUIC(APCDSF,13,Z,0),U,2)]"" X=X_" - "_$P(^AMHPSUIC(APCDSF,13,Z,0),U,2) D S(X)
 I $$VAL^XBDIQ1(9002011.65,APCDSF,.24)]"" S X="LETHALITY: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.24) D S(X)
 S X="DISPOSITION: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,.25) D S(X)
 I $P($G(^AMHPSUIC(APCDSF,14)),U,2)]"" S X="  DISPOSITION, IF OTHER: ",$E(X,40)=$$VAL^XBDIQ1(9002011.65,APCDSF,1402) D S(X)
 S X="  Narrative: " D S(X)
WP ;
 K ^UTILITY($J,"W")
 S APCDX=0
 S DIWL=5,DIWR=75 F  S APCDX=$O(^AMHPSUIC(APCDSF,41,APCDX)) Q:APCDX'=+APCDX  D
 .S X=^AMHPSUIC(APCDSF,41,APCDX,0) D ^DIWP
 .Q
WPS ;
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S X="",$E(X,5)=^UTILITY($J,"W",DIWL,Z,0) D S(X)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),APCDX
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCDS",$J,"DCS",0),U)+1,$P(^TMP("APCDS",$J,"DCS",0),U)=%
 S ^TMP("APCDS",$J,"DCS",%)=X
 Q
PRINT ;EP
 K ^TMP("APCDS",$J)
 D EP2(APCDSFI) ;gather up data
W ;write out array
 ;W:$D(IOF) @IOF
 K APCDQUIT
 ;W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"
 S APCDX=0 F  S APCDX=$O(^TMP("APCDS",$J,"DCS",APCDX)) Q:APCDX'=+APCDX!($D(APCDQUIT))  D
 .;I $Y>(IOSL-3) D HEADER Q:$D(APCDQUIT)
 .W !,^TMP("APCDS",$J,"DCS",APCDX)
 .Q
 I $D(APCDQUIT) S APCDSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K ^TMP("APCDS",$J)
 K APCDX,APCDQUIT,APCDY,APCDSBEG,APCDSTOB,APCDSUPI,APCDSED,APCDTOBN,APCDTOB,APCDOD,APCDO,X,Y,Z,APCDOPT,APCDSF,APCDSQIT,APCDOD
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
EPDE ;EP
 D EN^XBNEW("EP^APCDESF1","AUPN*;VALM*") K Y
 Q
