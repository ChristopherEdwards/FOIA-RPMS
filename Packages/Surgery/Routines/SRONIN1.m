SRONIN1 ;B'HAM ISC/MAM - NURSE INTRAOP REPORT (FORMAT 1) ; 21 OCT 91  11:00 AM
 ;;3.0; Surgery ;**25,48**;24 Jun 93
 I 'SRSITE("NRPT") D ^SRONRNF Q
 U IO S SRT=$S($E(IOST)="P":"UL",1:"Q")
 S SRUL="" F LINE=1:1:80 S SRUL=SRUL_"_"
 S (SRSOUT,SRPAGE)=0,DFN=$P(^SRF(SRTN,0),"^") D ^VADPT S SRNAME=VADM(1)
 S SRWARD=$S($D(^DPT(DFN,.1)):^(.1),1:""),SRBED=$S($D(^DPT(DFN,.101)):^(.101),1:"")
 D NOW^%DTC S Y=$E(%,1,12) D D^DIQ S SRDTNOW=Y
 S SR(0)="" D HDR G:SRSOUT END
 F X=0:.1:1.1,31,"1.0" S SR(X)=$G(^SRF(SRTN,X))
 S SROR=$P(SR(0),"^",2) I SROR S SROR=$P(^SRS(SROR,0),"^"),SROR=$P(^SC(SROR,0),"^")
 S Y=$P(SR(0),"^",10),C=$P(^DD(130,.035,0),"^",2) D:Y'="" Y^DIQ S SRTYPE=Y
 D UL W !,"Operating Room:  "_SROR,?40,"Surgical Priority: "_SRTYPE
 D UL K SRTIME S Y=$P(SR(.2),"^",15) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S:'$D(SRTIME) SRTIME="NOT ENTERED" W !,"Patient in Hold: ",?17,SRTIME
 K SRTIME S Y=$P(SR(.2),"^",10) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S:'$D(SRTIME) SRTIME="NOT ENTERED" W ?40,"Patient in OR: ",?59,SRTIME
 K SRTIME S Y=$P(SR(.2),"^",2) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S:'$D(SRTIME) SRTIME="NOT ENTERED" W !,"Operation Begin: ",?17,SRTIME
 K SRTIME S Y=$P(SR(.2),"^",3) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S:'$D(SRTIME) SRTIME="NOT ENTERED" W ?40,"Operation End: ",?59,SRTIME
 K SRTIME S Y=$P(SR(.2),"^",9) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 W ! I $D(SRTIME) W "Surgeon in OR: ",?17,SRTIME
 K SRTIME S Y=$P(SR(.2),"^",12) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S:'$D(SRTIME) SRTIME="NOT ENTERED" W ?40,"Patient Out OR: ",?59,SRTIME
 D UL K SRSUR S X=$P(SR(.1),"^",4) I X S SRSUR=$P(^VA(200,X,0),"^") I $L(SRSUR)>22 S SRSUR=$P(SRSUR,",")_","_$E($P(SRSUR,",",2),1)_"."
 S:'$D(SRSUR) SRSUR="NOT ENTERED" W !,"Surgeon: ",?17,SRSUR K SRSUR
 S X=$P(SR(.1),"^",5) I X S SRSUR=$P(^VA(200,X,0),"^") I $L(SRSUR)>20 S SRSUR=$P(SRSUR,",")_","_$E($P(SRSUR,",",2))_"."
 S:'$D(SRSUR) SRSUR="N/A" W ?40,"First Assistant:",?59,SRSUR K SRSUR
 S X=$P(SR(.1),"^",13) I X S SRSUR=$P(^VA(200,X,0),"^") I $L(SRSUR)>22 S SRSUR=$P(SRSUR,",")_","_$E($P(SRSUR,",",2))_"."
 S:'$D(SRSUR) SRSUR="NOT ENTERED" W !,"Attending Surg:",?17,SRSUR K SRSUR
 S X=$P(SR(.1),"^",6) I X S SRSUR=$P(^VA(200,X,0),"^") I $L(SRSUR)>20 S SRSUR=$P(SRSUR,",")_","_$E($P(SRSUR,",",2))_"."
 S:'$D(SRSUR) SRSUR="N/A" W ?40,"Second Assistant:",?59,SRSUR
 K SRANES S X=$P(SR(.3),"^") I X S SRANES=$P(^VA(200,X,0),"^") I $L(SRANES)>22 S SRANES=$P(SRANES,",")_","_$E($P(SRANES,",",2))_"."
 K SRANESA S X=$P(SR(.3),"^",3) I X S SRANESA=$P(^VA(200,X,0),"^") I $L(SRANESA)>20 S SRANESA=$P(SRANESA,",")_","_$E($P(SRANESA,",",2))_"."
 S:'$D(SRANES) SRANES="NOT ENTERED" S:'$D(SRANESA) SRANESA="N/A" W !,"Anesthetist: ",?17,SRANES,?40,"Assistant Anesth:",?59,SRANESA K SRANES
 D UL W !,"Other Scrubbed Assistants: " K OTHER S CNT=0 S SHEMP=0 F  S SHEMP=$O(^SRF(SRTN,28,SHEMP)) Q:'SHEMP!SRSOUT  S CNT=CNT+1 D OTHER
 G:SRSOUT END I '$D(OTHER(1)) W ?27,"N/A"
 I $Y+13>IOSL D FOOT G:SRSOUT END I $E(IOST)="P" D HDR G:SRSOUT END
 D ^SRONIN2 K SR(0) I SRSOUT G END
 D FOOT S SRSOUT=1
END W:$E(IOST)="P" @IOF I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 D ^%ZISC,^SRSKILL I $D(SRSITE("KILL")) K SRSITE W @IOF
 Q
OTHER ; other scrubbed assistants
 I $Y+12>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR,UL Q:SRSOUT
 S X=$P(^SRF(SRTN,28,SHEMP,0),"^"),OTHER(CNT)=$P(^VA(200,X,0),"^")
 W !,?2,OTHER(CNT) I '$O(^SRF(SRTN,28,SHEMP,1,0)) Q
 W !,?4,"Comments:" K ^UTILITY($J,"W") S CM=0 F  S CM=$O(^SRF(SRTN,28,SHEMP,1,CM)) Q:'CM  S X=^SRF(SRTN,28,SHEMP,1,CM,0),DIWL=6,DIWR=79 D ^DIWP
 I $D(^UTILITY($J,"W")) F J=1:1:^UTILITY($J,"W",6) D OSACM Q:SRSOUT
 K ^UTILITY($J,"W")
 Q
OSACM ; other scrubbed assistants comments
 I $Y+10>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR,UL Q:SRSOUT
 W !,?6,^UTILITY($J,"W",6,J,0)
 Q
FOOT ; print footer
 Q:SRSOUT  I $E(IOST)'="P" D PAGE Q
 I IOSL-10>$Y F X=$Y:1:(IOSL-10) W !
 W ! D UL W !,"NURSE'S SIG: ",?50,SRDTNOW
 D UL W !,SRNAME,?50,VA("PID"),!,"WARD: "_SRWARD,?50,"ROOM-BED: "_SRBED
 D UL W !,"VAMC: "_SRSITE("SITE"),?50,"SF 509 PROGRESS NOTES"
 Q
UL ; underline on printer
 Q:SRSOUT  I SRT'="UL" W ! Q
 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13),SRUL
 Q
PAGE W !!!,"Press RETURN to continue, or '^' to quit: " R X:DTIME I '$T!(X["^") K SR(0) S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report, or '^' to return to the",!,"previous menu." G PAGE
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 I '$D(SR(0)) Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD          |   NURSE INTRAOPERATIVE REPORT        PAGE "_SRPAGE W !
 Q
