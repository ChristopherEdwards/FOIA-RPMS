FHORD81 ; HISC/REL/NCA - Diet Order Lists (cont) ;11/30/00  13:55
 ;;5.0;Dietetics;**24,27**;Oct 11, 1995
 K C,^TMP("FH",$J) F L=0:0 S L=$O(^FH(118,L)) Q:L<1  I '$D(^FH(118,L,"I")) S C(L)=$P(^(0),"^",1)
 D NOW^%DTC S NOW=%,DT=NOW\1,X1=DT,X2=-14 D C^%DTC S OLN=+X S X1=NOW,X2=-3 D C^%DTC S OLD=+X
 S X1=DT,X2=2 D C^%DTC S K3=+X
 F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  S X=^(W1,0) D F0
 S (PG,REC)=0,NXW="" F  S NXW=$O(^TMP("FH",$J,NXW)) Q:NXW=""  F W1=0:0 S W1=$O(^TMP("FH",$J,NXW,W1)) Q:W1<1  D F2
 W ! Q
F0 I FHXX="C" S K1=$P(X,"^",8) I WRD,K1'=WRD Q
 I FHXX="W" S K1=$P(X,"^",1) I WRD,W1'=WRD Q
 S K1=$S(FHXX="W":"",K1<1:99,K1<10:"0"_K1,1:K1),P0=$P(X,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
 S WRDN=$P(^FH(119.6,W1,0),"^",1),^TMP("FH",$J,K1_P0_$E(WRDN,1,26),W1)="" Q
F2 S WRDN=$P(^FH(119.6,W1,0),"^",1)
 K ^TMP($J) F DFN=0:0 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN<1  S ADM=^(DFN) D RM
 Q:'$D(^TMP($J))  S NX="" D HDR
L2 S NX=$O(^TMP($J,NX)) I NX="" W ! Q
 S DFN=""
L3 ; Get Next Patient data
 S DFN=$O(^TMP($J,NX,DFN)) G:DFN="" L2 S ADM=^(DFN)
 G:ADM<1 L3 S Y(0)=^DPT(DFN,0) G:'$D(^DGPM(ADM,0)) L3
 G:'$D(^FHPT(DFN,"A",ADM,0)) L3 S LEN=0 D CUR^FHORD7 S MEAL=Y,X0=^FHPT(DFN,"A",ADM,0) S:$L(MEAL)>48 LEN=$L($E(MEAL,1,48),",")
 I SER'="A",$P(X0,"^",5)'=SER G L3
 D:$Y>54 HDR S DTP=$P(^DGPM(ADM,0),"^",1) D DTP^FH
 S RM=$S(SRT="R":NX,$D(^DPT(DFN,.101)):^(.101),1:"") D PID^FHDPA
 W !!,RM,?13,$E($P(Y(0),"^",1),1,24),?38,BID,?47,DTP
 S Y=$P(X0,"^",5) I Y'="" W ?67,Y
 D GET I Y'="" W !?13,"Nut. Status: ",Y S X=+X5 D DT W ?72,X
 D ALG^FHCLN I ALG'="" W !?13,"Allergies: " S ZZ=ALG D LNE^FHORD82
 I "NO ORDER"'[MEAL!'$P(X0,"^",4) W !?13,"Diet Order: ",$S(LEN:$P(MEAL,",",1,LEN-1)_",",1:MEAL)
 I  I FHORD S X=$P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",9) D DT W ?72,X D:FHLD'="" NPO W:LEN !?24,$P(MEAL,",",LEN,999) D COM
 G ^FHORD82
GET S Y="",X5=$O(^FHPT(DFN,"S",0)) Q:X5=""  S X5=^(X5,0)
 Q:$P(X5,"^",1)<$P($G(^FHPT(DFN,"A",ADM,0)),"^",1)
 S Y=$P($G(^FH(115.4,+$P(X5,"^",2),0)),"^",2) Q
NPO S LST=0 F K1=0:0 S K1=$O(^FHPT(DFN,"A",ADM,"AC",K1)) Q:K1<1!(K1>NOW)  I $P(^(K1,0),"^",2)=FHORD S LST=K1
 W:LST<OLD "*" Q
COM ; List comment if any
 S COM=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,1)) Q:COM=""  I $L(COM)<51 W !?16,COM Q
 F LEN=51:-1:1 Q:$E(COM,LEN)=" "
 W !?16,$E(COM,1,LEN-1) S COM=$E(COM,LEN+1,999)
 W:COM'="" !?19,COM Q
DT S X=$J(+$E(X,6,7),2)_"-"_$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(X,4,5)) Q
RM I SRT="R" S RM=$G(^DPT(DFN,.101))
 E  S RM=$P($G(^DPT(DFN,0)),"^",1)
 S:RM="" RM=" " S ^TMP($J,RM,DFN)=ADM Q
HDR W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1,DTP=NOW D DTP^FH
 W !,DTP,?(67-$L(WRDN)\2),WRDN," DIET ORDERS",?73,"Page ",PG
 I SER'="A" S X=$S(SER="T":"TRAY",SER="C":"CAFETERIA",1:"DINING ROOM")_" Service Only" W !!?(79-$L(X)\2),X
 W !!,"Room",?13,"Patient",?39,"ID#",?48,"Admission Date",?66,"Svc",?71,"Ord Date" Q
