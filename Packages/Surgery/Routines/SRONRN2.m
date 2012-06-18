SRONRN2 ;BIR/MAM - NURSE INTRAOP REPORT (FORMAT 0) ; [ 05/13/99  11:55 AM ]
 ;;3.0; Surgery ;**25,48,88**;24 Jun 93
 K NONUR,NURSE,OTH,OTHER,SHEMP,SRAGNT,SRCASE,SRCONS,SRCONV,SRDT,SRMOOD,SROPER,SROPS,SROR,SRSKIN,SRTIME,SRTYPE,SRUSER
 S SRPOS(1)="",(SRPOS,CNT)=0 F  S SRPOS=$O(^SRF(SRTN,42,SRPOS)) Q:'SRPOS  S X=$P(^SRF(SRTN,42,SRPOS,0),"^"),TIME=$P(^(0),"^",2) D POS
 I SRPOS(1)'="" D UL W !,"Surgery Position(s): "_$P(SRPOS(1),"^"),?53,"Placed: "_$P(SRPOS(1),"^",2) S X=1 F  S X=$O(SRPOS(X)) Q:'X!SRSOUT  S SRX=X D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .S X=SRX W !,?21,$P(SRPOS(X),"^"),?53,"Placed: "_$P(SRPOS(X),"^",2)
 Q:SRSOUT  I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S (REST,CNT)=0 F  S REST=$O(^SRF(SRTN,20,REST)) Q:'REST  S X=$P(^SRF(SRTN,20,REST,0),"^"),CNT=CNT+1,SREST(CNT)=$P(^SRO(132.05,X,0),"^")_"^"_$P(^SRF(SRTN,20,REST,0),"^",2,3)
 I $D(SREST(1)) D UL W !,"Restraints and Position Aids: "
 S X=0 F  S X=$O(SREST(X)) Q:'X!SRSOUT  S SRX=X D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .S X=SRX W !,?4,$P(SREST(X),"^"),?36,"Applied By: "_$S($P(SREST(X),"^",2)'="":$P(^VA(200,$P(SREST(X),"^",2),0),"^"),1:"N/A") I $P(SREST(X),"^",3)'="" W !,?8,"Comments: "_$P(SREST(X),"^",3)
 Q:SRSOUT  I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S SREL=$P(SR(.7),"^",5),SRELP=$P(SR(.5),"^",4),SRELP2=$P(SR(.5),"^",13),SREL=$S(SREL'="":SREL,1:"N/A"),SRC=$P(SR(.7),"^"),SRCT=$P(SR(.7),"^",2)
 S SRELP=$S(SRELP:$P(^SRO(138,SRELP,0),"^"),1:"N/A"),SRELP2=$S(SRELP2:$P(^SRO(138,SRELP2,0),"^"),1:"") S:SRC="" SRC="N/A" S:SRCT="" SRCT="N/A"
 I SREL'="N/A"!(SRELP'="N/A")!(SRELP2'="") D UL W !,"Electrocautery Unit: ",?27,SREL,!,"ESU Coagulation Range: ",SRC,!,"ESU Cutting Range: ",SRCT,!,"Electroground Position(s): "_SRELP I SRELP2'="" W !,?27,SRELP2
 I $Y+14>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 K SREL,SRELP,SRELP2,SRPOS,CNT,REST,SREST
 S SRMAJ=$P(SR(0),"^",3),SRMAJ=$S(SRMAJ="J":"Major",SRMAJ="N":"Minor",1:"Major")
 D UL W !,SRMAJ_" Operations Performed:",!,"Primary: " D PRIN^SRONIN3
 I $O(^SRF(SRTN,13,0)) D OTHER^SRONIN3 Q:SRSOUT
 K SROPS,CPT,SROPS,SROPER,SROPERS,SROTHER,SRMAJ,SRLONG
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SRONRN3
 Q
POS ; surgery positions
 S CNT=CNT+1,X=$P(^SRO(132,X,0),"^"),SRPOS(CNT)=$E(X,1,30)
 I 'TIME S SRPOS(CNT)=SRPOS(CNT)_"^N/A" Q
 S Y=$E(TIME,1,12) D D^DIQ S SRPOS(CNT)=SRPOS(CNT)_"^"_$P(Y,"@")_" "_$P(Y,"@",2)
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
LOOP ; break procedure if greater than 70 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<70  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
