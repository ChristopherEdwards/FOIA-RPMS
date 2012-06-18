UTIL ;JSH; 29 Oct 96 18:46;Function library part 1 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
SOC(P1,P2,SOC,T) ;EP - Set of Codes front end to readers
 ;P1,P2 same as reader
 ;SOC = code string
 ;T = type of reader (0 = scrolling, 1 = screen)
 N P21,I,J,X,DIC,Y,J1 S T=+$G(T)
 S $P(P1,";",9)="D TRANS^UTIL("_T_")",$P(P1,";",10)=""
 K ^UTILITY("UTSOC",$J)
 S P21="Choose from: " F I=1:1:$L(SOC,"^") S J=$P(SOC,"^",I),J1=$$CASECONV(J) S:I>1 P21=P21_", " S P21=P21_J,^UTILITY("UTSOC",$J,I,0)=J1,^UTILITY("UTSOC",$J,"B",J1,I)=""
 S ^UTILITY("UTSOC",$J,0)="CHOICE^1N^"_I_"^"_I S:$G(P2)="" P2=P21
 D @("^UT"_$S($G(T):"W",1:"S")_"RD(P1,P2)") K ^UTILITY("UTSOC",$J) Q X
TRANS(%E) ;input transform for reader
 ;%E = manipulate echo (0=no, 1=yes)
 Q:$E(X)="?"  X:%E $G(DIJC("EON"))
 S DIC="^UTILITY(""UTSOC"",$J,",DIC(0)="EM" D ^DIC K:+Y<0 X I +Y>0 S X=$P(Y,U,2)
 X:%E $G(DIJC("EOFF")) Q
 ;
AGE(DFN,S) ;Returns age of patient with entry # DFN as:
 ;                years^months^days
 ;Returns -1 if patient # invalid or date of birth invalid
 ;Returns -1^-1 if no date of birth, -1^1 if patient is dead
 ;If S parameter is passed with call by reference, it will have
 ; a formatted age as either Ny, Nm, Nd, or <1d.
 Q:'$D(^DPT(DFN)) -1
 Q:$P($G(^DPT(DFN,0)),U,3)="" "-1^-1"
 Q:$P($G(^DPT(DFN,0)),U,10)]"" "-1^1"
 N BD,M,X,XY,D
 S BD=$P(^DPT(DFN,0),"^",3),%DAT=$$CDATF2H^UTDT(BD) S X=+$H-%DAT,XY=X\365.25,M=X-(XY*365.25)\30.4375,D=X-(XY*365.25)-(M*30.4375)
 S S=$S(X<0:"unk",XY>1:XY,X>30:X\30.4375_"m",X:X_"d",1:"<1d") S:X="24m" X=2
 Q XY_U_M_U_D
 ;
CENTER(S,L) ;center text S in field of length L
 S S=$J("",L-$L(S)\2)_S Q S_$J("",L-$L(S))
 ;
CB(L) ;open window and clear to bottom
 Q:$G(L)=""  I '$D(IOXY)!'$D(DIJC("SR")) D VAR^DWUTL Q:POP
 N IOX,IOY,IOSR
 S IOSR=L+1_"^24",IOX=0,IOY=IOSR-1 X DIJC("SR"),IOXY,DIJC("EOP"),IOXY Q
 ;
 ;ENTRY POINT TO CLEAR LINES
CL(X) Q:'$D(IOXY)
 S:$G(X)="" X=23
 X "F I="_X_" S IOX=0,IOY=I X IOXY W "_DIJC("EOL")
 Q
 ;
LB(X) ;EP - Returns X with leading spaces stripped
 N I,Y S Y=X F I=1:1:$L(X) S:$E(X,I)=" " Y=$E(X,I+1,$L(X)) Q:$E(X,I)'=" "
 Q Y
 ;
TB(X) ;EP - Returns X with trailing spaces stripped
 N I,Y S Y=X F I=$L(X):-1:0 S:$E(X,I)=" " Y=$E(X,1,I-1) Q:$E(X,I)'=" "
 Q Y
 ;
LBTB(X) ;EP - Returns X with both leading and trailing spaces removed
 Q $$LB($$TB(X))
 ;
NOCTRL(X) ;Returns X with all control characters removed
 ;Control characters are $A values from 0-31,127
 Q $TR(X,$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;
INITIAL(DUZ) ;Returns INITIALS of user # DUZ
 Q $P($G(^DIC(3,DUZ,0)),U,2)
 ;
SETSCRL(Y1,Y2,C) ;Set scrolling region from Y1 to Y2 ($Y+1 values)
 ;C = Clear region or not (0:default = no, 1 = yes)
 Q:'$D(DIJTT)
 N IOSR,IOX,IOY S IOSR=Y1+1_"^"_(Y2+1) D:$G(C) CL(Y1_":1:"_Y2) X $G(DIJC("SR"))
 S IOX=0,IOY=Y1 X IOXY Q
 ;
NOSCROLL ;Remove scrolling region and leave cursor in current postition
 N IOX,IOY,IOSR S IOX=$X,IOY=$Y,IOSR="1^24" X DIJC("SR"),IOXY Q
 ;
PRIVBAN ;Display Privacy Act banner on 25th line
 D XUPR^DWUTL Q
 ;
CASECONV(STRING,CODE) ;EP - Returns STRING case converted according to CODE
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
REPLACE(STRING,ST1,ST2) ;EP - Replace all occurrences of ST1 in STRING with ST2
 ;Returns modified string.
 N %1,%S S %S=""
 F  S %1=$F(STRING,ST1) Q:'%1  S %S=%S_$E(STRING,1,%1-$L(ST1)-1)_ST2,STRING=$E(STRING,%1,999)
 Q %S_STRING
 ;
DUP(C,L) ;Returns a string of length L made by duplicating
 ;character(s) in C
 N %,I,S S %=L\$L(C)+1,$P(S,C,%+1)="" Q $E(S,1,L)
 ;  
FORMAT(S,W,D) ;EP - Formats string S into an array referenced by D with a
 ;maximum length of W in each array subscript
 N S1,I,% S %=1 K @D
 F  D  Q:S=""!($TR(S," ")="")
 . I $L(S)'>W S @D@(%)=S,S="" Q
 . F I=W:-1:1 Q:$E(S,I)=" "
 . S:I=1 I=W+1 S @D@(%)=$E(S,1,I-1),%=%+1,S=$E(S,I+(I'=(W+1)),999)
 Q
 ;
JUST(S,W,T,P) ;EP - returns string S in a field of width W
 ;T = "L" for left justify, = "R" for right justify
 ;P = 0 for pad with spaces, 1 = pad with zeros
 N %P
 S $P(%P,$S('P:" ",1:"0"),W-$L(S)+1)="",%P=$G(%P)
 Q:T="L" $E(S,1,W)_%P Q %P_$E(S,1,W)
 ;
ENV ;EP - Set up programming environment
 N X,%H,%,XQMTYPE,Y,DIC,Z
 I '$D(IOST) S (%ZIS,IOP)="" D ^%ZIS
 I '$G(DIJTT),$O(^%ZIS(2,IOST(0),"KEY1",0)) S X="DIJS"_IOST(0) S:$T(^@X)]"" DIJTT=IOST(0)
 ;IHS call differs from CHCS call. Assume IHS if DUZ("AG" not defined
 ;because user may usedthe programmer entry point without setting DUZ.
 ;This code must be hard coded differetly for the two systems.
 I '$D(DUZ("AG"))!($G(DUZ("AG"))="I") D DT^DICRW
 I $$SC^INHUTIL1 D VAR^DWUTL,SETLOG^%ZIS:'$D(IOHOME)
 ;**JSH 10/29/96 - SRS#961105002
ASKDUZ I '$G(DUZ) K DUZ S DIC(0)="QAEM",DIC="^DIC(3,",Y=-1 I $O(^DIC(3,0)) D ^DIC G:($E(X)'[U&(Y<0)) ASKDUZ S:Y>0 DUZ=+Y
 D:$$SC^INHUTIL1 IMODE^XQ1
 S:'$D(DUZ) DUZ=0
 I '$$SC^INHUTIL1,DUZ D DUZ^XUP(DUZ) Q
 D:DUZ DVARS^XQ1
 Q
 ;
