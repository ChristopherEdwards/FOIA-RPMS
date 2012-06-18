SRONIN4 ;B'HAM ISC/MAM - NURSE INTRAOP REPORT (FORMAT 1) ; [ 11/24/98  10:20 AM ]
 ;;3.0; Surgery ;**25,48,86**;24 Jun 93
 ;
 ; Reference to ^PSDRUG supported by DBIA #221
 ;
 D UL W !,"Material Sent to Laboratory for Analysis:",!,"Specimens: "
 I '$O(^SRF(SRTN,9,0)) W "N/A"
 S SRSP=0 F  S SRSP=$O(^SRF(SRTN,9,SRSP)) Q:'SRSP!SRSOUT  D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .W !,?2,^SRF(SRTN,9,SRSP,0)
 Q:SRSOUT  I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 W !,"Cultures:  " I '$O(^SRF(SRTN,41,0)) W "N/A"
 S SRSP=0 F  S SRSP=$O(^SRF(SRTN,41,SRSP)) Q:'SRSP!SRSOUT  D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .W !,?2,^SRF(SRTN,41,SRSP,0)
 Q:SRSOUT  I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Anesthesia Technique(s):" S ANE=0 F  S ANE=$O(^SRF(SRTN,6,ANE)) Q:'ANE  D ANE
 I '$O(^SRF(SRTN,6,0)) W " N/A"
 Q:SRSOUT  K X,SET,ANE,AGNT,CNT,DRUG,SRSP,SRAN,OTHER,OTH,OPS
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S SR(3)=$G(^SRF(SRTN,3)) W !,"Tubes and Drains: " S X=$P(SR(3),"^") S:X="" X="N/A" I X'="N/A" W !,?2,X
 I X="N/A" W "N/A"
 I $Y+14>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Tourniquet: " I '$O(^SRF(SRTN,2,0)) W "N/A"
 S TOUR=0 F  S TOUR=$O(^SRF(SRTN,2,TOUR)) Q:'TOUR  D TOUR
 K X,SET,FIELD,TIME,TIME2,M,APBY,PRESS
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SRONIN5
 Q
ANE ; print anesthesia technique
 I $Y+11>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 S A=^SRF(SRTN,6,ANE,0),Y=$P(A,"^"),C=$P(^DD(130.06,.01,0),"^",2) D:Y'="" Y^DIQ W !,?2,Y W:$P(A,"^",3)="Y" "  (PRINCIPAL)" D AGENT
 Q
AGENT ; print agents
 Q:$P(A,"^")="N"
 W !,"     Agent: " I '$O(^SRF(SRTN,6,ANE,1,0)) W "NONE ENTERED" Q
 S (AGNT,CNT)=0 F  S AGNT=$O(^SRF(SRTN,6,ANE,1,AGNT)) Q:'AGNT!SRSOUT  D
 .S CNT=CNT+1,X(0)=^SRF(SRTN,6,ANE,1,AGNT,0),X=$P(X(0),"^"),DRUG=$P(^PSDRUG(X,0),"^") W:CNT>1 ! W ?13,DRUG
 .S X=$P(X(0),"^",2) W:X "  "_X_" mg"
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 Q
TOUR ; tourniquet info
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 S M=^SRF(SRTN,2,TOUR,0),Y=$P(M,"^") D D^DIQ S TIME=$P(Y,"@")_"  "_$P(Y,"@",2),Y=$P(M,"^",4) S TIME2="NOT ENTERED" I Y D D^DIQ S TIME2=$P(Y,"@")_"  "_$P(Y,"@",2)
 S Y=$P(M,"^",2),C=$P(^DD(130.02,1,0),"^",2) D:Y'="" Y^DIQ S SITE=Y,PRESS=$P(M,"^",5) I PRESS="" S PRESS="N/A"
 S X=$P(M,"^",3),APBY=$S(X="":"N/A",1:$P(^VA(200,X,0),"^"))
 W !,?2,"Time Applied: "_TIME,?40,"Time Released: "_TIME2,!,?4,"Site Applied: "_$S(SITE'="":SITE,1:"NOT ENTERED"),?40,"Pressure Applied (in TORR): "_PRESS,!,?4,"Applied By: "_APBY
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
PAGE W !!!,"Press RETURN to continue, or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report, or '^' to return to the",!,"previous menu." G PAGE
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD          |   NURSE INTRAOPERATIVE REPORT        PAGE "_SRPAGE W !
 Q
