SRONRN5 ;B'HAM ISC/MAM - NURSE INTRAOP REPORT (FORMAT 0) ; 30 OCT 91 4:00 PM
 ;;3.0; Surgery ;**25,34,37,48,106**;24 Jun 93
 I $O(^SRF(SRTN,4,0)) D UL W !,"Blood Replacement Fluids: " S REP=0 F  S REP=$O(^SRF(SRTN,4,REP)) Q:'REP!(SRSOUT)  D REP
 K REP,QTY,FLUID,SRCE,VID,CM,^UTILITY($J,"W") Q:SRSOUT
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S SR(25)=$G(^SRF(SRTN,25)),SPONGE=$P(SR(25),"^"),SHARP=$P(SR(25),"^",2),INSTR=$P(SR(25),"^",3)
 S Y=SPONGE,C=$P(^DD(130,44,0),"^",2) D:Y'="" Y^DIQ S SPONGE=$S(Y'="":Y,1:"N/A")
 S Y=SHARP,C=$P(^DD(130,45,0),"^",2) D:Y'="" Y^DIQ S SHARP=$S(Y'="":Y,1:"N/A")
 S Y=INSTR,C=$P(^DD(130,46,0),"^",2) D:Y'="" Y^DIQ S INSTR=$S(Y'="":Y,1:"N/A")
 S X=$P(SR(25),"^",4),COUNTER=$S(X:$P(^VA(200,X,0),"^"),1:"N/A"),X=$P(SR(25),"^",5),VERIFY=$S(X:$P(^VA(200,X,0),"^"),1:"N/A")
 I SPONGE'="N/A" W !,"Sponge Count:",?20,SPONGE
 I SHARP'="N/A" W !,"Sharps Count: ",?20,SHARP
 I INSTR'="N/A" W !,"Instrument Count: ",?20,INSTR
 I COUNTER'="N/A" W !,"Counter: ",?20,COUNTER
 I VERIFY'="N/A" W !,"Counts Verified By: "_VERIFY
 K SPONGE,SHARP,INSTR,COUNTER,VERIFY I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S SR(35)=$G(^SRF(SRTN,35)),DRESS=$P(SR(35),"^"),Y=$P(SR(.8),"^",11),C=$P(^DD(130,.875,0),"^",2) D:Y'="" Y^DIQ S PACK=$S(Y'="":Y,1:"N/A")
 S DRESS=$S(DRESS'="":DRESS,1:"N/A")
 I DRESS'="N/A"!(PACK'="N/A") W !,"Dressing: "_DRESS,!,"Packing:  "_PACK K PACK,DRESS
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S BLOOD=$P(SR(.2),"^",5),URINE=$P(SR(.2),"^",16)
 I BLOOD'=""!(URINE'="") W !,"Blood Loss: "_BLOOD_$S(BLOOD'="":" cc's",1:""),?40,"Urine Output: "_URINE_$S(URINE'="":" cc's",1:"")
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL S MOOD=$P(SR(.8),"^"),CONS=$P(SR(.8),"^",10),INTEG=$P(SR(.7),"^",6),COLOR=$P(SR(.7),"^",7)
 S MOOD=$S(MOOD:$P(^SRO(135.3,MOOD,0),"^"),1:"N/A"),CONS=$S(CONS:$P(^SRO(135.4,CONS,0),"^"),1:"N/A"),INTEG=$S(INTEG:$P(^SRO(135.2,INTEG,0),"^"),1:"N/A")
 S Y=COLOR,C=$P(^DD(130,.77,0),"^",2) D:Y'="" Y^DIQ S COLOR=$S(Y="":"N/A",1:Y)
 I MOOD'="N/A" W !,"Postoperative Mood: ",?30,MOOD
 I CONS'="N/A" W !,"Postoperative Consciousness: "_CONS
 I INTEG'="N/A" W !,"Postoperative Skin Integrity: "_INTEG
 I COLOR'="N/A" W !,"Postoperative Skin Color: ",?30,COLOR
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL K COLOR,CONS,INTEG,COLOR
 S SR(.7)=$G(^SRF(SRTN,.7)),X=$P(SR(.7),"^",8) I X'="" W !,"Type of Laser: ",?16,X
 S X=$P(SR(.7),"^",3) I X'="" W !,"Sequential Compression Device: "_$S(X="Y":"YES",1:"NO")
 S Y=$P(SR("1.0"),"^",8),C=$P(^DD(130,1.09,0),"^",2) D:Y'="" Y^DIQ W !!,"Wound Classification:  "_$S(Y'="":Y,1:"NOT ENTERED")
 S Y=$P(SR(.4),"^",6),C=$P(^DD(130,.46,0),"^",2) D:Y'="" Y^DIQ S DISP=$S(Y'="":Y,1:"N/A")
 S X=$P(SR(.7),"^",4),VIA=$S(X:$P(^SRO(131.01,X,0),"^"),1:"N/A")
 I DISP'="N/A" W !,"Operation Disposition: "_DISP
 I VIA'="N/A" W !,"Discharged Via: "_VIA
 I $Y+13>IOSL D FOOT Q:SRSOUT  I $E(IOST)="P" D HDR Q:SRSOUT
 D UL W !,"Nursing Care Comments: " I '$O(^SRF(SRTN,7,0)) W "NO COMMENTS ENTERED"
 S COMM=0 F  S COMM=$O(^SRF(SRTN,7,COMM)) Q:'COMM!(SRSOUT)  D COMM
 Q
FOOT ; print footer
 D FOOT^SRONRN1
 Q
UL ; underline on printer
 Q:SRSOUT  I SRT'="UL" W ! Q
 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13),SRUL
 Q
PAGE W !!!,"Press RETURN to continue, or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Press RETURN to continue with this report, or '^' to return to the",!,"previous menu." G PAGE
HDR ; heading
 D HDR^SRONRN1
 Q
REP ; replacement fluids
 I $Y+12>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR,UL
 S X=^SRF(SRTN,4,REP,0),FLUID=$P(^SRO(133.7,$P(X,"^"),0),"^"),QTY=$P(X,"^",2),SRCE=$P(X,"^",4),VID=$P(X,"^",5)
 W !,?2,FLUID,?40,"Quantity: "_$S(QTY'="":QTY,1:"N/A") W:QTY " ml" W !,?4,"Source Identification: "_$S(SRCE'="":SRCE,1:"N/A"),!,?4,"VA Identification: "_$S(VID'="":VID,1:"N/A")
 I '$O(^SRF(SRTN,4,REP,1,0)) Q
 W !,?4,"Comments: " K ^UTILITY($J,"W") S CM=0 F  S CM=$O(^SRF(SRTN,4,REP,1,CM)) Q:'CM  S X=^SRF(SRTN,4,REP,1,CM,0),DIWL=6,DIWR=79 D ^DIWP
 I $D(^UTILITY($J,"W")) F J=1:1:^UTILITY($J,"W",6) D  Q:SRSOUT
 .I $Y+10>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR,UL
 .W !,?6,^UTILITY($J,"W",6,J,0)
 Q
COMM ; nursing care comments
 I $Y+11>IOSL D FOOT Q:SRSOUT  D:$E(IOST)="P" HDR,UL
 K X S X=^SRF(SRTN,7,COMM,0) I $L(X)<79 W !,?2,X Q
 I $E(X,1,78)'[" " W !,?2,X Q
 S K=1 F  D  I $L(X)<79 S X(K)=X Q
 .F I=0:1:77 S J=78-I,Y=$E(X,J) I Y=" " S X(K)=$E(X,1,J-1),X=$E(X,J+1,$L(X)) S K=K+1 Q
 .I X'[" " D
 ..F  Q:$L(X)<79  S X(K)=$E(X,1,78),X=$E(X,79,$L(X)),K=K+1
 F I=1:1:K W !,?2,X(I)
 Q
