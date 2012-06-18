BMCRR19 ; IHS/PHXAO/TMJ - Weekly RRR Report for One Facility Only ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
 W !?10,"********  REVIEW LISTING BY DATE OF SERVICE  ********",!
 W !!,"This report will print a list of all Primary referrals that were initiated in a",!,"date range entered by the user.  This report can be used by the"
 W !,"CHS or Managed Care Committee to review the referrals.",!
 W !,"This report allows User to Select and report on an INDIVIDUAL FACILITY Only!!",!
 W !,"This report also allows the User to EXCLUDE a particular Local Category ",!
 W !,"Inhouse Referrals are NOT included.",!
ASK ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Facility Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G XIT
 S BMCFAC=+Y
 ;
ASK1 ;Restrict a Certain Local Category
 S BMCLCAT=0
 W ! S DIR(0)="Y0",DIR("A")="Would you like to EXCLUDE a particular Local Category in this report",DIR("B")="NO"
 S DIR("?")="To EXCLUDE a particular Local Category from this Report - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) ASK
 I 'Y G BD
CAT ;Category Restriction
 S BMCLCAT=0
 S DIC="^BMCLCAT(",DIC(0)="AEQM",DIC("A")="Enter the Local Category to EXCLUDE: "
 D ^DIC K DIC
 Q:$D(DIRUT)
 G:Y=0 BD
 S BMCLCAT=+Y
 ;
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Referral Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ASK
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending Referral Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
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
 S XBRP="^BMCRR19P",XBRC="^BMCRR191",XBRX="XIT^BMCRR19",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR19P"")"
 S XBRC="^BMCRR191",XBRX="XIT^BMCRR19",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR19
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP,BMCLCAT
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
