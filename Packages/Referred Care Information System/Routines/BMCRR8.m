BMCRR8 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W:$D(IOF) @IOF W !!,"This report will list potentially high cost cases.  To determine whether a ",!,"case is potentially high cost, a taxonomy of ICD9 Diagnosis codes is used."
 W !!,"This report is not available to those who are not full coding their referrals.",!
 W "Inhouse Referrals are exlcuded",!
 W !!,"Please enter the range of referral initiated dates that you are interested in.",!
 S BMCHCTAX=$O(^ATXAX("B","BMC POTENTIAL HIGH COST DX",""))
 I 'BMCHCTAX W $C(7),$C(7),!!,"HIGH COST TAXONOMY MISSING!!!! NOTIFY SITE MANAGER",! G XIT
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
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) D
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR8P",XBRC="^BMCRR81",XBRX="XIT^BMCRR8",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR8P"")"
 S XBRC="^BMCRR81",XBRX="XIT^BMCRR8",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR8
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCED,BMCET,BMCFAC,BMCFILE,BMCFOUN,BMCG,BMCHCTAX,BMCHRN,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCX
 K DA,C,DFN,DIR,DIRUT,DIWF,DIWL,DIWR,DTOUT,DUOUT,X,X1,X2,Y,Z
 Q
