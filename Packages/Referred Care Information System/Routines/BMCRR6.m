BMCRR6 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 W:$D(IOF) @IOF W !,"This report presents, by facility referred to, timeliness of receiving",!,"discharge letters.  You will be given the number of letters received",!,"in under 1 month of discharge date, in 2-3 months, in 4-6 months"
 W !,"in in > 6 months.",!
 W !!,"Please enter the range of referral initiated dates that you are interested in.",!
 W !,"Inhouse Referrals are exlcuded",!
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
 S XBRP="^BMCRR6P",XBRC="^BMCRR61",XBRX="XIT^BMCRR6",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR6P"")"
 S XBRC="^BMCRR61",XBRX="XIT^BMCRR6",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR6
 D KILL^AUPNPAT
 K BMCBD,BMCBT,BMCBTH,BMCD,BMCED,BMCET,BMCF,BMCJOB,BMCODAT,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCSVCD
 K DA,DIR,DIRUT,DTOUT,DUOUT,J,K,T,X,X1,X2,Y,Z,%
 Q
