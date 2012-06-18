FHDCR1A	; HISC/REL/NCA - Build Diet Cards ;5/10/95  13:02
	;;5.0;Dietetics;;Oct 11, 1995
B1	; Store wards
	K ^TMP($J),NN,N,P S MFLG=0 D Q1^FHDCR1B D NOW^%DTC S (DTP,TIM)=% D DTP^FH S HD=DTP S:MEAL="A" MFLG=1
	S DTP=D1 D DTP^FH S (MDT,MEALDT)=DTP,MEALDT=$J("",62-$L(MEALDT)\2)_MEALDT
	S FHBOT=$P($G(^FH(119.9,1,4)),"^",1)
	I DFN D  Q
	.S ADM=+$G(^DPT(DFN,.105)),W1=+$P($G(^FHPT(DFN,"A",+ADM,0)),"^",8)
	.S K1=$G(^FH(119.6,+W1,0)),WRDN=$P(K1,"^",1),SP=$P(K1,"^",5),SP1=$P(K1,"^",6),FHPAR=$P(K1,"^",24),RM=$G(^DPT(DFN,.101))
	.I 'SP Q:FHPAR'="Y"  S SP=SP1 Q:'SP
	.K PP,S,MM S NBR=0
	.I 'TPP D BLD^FHDCR11 D:NBR UPD,PRT^FHDCR1C Q
	.I 'MFLG D BLD^FHDCR1D D:NBR UPD,PRT^FHMTK1C Q
	.F MEAL="B","N","E" D BLD^FHDCR1D
	.D UPD
	.D:NBR PRT^FHMTK1C
	.Q
	I W1 S ^TMP($J,"W","01"_$P($G(^FH(119.6,+W1,0)),"^",1))=W1_"^"_$P($G(^FH(119.6,+W1,0)),"^",5,6)_"^"_$P($G(^FH(119.6,+W1,0)),"^",24)
	E  F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  D
	.S P0=$G(^FH(119.6,W1,0)),WRDN=$P(P0,"^",1),SP=$P(P0,"^",5,6),D2=$P(P0,"^",8),FHPAR=$P(P0,"^",24),P0=$P(P0,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
	.I FHP,D2'=FHP Q
	.S ^TMP($J,"W",P0_WRDN)=W1_"^"_SP_"^"_FHPAR Q
	S NX="" F  S NX=$O(^TMP($J,"W",NX)) Q:NX=""  S X1=$G(^(NX)),W1=+X1,FHS=$P(X1,"^",2),SP1=$P(X1,"^",3),FHPAR=$P(X1,"^",4),WRDN=$E(NX,3,99) S:'FHS&(FHPAR="Y") FHS=SP1 I FHS K ^TMP($J,"D") D
	.F DFN=0:0 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN<1  D
	..S ADM=^(DFN)
	..I SORT="A" S RM=$P($G(^DPT(DFN,0)),"^",1),DL=0,RMB=$G(^DPT(DFN,.101)) S:RMB="" RMB="***"
	..E  S RI=$G(^DPT(DFN,.108)),RM=$G(^DPT(DFN,.101)) S:RM="" RM="***" S:RI RE=$O(^FH(119.6,"AR",+RI,W1,0)) S:'RI RE="" S DL=$S(RE:$P($G(^FH(119.6,W1,"R",+RE,0)),"^",2),1:""),RMB=""
	..S DL=$S(DL<1:99,DL<10:"0"_DL,1:DL)
	..S ^TMP($J,"D",DL_"~"_RM_"~"_$S(SORT="R":DFN,1:RMB))=DFN_"^"_ADM Q
	.K ^TMP($J,"MP"),^TMP($J,0),MM,PP,S S X9="",NBR=0 F  S X9=$O(^TMP($J,"D",X9)) Q:X9=""  S DFN=$P(^(X9),"^",1),ADM=$P(^(X9),"^",2),RM=$S(SORT="R":$P(X9,"~",2),1:$P(X9,"~",3)) S SP=FHS D
	..I TPP D  Q
	...I 'MFLG D BLD^FHDCR1D,UPD Q
	...F MEAL="B","N","E" D BLD^FHDCR1D
	...D UPD
	...Q
	..I 'TPP D BLD^FHDCR11 D UPD Q
	.I NBR,TPP D PRT^FHMTK1C Q
	.D:NBR PRT^FHDCR1C
	.Q
	Q
UPD	; Update Date/Time Diet Card was Printed
	S $P(^FHPT(DFN,"A",ADM,0),"^",16)=TIM Q
