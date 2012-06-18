SRONRPT2 ;TAMPA/CFB - NURSES REPORT ; 30 Jan 1989  8:48 AM;
 ;;3.0; Surgery ;;24 Jun 93
 I $P(SRTN(.1),"^",2) D UL G:SRSOUT END^SRONRPT1 S Z=$P(SRTN(.1),"^",2) D N W !,"Preop Shave By: ",Z
 S Z=$P($G(^SRF(SRTN,"1.0")),"^",8),Z=$S(Z="C":"CLEAN",Z="CC":"CLEAN/CONTAMINATED",Z="D":"CONTAMINATED",Z="I":"INFECTED",1:"") D UL G:SRSOUT END^SRONRPT1 W !,"Wound Clssification: "_Z
 S SRPOS(1)="",(SRPOS,CNT)=0 F  S SRPOS=$O(^SRF(SRTN,42,SRPOS)) Q:'SRPOS  S X=$P(^SRF(SRTN,42,SRPOS,0),"^"),TIME=$P(^(0),"^",2) D POS
 I SRPOS(1)="" S SRPOS(1)="N/A^N/A"
 D UL W !,"Surgery Position(s): "_$P(SRPOS(1),"^"),?53,"Placed: "_$P(SRPOS(1),"^",2) S X=1 F  S X=$O(SRPOS(X)) Q:'X  W !,?21,$P(SRPOS(X),"^"),?53,"Placed: "_$P(SRPOS(X),"^",2)
 K SRPOS,X
 D UL G:SRSOUT END^SRONRPT1 W !,"Restraints and Position Aids:" I $D(^SRF(SRTN,20)) F V=0:0 S V=$O(^SRF(SRTN,20,V)) Q:'V  I $D(^(V,0)) S W=^(0) W !,?5,$S(+W=0:"",$D(^SRO(132.05,+W,0))#2:$P(^(0),U,1),1:"")
 I $P(SRTN(.7),"^",5)'="" D UL G:SRSOUT END^SRONRPT1 W !,"Electrocautery: ",$P(SRTN(.7),"^",5) I $P(SRTN(.5),"^",4)'="" W ?50,"Placed: " S SREPOS=$P(SRTN(.5),"^",4) I SREPOS W $P(^SRO(138,SREPOS,0),"^")
 D UL G:SRSOUT END^SRONRPT1 S X=$P(SRTN(0),"^",3) W !,$S(X="J":"Major ",X="N":"Minor ",1:""),"Operation(s) Performed: "
 K CNT S SRP=$P(^SRF(SRTN,"OP"),"^") I $P(^("OP"),"^",2)'="" S SRP=SRP_" ("_$P(^ICPT($P(^SRF(SRTN,"OP"),"^",2),0),"^")_")"
 I $P($G(^SRF(SRTN,30)),"^")&$P($G(^SRF(SRTN,.2)),"^",10) S SRP="** ABORTED ** "_SRP
 K SROPS,MM,MMM S:$L(SRP)<70 SROPS(1)=SRP I $L(SRP)>69 S SRP=SRP_"  " F M=1:1 D LOOP Q:MMM=""
 W !,"Primary: "_SROPS(1) I $D(SROPS(2)) W !,?9,SROPS(2) I $D(SROPS(3)) W !,?9,SROPS(3)
 W !,"Other: " S CNT=0 F I=0:0 S CNT=$O(^SRF(SRTN,13,CNT)) Q:'CNT  S SRP=$P(^SRF(SRTN,13,CNT,0),"^") D CPT W ?9,SRP,!
 D UL G:SRSOUT END^SRONRPT1 W !,"Material Sent to Laboratory for Analysis: "
 I $O(^SRF(SRTN,9,0)) W !,"Specimens: " S V=0 F I=0:0 S V=$O(^SRF(SRTN,9,V)) Q:'V  W !,?4,^SRF(SRTN,9,V,0)
 I $O(^SRF(SRTN,41,0)) W !,"Cultures: " S V=0 F I=0:0 S V=$O(^SRF(SRTN,41,V)) Q:'V  W !,?4,^SRF(SRTN,41,V,0)
 I $D(^SRF(SRTN,6)) D UL G:SRSOUT END^SRONRPT1 W !,"Anesthesia Technique(s):" F V=0:0 S V=$O(^SRF(SRTN,6,V)) Q:'V  I $D(^(V,0)) S T=^(0) S Q(7)=$P(T,U),Q(3)=^DD(130.06,.01,0) D S W !,?5,Q(7) W:$P(T,U,3)="Y" ?25,"(PRINCIPAL)" D DRUG
 I $D(^SRF(SRTN,3)),$P(^(3),"^")'="" D UL G:SRSOUT END^SRONRPT1 W !,"Tubes and Drains: "_$P(^SRF(SRTN,3),"^")
 I $O(^SRF(SRTN,2,0)) D UL G:SRSOUT END^SRONRPT1 W !,"Tourniquet: " F V=0:0 S V=$O(^SRF(SRTN,2,V)) Q:'V  W !,?5,"Time On: " S W=^(V,0),X=$P(W,"^",1),%DT="ET" D:X'="" ^%DT W ?40,"Time Off: " D TOURN
 I $O(^SRF(SRTN,21,0)) D UL G:SRSOUT END^SRONRPT1 W !,"Thermal Unit: " F V=0:0 S V=$O(^SRF(SRTN,21,V)) Q:'V  I $D(^(V,0)) S W=^(0) W !,?5,"Unit: ",$P(W,U,1) W:$P(W,"^",3) ?40,"Temperature: "_$P(W,"^",3) D THERM
 G ^SRONRPT1
UL Q:SRSOUT  I SRT="UL" D UL1
Q I $Y>(IOSL-11) D FOOT^SRONRPT Q:SRSOUT  D HDR^SRONRPT
 Q
END W ! D ^SRSKILL D ^%ZISC W @IOF I $D(SRSITE("KILL")) K SRSITE
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
LOOP ; break procedure if greater than 70 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SRP," "),MMM=$P(SRP," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<70  S SROPS(M)=SROPS(M)_MM_" ",SRP=MMM
 Q
CPT ; concatonate CPT code onto procedure
 I $D(^SRF(SRTN,13,CNT,2)),$P(^(2),"^")'="" S SRP=SRP_" ("_+^(2)_")"
 Q
DRUG W !,?8,"Agents:" S AGNT=0 F  S AGNT=$O(^SRF(SRTN,6,V,1,AGNT)) Q:'AGNT  S T=^SRF(SRTN,6,V,1,AGNT,0) W !,?10,$P(^PSDRUG($P(T,"^"),0),"^") W:$P(T,"^",2) "  "_$P(T,"^",2)_" mg"
 Q
N S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q  ;S Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z),Z=$S(Z="":"",$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q
S Q:Q(7)=""  S Z1=$P(Q(3),U,3) F X1=1:1 Q:Q(7)=$P($P(Z1,";",X1),":",1)  Q:X1=50
 Q:X1=50  S Q(7)=$P($P(Z1,";",X1),":",2) Q
TOURN S X=$P(W,U,4) D:X'="" ^%DT W !,?5,"On: " S Q(3)=^DD(130.02,1,0),Q(7)=$P(W,U,2) D S W Q(7) I $P(W,U,3) W ?40 S Z=$P(W,"^",3) D N W "By: "_Z
 Q
THERM S X=$P(W,"^",2),%DT="ET" W:X !,?5,"On: " D:X'="" ^%DT W ?40,"  Off: " S X=$P(W,"^",4),%DT="ET" D:X'="" ^%DT
 Q
POS ; surgery positions
 S CNT=CNT+1,X=$P(^SRO(132,X,0),"^"),SRPOS(CNT)=$E(X,1,30)
 I 'TIME S SRPOS(CNT)=SRPOS(CNT)_"^N/A" Q
 S Y=$E(TIME,1,12) D D^DIQ S SRPOS(CNT)=SRPOS(CNT)_"^"_$P(Y,"@")_" "_$P(Y,"@",2)
 Q
