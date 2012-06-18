BMCRR20 ; IHS/PHXAO/TMJ - Case Review Dates/By Facility/Reviewer ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
 W !?10,"********  CASE REVIEW COMMENTS BY DATE OF RECORDING  ********",!
 W !!,"This report will print a list of all Case Review Comments that were initiated",!,"in a date range entered by the user.",!
 W !,"This report allows User to Select and report for a INDIVIDUAL FACILITY Only!!",!
 W !,"This report also allows the User to Select a particular Case REVIEWER ",!
 W !,"Inhouse Referrals are NOT included.",!
ASK ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Facility Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G XIT
 S BMCFAC=+Y
 ;
ASK1 ;Restrict to a Certain Case Review Person
 S BMCCREV=0
 W ! S DIR(0)="Y0",DIR("A")="Would you like to Restrict Report to a particular Case REVIEWER",DIR("B")="NO"
 S DIR("?")="To RESTRICT Report to a particular Case REVIEWER - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) ASK
 I 'Y G BD
REV ;Case Reviewer
 S BMCCREV=0
 S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Enter the Name of Case Reviewer: "
 D ^DIC K DIC
 Q:$D(DIRUT)
 G:Y=0 BD
 S BMCCREV=+Y
 ;
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Case Review Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ASK
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending Case Review Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
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
 S XBRP="^BMCRR20P",XBRC="^BMCRR201",XBRX="XIT^BMCRR20",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR20P"")"
 S XBRC="^BMCRR201",XBRX="XIT^BMCRR20",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR20 ; IHS/PHX/TMJ 11/25/98 Kill off Additional Local variables
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP,BMCCREV,BMCRNUMB
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
