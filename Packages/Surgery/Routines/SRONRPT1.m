SRONRPT1 ;TAMPA/CFB - NURSES REPORT ; 30 Jan 1989  8:45 AM;
 ;;3.0; Surgery ;;24 Jun 93
 I $O(^SRF(SRTN,1,0)) D UL G:SRSOUT END W !,"Prosthesis Installed:" F V=0:0 S V=$O(^SRF(SRTN,1,V)) Q:'V  I $D(^(V,0)) S W=^(0),W(1)=$S($D(^(1)):^(1),1:"") W !,?5,$S($P(W,U,1)="":"",$D(^SRO(131.9,$P(W,U,1),0))#2:$P(^(0),U,1),1:"") D PRO
 I $O(^SRF(SRTN,22,0)) D UL G:SRSOUT END W !,"Medications:" F V=0:0 S V=$O(^SRF(SRTN,22,V)) Q:'V  I $D(^(V,0)) D Q S W=^SRF(SRTN,22,V,0) W !,?5,$S(+W=0:"",$D(^PSDRUG(+W,0))#2:$P(^(0),U,1),1:"") D MED
 I $D(^SRF(SRTN,26)) D UL G:SRSOUT END W !,"Irrigation Solution(s):" F V=0:0 S V=$O(^SRF(SRTN,26,V)) Q:'V  I $D(^(V,0)) S W=^(0) W !,?5,$S($D(^SRO(133.6,$P(W,U,1),0)):$P(^(0),U,1),1:$P(W,U,1)) D IRR
 I $O(^SRF(SRTN,4,0)) D UL G:SRSOUT END W !,"Blood Replacement Fluids:" F V=0:0 S V=$O(^SRF(SRTN,4,V)) Q:'V  I $D(^(V,0)) S W=^(0) W !,?5,$S($D(^SRO(133.7,$P(W,U,1),0)):$P(^(0),U,1),1:$P(W,U,1)) D BLOOD
 K SRCOUNT,S(25) I $D(^SRF(SRTN,25)) S S(25)=^(25),SRCOUNT(1)=$S($P(S(25),"^")="Y":"CORRECT",$P(S(25),"^")="N":"NOT CORRECT, SEE NURSING CARE COMMENTS",1:"NOT APPLICABLE")
 I $D(S(25)) S SRCOUNT(2)=$S($P(S(25),"^",2)="Y":"CORRECT",$P(S(25),"^",2)="N":"NOT CORRECT, SEE NURSING CARE COMMENTS",1:"NOT APPLICABLE")
 I $D(S(25)) S SRCOUNT(3)=$S($P(S(25),"^",3)="Y":"CORRECT",$P(S(25),"^",3)="N":"NOT CORRECT, SEE NURSING CARE COMMENTS",1:"NOT APPLICABLE")
 I $D(S(25)) S SRCNTR=$P(S(25),"^",4),SRVFR=$P(S(25),"^",5) S:SRCNTR'="" SRCNTR=$P(^VA(200,SRCNTR,0),"^") S:SRVFR'="" SRVFR=$P(^VA(200,SRVFR,0),"^")
 F I=1:1:3 I '$D(SRCOUNT(I)) S SRCOUNT(I)=""
 S:'$D(SRCNTR) SRCNTR="" I '$D(SRVFR) S SRVFR=""
 D UL G:SRSOUT END W !,"Sponge Count: "_SRCOUNT(1),!,"Sharps Count: "_SRCOUNT(2),!,"Instrument Count: "_SRCOUNT(3),!,?5,"Counter:: "_SRCNTR,!,?5,"Counts Verified By: "_SRVFR
 G ^SRONRPT3
UL Q:SRSOUT  I SRT="UL" D UL1
Q Q:$Y'>(IOSL-11)  D FOOT^SRONRPT Q:SRSOUT  D HDR^SRONRPT
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
END Q:$D(SRNIGHT)
 W ! I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 D ^SRSKILL D ^%ZISC W @IOF I $D(SRSITE("KILL")) K SRSITE
 Q
PRO W:$P(W,"^",3)]"" ?40,"Model: ",$P(W,"^",3) W:$P(W,"^",5)]"" !,?40,"Lot/Serial Number: ",$P(W,"^",5) I $D(W(1)),W(1)]"" W !,?40,"Size: ",$P(W(1),"^")
 Q
N S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q  ;S Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z),Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q
S Q:Q(7)=""  S Z1=$P(Q(3),U,3) F X1=1:1 Q:Q(7)=$P($P(Z1,";",X1),":",1)  Q:X1=50
 Q:X1=50  S Q(7)=$P($P(Z1,";",X1),":",2) Q
MED F A=0:0 S A=$O(^SRF(SRTN,22,V,1,A)) Q:'A  S W=^(A,0) W !,?5 S X=$P(W,U,1) D:X'="" ^%DT S Q(3)=^DD(130.34,4,0),Q(7)=$P(W,U,5) D S W:Q(7)'="" ?40,Q(7) D MED1
 Q
MED1 S Z=$P(W,"^",3) W:$P(W,"^",2)'="" "  ("_$P(W,"^",2)_")" D N I Z'="" W !,?10,"Ordered By: ",$E(Z,1,20) I $P(W,"^",4)'="" W ?40,"Adm By: " S Z=$P(W,"^",4) D N W Z
 I $P(W,"^",6)'="" W !,?10,"Medication Comments: ",!,?10,$P(W,"^",6)
 Q
IRR F V(1)=0:0 S V(1)=$O(^SRF(SRTN,26,V,1,V(1))) Q:'V(1)  S W=^(V(1),0),X=$P(W,U,1) W !,?10,"Time Used: " D:X'="" ^%DT W !,?10,"Amount: ",$P(W,U,2),?40 S Z=$P(W,U,3) D N W "Provider: "_Z
 Q
BLOOD W ?40,"Quantity: ",$P(W,U,2)," cc's" I $P(W,U,3)'=""!($P(W,U,4)'="")!($P(W,U,5)'="") W !,?10,"Source ID: ",$P(W,U,4),?40,"VA ID: ",$P(W,U,5)
 Q
