FHORT5A	; HISC/REL/NCA - Tubefeeding Reports (cont) ;10/20/94  12:37 
	;;5.0;Dietetics;;Oct 11, 1995
Q1	; Print Tubefeeding Report
	S PG=0 D NOW^%DTC S (DTP,NOW)=% D DTP^FH K ^TMP($J)
	F DFN=0:0 S DFN=$O(^FHPT("ADTF",DFN)) Q:DFN<1  F ADM=0:0 S ADM=$O(^FHPT("ADTF",DFN,ADM)) Q:ADM<1  D Q2
	I FHOPT=1 D PREP^FHORT5B,PULL^FHORT5C,DEL^FHORT5C Q
	I FHOPT=2 D PREP^FHORT5B Q
	I FHOPT=3 D CST^FHORT5D Q
	I FHOPT=4 D LAB^FHORT5D Q
	I FHOPT=5 D PULL^FHORT5C
	Q
Q2	S Z=$G(^FHPT(DFN,"A",ADM,0)),WARD=$P(Z,"^",8) S:WARD WARD=$P($G(^FH(119.6,WARD,0)),"^",1) I WARD="" G Q3
	G:'$D(^DPT(DFN,.1)) Q3 S CADM=$G(^DPT("CN",^DPT(DFN,.1),DFN)) G:ADM'=CADM Q3
	S TF=$P(Z,"^",4) G:TF<1 Q3
	S Z1=$P(Z,"^",5),Z2=$P(Z,"^",7),W1=$P(Z,"^",8),P0=$G(^FH(119.6,+W1,0)),Z3=$P(P0,"^",8),CC=$P($G(^FH(119.73,+Z3,0)),"^",1)
	I FHXX="C" S D2=$P(P0,"^",8) I FHP,FHP'=D2 Q
	I FHXX="W",FHP,FHP'=W1 Q
	S P0=$P(P0,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
	S TNOD=$S(FHXX="C":"99~"_CC,1:P0_"~"_WARD),CNOD=$S('SUM:TNOD,1:"0")
	D CUR^FHORD7 I FHLD="P" Q
	I FHOPT=3 D
	.S CTR=$G(^TMP($J,"C",CNOD,0))
	.I "^^^^"[FHOR S:'Z2 $P(CTR,"^",1)=$P(CTR,"^",1)+1 S:Z2 $P(CTR,"^",3)=$P(CTR,"^",3)+1
	.I "^^^^"'[FHOR,Z1="T" S:'Z2 $P(CTR,"^",2)=$P(CTR,"^",2)+1 S:Z2 $P(CTR,"^",4)=$P(CTR,"^",4)+1
	.S ^TMP($J,"C",CNOD,0)=CTR Q
	I "124"[FHOPT D
	.S RM=$G(^DPT(DFN,.101))
	.S RI=$G(^DPT(DFN,.108)) S RE=$S(RI:$O(^FH(119.6,"AR",+RI,W1,0)),1:"")
	.S R0=$S(RE:$P($G(^FH(119.6,W1,"R",+RE,0)),"^",2),1:"")
	.S R0=$S(R0<1:99,R0<10:"0"_R0,1:R0)
	.S PNOD=P0_"~"_R0_RM_"~"_DFN,X=^DPT(DFN,0) D PID^FHDPA
	.S XY=^FHPT(DFN,"A",ADM,"TF",TF,0)
	.S ^TMP($J,"T",TNOD,PNOD,0)=$E($P(X,"^",1),1,22)_"^"_BID_"^"_WARD_"^"_RM_"^"_$P(XY,"^",5,7) Q
	F TF2=0:0 S TF2=$O(^FHPT(DFN,"A",ADM,"TF",TF,"P",TF2)) Q:TF2<1  S YY=^(TF2,0) D LP
	Q
LP	S TP=$P(YY,"^",4) D PREP
	I "135"[FHOPT S:'$D(^TMP($J,"C",CNOD,TUN,0)) ^(0)="" S $P(^(0),"^",1)=$P(^(0),"^",1)+TU,$P(^(0),"^",2)=$P(^(0),"^",2)+1
	I "124"[FHOPT S ^TMP($J,"T",TNOD,PNOD,TF2,0)=$P(Y0,"^",1)_"^"_$P(Y0,"^",2)_"^"_TP_"^"_TW_"^"_TU_"^"_P1_"^"_STR_"^"_QUA_"^"_TUN
	Q
Q3	K ^FHPT("ADTF",DFN,ADM)
	I $D(^FHPT(DFN,"A",ADM,0)) S TF=$P(^(0),"^",4),$P(^(0),"^",4)="" I TF>0,$D(^FHPT(DFN,"A",ADM,"TF",TF,0)) S $P(^(0),"^",11)=NOW,ORIFN=$P(^(0),"^",14) I ORIFN S ORSTS=1 D ST^ORX
	Q
PREP	; Calculate Preparation
	S TUN=$P(YY,"^",1),Y0=$G(^FH(118.2,TUN,0)) Q:Y0=""
	S STR=$P(YY,"^",2),QUA=$P(YY,"^",3)
	I $E($P(Y0,"^",3),$L($P(Y0,"^",3)))="G" D GRM Q
	S TU=$P(YY,"^",4)/$S(+$P(Y0,"^",3):+$P(Y0,"^",3),1:9999),TW=$P(YY,"^",5)
	I TW<6 S TP="",TW="",TU=TU+.75\1,P1=TU Q
	S TU=TU+.2*4\1/4,TP=$J(TP/10,0)*10,TW=$J(TW/10,0)*10
	S P1=$S(TU<1:"",1:TU\1) I TU#1 S:P1 P1=P1_"-" S P2=TU#1,P1=P1_$S(P2<.3:"1/4",P2<.6:"1/2",1:"3/4")
	Q
GRM	; Calculate Gram
	S TW=0,X=QUA D FIX^FHORT10 S Z5="" F L=1:1:$L(X) I $E(X,L)'=" " S Z5=Z5_$E(X,L)
	S Z5=$P(Z5,"/",2),Z5=$P(Z5,"X",2)
	I 'Z5 S Z5=$P("1,24,2,3,12,8,6,4",",",K) G G1
	I Z5'["F" S Z5=$S(K=1:1,K=2:Z5,K=3:2,K=4:3,K=5:Z5\2,K=6:Z5\3,K=7:Z5\4,1:Z5\6)
	E  S:K=1 Z5=1
G1	S TU=+QUA*Z5
	S TU=TU/$S(+$P(Y0,"^",3):+$P(Y0,"^",3),1:9999)
	S P1=$S(TU<1:"",1:TU\1) I P1="" S TU=TU+.95\1,P1=TU
	I TU#1 S:P1 P1=P1_"-" S TU=TU#1,P1=P1_$S(TU<.3:"1/4",TU<.6:"1/2",1:"3/4")
	Q
