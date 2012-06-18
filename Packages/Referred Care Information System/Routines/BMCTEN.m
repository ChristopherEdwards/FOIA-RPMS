BMCTEN ; IHS/PHXAO/TMJ - TOP TEN POVS ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 W !!?15,"*****  RCIS FREQUENCY OF DIAGNOSES REPORT  *****",!!
 W !,"NOTE: Report does not include Secondary referrals",!
 D EXIT
 S BMCTYPR="P"
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Referral Date" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EXIT
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_BMCBD_":DT:EP",DIR("A")="Enter ending Referral Date:  " S Y=BMCBD D DD^%DT S Y="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
 S Y=BMCBD D DD^%DT S BMCBDD=Y S Y=BMCED D DD^%DT S BMCEDD=Y
 ;
 S BMCNCAN=1 D ADD^BMCRL01 I $D(BMCQUIT) D DEL^BMCRL K BMCQUIT G GETDATES
NUM S DIR(0)="NO^5:100:0",DIR("A")="How many entries do you want in the list",DIR("B")="10",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 I $D(DIRUT) G GETDATES
 S BMCLNO=Y
SCREEN ;
 S BMCTCW=0,BMCPTVS="R",BMCTYPE="D",BMCCTYP="T"
 K ^BMCRTMP(BMCRPT,11) S BMCCNTL="S" D ^BMCRL4 K BMCCNTL I $D(BMCQUIT) D DEL^BMCRL G GETDATES
POV ;
 K BMCPRIM,BMCALL
 S DIR(0)="SO^P:Primary Diagnosis of Referral;A:All Diagnosis of Referral (Primary and Secondary)",DIR("A")="Report should include"
 S DIR("?")="If you wish to count only the primary purpose of Referral enter a 'P'.  To include ALL purpose of visits enter an 'A'.  " D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" G SCREEN
 I Y="A" S BMCALL=""
 I Y="P" S BMCPRIM=""
 ;
CHRT ;
 S DIR(0)="S^L:List of items with Counts;B:Bar Chart (132 col)",DIR("A")="Select TYPE OF OUTPUT",DIR("B")="L" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G POV
 S BMCCHRT=Y
ZIS ;
 K BMCANS,BMCCNT,BMCCRIT,BMCCUT,AMQQTAX,BMCDISP,BMCHIGH,BMCI,BMCCAN,BMCSEL,BMCSKIP,BMCTEXT,BMCVAR,BMCVIEN,BMCRREC
 S XBRC="^BMCTEN1",XBRP="^BMCTENP",XBNS="BMC",XBRX="EXIT^BMCTEN"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;
 D EXIT^BMCTEN1
 Q
 ;
 ;
 ;
 ;
