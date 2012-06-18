BMCRR10 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ ADDED ABILITY TO SELECT BEG AND END DATE OF REPORT
 ;
 ;
START ;
 W !!,"This report prints out a list of all referrals that are still active",!,"(not closed), sorted by the outside provider.  Optionally, you may print",!,"out each outside provider's list on a separate page.",!!
 W "In-House Referrals are NOT included in this report output",!
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each Facility Referred To on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSPAGE=Y
BD ;get beginning date and end date for report
 D BD^BMCRUTL
 G:$D(DIRUT) XIT
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) PAGE
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR10P",XBRC="^BMCRR101",XBRX="XIT^BMCRR10",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR10P"")"
 S XBRC="^BMCRR101",XBRX="XIT^BMCRR10",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR10
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCET,BMCFAC,BMCJOB,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSPAGE
 K BMCBD,BMCED,BMCBDD,BMCEDD,BMCSD,BMCCT
 K DA,DFN,DIR,DIRUT,DTOUT,X,Y
 Q
