BCHRP4 ; IHS/TUCSON/LAB - All visit report driver ;  [ 04/02/01  9:36 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**12**;OCT 28, 1996
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K BCHSITE Q
 S BCHJOB=$J,BCHBTH=$H
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date of Service" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ending Date of Service" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 ;
PROG ;IHS/CMI/LAB - added program screen
 S BCHPRG=""
 S DIR(0)="Y",DIR("A")="Include data from ALL CHR Programs",DIR("?")="If you wish to include visits from ALL programs answer Yes.  If you wish to tabulate for only one program enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHPRG="" G ZIS
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
ZIS ;CALL TO XBDBQUE
 S XBRP="PRINT^BCHRP4",XBRC="PROC^BCHRP4",XBRX="XIT^BCHRP4",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 D EN^XBVK("BCH")
 K ^TMP($J)
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"****** REPORT OF # OF RECORDS/PATIENTS BY TRIBE  ******",!
 W !,"This report will tally records and patients seen by Tribe",!
 Q
 ;
 ;
PROC ;EP - called from xbdbque
VD ; Run by visit date
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 K BCHTOT K ^TMP($J)
 S BCHODAT=BCHSD_".9999" F  S BCHODAT=$O(^BCHR("B",BCHODAT)) Q:BCHODAT=""!((BCHODAT\1)>BCHED)  D V1
 Q
 ;
V1 ;
 S BCHR="" F  S BCHR=$O(^BCHR("B",BCHODAT,BCHR)) Q:BCHR'=+BCHR  I $D(^BCHR(BCHR,0)),$P(^(0),U,2)]"",$P(^(0),U,3)]"" S BCHR0=^BCHR(BCHR,0),DFN=$P(BCHR0,U,4) D PROC1
 Q
PROC1 ;
 Q:'DFN
 S BCHPROG=$P(BCHR0,U,2)
 I BCHPRG,BCHPRG'=BCHPROG Q  ;not correct program
 S T=$$TRIBE^AUPNPAT(DFN,"I")
 I T=-1 S T="UNKNOWN"
 I T="" S T="UNKNOWN"
 I T S T=$P(^AUTTTRI(T,0),U)
 S $P(BCHTOT(T),U,1)=$P($G(BCHTOT(T)),U,1)+1
 I $D(^TMP($J,"DFN",DFN)) Q  ;already counted this patient
 S ^TMP($J,"DFN",DFN)=""
 S $P(BCHTOT(T),U,2)=$P($G(BCHTOT(T)),U,2)+1
 Q
PRINT ;EP
 S BCHPG=0 S BCHQUIT=0
 I '$D(BCHTOT) D HEAD W !!,"NO DATA TO REPORT",!! Q
 D HEAD
 S BCHT="" F  S BCHT=$O(BCHTOT(BCHT)) Q:BCHT=""!(BCHQUIT)  D
 .I $Y>(IOSL-4) D HEAD Q:BCHQUIT
 .W !?3,BCHT,?50,$$C($P(BCHTOT(BCHT),U,1),0,8),?65,$$C($P(BCHTOT(BCHT),U,2),0,8)
 .Q
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
HEAD ;
 I 'BCHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT=1 Q
HEAD1 ; if terminal
 W:$D(IOF) @IOF
HEAD2 ; if printer
 S BCHPG=BCHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?33,$$FMTE^XLFDT(DT),?70,"Page ",BCHPG,!
 W $$CTR^BCHRLU($$LOC^BCHRLU),!
 S X="TALLY OF RECORDS AND PATIENTS BY TRIBE" W $$CTR^BCHRLU(X,80),!
 S BCHPROGN=$S(BCHPRG:$P(^BCHTPROG(BCHPRG,0),U)_" ("_$P(^(0),U,5)_")",1:"ALL"),X=$L(BCHPROGN)+10
 W ?((80-X)/2),"PROGRAM:  ",BCHPROGN,!
 W ?17,"REPORT DATES:  ",$$FMTE^XLFDT(BCHBD)," TO ",$$FMTE^XLFDT(BCHED),!
 W !?50,"# RECORDS",?65,"# PATIENTS",!
 W !,$TR($J(" ",80)," ","-")
 Q
ATTACH ;
 S X=$$ADD^XPDMENU("BCH M WORKLOAD REPORTS","BCH RECORDS PATIENTS BY TRIBE","TBT")
 Q
