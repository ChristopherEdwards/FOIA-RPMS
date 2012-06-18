SRONRPT3 ;TAMPA/CFB - NURSE'S REPORT ; 30 Jan 1989  8:52 AM
 ;;3.0; Surgery ;;24 Jun 93
 I $P(SRTN(.5),"^") D UL G:SRSOUT END W !,"Sponge, Sharps, and Instrument Count Verified As " S Q(7)=$P(SRTN(.5),"^",1),Q(3)=^DD(130,.52,0) D S W Q(7)
 I $P(SRTN(.5),"^",9) D UL G:SRSOUT END W !,"First Verifier: " S Z=$P(SRTN(.5),"^",9) D N W $E(Z,1,30) I $P(SRTN(.5),"^",12) S Z=$P(SRTN(.5),"^",12) D N W !,"Second Verifier: ",$E(Z,1,30)
 I $D(^SRF(SRTN,35)) W !,"Dressing: "_$P(^(35),"^")
 S X=$P($G(^SRF(SRTN,.8)),"^",11),SHEMP=$S(X="P":"PLAIN",X="I":"IDOFORM",X="V":"VASOLINE",X="B":"BETADINE",X="O":"OTHER",1:"NONE") W !,"Packing: "_SHEMP
 D UL G:SRSOUT END I $D(SRTN(.2)) W:+$P(SRTN(.2),"^",5) !,"Blood Loss: ",$P(SRTN(.2),"^",5)," cc's" W:+$P(SRTN(.2),"^",16) ?40,"Urine Output: ",$P(SRTN(.2),"^",16)," cc's"
 D UL G:SRSOUT END W !,"Postop Mood: "_$S($P(SRTN(.8),"^")'="":$P(^SRO(135.3,$P(SRTN(.8),"^"),0),"^"),1:"") W ?40,"Postop Cons: "_$S($P(SRTN(.8),"^",10):$P(^SRO(135.4,$P(SRTN(.8),"^",10),0),"^"),1:"")
 W !,"Postop Skin Integrity: "_$S($P(SRTN(.7),"^",6):$P(^SRO(135.2,$P(SRTN(.7),"^",6),0),"^"),1:"")
 W:$P(SRTN(0),"^",8)'="" !,"Postop Skin Color: " S Q(3)=^DD(130,.77,0),Q(7)=$P(SRTN(0),"^",8) D S W Q(7)
 D UL G:SRSOUT END W !,"Operation Disposition: " S Q(3)=^DD(130,.46,0),Q(7)=$P(SRTN(.4),"^",6) D S W Q(7)
 I $P(SRTN(.7),"^",4)'="" D UL G:SRSOUT END S SRVIA=$P(SRTN(.7),"^",4) W !,"Discharged Via: "_$P(^SRO(131.01,SRVIA,0),"^")
TEXT W !!,"Nursing Care Comments: " I $O(^SRF(SRTN,7,0)) S SRNCC=0 F  S SRNCC=$O(^SRF(SRTN,7,SRNCC)) Q:SRNCC=""  D:$Y+10>IOSL FOOT^SRONRPT,HDR^SRONRPT D OUT
P1 I SRT="UL",$Y<(IOSL-9) W ! G P1
 D FOOT^SRONRPT
END Q:$D(SRNIGHT)
 W:$E(IOST)="P" @IOF I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 S X=SRTN K SRT,SRTN S SRTN=X D ^SRSKILL
 D ^%ZISC W @IOF K:$D(SRSITE("KILL")) SRSITE Q
UL Q:SRSOUT  I SRT="UL" D UL1
Q I $Y>(IOSL-11) D FOOT^SRONRPT Q:SRSOUT  D HDR^SRONRPT
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
N S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),"^",1),1:Z) Q  ;S Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),"^",1),1:Z),Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),"^",1),1:Z) Q
S Q:Q(7)=""  S Z1=$P(Q(3),"^",3) F X1=1:1 Q:Q(7)=$P($P(Z1,";",X1),":",1)  Q:X1=50
 Q:X1=50  S Q(7)=$P($P(Z1,";",X1),":",2) Q
OUT S SRX=^SRF(SRTN,7,SRNCC,0) I $L(SRX)<77 W !,?1,SRX Q
 S SRX=SRX_"  " F M=1:1 Q:SRX=" "  S SRX(M)="" F L=1:1 S MM=$P(SRX," "),SRZ=$P(SRX," ",2,255) Q:SRZ=""  Q:$L(SRX(M))+$L(MM)'<77  S SRX(M)=SRX(M)_MM_" ",SRX=SRZ
 F I=1:1:M-1 D:$Y+10>IOSL FOOT^SRONRPT,HDR^SRONRPT W !,?1,SRX(I)
 Q
