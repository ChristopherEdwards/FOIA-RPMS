BMCRR3 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W !,"This report will present a list of high cost users.  The user will enter",!,"a date range and a dollar amount which will serve as the indicator of high",!,"cost.  "
 W "All referrals incurred by a patient in that date range will be totalled.",!,"If the total cost is greater than or equal to the dollar amount entered by the",!,"user, that patient will be considered a high cost user.",!
 W !,"The Total Cost can be either IHS COST or TOTAL COST.",!
 W !,"If ACTUAL Cost is available, it will be used.  If not available, estimated",!,"cost is used.  Inhouse Referrals are NOT included.",!
D ;DATE RANGE
BD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning Referral Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending Referral Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
 ;
DOLLAR ;
 W ! S DIR(0)="90001,1101",DIR("A")="Enter a dollar amount that will be used to determine high cost" K DA D ^DIR K DIR
 I Y="" G BD
 I $D(DIRUT) G BD
 S BMCAMT=Y
COST ;
 S BMCCOST=""
 S DIR(0)="S^I:BEST AVAILABLE IHS COST;T:BEST AVAILABLE TOTAL COST",DIR("A")="Use which COST in determining high cost users",DIR("B")="I" K DA D ^DIR K DIR
 I $D(DIRUT) G DOLLAR
 S BMCCOST=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) COST
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR3P",XBRC="^BMCRR31",XBRX="XIT^BMCRR3",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR3P"")"
 S XBRC="^BMCRR31",XBRX="XIT^BMCRR3",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR3
 D KILL^AUPNPAT
 K BMC11,BMC80D,BMC80E,BMCAMT,BMCBD,BMCBT,BMCBTH,BMCCOST,BMCDOLL,BMCED,BMCET,BMCHRN,BMCJOB,BMCOPT,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD
 K DA,DFN,DIR,DIRUT,DTOUT,DUOUT,X,X1,X2,Y
 Q
