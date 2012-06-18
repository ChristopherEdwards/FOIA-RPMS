SROPR02 ;B'HAM ISC/MAM - OPERATION REPORT (FORMAT 0) ; [ 12/07/98  8:09 AM ]
 ;;3.0; Surgery ;**48,63,66,70,86**;24 Jun 93
 ;
 ; Reference to ^PSDRUG supported by DBIA #221
 ;
 I $O(^SRF(SRTN,19,0))!$O(^SRF(SRTN,23,0)) D UL W !,"OR Support Personnel:",!,"  Scrubbed",?40,"Circulating" K NURSE S CNT=0 D NURSE
 S I=0 F  S I=$O(NURSE(I)) Q:'I!SRSOUT  D
 .I $Y+8>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .W !,?2,$P(NURSE(I),"^"),?40,$P(NURSE(I),"^",2)
 Q:SRSOUT  K NURSE
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 I $O(^SRF(SRTN,6,0)) D UL W !,"Anesthesia Technique(s):" S ANE=0 F  S ANE=$O(^SRF(SRTN,6,ANE)) Q:'ANE  D ANE
 K X,SET,ANE,AGNT,CNT,DRUG,SRSP,SRAN,OTHER,OTH,OPS
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 K AB S Y=$P(SR(.2),"^") I Y D D^DIQ S AB=$P(Y,"@")_"  "_$P(Y,"@",2)
 K AE S Y=$P(SR(.2),"^",4) I Y D D^DIQ S AE=$P(Y,"@")_"  "_$P(Y,"@",2)
 D UL I $D(AB)!$D(AE) S:'$D(AB) AB="N/A" S:'$D(AE) AE="N/A" W !,"Anesthesia Begin: "_AB,?40,"Anesthesia End: "_AE
 K SRTIME S Y=$P(SR(.2),"^",2) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 W !,"Operation Begin:  "_$S($D(SRTIME):SRTIME,1:"NOT ENTERED")
 K SRTIME S Y=$P(SR(.2),"^",3) I Y D D^DIQ S SRTIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 W ?40,"Operation End:  "_$S($D(SRTIME):SRTIME,1:"NOT ENTERED")
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SROPR03
 Q
NURSE ; nurse info
 S (CNT,CIRC)=0 F  S CIRC=$O(^SRF(SRTN,19,CIRC)) Q:'CIRC  S CNT=CNT+1,Z=^SRF(SRTN,19,CIRC,0),X=$P(Z,"^"),SRX=$P(^VA(200,X,0),"^"),Y=$P(Z,"^",3),C=$P(^DD(130.28,3,0),"^",2) D:Y'="" Y^DIQ S CIRC(CNT)=$E(SRX,1,20)_" ("_Y_")"
 S (CNT,SCRU)=0 F  S SCRU=$O(^SRF(SRTN,23,SCRU)) Q:'SCRU  S CNT=CNT+1,Z=^SRF(SRTN,23,SCRU,0),X=$P(Z,"^"),SRX=$P(^VA(200,X,0),"^"),Y=$P(Z,"^",3),C=$P(^DD(130.36,3,0),"^",2) D:Y'="" Y^DIQ S SCRU(CNT)=$E(SRX,1,20)_" ("_Y_")"
 S:'$D(SCRU(1)) SCRU(1)="N/A" S:'$D(CIRC(1)) CIRC(1)="N/A"
 F I=1:1 Q:('$D(SCRU(I))&'$D(CIRC(I)))  S NURSE(I)=$S($D(SCRU(I)):SCRU(I),1:"")_"^"_$S($D(CIRC(I)):CIRC(I),1:"")
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
PAGE W !!!,"Press RETURN to continue, or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report,  or '^' to return to the",!,"previous menu." G PAGE
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD                       OPERATION REPORT        PAGE "_SRPAGE W !
 Q
ANE ; print anesthesia technique
 S A=^SRF(SRTN,6,ANE,0),Y=$P(A,"^"),C=$P(^DD(130.06,.01,0),"^",2) D:Y'="" Y^DIQ W !,?2,Y W:$P(A,"^",3)="Y" "  (PRINCIPAL)" D AGENT
 Q
AGENT ; print agents
 Q:$P(A,"^")="N"
 W !,"     Agent: " I '$O(^SRF(SRTN,6,ANE,1,0)) W "NONE ENTERED" Q
 S (AGNT,CNT)=0 F  S AGNT=$O(^SRF(SRTN,6,ANE,1,AGNT)) Q:'AGNT  S CNT=CNT+1,X=$P(^SRF(SRTN,6,ANE,1,AGNT,0),"^"),DRUG=$P(^PSDRUG(X,0),"^") W:CNT>1 ! W ?13,DRUG
 Q
