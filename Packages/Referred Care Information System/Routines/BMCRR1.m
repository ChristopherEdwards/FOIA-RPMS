BMCRR1 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W !!,"This report will list all referrals for which a discharge letter has not ",!,"been received.",!
 W !,"ALL referral records with or without an actual end date of service",!,"and no discharge letter received are listed.",!
 W !,"I User Selects a SPECIFIC FACILITY REFERRED TO, then only CHS Type Referrals-",!
 W "For that particular Vendor -  will be displayed",!
TIME ;
 S BMCTIME=""
 S DIR(0)="N^1:9999999:",DIR("A")="Please specify the minimum time overdue (in days)" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCTIME=Y
SORT ;
 S BMCSTYPE=""
 S BMCFAC=""
 S DIR(0)="S^F:Facility Referred to;T:Amount of Time Overdue",DIR("A")="Sort Report by",DIR("B")="F" K DA D ^DIR K DIR
 I $D(DIRUT) G TIME  ;IHS/PHXAO/ Quit if Uphat 6/14/99
 S BMCSTYPE=Y
 ;
 I BMCSTYPE="F" D ASKFAC ;If Facility Selected-Ask for specific facility
 ;
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each "_$S(BMCSTYPE="T":"Time Bucket",BMCSTYPE="F":"Facility")_" on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G SORT
 S BMCSPAGE=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) SORT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR1P",XBRC="^BMCRR11",XBRX="XIT^BMCRR1",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR1P"")"
 S XBRC="^BMCRR11",XBRX="XIT^BMCRR1",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR1
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCET,BMCFAC,BMCHRN,BMCJOB,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSKIP,BMCSORT,BMCSPAGE,BMCSPEC,BMCSTYPE,BMCTIME
 K DA,DFN,DIR,DIRUT,DTOUT,Y,Z,%,%1
 Q
 ;
ASKFAC ;Ask for a specific Vendor
 ;S BMCFAC=0
 W ! S DIR(0)="Y0",DIR("A")="Would you like to include a Specific Facility Referred To? ",DIR("B")="NO"
 S DIR("?")="To Select a SPECIFIC Facility Referred To for this Report - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) SORT
 I 'Y Q
SELFAC ;Select a Specific Facility Referred To
 W ! S DIC="^AUTTVNDR(",DIC("A")="Enter Facility/Vendor Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G ASKFAC
 S BMCFAC=+Y
 ;
