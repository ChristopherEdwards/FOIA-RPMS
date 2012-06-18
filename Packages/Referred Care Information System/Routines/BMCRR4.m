BMCRR4 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;**4**;JAN 09, 2006
 ;BMC*4.0*4 IHS/OIT/FCJ TYPEO
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will display referral patterns by provider or referring facility.",!,"The report will include the provider or facility name, the number of referrals,"
 W !,"the type of referrals, compared to the total number of PCC visits for that",!,"provider or facility and the referral rate per 100 PCC visits.",!
 W !,"** - canceled referrals are excluded - Inhouse Referrals and closed not completed Referrals are excluded"
 ;IHS/OIT/FCJ FXED NXT LINE TO READ "are NOT"
 ;W !!,"Secondary Referrals are NOT included. The user will enter a date range.",!!
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
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) D
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR4P",XBRC="^BMCRR41",XBRX="XIT^BMCRR4",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR4P"")"
 S XBRC="^BMCRR41",XBRX="XIT^BMCRR4",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR4
 D KILL^AUPNPAT
 K BMC2,BMC80D,BMC80E,BMCBD,BMCBT,BMCBTH,BMCED,BMCET,BMCJOB,BMCODAT,BMCOPT,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCSORT,BMCTYPE,BMCVDFN,BMCVREC,BMCX
 K DA,DIR,DIRUT,DTOUT,DUOUT,X,X1,X2,Y
 Q
