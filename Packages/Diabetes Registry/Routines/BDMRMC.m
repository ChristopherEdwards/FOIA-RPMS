BDMRMC ; IHS/CMI/LAB - patients w/o dm on problem list ; 28 Oct 2015  2:08 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
START ;
 D INFORM
 D EXIT
GETINFO ;
 K BDMSTAT
R ;
 S BDMREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S BDMQUIT="" D EXIT Q
 S BDMREG=+Y
PS ;
 K BDMPATS
 S DIR(0)="S^I:Individual Patient Names/HRNs;A:Group of Patients by Attribute",DIR("A")="Select Patients By",DIR("B")="I" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BDMPS=Y
 I BDMPS="I" D GETPATS I '$D(BDMPATS) W !!,"No patients selected." G EXIT
 I BDMPS="I" G HS
 D GROUP
 I '$D(BDMPATS) W !!,"No patients selected." G EXIT
HS ;
 I $P(^ACM(41.1,BDMREG,0),U,10)=1 D
 .S DIR(0)="YO",DIR("A")="Include PCC HEALTH SUMMARY",DIR("B")="NO"
 .W !
 .D ^DIR K DIR
 .I Y=1 S ACMMHS="" D SELTYP I ACMSTYP="" W !,"No Health summary will be included.",!
ZIS ;call to XBDBQUE
DEMO ;
 ;D DEMOCHK^BDMUTL(.BDMDEMO)
 ;I BDMDEMO=-1 G R
 ;I BDMTEMP="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BDMRMC",XBRC="",XBRX="EXIT^BDMRMC",XBNS="BDM"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMRMC"")"
 S XBRC="",XBRX="EXIT^BDMRMC",XBIOP=0 D ^XBDBQUE
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,$$CTR("DIABETES REGISTER MULTIPLE PATIENTS SUMMARIES",80)
 W !!,"This report will print patient summaries for a selected set of patients."
 W !,"You may select individual patients by name/HRN or you may select a group"
 W !,"of patients by any combination of the following attributes:"
 W ?5,"- Register Status",!
 W ?5,"- Community of Residence",!
 W ?5,"- Case Manager",!
 W ?5,"- Where Followed",!
 W ?5,"- Next Review Date",!
 W !
 Q
EXIT ;clean up and exit
 NEW BDMRDA,BDMREGNM
 D EN^XBVK("BDM")
 D EN^XBVK("ACM")
 K ACMMHS,ACMSTYP
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PRINT ;EP - called from xbdbque
 ;loop bdmpats and print patient summary and optionally health summary
 S BDMMULTS=1
 S BDMPATX=0 F  S BDMPATX=$O(BDMPATS(BDMPATX)) Q:BDMPATX=""!($D(ACMZQUIT))  D
 .S DFN=BDMPATX
 .S BDMRDA=BDMREG
 .S BDMRPDA=$G(^ACM(41,"AC",BDMPATX,BDMREG))
 .D CS1^BDMVRL
 .;I ACMSTYP S APCHSTYP=ACMSTYP,APCHSPAT=BDMPAT D EN^APCHS
 .I $E(IOST,1,2)="C-" D PAUSE1^ACMPPDTX
 D EXIT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
GETPATS ;
 S BDMSTP=0 K BDMPATS
I1 ;
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ",DIC("S")="I $G(^ACM(41,""AC"",+Y,BDMREG))" D ^DIC K DIC
 I Y=-1,'$D(BDMPATS) W !,"No patients selected" S BDMSTP=1 Q
 I Y=-1 Q
 I '$G(^ACM(41,"AC",+Y,BDMREG)) W !,"That patient is not on the register!" G I1
 S BDMPATS(+Y)=""
 G I1
GROUP ;get register, status, random or not
 S BDMSTP=0
 K BDMPATS
 S BDMSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GROUP
 I Y=0 G GROUP1
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GROUP
 S BDMSTAT=Y
GROUP1 ;
 ;gather up patients from register in ^XTMP
 K BDMPATS S BDMCNT=0,X=0 F  S X=$O(^ACM(41,"B",BDMREG,X)) Q:X'=+X  D
 .I BDMSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=BDMSTAT S BDMCNT=BDMCNT+1,BDMPATS($P(^ACM(41,X,0),U,2))="" Q
 .I BDMSTAT="" S BDMCNT=BDMCNT+1,BDMPATS($P(^ACM(41,X,0),U,2))=""
 I '$D(BDMPATS) W !,"No patients with that status in that register!" S BDMSTP=1 G GROUP
 W !!,"There are ",BDMCNT," patients in the ",$P(^ACM(41.1,BDMREG,0),U)," register with a status of ",BDMSTAT,".",!!
 D CM
 I BDMSTP K BDMPATS Q
 D CC
 I BDMSTP K BDMPATS Q
 D WF
 I BDMSTP K BDMPATS Q
 D NRD
 I BDMSTP K BDMPATS Q
 Q
NRD ;NEXT REVIEW DATE RANGE
 S DIR(0)="Y",DIR("A")="Select Patients by Next Review Date",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y Q
 I $D(DIRUT) Q
 ;
GETDATES ;
BD ;
 W !!!,"Enter the next review date range.",!
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Next Review Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDMSTP=1 Q
 S BDMBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Next Review Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 I Y<BDMBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDMED=Y
 S X1=BDMBD,X2=-1 D C^%DTC S BDMSD=X
 ;
 ;LOOP THROUGH AND CHECK NRD
 S P=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S BDMX=$G(^ACM(41,"AC",P,BDMREG)) D
 .I 'BDMX K BDMPATS(P) Q
 .S X=$$VALI^XBDIQ1(9002241,BDMX,9)
 .I 'X K BDMPATS(P) Q
 .I X<BDMBD K BDMPATS(P) Q
 .I X>BDMED K BDMPATS(P) Q
 S P=0,C=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S C=C+1
 I 'C W !!,"There are no patients with that case manager." S BDMSTP=1 Q
 W !,"There are ",C," patients selected so far.",!
 Q
CM ;
 K BDMCM
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular CASE MANAGER",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I Y=0 Q
CM1 ;which status
 K DIC S DIC(0)="AEMQ",DIC=200,DIC("A")="Select "_$S($D(BDMCM):"another ",1:"")_"Case Manager: " D ^DIC K DIC
 I Y=-1,'$D(BDMCM) G CM
 I Y=-1,$D(BDMCM) D  Q
 .;LOOP THROUGH AND CHECK CASE MANAGER
 .S P=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S BDMX=$G(^ACM(41,"AC",P,BDMREG)) D
 ..I 'BDMX K BDMPATS(P) Q
 ..S X=$$VALI^XBDIQ1(9002241,BDMX,6)
 ..I 'X K BDMPATS(P) Q
 ..I '$D(BDMCM(X)) K BDMPATS(P) Q
 .S P=0,C=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S C=C+1
 .I 'C W !!,"There are no patients with that case manager." S BDMSTP=1 Q
 .W !,"There are ",C," patients selected so far.",!
 S BDMCM(+Y)=""
 G CM1
WF ;
 K BDMWF
 S DIR(0)="Y",DIR("A")="Do you want to select patients with a particular facility WHERE FOLLOWED",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I Y=0 K BDMWF Q
WF1 ;which status
 K DIC S DIC=9999999.06,DIC(0)="AEMQZ",DIC("A")="Select "_$S($D(BDMWF):"another ",1:"")_"WHERE FOLLOWED facility: " D ^DIC K DIC
 I Y=-1,'$D(BDMWF) G WF
 I $D(DIRUT),'$D(BDMWF) G WF
 I Y=-1,$D(BDMWF) D  Q
 .;LOOP THROUGH AND CHECK WHERE FOLLOWED
 .S P=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S BDMX=$G(^ACM(41,"AC",P,BDMREG)) D
 ..I 'BDMX K BDMPATS(P) Q
 ..S X=$$VALI^XBDIQ1(9002241,BDMX,10)
 ..I 'X K BDMPATS(P) Q
 ..I '$D(BDMWF(X)) K BDMPATS(P) Q
 .S P=0,C=0 F  S P=$O(BDMPATS(P)) Q:P'=+P  S C=C+1
 .I 'C W !!,"There are no patients with that Where Followed Value." H 5 S BDMSTP=1 Q
 .W !,"There are ",C," patients selected so far.",!
 S BDMWF(+Y)=""
 G WF1
CC ;current community
 S BDMSTP=0
 W ! K DIR S DIR(0)="Y",DIR("A")="Limit the patients who live in a particular community ",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 Q:'Y
 K DIC S DIC="^AUTTCOM(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G CC
 S BDMCOM=$P(^AUTTCOM(+Y,0),U)
 S X=0 F  S X=$O(BDMPATS(X)) Q:X'=+X  I $P($G(^AUPNPAT(X,11)),U,18)'=BDMCOM K BDMPATS(X)
 S (X,C)=0 F  S X=$O(BDMPATS(X)) Q:X'=+X  S C=C+1
 I 'C W !!,"There are no patients living in that community." H 5 S BDMSTP=1 Q
 W !!,C," patients have been selected so far.",!
 Q
SELTYP ;PEP;TO SELECT HEALTH SUMMARY TYPE
 K DIC
 S DIC="^APCHSCTL(",DIC("A")="Select health summary type: ",DIC(0)="AEQM",DIC("B")="DIABETES STANDARD"
 W !
 D ^DIC
 K DIC,DA,DR
 I Y<0 Q
 S ACMSTYP=+Y
 Q
