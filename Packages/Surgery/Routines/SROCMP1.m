SROCMP1 ;B'HAM ISC/MAM - Perioperative Occurrences ; [ 07/27/98   2:33 PM ]
 ;;3.0; Surgery ;**38,50**;24 Jun 93
EN ; entry point
 S (SRSOUT,SRSP)=0 G:SRBOTH DEV
SPEC W @IOF,! K DIR S DIR("A")="Do you want to print this report for all Surgical Specialties ",DIR("B")="YES",DIR(0)="Y"
 S DIR("?",1)="Enter RETURN to print this report for all surgical specialties, or 'NO' to",DIR("?")="select a specific specialty."
 D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 G END
 I 'Y D SP I SRSOUT G END
DEV S SRGRAMM=$S(SRBOTH:"These reports are ",1:"This report is ")
 K IOP,%ZIS,POP,IO("Q") S %ZIS("A")="Print the Report on which Device: ",%ZIS="QM" W !!,SRGRAMM_"designed to use a 132 column format.",! D ^%ZIS I POP S SRSOUT=1 G END
 I $D(IO("Q")) K IO("Q") S ZTDESC="PERIOPERATIVE OCCURRENCES",ZTRTN="BEG^SROCMP",(ZTSAVE("SRBOTH"),ZTSAVE("SRED"),ZTSAVE("SRSD"),ZTSAVE("SRINST"),ZTSAVE("SRINSTP"),ZTSAVE("SRSP*"))="" D ^%ZTLOAD G END
 D BEG^SROCMP
END ;
 Q:'$D(SRSOUT)  I 'SRSOUT W !!,"Press RETURN to continue  " R X:DTIME
 D ^%ZISC,^SRSKILL K SRTN W @IOF
 Q
SP W !! S SRSP=1 K DIC S DIC("S")="I '$P(^(0),""^"",3)",DIC=137.45,DIC(0)="QEAMZ",DIC("A")="Print the report for which Specialty ?  " D ^DIC I Y<0 S SRSOUT=1 Q
 S SRCT=+Y,SRSP(SRCT)=+Y
MORE ; ask for more surgical specialties
 K DIC S DIC("S")="I '$P(^(0),""^"",3)",DIC=137.45,DIC(0)="QEAMZ",DIC("A")="Select an Additional Specialty:  " D ^DIC I Y>0 S SRCT=+Y,SRSP(SRCT)=+Y G MORE
 Q
