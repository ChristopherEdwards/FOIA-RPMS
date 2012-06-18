BMCRR9 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ ADDED ABILITY TO SELECT BEG AND END DATE OF REPORT
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will list all referrals by either date initiated or Best available",!,"beginning date of service.  Best of available Date of service is defined as"
 W !,"the actual begin date of service if available, otherwise the expected begin "
 W !,"date.  Inhouse Referrals are excluded.",!
BD ;get beginning date and ending dates
 D BD^BMCRUTL
 G:$D(DIRUT) XIT
SORT ;sort by?
 S BMCSTYPE=""
 S DIR(0)="S^B:Begin Date of Service;I:Date Referral Initiated",DIR("A")="Sort output by which of the above",DIR("B")="B" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 S BMCSTYPE=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) SORT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR9P",XBRC="^BMCRR91",XBRX="XIT^BMCRR9",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR9P"")"
 S XBRC="^BMCRR91",XBRX="XIT^BMCRR9",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR9
 D KILL^AUPNPAT
 K BMC80D,BMC80E,BMCBT,BMCBTH,BMCET,BMCFAC,BMCJOB,BMCOPT,BMCPG,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSORT,BMCSTYPE
 K BMCBD,BMCED,BMCBDD,BMCEDD,BMCSD
 K DA,DFN,DIR,X,Y
 Q
