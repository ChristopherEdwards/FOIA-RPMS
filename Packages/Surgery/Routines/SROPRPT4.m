SROPRPT4 ;B'HAM ISC/MAM - OPERATION REPORT (FORMAT 1) ; [ 04/14/97  2:39 PM ]
 ;;3.0; Surgery ;**66**;24 Jun 93
 S SR(31)=$G(^SRF(SRTN,31))
 D UL K SRTIME S Y=$P(SR(31),"^",6) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 W !,"Date/Time of Dictation: "_$S($D(SRTIME):SRTIME,1:"NOT ENTERED")
 K SRTIME S Y=$P(SR(31),"^",7) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 W !,"Date/Time Transcribed:  "_$S($D(SRTIME):SRTIME,1:"NOT ENTERED")
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Indications for Operation: " S IND=0 F  S IND=$O(^SRF(SRTN,40,IND)) Q:'IND  W !,?2,^SRF(SRTN,40,IND,0)
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Surgeon's Dictation: " I '$O(^SRF(SRTN,12,0)) W "N/A"
 I $O(^SRF(SRTN,12,0)) S SD=0 F  S SD=$O(^SRF(SRTN,12,SD)) Q:'SD!(SRSOUT)  D DICT
 I $E(IOST)'="P" Q
 D FOOT
 Q
DICT ; print surgeon's dictation
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT  D UL
 W !,^SRF(SRTN,12,SD,0)
 Q
FOOT ; print footer
 Q:SRSOUT  I $E(IOST)'="P" D PAGE Q
 I IOSL-10>$Y F X=$Y:1:(IOSL-10) W !
 D UL W !,"SURGEON'S SIG: ",?50,SROPDT D UL W !,VADM(1),?50,"AGE: "_VADM(4),?60,"ID#: "_VA("PID"),!,"WARD: "_$G(^DPT(DFN,.1)),?50,"ROOM-BED: "_$G(^DPT(DFN,.101))
 D UL W !,"VAMC: "_SRSITE("SITE"),?50,"REPLACEMENT FORM 516",!
 Q
UL ; underline on printer
 Q:SRSOUT  I SRT'="UL" W ! Q
 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13),SRUL
 Q
IM ;Code below modified for Imaging ;SRR 05/22/94
PAGE W !!!,"Press RETURN to continue," W:$D(SRIMAGE) "I to view Images," W "or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report," W:$D(SRIMAGE) "I to view Images associated with this report," W " or '^' to return to the",!,"previous menu." G PAGE
 I X["I",$D(SRIMAGE) D ^MAGDSSR G PAGE
 ;Code above modified for Imaging ;SRR 05/22/94
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD                       OPERATION REPORT        PAGE "_SRPAGE W !
 Q
