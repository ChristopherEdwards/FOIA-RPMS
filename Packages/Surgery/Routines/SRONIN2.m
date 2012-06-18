SRONIN2 ;B'HAM ISC/MAM - NURSE INTRAOP REPORT (FORMAT 1) ; 22 OCT 91  1:15 PM
 ;;3.0; Surgery ;**25,48,115**;24 Jun 93
 D UL W !,"OR Support Personnel:",!,"  Scrubbed",?40,"Circulating"
 S NONUR=0 I '$O(^SRF(SRTN,19,0)),'$O(^SRF(SRTN,23,0)) S NONUR=1
 S CNT=0 K NURSE I 'NONUR D NURSE
 I NONUR W !,?2,"N/A",?40,"N/A"
 S I=0 F  S I=$O(NURSE(I)) Q:'I!SRSOUT  D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .W !,?2,$P(NURSE(I),"^"),?40,$P(NURSE(I),"^",2)
 Q:SRSOUT  K NURSE I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Other Persons in OR: " S OTH=0 F  S OTH=$O(^SRF(SRTN,32,OTH)) Q:'OTH!SRSOUT  D
 .I $Y+10>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR,UL Q:SRSOUT
 .S X=^SRF(SRTN,32,OTH,0) W !,?2,$P(X,"^") I $P(X,"^",2)'="" W " ("_$P(X,"^",2)_")"
 I '$O(^SRF(SRTN,32,0)) W "N/A"
 Q:SRSOUT  I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 S SRMOOD=$P(SR(.1),"^",9),SRCONS=$P(SR(.1),"^",15),SRSKIN=$P(SR(0),"^",7),SRCONV=$P(SR(.1),"^",14)
 I SRMOOD S SRMOOD=$P(^SRO(135.3,SRMOOD,0),"^")
 I SRCONS S SRCONS=$P(^SRO(135.4,SRCONS,0),"^")
 I SRSKIN S SRSKIN=$P(^SRO(135.2,SRSKIN,0),"^")
 S Y=SRCONV,C=$P(^DD(130,.195,0),"^",2) D:Y'="" Y^DIQ S SRCONV=$S(Y'="":Y,1:"N/A")
 D UL W !,"Preop Mood: ",?18,$S(SRMOOD'="":$E(SRMOOD,1,20),1:"N/A"),?40,"Preop Consc:",?56,$S(SRCONS'="":$E(SRCONS,1,24),1:"N/A")
 W !,"Preop Skin Integ: ",?18,$S(SRSKIN'="":$E(SRSKIN,1,20),1:"N/A"),?40,"Preop Converse: "_SRCONV
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL K SRUSER S X=$P(SR(.6),"^",9) I X S SRUSER=$P(^VA(200,X,0),"^")
 S:'$D(SRUSER) SRUSER="N/A" W !,"Valid Consent/ID Band Confirmed By:  "_SRUSER K SRUSER
 ;
 N SROUT
 S SROUT=$P($G(^SRF(SRTN,"VER")),"^",3)
 S SROUT=$S(SROUT="Y":"YES",SROUT="N":"NO, SEE NURSING CARE COMMENTS",SROUT="":"NOT ENTERED")
 W !,"Time Out Verification Completed:     "_SROUT
 ;
 N SROIM
 S SROIM=$P($G(^SRF(SRTN,"VER")),"^",4)
 S SROIM=$S(SROIM="Y":"YES",SROIM="N":"NO, SEE NURSING CARE COMMENTS",SROIM="":"NOT ENTERED",SROIM="NA":"NOT APPLICABLE")
 W !,"Preoperative Imaging Confirmed:      "_SROIM D UL
 W !
 ;
 S X=$P(SR(.1),"^",8) I X S SRUSER=$P(^VA(200,X,0),"^")
 S:'$D(SRUSER) SRUSER="N/A" W !,"Skin Prep By:     "_$E(SRUSER,1,20)
 K SRAGNT S X=$P(SR(.1),"^",7) I X S SRAGNT=$P(^SRO(135.1,X,0),"^")
 S:'$D(SRAGNT) SRAGNT="N/A" W ?40,"Skin Prep Agent:     "_$E(SRAGNT,1,18)
 K SRUSER S X=$P(SR(.1),"^",12) I X S SRUSER=$P(^VA(200,X,0),"^")
 S:'$D(SRUSER) SRUSER="N/A" W !,"Skin Prep By (2): "_$E(SRUSER,1,20)
 K SRAGNT S X=$P(SR(31),"^",2) I X S SRAGNT=$P(^SRO(135.1,X,0),"^")
 S:'$D(SRAGNT) SRAGNT="N/A" W ?40,"2nd Skin Prep Agent: "_$E(SRAGNT,1,18)
 K SRUSER S X=$P(SR(.1),"^",2) I X S SRUSER=$P(^VA(200,X,0),"^")
 S:'$D(SRUSER) SRUSER="N/A" W !,"Preop Shave By:   "_SRUSER
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D ^SRONIN3
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
