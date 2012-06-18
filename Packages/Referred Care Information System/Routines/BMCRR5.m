BMCRR5 ; IHS/PHXAO/TMJ - patients without medical and/or cost data;    
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ ADDED VAR ;ADDED REQUEST TO SORT BY ALPHA
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will list patients who are currently under treatment at outside ",!,"referral facilities.  The definition of those under treatment at outside"
 W !,"facilities is the following:"
 W !?5,"- the referral is an Inpatient referral"
 W !?5,"- the beginning date of service is today or earlier and the expected",!?7,"end date of service is on or after today's date of " W $$FMTE^XLFDT(DT)
 W !?5,"- the status of the referral is active",!,?5,"- Inhouse Referrals are excluded",!
 W !,"This transfer log will contain a 1-2 page detailed summary record display",!,"for each referral.",!
 ;
 ;
SORT ;sort by?
 S BMCSTYPE=""
 S DIR(0)="S^F:Facility Referred to;C:Case Manager;P:Patient Name",DIR("A")="Sort output by which of the above",DIR("B")="F" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCSTYPE=Y
 S BMCSTYPA=""
 I BMCSTYPE'="P" D  G:$D(DIRUT) SORT
 .S DIR(0)="Y",DIR("A")="Would you like entries listed alphabetically by patient name",DIR("B")="Y" K DA D ^DIR K DIR
 .Q:$D(DIRUT)
 .S BMCSTYPA=Y
 ;
PAGE ;separate page for each
 S BMCSPAGE=""
 S DIR(0)="Y",DIR("A")="Do you want each "_$S(BMCSTYPE="C":"Case Manager",BMCSTYPE="P":"Patient",BMCSTYPE="F":"Facility")_" on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) G SORT
 S BMCSPAGE=Y
SECREF ;PRINT SEC REF AS A SEPARATE ENTRY
 S BMCTYPR=""
 S DIR(0)="Y",DIR("A")="Would you like to print the Secondary Referrals as Separate entries",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCTYPR=Y
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) XIT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR5P",XBRC="^BMCRR51",XBRX="XIT^BMCRR5",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR5P"")"
 S XBRC="^BMCRR51",XBRX="XIT^BMCRR5",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR5
 D KILL^AUPNPAT
 K BMC1,BMC2,BMC80D,BMC80E,BMCAR,BMCBT,BMCBTH,BMCCOL,BMCCTR,BMCET,BMCFILE,BMCG,BMCH,BMCI,BMCJOB,BMCNODE,BMCOPT,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSTR,BMCV,BMCVDFN,BMCVDG,BMCVFILE,BMCVI,BMCVIGR,BMCVL,BMCVNM,BMCX,BMCY
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 K BMCD,BMCHRN,BMCSORT,BMCP,BMCSPAGE,BMCSTYPE,BMCTST,BMC15S,BMCRNUMB,BMCTYPR
 Q
