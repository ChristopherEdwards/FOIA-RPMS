AMHBL ; IHS/CMI/LAB - backload pcc visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;given a date range this routine will backoad pcc visits from mhsss
 ;
EP ;
 S AMHBL=""
 W !!,"This routine will backload PCC visits from the BH package for a date",!,"range specified by the user.",!
 D ^AMHLEIN
 I 'AMHLPCC W !!,"No PCC link is active.  Check PCC Master Control file, or MHSS Site Parameter",!,"file.",!! G XIT
 I $P(^AMHSITE(DUZ(2),0),U,33)=1 W !!,"*** PLEASE TURN OFF THE INTERACTIVE PCC LINK BEFORE YOU RUN THIS ROUTINE",!,"AND THEN REMEMBER TO SET IT BACK WHEN DONE.",!
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range for which visits will be created from BH package.",!
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter ending Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 ;
CONT ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I 'Y G XIT
D ; Run by encounter date
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D D1
 Q
 ;
D1 ;
 S (AMHR,AMHRCNT)=0 F  S AMHR=$O(^AMHREC("B",AMHODAT,AMHR)) Q:AMHR'=+AMHR  I $D(^AMHREC(AMHR,0)),$P(^(0),U,2)]"",$P(^(0),U,3)]"" S AMHR0=^(0) D PROC
 Q
PROC ;
 Q:$P($G(^AMHREC(AMHR,11)),U,10)  ;EHR VISIT NO PCC LINK
 ;W "."
 S AMHPTYPE=$P(^AMHREC(AMHR,0),U,2)
 I $P(AMHR0,U,16) Q  ;already in PCC S AMHACTN=2 D PCCLINK^AMHLE2 Q
 W "."
 S AMHACTN=1 D PCCLINK^AMHLE2
 Q
XIT ;
 W !!,"ALL DONE",!
 K AMHBL,AMHR,AMHRCNT,AMHSD,AMHBD,AMHED,AMHODAT,AMHR0,AMHACTN,AMHBDD,AMHEDD,AMHLPCC
 D ^AMHEKL
 Q
