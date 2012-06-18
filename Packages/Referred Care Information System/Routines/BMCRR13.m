BMCRR13 ; IHS/PHXAO/TMJ - list active referral by Requesting Provider ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ ADDED BEG AND END DATE SELECTION TO REPORT
 ;
START ;
 W !!,"This report prints out a list of all referrals that are still",!,"active (not closed), sorted by the provider within your facility who requested",!,"it.  You can select to print just one provider's list or all providers' lists"
 W !,"in which case you can optionally print each provider's list on a separate",!,"page.",!
 W !,"In-House Referrals are excluded in this report.",!
BD ;GET BEG AND ENDING DATES
 D BD^BMCRUTL
 G:$D(DIRUT) XIT
PROV ;
 S BMCPROV=""
 S DIR(0)="S^A:ALL PROVIDERS;O:ONE PROVIDER",DIR("A")="Display referrals for ",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I Y="A" G PAGE
PROV1 ;
 S DIR(0)="90001,.06",DIR("A")="Enter Referring Provider" K DA D ^DIR K DIR
 G:$D(DIRUT) PROV
 G:Y="" PROV
 S BMCPROV=+Y,BMCSPAGE=0 G ZIS
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each Provider on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSPAGE=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" G XIT
 S BMCOPT=Y
 G:$G(BMCQUIT) PAGE
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR13P",XBRC="^BMCRR131",XBRX="XIT^BMCRR13",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR13P"")"
 S XBRC="^BMCRR131",XBRX="XIT^BMCRR13",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR13
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCET,BMCPRV,BMCJOB,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSPAGE,BMCPROV
 K BMCBD,BMCED,BMCBDD,BMCEDD,BMCSD
 K DA,DFN,DIR,DIRUT,DTOUT,X,Y
 Q
