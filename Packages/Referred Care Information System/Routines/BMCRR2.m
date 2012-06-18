BMCRR2 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;    
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
START ;
 W !,"This report will list patients who are currently under treatment at outside ",!,"referral facilities.  The definition of those under treatment at outside"
 W !,"facilities is the following:"
 W !?5,"- the referral is an Inpatient referral"
 W !?5,"- the beginning date of service is today or earlier and the actual",!?7,"end date of service is blank, or on or after today's date of " W $$FMTE^XLFDT(DT,"5D")
 W !?5,"- the status of the referral is active",!,"Inhouse Referrals are NOT included.",!
SORT ;sort by?
 S BMCSTYPE=""
 S DIR(0)="S^F:Facility Referred to;C:Case Manager;P:Patient Name",DIR("A")="Sort output by which of the above",DIR("B")="F" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSTYPE=Y
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
 ;
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
 S XBRP="^BMCRR2P",XBRC="^BMCRR21",XBRX="XIT^BMCRR2",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR2P"")"
 S XBRC="^BMCRR21",XBRX="XIT^BMCRR2",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR2
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCCOL,BMCD,BMCET,BMCFILE,BMCG,BMCHRN,BMCJOB,BMCNODE,BMCOPT,BMCP,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSORT,BMCSPAGE,BMCSTYPE,BMCX,BMCOUTP,BMC132D,BMC132E,BMCRNUMB
 K C,DA,DFN,DIR,DIRUT,DIWF,DIWL,DIWR,DTOUT,X,Y,Z,BMCTYPR
 Q
