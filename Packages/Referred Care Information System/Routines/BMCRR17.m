BMCRR17 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W !,"This report will list patients who have been hospitalized longer than",!," the Estimated Length of stay."
 W !,"The report will list any referral that meets the following criteria:"
 W !?5,"- the referral is an Inpatient referral"
 W !?5,"- the date of admission is today or earlier",!,?5,"- the actual discharge date is blank"
 W !?5,"- the status of the referral is active"
 W !?5,"- the actual LOS to date is greater than the Estimated LOS"
 W !?5,"note:  if the estimated LOS is not entered, the referral will",!?5,"NOT display on this report.  Inhouse Referrals are NOT included.",!
SORT ;sort by?
 S BMCSTYPE=""
 S DIR(0)="S^F:Facility Referred to;C:Case Manager;P:Patient Name",DIR("A")="Sort output by which of the above",DIR("B")="F" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSTYPE=Y
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each "_$S(BMCSTYPE="C":"Case Manager",BMCSTYPE="P":"Patient",BMCSTYPE="F":"Facility")_" on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G SORT
 S BMCSPAGE=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) SORT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR17P",XBRC="^BMCRR171",XBRX="XIT^BMCRR17",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR17P"")"
 S XBRC="^BMCRR171",XBRX="XIT^BMCRR17",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR17
 K BMC80D,BMC80E,BMCALOS,BMCBT,BMCBTH,BMCCOL,BMCD,BMCELOS,BMCET,BMCFILE,BMCG,BMCHRN,BMCI,BMCJOB,BMCNODE,BMCNOES,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSORT,BMCSPAGE,BMCSTR,BMCSTYPE,BMCX
 K C,DA,DFN,DIR,DIRUT,DIWF,DIWL,DIWR,DTOUR,O,X,Y,Z
 D KILL^AUPNPAT
 Q
