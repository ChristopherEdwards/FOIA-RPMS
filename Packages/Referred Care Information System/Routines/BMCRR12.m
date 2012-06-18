BMCRR12 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W !,"This report will display CHS Referral Costs By Requesting provider",!,"or referring facility.  The report will include total number of referrals"
 W !,"total number of CHS referrals, total cost of CHS referrals, # of PCC visits,",!,"and CHS Referral Cost per 100 PCC Visits.",!
 W !,"** - canceled referrals and In-House referrals are excluded"
 W !!,"Report includes Secondary Referrals.  The user will enter a date range.",!!
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
PF ;run for provider or requesting facility
 W ! S DIR(0)="S^P:Requesting Provider;F:Requesting Facility",DIR("A")="Run the report for requesting",DIR("B")="P" K DA D ^DIR K DIR
 G:$D(DIRUT) BD
 S BMCTYPE=Y
COST ;
 S BMCTCOST=""
 S DIR(0)="S^A:ACTUAL CHS COST;B:BEST AVAILABLE CHS COST",DIR("A")="Which Cost Data Should be Used",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) PF
 S BMCTCOST=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) PF
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR12P",XBRC="^BMCRR121",XBRX="XIT^BMCRR12",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR12P"")"
 S XBRC="^BMCRR121",XBRX="XIT^BMCRR12",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR12
 D KILL^AUPNPAT
 K BMC2,BMC80D,BMC80E,BMCBD,BMCBT,BMCBTH,BMCED,BMCET,BMCJOB,BMCODAT,BMCOPT,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCSORT,BMCTYPE,BMCVDFN,BMCVREC,BMCX,BMCTCOST
 K DA,DIR,DIRUT,DTOUT,DUOUT,X,X1,X2,Y
 Q
