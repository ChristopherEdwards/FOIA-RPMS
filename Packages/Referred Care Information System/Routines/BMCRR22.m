BMCRR22 ; IHS/PHXAO/TMJ - list patients currently in active, outpatient referral status ;    
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;3.9.04 IHS/ITSC/FCJ CALL made to the wrong routine
 ;
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will list patients currently referred for outpatient services",!,"at outside referral facilities.  The definition of 'currently referred for is",!
 W !?5,"- the referral is an Outpatient referral"
 W !?5,"- the best available beginning (actual or estimated) date is today or",!?7,"earlier and ",!?5,"- the actual end date of service is blank or on or after",!?7," today's date of ",$$FMTE^XLFDT(DT,"5D")
 W !?5,"- the status of the referral is active",!,?5,"- Inhouse Referrals are excluded",!
SORT ;sort by?
 S BMCSTYPE=""
 S DIR(0)="S^F:Facility Referred to;C:Case Manager;P:Patient Name;R:Referring Physician",DIR("A")="Sort output by which of the above",DIR("B")="F" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSTYPE=Y
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each "_$S(BMCSTYPE="C":"Case Manager",BMCSTYPE="P":"Patient",BMCSTYPE="F":"Facility",BMCSTYPE="R":"IHS Referring Physician")_" on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G SORT
 S BMCSPAGE=Y
 ;
OUTPUT ;Print Output Summary or Detail
 S BMCOUTP=""
 S DIR(0)="S^D:Detailed Report Listing;S:Summary Report Listing",DIR("A")="Select Report Printing",DIR("B")="D" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCOUTP=Y
SECREF ;PRINT SEC REF AS A SEPARATE ENTRY
 S BMCTYPR=""
 S DIR(0)="Y",DIR("A")="Would you like to print the Secondary Referrals as Separate entries",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCTYPR=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) SORT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 I BMCOUTP="D" G DETAIL
 ;
SUMMARY ;Print Summary Report
 S XBRP="^BMCRR7P",XBRC="^BMCRR71",XBRX="XIT^BMCRR22",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
DETAIL ;Print Detail
 S XBRP="^BMCRR22P",XBRC="^BMCRR221",XBRX="XIT^BMCRR22",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 I BMCOUTP="S" D BROWSE1,XIT Q
 S XBRP="VIEWR^XBLM(""^BMCRR22P"")"
 S XBRC="^BMCRR221",XBRX="XIT^BMCRR22",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR22
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCCOL,BMCET,BMCFAC,BMCFILE,BMCG,BMCHRN,BMCJOB,BMCNODE,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSORT,BMCSPAGE,BMCSTYPE,BMCX
 K DA,DFN,DIR,DIRUT,DIWF,DIWL,DIWR,DTOUT,X,Y,BMCTYPR
 Q
 ;
BROWSE1 ;Summary Browse
 S XBRP="VIEWR^XBLM(""^BMCRR7P"")"
 S XBRC="^BMCRR71",XBRX="XIT^BMCRR22",XBIOP=0 D ^XBDBQUE
