LABCX7XX ; IHS/DIR/FJE - BECKMAN BIDIRECTIONAL DIRECT CONNECT INTERFACE 8/16/90 14:53 COPY FOR INSTRUMENT #-- ; [ 05/14/1999  10:03 AM ]
 ;;5.2;LA;**1004**;MAY 14, 1999
 ;;5.1;LAB;;04/11/91 11:06
0 S LANM=$T(+0),(TSK,T)=+$E(LANM,7,8) Q:+T<1  Q:$D(^LA("LOCK",T))  S IOP=$P(^LAB(62.4,T,0),"^",2) G:IOP="" H^XUS D NOW^%DTC S DT=X K ^LA(T) D ^LABCX7I
 S X="ERR^ZU",@^%ZOSF("TRAP") ;*** JPC - MOVED HERE FROM LINE DQ (SO RESTART INSTRUMENT CAN BE USED, WHICH CALLS TOP OF ROUTINE)
 I $D(ZTSK) D KILL^%ZTLOAD K ZTSK ;*** JPC - ADDED IN CASE ITS TASKED
LA2 K RES,TV,Y S A=1 G RD:OUT="" D:$D(^LA(DEB,0)) DBO
 I $A(OUT)<32 W OUT G RD
 I OUT["]" W OUT,! S OUT=$C(10) D:$D(^LA(DEB,0)) DBO G RD
 W OUT G TOUT
RD S TOUT=5 S IN="",A=0 R *X:TOUT G:'$T TOUT D:$D(^LA(DEB,0)) DBX S IN=$C(X) D IN G RD1:IN="["
 I X=^LA(T,"P2") S ^("P2")=$S(X=ACK:ETX,1:ACK) ;,^LA(T,"P3")=^LA(T,"O",0)
 I X=ETX S ^LA(T,"P3")=^LA(T,"O",0)+1 G TOUT
 I X=ACK S ^LA(T,"P3")=^LA(T,"O",0)+1 G TOUT
 I X=LB S ^LA(T,"P")="IN",OUT=$C(ACK),^("P1")=ETX G LA2
 I X=LBO S OUT=$C(NAK) G LA2
 I X=EOT S ^LA(T,"P")="",(^("P1"),^("P2"))=ACK,OUT="" G LA2
 I X=ENQ G LA2
 I X=NAK D CHECK G W ; S ^LA(T,"O",0)=^LA(T,"P3") G W
 S OUT="" G LA2
RD1 S TOUT=2,CK=X,FL=1,^LA(T,"P")="IN"
RD2 F I=0:0 Q:$L(IN)=255  R *X:TOUT Q:('$T!(X=13))  S:FL CK=CK+X S IN=IN_$C(X) S:X=93 FL=0
 D:'$D(^LA(T,"I")) SET D IN,QC,DBI:$D(^LA(DEB,0)) S LN=$L(IN)
 I LN=255,(IN'["]") S IN="" G RD2
 I LN<255,(IN'["]") S OUT=$C(NAK) G LA2
 S OUT=$C(^LA(T,"P1")),^LA(T,"P1")=$S(^LA(T,"P1")=ACK:ETX,1:ACK)
 K TV S (TRAY,CUP,ID,IDE,RMK)="",ST=+$P(Y(1),",",2),FC=+$P(Y(1),",",3) G @ST
700 ;
703 I FC=4 S ^LAZ("ZZZ",T)=Y(1) G LA2
704 G LA2
701 G:FC#2 LA2 D:FC=2 RET D:FC=6 ^LABCX7R G:RC>0 LA2 W OUT D:$D(^LA(DEB,0)) DBO G TOUT
702 D HDR:FC=1,RES:FC=3,EOC:FC=5,RES2:FC=11,RES2:FC=13 ;*** JPC - 11,13
 G LA2
W ;
 S OUT="",CNT=^LA(T,"O",0)+1 I $D(^(CNT)) S ^(0)=CNT,OUT=^(CNT)
 S:OUT=$C(4,1) ^LA(T,"P")="PEND" G LA2
TOUT S %H=$H D YMD^%DTC S:LADT'=X LADT=X K %,%H
 I $D(^LA("STOP",T)) K ^LA("LOCK",T),^LA("STOP",T) H
 I $D(^LA(T,"O")),^LA(T,"O")>^LA(T,"O",0) G W
 I ^LA(T,"O")=^LA(T,"O",0) K ^LA(T,"O") S (^LA(T,"O"),^LA(T,"O",0))=0
 G RD
QC S A=A+1,Y(A)=IN Q
NUM S X="" F JJ=1:1:$L(V) S:$A(V,JJ)>32 X=X_$E(V,JJ)
 S V=X Q
IN Q:IN="["  L ^LA(T,"I") S (CNT,^LA(T,"I"),^LA(T,"I",0))=^LA(T,"I")+1,^LA(T,"I",CNT)=$S($L(IN)>1:IN,1:"~"_$C(X+64)) K:CNT>100 ^LA(T,"I",CNT-100) L  Q
DQ K ^LA("LOCK",$E($T(+0),7,8)),^LA("STOP",$E($T(+0),7,8)) G 0 ;*** JPC - KILL STOP NODE IN CASE IT WAS STOPPED WHEN NOT RUNNING
SET S:'$D(^LA(T,"I"))#2 ^LA(T,"I")=0,^("I",0)=0
SETO S:'$D(^LA(T,"O"))#2 ^LA(T,"O")=0,^("O",0)=0 Q
TRAP Q  ;D ^LABERR S T=TSK D SET^LAB G @("LA2^"_LANM)
DBO S (Q,^LA(DEB,0))=^LA(DEB,0)+1,^(Q)="OUT: "_$S($L(OUT)>2:$E(OUT,1,230),$L(OUT)=1:"~"_$C($A(OUT)+64),1:"~"_$C($A(OUT,1)+64)_"~"_$C($A(OUT,2)+64))_"%^%"_$H Q
DBX Q:X=91  S (Q,^LA(DEB,0))=^LA(DEB,0)+1,^(Q)="IN: "_$S(X>31:$C(X),1:"~"_$C(X+64))_"%^%"_$H Q
DBI S (Q,^LA(DEB,0))=^LA(DEB,0)+1,^(Q)="IN: "_$E(IN,1,230)_"%^%"_$H Q
HDR ;
 S TRAY=$P(Y(1),",",8) I $E(TRAY)=" " S TRAY=$E(TRAY,2)
 S CUP=$P(Y(1),",",9) I $E(CUP)=" " S CUP=$E(CUP,2)
 S ID=$E($P(Y(1),",",13),1,11),AA=$E(ID,1,3),AID=+$E(ID,8,11),AAN=0
AAN S AAN=$O(^LRO(68,"B",AA,AAN)) I AAN I ^LRO(68,"B",AA,AAN)="" G AAN
 I AAN="" S ^LAZ("ZZZ",ID)="INVALID ACCESSION AREA" Q
 S LWL=$P(^LAB(62.4,T,0),U,4)
 ;FHL - Y2K 9/21/98 S D1=$P(Y(1),",",4),FDT=2_$E(D1,5,6)_$E(D1,3,4)_$E(D1,1,2)
 ;FHL - Y2K 9/21/98
 ;D1 appears to be in international format (DDMMYY)
 ;So with %DT="I" (international date format flag) ^%DT should
 ;convert D1 directly to fm formated date. ^%DT handles 2 digit
 ;years correctly until 2018.
 ;
 K %DT S D1=$P(Y(1),",",4),%DT="I",X=D1 D ^%DT S:Y'=-1 FDT=Y K %DT
 I Y=-1 S X="T" D ^%DT S FDT=Y
 L ^LAH(LWL) I $D(^LAH(LWL))#10=0 S ^LAH(LWL)=0
SUB S (SUB,^LAH(LWL))=^LAH(LWL)+1 G:$D(^LAH(LWL,1,SUB)) SUB L
 S ^LAH(LWL,1,SUB,0)=TRAY_U_CUP_U_AAN_U_FDT_U_AID_"^^CX7"
 S ^LAH(LWL,1,"B",TRAY_";"_CUP,SUB)=""
 S ^LAH(LWL,1,"C",AID,SUB)=""
 Q
RES ;
 S ID=$E($P(Y(1),",",10),1,11),AID=+$E(ID,8,11),AA=$E(ID,1,3),AAN=0
AAN2 S AAN=$O(^LRO(68,"B",AA,AAN)) I AAN I ^LRO(68,"B",AA,AAN)="" G AAN2
 I AAN="" Q
 S LWL=$P(^LAB(62.4,T,0),U,4)
 S T1=$P($P(Y(1),",",11)," "),LO=0 F I=1:1 S LO=$O(^LAB(62.4,T,3,LO)) Q:LO=""  Q:$P(^LAB(62.4,T,3,LO,0),U,6)=T1  ;**JPC - T1 CHANGE TO $P(... " ") TO ALLOW FOR 4 CHAR NAMES
 I '$D(SUB) S SUB=0 F  S SUB=$O(^LAH(LWL,1,"C",AID,SUB)) Q:SUB=""  S T0=$G(^LAH(LWL,1,SUB,0)) Q:$P(T0,U,3)=AAN  ;**JPC - WITH MULT ACCN AREAS, NEED TO VERIFY CORRECT SUB
 Q:SUB=""
 I LO="" S ^LAZ("ZZZ",ID)=T1_" NOT IN THE AUTO INSTRUMENT FILE" Q  ;JPC FIXED SPELLING OF INSTRUMENT
 S T2=$P($P(^LAB(62.4,T,3,LO,1),"(",2),",",1)
 S RES=$P(Y(1),",",16) F I=1:1:8 I $E(RES)=" " S RES=$E(RES,2,$L(RES))
 S ^LAH(LWL,1,SUB,T2)=RES
 Q
EOC ;end of cup record, clean up LA(T,"I")
 I ^LA(T,"I")=^LA(T,"I",0) K ^LA(T,"I") S (^LA(T,"I"),^LA(T,"I",0))=0
 S ID=$E($P(Y(1),",",7),1,11) K ^LAZ(ID) Q
 ;
RES2 ; *** JPC - ADDED RES2 TO PROCESS SPECIAL CALC AND TIMED URINE
 ; PARAM 3 IN AUTO INSTR SHOULD MATCH NAMES ON CX7
 Q:$P(Y(1),",",12)'="OK"  ;check status--quit if not valid calc
 S ID=$E($P(Y(1),",",9),1,11),AID=+$E(ID,8,11),AA=$E(ID,1,3),AAN=0
AAN21 S AAN=$O(^LRO(68,"B",AA,AAN)) I AAN I ^LRO(68,"B",AA,AAN)="" G AAN21
 I AAN="" Q
 S LWL=$P(^LAB(62.4,T,0),U,4)
 S T1=$P(Y(1),",",11),LO=0 F I=20:-1:2 Q:$E(T1,I)'=" "  S T1=$E(T1,1,I-1)
 F I=1:1 S LO=$O(^LAB(62.4,T,3,LO)) Q:LO=""  Q:$P(^LAB(62.4,T,3,LO,0),U,4)=T1
 I '$D(SUB) S SUB=0 F  S SUB=$O(^LAH(LWL,1,"C",AID,SUB)) Q:SUB=""  S T0=$G(^LAH(LWL,1,SUB,0)) Q:$P(T0,U,3)=AAN
 Q:SUB=""
 I LO="" S ^LAZ("ZZZ",ID)=T1_" NOT IN THE AUTO INSTRUMENT FILE" Q
 S T2=$P($P(^LAB(62.4,T,3,LO,1),"(",2),",",1)
 S RES=$P(Y(1),",",13) F I=1:1:8 I $E(RES)=" " S RES=$E(RES,2,$L(RES))
 S ^LAH(LWL,1,SUB,T2)=RES
 Q
 ;
CHECK ;come here on NAK
 S CK=CNT-1 I ^LA(T,"I",CK)'="~U" S ^LA(T,"O",0)=^LA(T,"P3")-1 Q  ;***JPC - SUBTRACT 1 FROM COUNTER IN P3 NODE
 S CT=^LA(T,"O",0) I ^(CT)["[" S NID=$P(^(CT),",",9),^LAZ("ZZZ",NID)="Response to Host Query, Device "_T_", Failed"
 F I=(CT+1):1 Q:'$D(^LA(T,"O",I))  Q:$E(^LA(T,"O",I))="["
 I I>^LA(T,"O") S I=^LA(T,"O")+1 ;***JPC - ADD 1 FOR NEXT LINE
 S ^LA(T,"O",0)=I-1 K CK,CT,NID Q  ;***JPC - SUBTRACT 1
RET ;Capture return code from 701-02.  Report on error list.
 S RC=$P(Y(1),",",4) I $E(RC)=" " S RC=$E(RC,2)
 S SID=$E($P(Y(1),",",8),1,11) I RC=0 K ^LAZ("ZZZ",SID),SID S RC=1 Q
 S ^LAZ("ZZZ",SID)=^LAZ("ZZZERROR",RC) K SID Q
