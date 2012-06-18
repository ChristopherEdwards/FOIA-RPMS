SRONIN5 ;B'HAM ISC/MAM - NURSE INTRAOP REPORT (FORMAT 1) ; 30 OCT 91 11:35 AM
 ;;3.0; Surgery ;**18,22,25,48**;24 Jun 93
 D UL W !,"Thermal Unit: " I '$O(^SRF(SRTN,21,0)) W "N/A"
 S (TH,CNT)=0 F  S TH=$O(^SRF(SRTN,21,TH)) Q:'TH!SRSOUT  S CNT=CNT+1 D THERM
 Q:SRSOUT  I $Y+14>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Prosthesis Installed: " I '$O(^SRF(SRTN,1,0)) W "N/A"
 S (PRO,CNT)=0 F  S PRO=$O(^SRF(SRTN,1,PRO)) Q:'PRO!(SRSOUT)  S CNT=CNT+1 D PRO
 Q:SRSOUT  K PRO,UNIT,MODEL,SERIAL,SIZE,CNT,X,TH,TEMP,ON,OFF,Y,I,STERILE,QTY,Z
 I $O(^SRF(SRTN,22,0)),$Y+16>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 I '$O(^SRF(SRTN,22,0)),$Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Medications: " I '$O(^SRF(SRTN,22,0)) W "N/A"
 S (MED,CNT)=0 F  S MED=$O(^SRF(SRTN,22,MED)) Q:'MED!(SRSOUT)  S CNT=CNT+1 D MED
 Q:SRSOUT  K MED,X,TIME I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Irrigation Solution(s): " I '$O(^SRF(SRTN,26,0)) W "N/A"
 S IRR=0 F  S IRR=$O(^SRF(SRTN,26,IRR)) Q:'IRR!(SRSOUT)  S X=^SRF(SRTN,26,IRR,0),SOLU=$P(^SRO(133.6,X,0),"^") D IRR
 K IRR,TIME,MM,AMT,DOC,SOLU,X I SRSOUT Q
 I $O(^SRF(SRTN,4,0)),$Y+14>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 I '$O(^SRF(SRTN,4,0)),$Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SRONIN6
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
THERM ; thermal unit
 S UNIT=^SRF(SRTN,21,TH,0),TEMP=$P(UNIT,"^",3),TEMP=$S(TEMP'="":TEMP,1:"N/A"),ON=$P(UNIT,"^",2),OFF=$P(UNIT,"^",4) W:CNT>1 !! W ?14,$P(UNIT,"^"),?48,"Temperature: "_TEMP
 I 'ON W !,?14,"Time On: N/A",?48,"Time Off: N/A" Q
 S Y=ON D D^DIQ S ON=$P(Y,"@")_"  "_$P(Y,"@",2) I OFF S Y=OFF D D^DIQ S OFF=$P(Y,"@")_"  "_$P(Y,"@",2)
 I OFF="" S OFF="N/A"
 W !,?14,"Time On: "_ON,?48,"Time Off: "_OFF
 I $Y+11>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR D UL
 Q
PRO ; prosthesis
 I $Y+13>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR D UL
 S X=^SRF(SRTN,1,PRO,0),ITEM=$P(X,"^"),VENDOR=$P(X,"^",2),MODEL=$P(X,"^",3),SERIAL=$P(X,"^",5),Y=$P(X,"^",7),C=$P(^DD(130.01,5,0),"^",2) D:Y'="" Y^DIQ S STERILE=Y
 S X=$G(^SRF(SRTN,1,PRO,1)),SIZE=$P(X,"^"),QTY=$P(X,"^",2)
 W:CNT>1 ! W !,?2,"Item:  "_$P(^SRO(131.9,ITEM,0),"^"),!,?2,"Vendor: "_$S(VENDOR'="":VENDOR,1:"N/A"),!,?2,"Model: "_$S(MODEL'="":MODEL,1:"N/A"),!,?2,"Lot/Serial Number: "_$S(SERIAL'="":SERIAL,1:"N/A")
 W ?53,"Sterile Resp: "_$S(STERILE'="":STERILE,1:"N/A"),!,?2,"Size: "_$S(SIZE'="":SIZE,1:"N/A"),?53,"Quantity: "_$S(QTY'="":QTY,1:"N/A")
 Q
MED ; medications
 I $Y+13>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR D UL
 S DRUG=^SRF(SRTN,22,MED,0),DRUG=$P(^PSDRUG(DRUG,0),"^") W:CNT>1 ! W !,?2,DRUG
 S ADM=0 F  S ADM=$O(^SRF(SRTN,22,MED,1,ADM)) Q:'ADM  D MED1
 Q
MED1 ; more medication info
 I $Y+12>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR D UL
 S MM=^SRF(SRTN,22,MED,1,ADM,0),Y=$P(MM,"^") D D^DIQ S TIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S DOSE=$P(MM,"^",2),X=$P(MM,"^",3) S:X="" ORBY="N/A" I X S ORBY=$P(^VA(200,X,0),"^")
 S X=$P(MM,"^",4) S:X="" ADBY="N/A" I X S ADBY=$P(^VA(200,X,0),"^")
 S Y=$P(MM,"^",5),C=$P(^DD(130.34,4,0),"^",2) D:Y'="" Y^DIQ S ROUTE=Y
 S COMMENT=$P(MM,"^",6) S:COMMENT="" COMMENT="N/A"
 W !,?4,"Time Administered: "_TIME,!,?6,"Route: "_ROUTE,?45,"Dosage: "_DOSE,!,?6,"Ordered By: "_ORBY,!,?6,"Administered By: "_ADBY
 W !,?6,"Comments: "_COMMENT
 Q
IRR ; irrigations
 I $Y+12>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT  D UL
 W !,?2,SOLU S USED=0 F  S USED=$O(^SRF(SRTN,26,IRR,1,USED)) Q:'USED!(SRSOUT)  S MM=^SRF(SRTN,26,IRR,1,USED,0),Y=$P(MM,"^") D D^DIQ S TIME=$P(Y,"@")_"  "_$P(Y,"@",2) D IRR1
 Q
IRR1 ; more irrigation info
 I $Y+12>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR D UL
 S AMT=$P(MM,"^",2),DOC=$P(MM,"^",3) S:AMT="" AMT="N/A" S:DOC="" DOC="N/A" I DOC S DOC=$P(^VA(200,DOC,0),"^")
 W !,?5,"Time Used: "_TIME,!,?5,"Amount: "_AMT,?40,"Provider: "_DOC
 Q
