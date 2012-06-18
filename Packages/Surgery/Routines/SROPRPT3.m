SROPRPT3 ;BIR/MAM - OPERATION REPORT (FORMAT 1) ; [ 05/12/99  2:38 PM ]
 ;;3.0; Surgery ;**48,66,88**;24 Jun 93
 S SR(3)=$G(^SRF(SRTN,3)),X=$P(SR(3),"^") D UL W !,"Tubes and Drains: " W !,?2,$S(X'="":X,1:"N/A")
 D UL W !,"Tourniquet: " W:'$O(^SRF(SRTN,2,0)) "N/A" I $O(^SRF(SRTN,2,0)) S TOUR=0 F  S TOUR=$O(^SRF(SRTN,2,TOUR)) Q:'TOUR  D TOUR
 K M,TIME,TIME2,SET,FIELD,Y
 D UL W !,"Material Sent to Laboratory for Analysis:"
 W !,"Specimens: " W:'$O(^SRF(SRTN,9,0)) "N/A" S SRSP=0 F  S SRSP=$O(^SRF(SRTN,9,SRSP)) Q:'SRSP  W !,?2,^SRF(SRTN,9,SRSP,0)
 W !,"Cultures:  " W:'$O(^SRF(SRTN,41,0)) "N/A" S SRSP=0 F  S SRSP=$O(^SRF(SRTN,41,SRSP)) Q:'SRSP  W !,?2,^SRF(SRTN,41,SRSP,0)
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Postoperative Diagnosis: " S X=$G(^SRF(SRTN,34)),DIAG=$P(X,"^"),CODE=$P(X,"^",2) S:CODE CODE=$P(^ICD9(CODE,0),"^") I DIAG="" W "NOT ENTERED"
 I DIAG'="" W !,"  Primary: "_DIAG,?55,"ICD9 Code: "_$S(CODE'="":CODE,1:"NOT ENTERED") S (OTH,CNT)=0 F  S OTH=$O(^SRF(SRTN,15,OTH)) Q:'OTH  S CNT=CNT+1 D DIAG
 I $Y+15>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S SRMAJ=$P(SR(0),"^",3),SRMAJ=$S(SRMAJ="J":"Major",SRMAJ="N":"Minor",1:"Major")
 D UL W !,SRMAJ_" Operations Performed:",!,"Primary: " D PRIN
 I $O(^SRF(SRTN,13,0)) D OTHER Q:SRSOUT
 K SROPS,CPT,SROPS,SROPER,SROPERS,SROTHER,SRMAJ,SRLONG
 I $Y+15>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 W !!,"Concurrent Procedure(s): " S CON=$P($G(^SRF(SRTN,"CON")),"^") I 'CON W "N/A"
 S SRTN("OLD")=SRTN I CON S SRTN=CON D PRIN
 K CON,CPT,X S SRTN=SRTN("OLD") K SRTN("OLD")
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SROPRPT4
 Q
PRIN ; print principal procedure information
 S SROPER=$P(^SRF(SRTN,"OP"),"^"),X=$P(^("OP"),"^",2),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 I $P($G(^SRF(SRTN,30)),"^")&$P($G(^SRF(SRTN,.2)),"^",10) S SROPER="** ABORTED ** "_SROPER
 K SROPS,MM,MMM S:$L(SROPER)<70 SROPS(1)=SROPER I $L(SROPER)>69 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W SROPS(1) I $D(SROPS(2)) W !,?9,SROPS(2) I $D(SROPS(3)) W !,?9,SROPS(3)
 W !,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,"OPMOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,"OPMOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 Q
DIAG W ! W:CNT=1 "  Other:   " W ?10,$P(^SRF(SRTN,15,OTH,0),"^")
 S X=$P(^SRF(SRTN,15,OTH,0),"^",3),X=$S(X:$P(^ICD9(X,0),"^"),1:"NOT ENTERED") W ?55,"ICD9 Code: "_X
 Q
OTHER ; other procedures
 W ! S (OTH,CNT)=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH  S CNT=CNT+1 D OTH Q:SRSOUT
 Q
OTH I $Y+15>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S OTHER=$P(^SRF(SRTN,13,OTH,0),"^"),X=$P($G(^SRF(SRTN,13,OTH,2)),"^"),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 W !,"Other:   "_OTHER,!,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,13,OTH,"MOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,13,OTH,"MOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 Q
LOOP ; break procedure if greater than 70 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<70  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
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
 I X["?" W !!,"Press RETURN to continue with this report, or '^' to return to the",!,"previous menu." G PAGE
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD                       OPERATION REPORT        PAGE "_SRPAGE W !
 Q
TOUR ; tourniquet info
 S M=^SRF(SRTN,2,TOUR,0),Y=$P(M,"^") D D^DIQ S TIME=$P(Y,"@")_"  "_$P(Y,"@",2),Y=$P(M,"^",4) S TIME2="NOT ENTERED" I Y D D^DIQ S TIME2=$P(Y,"@")_"  "_$P(Y,"@",2)
 S Y=$P(M,"^",2),C=$P(^DD(130.02,1,0),"^",2) D:Y'="" Y^DIQ S SITE=Y
 W !,?2,"Time Applied: "_TIME,?40,"Time Released: "_TIME2,!,?2,"Site Applied: "_$S(SITE'="":SITE,1:"NOT ENTERED")
 Q
