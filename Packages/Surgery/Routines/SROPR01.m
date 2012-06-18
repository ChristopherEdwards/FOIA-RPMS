SROPR01 ;B'HAM ISC/MAM - OPERATION REPORT 516 (FORMAT 0) ; [ 04/14/97  2:13 PM ]
 ;;3.0; Surgery ;**48,63,66**;24 Jun 93
 U IO S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT
 S SRSOUT=0,SRUL="" F X=1:1:80 S SRUL=SRUL_"_"
 S SRPAGE=0,SRT=$S($E(IOST)="P":"UL",1:"") D HDR^SROPRPT Q:SRSOUT
 F NODE=0:.1:1.1 S SR(NODE)=$G(^SRF(SRTN,NODE))
 D NOW^%DTC S Y=$E(%,1,12) D D^DIQ S SROPDT=$P(Y,"@")_" "_$P(Y,"@",2)
 D UL S X=$P($G(^SRF(SRTN,33)),"^") W !,"Preoperative Diagnosis: ",!,"  Primary: "_$S(X'="":X,1:"NOT ENTERED")
 I $O(^SRF(SRTN,14,0)) S (DIAG,CNT)=0 F  S DIAG=$O(^SRF(SRTN,14,DIAG)) Q:'DIAG  S CNT=CNT+1,X=$P(^SRF(SRTN,14,DIAG,0),"^") W !,$S(CNT=1:"  Other:   ",1:""),?10,X
 D UL Q:SRSOUT  S X=$P(SR(.1),"^",4) D PERSON W !,"Surgeon:",?16,$E(X,1,20)
 S Y=$P(SR(0),"^",10),C=$P(^DD(130,.035,0),"^",2) D:Y'="" Y^DIQ W ?36,"Surgical Priority: "_$S(Y'="":Y,1:"NOT ENTERED")
 S X=$P(SR(.1),"^",13) D PERSON S:X="N/A" X="NOT ENTERED" W !,"Attend Surgeon:",?16,$E(X,1,20)
 S X=$P(SR(.1),"^",16),X=$S(X=0:"0. STAFF",X=1:"1. ATTENDING IN O.R.",X=2:"2. ATTENDING IN O.R. SUITE",X=3:"3. NOT PRESENT, BUT AVAILABLE",1:"NOT ENTERED") W ?36,"Attend Code: "_X
 K FIRST S X=$P(SR(.1),"^",5) D PERSON S FIRST=X
 K SECOND S X=$P(SR(.1),"^",6) D PERSON S SECOND=X
 I FIRST'="N/A"!(SECOND'="N/A") W !,"1st Assistant:  "_$E(FIRST,1,20),?36,"2nd Assistant: "_$E(SECOND,1,20)
 I $O(^SRF(SRTN,28,0)) W !!,"Other Scrubbed Assistants: " S (OTH,CNT)=0 F  S OTH=$O(^SRF(SRTN,28,OTH)) Q:'OTH  S CNT=CNT+1,X=$P(^SRF(SRTN,28,OTH,0),"^") D PERSON W:CNT>1 ! W ?27,X
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S X=$P(SR(.3),"^") D PERSON S SRANE=$E(X,1,20)
 S X=$P(SR(.3),"^",3) D PERSON S SRANASS=$E(X,1,20)
 S X=$P(SR(.3),"^",4) D PERSON S SRANATT=$E(X,1,20)
 I SRANE'="N/A"!(SRANASS'="N/A") D UL W !,"Anesthetist: "_SRANE,?40,"Asst. Anesthetist: "_SRANASS
 I SRANATT'="N/A" W !,"Attending Anesthesiologist: "_SRANATT
 K SRANE,SRANASS,SRANATT
 I X S X=$P(^SRO(132.95,X,0),"^") W !,"Anesthesia Supervisor Code: "_X
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S X=$P(SR(.1),"^",19) D PERSON S PERF=$E(X,1,20)
 S X=$P(SR(.1),"^",20) D PERSON S PERFA=$E(X,1,20)
 I PERF'="N/A"!(PERFA'="N/A") D UL W !,"Perfusionist: "_PERF,?40,"Asst. Perfusionist: "_PERFA
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)'="P" D HDR Q:SRSOUT
 D ^SROPR02
 Q
UL ; underline
 Q:SRSOUT  I SRT'="UL" W ! Q
 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13),SRUL
 Q
PERSON ; get person name
 S X=$S(X:$P(^VA(200,X,0),"^"),1:"N/A")
 Q
FOOT ; print footer
 Q:SRSOUT  I $E(IOST)'="P" D PAGE Q
 I IOSL-10>$Y F X=$Y:1:(IOSL-10) W !
 D UL W !,"SURGEON'S SIG: ",?50,SROPDT D UL W !,VADM(1),?50,"AGE: "_VADM(4),?60,"ID#: "_VA("PID"),!,"WARD: "_$G(^DPT(DFN,.1)),?50,"ROOM-BED: "_$G(^DPT(DFN,.101))
 D UL W !,"VAMC: "_SRSITE("SITE"),?50,"REPLACEMENT FORM 516",!
 Q
IM ;Code below modified for Imaging
PAGE W !!!,"Press RETURN to continue," W:$D(SRIMAGE) "I to view Images," W "or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report," W:$D(SRIMAGE) "I to view Images associated with this report," W " or '^' to return to the",!,"previous menu." G PAGE
 I X["I",$D(SRIMAGE) D ^MAGDSSR G PAGE
 ;Code above added for Imaging
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 I '$D(SR(0)) Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 W:$E(IOST)="P" !!! W ! D UL W !,?5,"MEDICAL RECORD                       OPERATION REPORT        PAGE "_SRPAGE W !
 Q
