SROARPT1 ;TAMPA/CFB - ANESTHETIST'S REPORT ; [ 11/24/98  10:07 AM ]
 ;;3.0; Surgery ;**48,86**;24 Jun 93
 ;
 ; References to ^PSDRUG supported by DBIA #221
 ;
 I $O(^SRF(SRTN,22,0)) D UL Q:SRSOUT  W !,"Medications:" S CNT=1,V=0 F  S V=$O(^SRF(SRTN,22,V)) Q:'V  I $D(^(V,0)) S W=^(0) Q:SRSOUT  W:CNT>1 ! W !,?5,$S(+W=0:"",$D(^PSDRUG(+W,0))#2:$P(^(0),"^",1),1:"") D MED S CNT=CNT+1
 D UL Q:SRSOUT  W !,"Anesthesia Start: " S Y=$P(SRTN(.2),"^") I Y D D^DIQ S Y=$P(Y,"@")_" "_$P(Y,"@",2) W Y
 S Y=$P(SRTN(.2),"^",4) W ?40,"Anesthesia Stop: " I Y D D^DIQ S Y=$P(Y,"@")_" "_$P(Y,"@",2) W Y
 D UL Q:SRSOUT  S Z=$P(SRTN(.3),"^",1) D N W !,"Anesthetist:      ",Z S Z=$P(SRTN(.3),"^",2) D N W ?40,"Relief Anesth:   ",Z
 D UL Q:SRSOUT  S Z=$P(SRTN(.3),"^",4) D N W !,"Anesthesiologist: ",Z
 S SRATC="" I $P(SRTN(.3),"^",6)'="" S SRATC=$P(^SRO(132.95,$P(SRTN(.3),"^",6),0),"^") I $L(SRATC)>23 S J=24 F  S X=$E(SRATC,J) Q:X=" "  S J=J-1
 I SRATC'="" W ?40,"Attending Code:  "_$S($L(SRATC)>23:$E(SRATC,1,J-1),1:SRATC) I $L(SRATC)>23 W !,?57,$E(SRATC,J+1,$L(SRATC))
 D UL Q:SRSOUT  S Z=$P(SRTN(.3),"^",3) D N W !,"Assistant Anesth: ",Z,?40,"Min Intraoperative Temp: ",$P(SRTN(.3),"^",7)
 I $O(^SRF(SRTN,27,0)) D UL Q:SRSOUT  W !,"Monitors:" S CNT=1,V=0 F  S V=$O(^SRF(SRTN,27,V)) Q:'V  I $D(^SRF(SRTN,27,V,0)) S W=^(0) W:CNT>1 ! W !,?5,$S($D(^SRO(133.4,$P(W,"^"),0)):$P(^(0),"^"),1:$P(W,"^")) D MON S CNT=CNT+1
 I $O(^SRF(SRTN,4,0)) D UL Q:SRSOUT  W !,"Blood Replacement Fluids:" S CNT=1,V=0 F  S V=$O(^SRF(SRTN,4,V)) Q:'V  I $D(^SRF(SRTN,4,V,0)) S W=^(0) W:CNT>1 ! W !,?5,$S($D(^SRO(133.7,$P(W,"^"),0)):$P(^(0),"^"),1:$P(W,"^")) D BLOOD
 D UL Q:SRSOUT  W !,"Intraoperative Blood Loss: ",$P(SRTN(.2),"^",5) W:$P(SRTN(.2),"^",5) " cc's" W ?40,"Urine Output: ",$P(SRTN(.2),"^",16) W:$P(SRTN(.2),"^",16) " cc's"
 D UL Q:SRSOUT  S Y=$P(SRTN(.4),"^",6),C=$P(^DD(130,.46,0),"^",2) D:Y'="" Y^DIQ W !,"Operation Disposition: ",Y
 D UL Q:SRSOUT  W !,"PAC(U) Admit Score: ",$P(SRTN(1.1),"^"),?40,"PAC(U) Discharge Score: ",$P(SRTN(1.1),"^",2)
 D UL Q:SRSOUT  S Y=$P(SRTN(1.1),"^",9) W !,"Postop Anesthesia Note: " I Y D D^DIQ W Y
 I $O(^SRF(SRTN,10,0)) D UL Q:SRSOUT  W !,"Intraoperative Complications: " F T=0:0 S T=$O(^SRF(SRTN,10,T)) Q:'T!(T'?1N.N)  S SR("INTRA")=$P(^SRF(SRTN,10,T,0),"^") W !,?2,SR("INTRA")
 I $O(^SRF(SRTN,16,0)) D UL Q:SRSOUT  W !,"Postoperative Complications: " F T=0:0 S T=$O(^SRF(SRTN,16,T)) Q:'T!(T'?1N.N)  S SR("POST")=$P(^SRF(SRTN,16,T,0),"^") W !,?2,SR("POST")
 I $O(^SRF(SRTN,5,0)) D GC
P I SRT="UL",$Y<50 W ! G P
SIG D UL Q:SRSOUT  W !!,"ANESTHETIST'S SIG: ",?50 D NOW^%DTC S Y=% D D^DIQ W Y
 Q
MON S Y=$P(W,"^",4),SRB=$S(Y:$P(^VA(200,Y,0),"^"),1:"N/A") W ?40,"Applied By: ",SRB,!,?5,"Installed: " S Y=$P(W,"^",2) D:Y D^DIQ W $S(Y="":"N/A",1:Y),?40,"Removed: " S Y=$P(W,"^",3) D:Y D^DIQ W $S(Y="":"N/A",1:Y)
 Q
BLOOD S CNT=CNT+1 W ?40,"Quantity: ",$P(W,"^",2)," cc's" I $P(W,"^",4)'="" W !,?5,"Source ID: ",$P(W,"^",4)
 I $P(W,"^",5)'="" W !,?5,"VA ID:     ",$P(W,"^",5)
 Q
MED F A=0:0 S A=$O(^SRF(SRTN,22,V,1,A)) Q:'A  S W=^(A,0) W !,?5 S Y=$P(W,"^",1) D:Y'="" D^DIQ S:Y'="" Y=$P(Y,"@")_" "_$P(Y,"@",2) W Y S Y=$P(W,"^",5),C=$P(^DD(130.34,4,0),"^",2) D:Y'="" Y^DIQ W:Y'="" ?40,Y D MED1
 Q
MED1 S Z=$P(W,"^",3) W:$P(W,"^",2)'="" "  ("_$P(W,"^",2)_")" D N I Z'="" W !,?10,"Ordered By: ",$E(Z,1,20) I $P(W,"^",4)'="" W ?40,"Admin By: " S Z=$P(W,"^",4) D N W Z
 I $P(W,"^",6)'="" W !,?10,"Medication Comments: ",!,?10,$P(W,"^",6)
 Q
DRUG Q:$P(^SRF(SRTN,6,V,0),"^")="N"
 W !,?8,"Agents:" F V1=0:0 S V1=$O(^SRF(SRTN,6,V,V1)) Q:'V1  F V2=0:0 S V2=$O(^SRF(SRTN,6,V,V1,V2)) Q:'V2  I $D(^(V2,0)) S T=^(0) W !,$S(+T=0:"",$D(^PSDRUG(+T,0)):$P(^(0),U),1:"UNKNOWN")
N S:'$D(Z) Z="" S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),"^",1),1:Z) I $L(Z)>18 S Z=$P(Z,",")_","_$P(Z,",",2)_"."
 Q
UL I SRT="UL" D UL1
Q I $Y>(IOSL-10) W ! D FOOT^SROARPT Q:SRSOUT  D HDR^SROARPT
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
GC K ^UTILITY($J,"W") D UL Q:SRSOUT  W !!,"General Comments:" S SRCOM=0 F  S SRCOM=$O(^SRF(SRTN,5,SRCOM)) Q:'SRCOM!SRSOUT  S X=^SRF(SRTN,5,SRCOM,0),DIWL=3,DIWR=76,DIWF="" D ^DIWP
OUT I $D(^UTILITY($J,"W")) F V=1:1:^UTILITY($J,"W",DIWL) D:$Y>(IOSL-10) UL Q:SRSOUT  W !,?DIWL,^UTILITY($J,"W",DIWL,V,0)
 K ^UTILITY($J,"W")
 Q
