BMCRR7 ; IHS/PHXAO/TMJ - list patients currently in active, outpatient referral status ; 10 Nov 2009  1:45 PM
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;Modified for Y2k Compliance  IHS/DSD/HJT  5/25/99
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will list patients currently referred for outpatient services",!,"at outside referral facilities.  The definition of 'currently referred for is",!
 W !?5,"- the referral is an Outpatient referral"
 ;Begin Y2k fix
 ;W !?5,"- the best available beginning (actual or estimated) date is today or",!?7,"earlier and ",!?5,"- the actual end date of service is blank or on or after",!?7," today's date of ",$$FMTE^XLFDT(DT,"2D")
 W !?5,"- the best available beginning (actual or estimated) date is today or",!?7,"earlier and ",!?5,"- the actual end date of service is blank or on or after",!?7," today's date of ",$$FMTE^XLFDT(DT,"5D")  ;Y2000
 ;End y2k fix
 W !?5,"- the status of the referral is active",!,?5,"- Inhouse Referrals are excluded",!
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
 S XBRP="^BMCRR7P",XBRC="^BMCRR71",XBRX="XIT^BMCRR7",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR7P"")"
 S XBRC="^BMCRR71",XBRX="XIT^BMCRR7",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR7
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCCOL,BMCET,BMCFAC,BMCFILE,BMCG,BMCHRN,BMCJOB,BMCNODE,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSORT,BMCSPAGE,BMCSTYPE,BMCX
 K DA,DFN,DIR,DIRUT,DIWF,DIWL,DIWR,DTOUT,X,Y
 Q
