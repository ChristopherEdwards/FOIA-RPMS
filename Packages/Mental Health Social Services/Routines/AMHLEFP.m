AMHLEFP ; IHS/CMI/LAB - PRINT ENCOUNTER RECORD ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;print individual forms for each member of group
START ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  ENCOUNTER FORM PRINT  **********",!!
 W "This report will produce hard copy computer generated encounter forms.",!
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range for which forms should be printed.",!
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter ending Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 ;
PAT ;one or all patients
 S AMHPAT=""
 S DIR(0)="Y",DIR("A")="Do you wish to print forms for one particular PATIENT",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 G:'Y PROV
 I Y=1 S DIC("A")="Enter PATIENT Name: ",DIC=9000001,DIC(0)="AEQMZ" D ^DIC G PAT:Y<0 S AMHPAT=+Y I '$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL S AMHPAT="" G PAT
PROV ;limit by provider
 K DIC
 S AMHPROV=""
 S DIR(0)="Y",DIR("A")="Do you wish to print forms for one particular PROVIDER",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 G:'Y FORMAT
 I Y=1 S DIC("A")="Enter PROVIDER Name: ",DIC=200,DIC(0)="AEQMZ" D ^DIC G PROV:Y<0 S AMHPROV=+Y
FORMAT ;
 K AMHEFT,AMHEFTH
 D FORMDIR()
 I $D(DIRUT) G PROV
 S (AMHEFT,AMHEFTH)=Y
 I 'AMHPAT S AMHDOLOG=1
ZIS ;EP
 S XBRC="COMP^AMHLEFP",XBRP="PRINT^AMHLEFP",XBNS="AMH",XBRX="XIT^AMHLEFP"
 D ^XBDBQUE
 ;
XIT ;
 K ZTSK,Y,AMHBD,AMHED,IO("Q"),AMH80D,AMHBTH,AMHHRCN,AMHJOB,AMHLENG,AMHPCNT,AMHPG,AMHPROV,AMHX,DFN,DIC,DIR,DIRUT,DTOUT,DUOUT,XBNS,XBRC,XBRP,XBTX,D,AMHC,AMHEFT,AMHEFTH,AMHPAT
 K AMHPRNM,AMHPRNT,AMHNOLOG,AMHPROB,AMHPRV,AMHR,AMHRCNT,AMHRLOC,AMHSD,AMHTOT,AMHBDD,AMHBT,AMHEDD,AMHEDO,AMHBDO,AMHBT,AMHFOUND,AMHHIT,AMHID,AMHLINE,AMHP,AMHHRN,AMHODAT,AMHQUIT,AMHR0,AMHTICL,AMHTNRQ,AMHTQ,AMHTTXT
 K AMHDOLOG
 Q
COMP ;EP - do nothing
 Q
PRINT ; EP - print individual forms
 S AMHQUIT=0
D ; Run by visit date
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)!(AMHQUIT)  D V1
 Q
V1 ;
 S (AMHR,AMHRCNT)=0 F  S AMHR=$O(^AMHREC("B",AMHODAT,AMHR)) Q:AMHR'=+AMHR!(AMHQUIT)  I $D(^AMHREC(AMHR,0)),$P(^(0),U,2)]"",$P(^(0),U,3)]"" D  I F D PRINT1
 .;CHECK PATIENT
 .S F=0
 .I '$$ALLOWVI^AMHUTIL(DUZ,AMHR) Q  ;not allowed to see visits to this location
 .I AMHPAT,$P(^AMHREC(AMHR,0),U,8)'=AMHPAT Q
 .I '$$ALLOWP^AMHUTIL(DUZ,$P(^AMHREC(AMHR,0),U,8))
 .S F=1
 .;CHECK PROVIDER
 .S F=0
 .I 'AMHPROV S F=1 Q
 .S X=0,F=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I AMHPROV=$P(^AMHRPROV(X,0),U) S F=1
 Q
PRINT1 ;
 W:$D(IOF) @IOF
 ;I AMHEFTH="B" S AMHEFT="S" D PRINT1^AMHLEFP2(AMHR) Q:AMHQUIT  S AMHEFT="F" W:$D(IOF) @IOF D PRINT1^AMHLEFP2(AMHR) Q
 ;D PRINT1^AMHLEFP2(AMHR)
 S AMHEFT=AMHEFTH
 D ^AMHLEFP2
 Q
 ;
FORMDIR(R) ;EP
 ;
 S R=$G(R)
 K DIR
 W !! S DIR(0)="S^F:Full Encounter Form;S:Suppressed Encounter Form;B:Both a Suppressed & Full;T:2 copies of the Suppressed;E:2 copies of the Full"
 ;S DIR(0)=DIR(0)_$S('$G(R):";W:Print a Copy of the Full Encounter Form without the Intake",$P($G(^AMHREC(R,0)),U,33)="I":";W:Print a Copy of the Full Encounter Form without the Intake",1:"")
 S DIR("B")=$S($P(^AMHSITE(DUZ(2),0),U,23)]"":$P(^AMHSITE(DUZ(2),0),U,23),1:"B")
 S DIR("A")="What type of form do you want to print" K DA D ^DIR K DIR
 Q
