SRODCT1 ;B'HAM ISC/MAM - LIST UNDICTATED CASES ; [ 09/22/98  11:32 AM ]
 ;;3.0; Surgery ;**77,50**;24 Jun 93
HDR ; print heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRQ=1 Q
 S SRHDR=1 W:$Y @IOF W !,?11,"UNDICTATED OPERATIONS FOR "_SRS
 I SRFLG W !,?11,SRFRTO
 W:$E(IOST)="P" !,?11,SRPRINT
 W !!,"CASE #",?11,"PATIENT",?50,"SURGEON",!,?11,"OPERATION DATE",?50,"WARD LOCATION",! F LINE=1:1:80 W "="
 Q
SET ; set up ^TMP("SR",$J)
 S SRSDATE=$P(^SRF(SRTN,0),"^",9) I SRFLG Q:SRSDATE>SRSEDT!(SRSDATE<SRSDT)
 S Y=SRSDATE D D^DIQ S SRODT=Y
 D DEM^VADPT S SRNM=VADM(1)_" ("_VA("PID")_")"
 S SRWARD=$S($D(^DPT(DFN,.101)):^DPT(DFN,.1)_" "_^DPT(DFN,.101),1:"OUTPATIENT"),SRSS=$P(^SRF(SRTN,0),"^",4) I SRSS S SRSS=$P(^SRO(137.45,SRSS,0),"^"),SRSS=$P(SRSS,"(",1)
 S:SRSS="" SRSS="UNKNOWN" S SRSOP=$P(^SRF(SRTN,"OP"),"^"),SRSUR="" I $D(^SRF(SRTN,.1)),$P(^(.1),"^",4) S SRSUR=$P(^VA(200,$P(^(.1),"^",4),0),"^")
 S ^TMP("SR",$J,SRSS,SRSDATE,SRTN)=SRNM_"^"_SRSUR_"^"_SRODT_"^"_SRWARD_"^"_SRSOP
 Q
UTL ; loop through ^TMP("SR",$J)
 S (SRS,SRDT,SRHDR,SRTN,SRQ)=0
 F  S SRS=$O(^TMP("SR",$J,SRS)) Q:SRS=""!SRQ  D:SRHDR=1 ASK Q:SRQ  D HDR F  S SRDT=$O(^TMP("SR",$J,SRS,SRDT)) Q:'SRDT!SRQ  F  S SRTN=$O(^TMP("SR",$J,SRS,SRDT,SRTN)) Q:'SRTN!SRQ  D PRINT
 I '$D(^TMP("SR",$J)) W $$NODATA^SROUTL0()
 Q
PRINT ; print data from ^TMP("SR",$J)
 S SRUTL=^TMP("SR",$J,SRS,SRDT,SRTN),SRSOP=$P(SRUTL,"^",5) I $Y+6>IOSL D ASK Q:SRQ  D HDR Q:SRQ
 K SROPS,MM,MMM S:$L(SRSOP)<65 SROPS(1)=SRSOP I $L(SRSOP)>64 S SRSOP=SRSOP_"  " F M=1:1 D LOOP Q:MMM=""
 W !!," "_SRTN,?11,$P(SRUTL,"^"),?50,$P(SRUTL,"^",2),!,?11,$P(SRUTL,"^",3),?50,$P(SRUTL,"^",4),!,?11,SROPS(1) I $D(SROPS(2)) W !,?11,SROPS(2) I $D(SROPS(3)) W !,?11,SROPS(3) I $D(SROPS(4)) W !,?11,SROPS(4)
 Q
ASK I $E(IOST)'="P" W !!,"Press RETURN to continue, or '^' to quit:   " R X:DTIME S:'$T X="^" S:X["^" SRQ=1 I X["^" Q
 Q
EN1 ; find operations not dictated
 S (SDATE,EDATE)="",(SRFLG,SRQ)=0 W @IOF,!,"List of Undictated Operations",!!
 K DIR S DIR("A")="Enter selection",DIR("A",1)="How do you want this report printed ?",DIR("A",2)=" ",DIR("A",3)="   (1) Print ALL undictated operations.",DIR("A",4)="   (2) Print undictated operations for a selected DATE range."
 S DIR("A",5)=" ",DIR("B")="1",DIR("?")="Enter 1 or A to print ALL undictated operations or enter 2 or D to print the report for a selected DATE range."
 S DIR(0)="F^1:1^K:""12AaDd""'[X X" D ^DIR I $D(DTOUT)!$D(DUOUT) G END
 I Y=2!(Y="D") S SRFLG=1 D DATE G:SRQ END
 I $D(^XUSEC("SROCHIEF",+DUZ)) N SRINSTP S SRINST=$$INST^SROUTL0() G:SRINST="^" END S SRINSTP=$P(SRINST,U)
 K IOP,%ZIS,POP,IO("Q") S %ZIS("A")="Print the Report on which Device: ",%ZIS="Q" D ^%ZIS G:POP END
 I $D(IO("Q")) K IO("Q") S ZTDESC="Undictated Operations",ZTRTN="UD^SRODCT1",(ZTSAVE("SDATE"),ZTSAVE("EDATE"),ZTSAVE("SRFLG"),ZTSAVE("SRSITE*"),ZTSAVE("SRINSTP"))="" D ^%ZTLOAD G END
UD ; entry when queued
 U IO K ^TMP("SR",$J) S (SRQ,FLG,SRTN,CNT)=0 I SRFLG S SRSDT=SDATE-.0001,SRSEDT=EDATE+.9999
 N SRFRTO S Y=SDATE X ^DD("DD") S SRFRTO="FOR "_Y_"  TO " S Y=EDATE X ^DD("DD") S SRFRTO=SRFRTO_Y
 S PAGE=1,Y=DT X ^DD("DD") S SRPRINT="DATE PRINTED: "_Y
 F  S SRTN=$O(^SRF("AUD",SRTN)) Q:SRTN=""!SRQ  I $P($G(^SRF(SRTN,30)),"^")="" S DFN=$P(^SRF(SRTN,0),"^"),Z=0 D
 .I $D(^XUSEC("SROCHIEF",+DUZ)) I $$MANDIV^SROUTL0(SRINSTP,SRTN) D SET
 .I '$D(^XUSEC("SROCHIEF",+DUZ)) I $$DIV^SROUTL0(SRTN) D SET
 D UTL D:'SRQ ASK W:$E(IOST)="P" @IOF I $D(ZTQUEUED) K ^TMP("SR",$J) Q:$G(ZTSTOP)  S ZTREQ="@" Q
END D ^%ZISC W @IOF D ^SRSKILL K SRTN
 Q
LOOP ; break procedure if greater than 65 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SRSOP," "),MMM=$P(SRSOP," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<65  S SROPS(M)=SROPS(M)_MM_" ",SRSOP=MMM
 Q
DATE D DATE^SROUTL(.SDATE,.EDATE,.SRQ)
 Q
