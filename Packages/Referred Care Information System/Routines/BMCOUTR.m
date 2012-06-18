BMCOUTR ; IHS/PHXAO/TMJ - Outside Facilities - No IHS  Providers   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;Driver - BMCOUTR , PROCESS - BMCOUTR1 , PRINT - BMCOUTRP
 ;
 W !?10,"********  OUTSIDE FACILITY REFERRALS BY DATE OF RECORDING  ********",!
 W !!,"This report will list all Primary Referrals which were initiated at an Outside",!,"Facility.  These include call in NOTIFICATION by the outside Provider or the",!,"Patient or the patient representative.",!
 W !,"This report allows User to Select and report for a INDIVIDUAL FACILITY Only!!",!
ASK ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Facility Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G XIT
 S BMCFAC=+Y
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Referral Initiated Date Range" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ASK
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter Referral Intiated Date Range"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) XIT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCOUTRP",XBRC="^BMCOUTR1",XBRX="XIT^BMCOUTR",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCOUTRP"")"
 S XBRC="^BMCOUTR1",XBRX="XIT^BMCOUTR",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR20
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP,BMCCREV,BMCRIEN,BMCPTN
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
