INHUTIL ;JSH; 6 Mar 96 13:04;Function library part 1 - VA version
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
SOC(P1,P2,SOC,T) ;Set of Codes front end to readers
 ;P1,P2 same as reader
 ;SOC = code string
 ;T = type of reader (0 = scrolling, 1 = screen)
 N P21,I,J,X,DIC,Y
 S $P(P1,";",9)="D TRANS^UTIL("_T_")",$P(P1,";",10)=""
 K ^UTILITY("UTSOC",$J)
 S P21="Choose from: " F I=1:1:$L(SOC,"^") S J=$P(SOC,"^",I) S:I>1 P21=P21_", " S P21=P21_J,^UTILITY("UTSOC",$J,I,0)=$P(SOC,U,I),^UTILITY("UTSOC",$J,"B",$P(SOC,U,I),I)=""
 S ^UTILITY("UTSOC",$J,0)="CHOICE^1N^"_I_"^"_I S:$G(P2)="" P2=P21
 D @("^UT"_$S($G(T):"W",1:"S")_"RD(P1,P2)") K ^UTILITY("UTSOC",$J) Q X
TRANS(%E) ;input transform for reader
 ;%E = manipulate echo (0=no, 1=yes)
 Q:$E(X)="?"  X:%E $G(^%ZOSF("EON"))
 S DIC="^UTILITY(""UTSOC"",$J,",DIC(0)="EM" D ^DIC K:+Y<0 X I +Y>0 S X=$P(Y,U,2)
 X:%E $G(^%ZOSF("EOFF")) Q
 ;
CENTER(S,L) ;center text S in field of length L
 S S=$J("",L-$L(S)\2)_S Q S_$J("",L-$L(S))
 ;
LB(X) ;Returns X with leading spaces stripped
 N I,Y S Y=X F I=1:1:$L(X) S:$E(X,I)=" " Y=$E(X,I+1,$L(X)) Q:$E(X,I)'=" "
 Q Y
 ;
TB(X) ;Returns X with trailing spaces stripped
 N I,Y S Y=X F I=$L(X):-1:0 S:$E(X,I)=" " Y=$E(X,1,I-1) Q:$E(X,I)'=" "
 Q Y
 ;
LBTB(X) ;Returns X with both leading and trailing spaces removed
 Q $$LB($$TB(X))
 ;
NOCTRL(X) ;Returns X with all control characters removed
 ;Control characters are $A values from 0-31,127
 Q $TR(X,$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;
CASECONV(STRING,CODE) ;Returns STRING case converted according to CODE
 ;CODE = U  (to upper case)
 ;CODE = L  (to lower case)
 S:'$D(CODE) CODE="U"
 Q:CODE="U" $TR(STRING,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q:CODE="L" $TR(STRING,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 Q STRING
 ;
NAME(NAME,F) ;Returns NAME (in FileMan storage form LAST,FIRST MIDDLE)
 ;formatted according to format string F.
 N %F,%M,%L,%N,I S %L=$P(NAME,","),%F=$P($P(NAME,",",2)," "),%M=$P($P(NAME,",",2)," ",2)
 S %N="" F I=1:1:$L(F) D
 . I "FML"[$E(F,I) S %N=%N_@("%"_$E(F,I)) Q
 . S %N=%N_$E(F,I) Q
 Q %N
 ;
REPLACE(STRING,ST1,ST2) ;Replace all occurrences of ST1 in STRING with ST2
 ;Returns modified string.
 N %1,%S S %S=""
 F  S %1=$F(STRING,ST1) Q:'%1  S %S=%S_$E(STRING,1,%1-$L(ST1)-1)_ST2,STRING=$E(STRING,%1,999)
 Q %S_STRING
 ;
DUP(C,L) ;Returns a string of length L made by duplicating
 ;character(s) in C
 N %,I,S S %=L\$L(C)+1,$P(S,C,%+1)="" Q $E(S,1,L)
 ;  
FORMAT(S,W,D) ;Formats string S into an array referenced by D with a
 ;maximum length of W in each array subscript
 N S1,I,% S %=1 K @D
 F  D  Q:S=""!($TR(S," ")="")
 . I $L(S)'>W S @D@(%)=S,S="" Q
 . F I=W:-1:1 Q:$E(S,I)=" "
 . S:I=1 I=W+1 S @D@(%)=$E(S,1,I-1),%=%+1,S=$E(S,I+(I'=(W+1)),999)
 Q
 ;
JUST(S,W,T,P) ;returns string S in a field of width W
 ;T = "L" for left justify, = "R" for right justify
 ;P = 0 for pad with spaces, 1 = pad with zeros
 N %P
 S $P(%P,$S('P:" ",1:"0"),W-$L(S)+1)="",%P=$G(%P)
 Q:T="L" $E(S,1,W)_%P Q %P_$E(S,1,W)
 ;
ENV ;Set up user environment
 I '$G(DUZ) S DIC="^DIC(3,",DIC(0)="QAEM" D ^DIC Q:Y<0  S DUZ=+Y
 X $G(^INRHSITE(1,1)) Q
 ;
ACTV(BIT) ;activate/inactivate all active messages in Script Generator
 ;        Message file #4011
 ;input:
 ;  BIT - (req,pbv) 1:inactive, 0:active
 N INI,P01
 S P01=""
 F  S P01=$O(^INTHL7M("B",P01)) Q:P01=""  D
 .S INI=""
 .F  S INI=$O(^INTHL7M("B",P01,INI)) Q:'INI  D
 ..S $P(^INTHL7M(INI,0),U,8)=BIT
 ..W:$X>(IOM-($L(P01)+$S(BIT:11,1:9))) !
 ..W P01_$S(BIT:" in",1:" ")_"active.    "
 Q
QS(GLB,SUB) ; return subscript - temporary replacement for $QS
 ; Input:
 ; (r) GLB - Global node
 ; (r) SUB - Subscript of node
 N I,N,P,PO,S,X,%
 I SUB<1 S GLB=$TR($P(GLB,"("),"[]","||") D  Q $G(X(SUB))
 . I GLB["|" S X(-1)=$P(GLB,"|",2),X(-1)=$E(X(-1),2,$L(X(-1))-1),X(0)=$P(GLB,"|",1)_$P(GLB,"|",3)
 . E  S X(0)=GLB
 S GLB=$P(GLB,"(",2),GLB=$E(GLB,1,$L(GLB)-1)
 S S=1,P=1,PO=0 F  S X(S)=$P(GLB,",",P,P+PO) Q:'$L(X(S))  S %=$L(X(S),"""")#2 S:% S=S+1,P=P+1+PO,PO=0 S:'% PO=PO+1 Q:S>SUB
 S GLB=$G(X(SUB)),N=$E(GLB)
 I 'N,N'=0 S GLB=$E(GLB,2,$L(GLB)-1),%=0 F  S %=$F(GLB,"""""",%-1) Q:'%  S GLB=$E(GLB,1,%-3)_""""_$E(GLB,%,999)
 Q GLB
