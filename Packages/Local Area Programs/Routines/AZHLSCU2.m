AZHLSCU2 ; IHS/ADC/GTH:KEU - UNDEF CHECKER. PROCESS "GRB" ; 
 ;;5.0;AZHLSC;;JUL 10, 1996
% S LINE=GRB,COM="" F I=0:0 S STR=$P(LINE,$C(9),1),LINE=$P(LINE,$C(9),2,999),NOA=0 D:STR]"" ARGG Q:LINE']""
 Q
 ;Process argument
ARGG D ^AZHLSCU9 S I=0,AC=999 F %=0:0 S %=$O(LV(%)) Q:%'>0  S I(%)=0
ARGS ;Proccess all agruments at this level
 S AC=LI+AC F  Q:AC'>LI  D INC Q:S=""  D ARG
 Q
 ;
ARG ;Process one argument
 I CH="," D PEEK Q
 Q:CH=Q
 I (CH?1A)!(CH="%") D LOC Q
 I CH="^" S LOC="G" G NAK:S="^",EXTGLO:S["[",GLO Q
 I CH="$" D FUN Q
 I CH="?" D PAT Q
 I CH="(" D INC S NOA=S D DN,INC Q
 Q
 ;
NAK S LOC="N" G GLO
EXTGLO D EG,INC S S=U_S
 G GLO
EG N GK,LOC S GK="",LOC="L" ;HANDLE EXTENDED GLOBAL
 F  D INC Q:"]"[CH  D ARG
 Q
GLO S X=$E(S,2,99)
 I S1="(" S S=S_S1 D PEEKDN S:(Y?1.N)!($A(Y)=34)!("^$J^$I^$H^"[(U_Y)) S=S_Y
 D ST(LOC,S) I S1="(" D INC2 S NOA=S D DN,INC
 Q
LOC S LOC="L"
 I S1="(" S S=S_S1 D PEEKDN S:(Y?1.N)!($A(Y)=34) S=S_Y
 D ST(LOC,S) I S1="(" D INC2 S NOA=S D DN,INC
 Q
PEEK S Y=$G(LV(LV,LI+1)) Q
INC2 S LI=LI+1 ;Drop into INC
INC S LI=LI+1,S=$G(LV(LV,LI)),S1=$G(LV(LV,LI+1)),CH=$E(S) G:$A(S)=10 ERR Q
DN S LI(LV)=LI,LI(LV,1)=AC,LV=LV+1,LI=LI(LV),AC=NOA
 D ARGS,UP Q
UP ;Inc LI as we save to skip the $C(10).
 D PEEK D:$A(Y)'=10 ERR S LI(LV)=LI+1,LV=LV-1,LI=LI(LV),AC=LI(LV,1) Q
PEEKDN S Y=$G(LV(LV+1,LI(LV+1)+1)) Q
ERR S (S,S1,CH)="" Q
 S Z=$P(LV(LV+1),$C(9),LI(LV+1),99),Z=$P(Z,$C(10)) W !,"COUNT=",$L(Z,",")
 ;functions
FUN N FUN S FUN=S G EXT:S["$$",SPV:S1'["(" S NOA=$P(S,"^",2)
 D INC2
 I FUN'["$$" G:FUN["$TE" TEXT I FUN["$N" D ST("MK","$N")
 S Y=1 F Z1=LI(LV+1)+1:1 S X=$G(LV(LV+1,Z1)) Q:$A(X)=10!(X="")  S:X="," Y=Y+1
 S NOA=S D DN,INC
 Q
 ;
TEXT D PEEKDN S NOA=S D ST("MK","$T("_$S($$VN(Y):Y,1:"")) I $$VN(Y) S LI(LV+1)=LI(LV+1)+1,NOA=NOA-1 D ST("I",Y)
 D DN,INC Q
 ;special variables
SPV ;
 Q
EXT ;Extrinsic functions
 I $E(S1)="^" S Y=$E(S1,2,99)_" "_S D INC S S=Y ;Build S and fall thru
 D ST($S(S[" ":"X",1:"I"),S) ;Internal, eXternal
 I S1["(" D INC2 S NOA=S D DN,INC ;Process param.
 Q
PAT F I=2:1 S CH=$E(S,I) D PATQ:CH=Q I CH=""!(CH'?1N&("ACELNPU."'[CH)) Q
 S S=$E(S,I,999) Q
PATQ F I=I+1:1 S CH=$E(S,I) Q:CH=""!(CH=Q)
 S I=I+1,CH=$E(S,I) G:CH=Q PATQ
 Q
ST(LOC,S) S:'$D(V(LOC,S)) V(LOC,S)="" I $D(GK),GK]"",V(LOC,S)'[GK S V(LOC,S)=V(LOC,S)_GK
 S GK="" Q
VN(X) ;Check if a valid name
 Q (X?1A.7AN)!(X?1"%".7AN)!(X?1.8N)
