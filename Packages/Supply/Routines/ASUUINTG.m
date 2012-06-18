ASUUINTG ; IHS/ITSC/LMH - MASTER TO HISTORY INTEGRITY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
VALQTY ;
 N S,X,H,C,V,Q,F,F1,E
 S S=40002,X=0,F1=0
 F  S X=$O(^ASUMS(S,1,X)) Q:X'?1N.N  D
 .S V=$P(^ASUMS(S,1,X,0),U,16),Q=$P(^ASUMS(S,1,X,0),U,17),F=0
 .S H=999999999 F C=0:1 S H=$O(^ASUH("I",X,H),-1) Q:H']""  D  Q:F=1
 ..S HQ=$P(^ASUH(H,1),U,6),HV=$P(^ASUH(H,1),U,7),HS=$P(^ASUH(H,0),U,24),HMQ=$P(^ASUH(H,0),U,21),HMV=$P(^ASUH(H,0),U,22)
 ..I HMQ=Q,HMV=V D
 ...S Q=(Q-(HQ*HS)),V=(V-(HV*HS))
 ..E  D  Q
 ...I F1=0 D
 ....S F1=1
 ....W !,"INDEX",?8,"QTY",?14," VALUE ",?23,"HIST"
 ....W ?29,"HQTY",?35,"MQTY",?41,"QTYD"
 ....W ?47,"  VALUE ",?57,"MSTRVAL",?67," VAL DIFF ",?77,"TRANS BACK"
 ...W !,$E(X,3,7),".",$E(X,8)
 ...W ?8,$J($FN(Q,","),5)
 ...W ?14,$J($FN(V,",",2),8)
 ...W ?23,$J(H,5),?29,$J($FN(Q,","),5)
 ...W ?35,$J($FN(HMQ,","),5)
 ...W ?41,$J($FN((Q-HMQ),","),5)
 ...W ?47,$J($FN(V,",",2),8)
 ...W ?57,$J($FN(HMV,",",2),8)
 ...W ?67,$J($FN((V-HMV),",",2),8)
 ...S F=1,E=$G(E)+1
 .W:$G(F)>0 ?76,$J($FN(C,","),4)
 W !!,"TOTAL ERRORS:",$J($FN($G(E),","),8)
 Q
KEYS ;
 N H,K,B,D,A,S
 S H=0 F C=0:1 S H=$O(^ASUH(H)) Q:H'?1N.N  D
 .S K=$P(^ASUH(H,0),U),D=$P(K,"-",2),S=$P(K,"-",3)
 .I D'=$G(B) W:D'>$G(B) !,"DATE SEQ ERR:PREV:",B," NEXT:",D S B=D,A=1
 .I A'=+S W !,"SEQ ERR:#",H," DATE:",D," SEQ:",$J(+S,6)," CNT:",$J(A,6) I S>A W "   DROPED:",A W:S>(A+1) "-",(S-1) S A=S
 .S A=$G(A)+1
 Q
