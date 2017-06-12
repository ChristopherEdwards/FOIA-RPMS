APCDCAFP ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;**2,7,11,15**;MAY 14, 2009;Build 11
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 D INFORM
  I $P(^APCCCTRL(DUZ(2),0),U,12)="" W !!,"The EHR/PCC Coding Audit Start Date has not been set",!,"in the PCC Master Control file." D  D XIT Q
 .W !!,"Please see your Clinical Coordinator or PCC Manager."
 .S DIR(0)="E",DIR("A")="Press Enter" KILL DA D ^DIR KILL DIR
 .Q
GETPAT ;
 W !
 S APCDPATF=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 G:Y<0 XIT
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S (DFN,APCDPATF)=+Y
SORT ;how to sort list of visits
 W !! S APCDSORT=""
 K DIR S DIR(0)="S^D:Date of Visit;S:Service Category;L:Location of Encounter;C:Clinic;O:Hospital Location;P:Primary Provider;A:Chart Audit Status"
 S DIR("A")="How would you like the list of visits sorted",DIR("B")="D" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G XIT
 S APCDSORT=Y
PROC1 ; call listmanager
 S APCDCAFP=DFN,APCDBD=$P(^APCCCTRL(DUZ(2),0),U,12),APCDED=DT,APCDPEHR=1
 D EN^APCDCAF
 D XIT
 Q
XIT ;
 K DIR
 D EN^XBVK("APCD")  ;clean up APCD variables
 D ^XBFMK  ;clean up fileman variables
 D KILL^AUPNPAT  ;clean up AUPN
 D EN^XBVK("AMQQ")  ;clean up after qman
 Q
 ;
PROC ;EP - called from xbdbque
 Q
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;inform user what this report is all about
 W !,$$CTR($$LOC)
 W !!,$$CTR("PCC/EHR CODING AUDIT FOR ONE PATIENT")
 W !!,"This option is used to review visits created by EHR users for one patient."
 W !,"The visits displayed in the list are those with an INCOMPLETE or blank"
 W !,"chart audit status.  This list can be sorted by date, primary provider"
 W !,"clinic code, hospital location (scheduling clinic), and facility."
 W !,"Once the visit has been reviewed, the review status can be set as reviewed/"
 W !,"complete or incomplete. All visits set as reviewed/complete will be passed"
 W !,"to the IHS/RPMS billing package."
 W !,"Contract Health visits are excluded."
 W !,"Visits that do not have a primary provider are ",$S($P(^APCDSITE(DUZ(2),0),U,28):"included in ",1:"excluded from "),"the list."
 W !,"Visits with the following service categories are NOT included in the list:"
 W !?10,"- Event (Historical)"
 S X="" F  S X=$O(^APCDSITE(DUZ(2),13,"B",X)) Q:X=""  W !?10,"- ",$$EXTSET^XBFUNC(9000010,.07,X)
 W !!,"PLEASE NOTE:  A visit will NOT pass to Billing until it is marked"
 W !,"as reviewed/completed."
 W !
 Q
 ;
