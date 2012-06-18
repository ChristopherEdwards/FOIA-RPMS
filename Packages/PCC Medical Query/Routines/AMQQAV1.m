AMQQAV1 ; IHS/CMI/THL - GETS OVERFLOW FROM AMQQAV ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
COMPF ; ENTRY POINT FROM AMQQAV
 I AMQQNOCO>1 G COMPF2
 I $D(AMQQXX) G COMPF1
 W !,?(5*$D(AMQQZNM)),$S(AMQQATN'=699:"What: ",1:"Which month(S): ")
 R X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" Q
 I X["^"!(X[":") W "  <- Can't use ""^"" or"":""",*7,!! K AMQQCOMP G COMPF
 I X?1."?",AMQQSYMB="?" W !!,"Enter the MUMPS pattern match code (e.g. '2N.E')",!! G COMPF
 I X?1."?" W !!,"Enter the comparison text or value.",!! G COMPF
COMPF1 I X="@" S X=""
 I $G(AMQQCOND)=82 D PATCK I '$D(X) W "  ??",*7 G COMPF
 I X["""" D QUOTES
 I AMQQATN=699,X["-"!X D BIRMON
 S AMQQCOMP=X
 Q
 ;
COMPF2 I $D(AMQQXX) N Z S Z=X,X=$P(X,";") G COMPF21
 R !,?(5*$D(AMQQZNM)),"Start with: ",X:DTIME E  S AMQQQUIT="" Q
COMPF21 I X?1."?" D COMPFH2 G COMPF2
 I X=U S AMQQQUIT="" Q
 I X="" S X=" "
 I X["^"!(X[":") W "  <- Can't use ""^"" or"":""",*7,!! K AMQQCOMP G COMPF2
 S AMQQCOMP=X
 I $D(AMQQXX) S X=$P(Z,";",2) G F21
F2 R !,?(5*$D(AMQQZNM)),"End with: ",X:DTIME E  S AMQQQUIT="" Q
F21 I X?1."?" D COMPFH2 G F2
 I X=U S AMQQQUIT="" K AMQQCOMP Q
 I X="" S X="|||||"
 I (X_AMQQCOMP)["^"!((X_AMQQCOMP)[";") W !!,"Your answer must not contain a ""^"" or "";"" ... Try again",*7,!! K AMQQCOMP G COMPF2
 S AMQQCOMP=AMQQCOMP_";"_X
 Q
 ;
COMPFH2 W !!,"Enter a letter at the beginning and end of the range",!!
 Q
 ;
COMPZ ; ENTRY POINT FROM AMQQAV
 I AMQQNOCO>1 G COMPZ2
 I $D(AMQQXX) G COMPZ1
 W !,?(5*$D(AMQQZNM)),"Enter the value (NEG -> 4+): "
 R X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" Q
 I X[U!X[";" W "  ??",*7 G COMPZ
 I X?1."?" W !!,"Choose from ""NEGATIVE"", ""TRACE"", 1+, 2+, 3+ or 4+",! G COMPZ
COMPZ1 S %=U_X
 S Y="^NEGATIVE;NEGATIVE^TRACE;TRACE^1+;1+^2+;2+^3+;3+^4+;4+"
 S Z=$F(Y,%)
 I 'Z Q:$D(AMQQXX)  W "  ??",*7 G COMPZ
 S %=$E(Y,Z,99)
 S X=$P(%,";")
 S Y=$P(%,";",2)
 S Y=$P(Y,U)
 W:'$D(AMQQXX) X
 S AMQQCOMP=Y
 Q
 ;
COMPZ2 W !,?(5*$D(AMQQZNM)),"Enter the first value (0 -> 4+): NEGATIVE// "
 R X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" S AMQQCOMP="NEGATIVE" W "  (NEGATIVE)" G Z2
 I X[U!X[";" W "  ??",*7 G COMPZ2
 I X?1."?" W !!,"Choose from ""NEGATIVE"", ""TRACE"", 1+, 2+, 3+ or 4+",! G COMPZ2
 S %=U_X
 S Y="^NEGATIVE;NEGATIVE^TRACE;TRACE^1+;1+^2+;2+^3+;3+^4+;4+"
 S Z=$F(Y,%)
 I 'Z W "  ??",*7 G COMPZ2
 S %=$E(Y,Z,99)
 S X=$P(%,";")
 S Y=$P(%,";",2)
 S Y=$P(Y,U)
 W X
 S AMQQCOMP=Y
 I $D(AMQQXX) S X=$P(Z,";",2) G Z21
Z2 W !,?(5*$D(AMQQZNM)),"Enter the second value (0 -> 4+): 4+// "
 R X:DTIME E  S X=U
Z21 I X=U S AMQQQUIT="" Q
 I X="" S X="4+" S AMQQCOMP=AMQQCOMP_";"_X Q
 I X[U!X[";" W "  ??",*7 G Z2
 I X?1."?" W !!,"Choose from ""NEGATIVE"", ""TRACE"", 1+, 2+, 3+ or 4+",! G Z2
 S %=U_X
 S Y="^NEGATIVE;NEGATIVE^TRACE;TRACE^1+;1+^2+;2+^3+;3+^4+;4+"
 S Z=$F(Y,%)
 I 'Z W "  ??",*7 G Z2
 S %=$E(Y,Z,99)
 S X=$P(%,";")
 S Y=$P(%,";",2)
 S Y=$P(Y,U)
 W X
 S %="NEGATIVETRACE1+2+3+4+"
 I $F(%,AMQQCOMP)>$F(%,Y) W "  ??",*7 G Z2
 S AMQQCOMP=AMQQCOMP_";"_Y
 Q
 ;
COMPQ ; ENTRY POINT FROM AMQQAV
 I $D(AMQQXX) G COMPQ1
 R !,?(5*$D(AMQQZNM)),"Result (""POS"" or ""NEG""): POS// ",X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" S X="POS" W "  POS"
 I X?1."?" W !!,"Enter ""POSITIVE"" or ""NEGATIVE""",! G COMPQ
COMPQ1 I "PN"'[$E(X) Q:$D(AMQQXX)  W "  ??",*7 G COMPQ
 I $E(X)="P" W $E("POSITIVE",1+$L(X),99)
 I $E(X)="N" W $E("NEGATIVE",1+$L(X),99)
 S X=$E(X)
 S AMQQCOMP=$S(X="P":"POS",1:"NEG")
 Q
 ;
QUOTES F  Q:X'[""""  S X=$P(X,"""")_"@#$"_$P(X,"""",2,99)
 F  Q:X'["@#$"  S X=$P(X,"@#$")_""""_""""_$P(X,"@#$",2,99)
 Q
 ;
PATCK S AMQQPCK=X,X="I X?"_AMQQPCK
 D ^DIM
 I '$D(X) Q
 S X=AMQQPCK K AMQQPCK
 Q
 ;
BIRMON ;EP;TO INTERPRET BIRTH MONTH;
 N Y,X1,X2,X3
 S X=$TR(X," ","-")
 S X1=$P(X,"-")
 S X2=$P(X,"-",2)
 I X2="",X1 S X2=X1
 I 'X1 S X1=$S(X1["JAN":1,X1["FEB":2,X1["MAR":3,X1["APR":4,X1["MAY":5,X1["JUN":6,X1["JUL":7,X1["AUG":8,X1["SEP":9,X1["OCT":10,X1["NOV":11,X1["DEC":12,1:"")
 I 'X2 S X2=$S(X2["JAN":1,X2["FEB":2,X2["MAR":3,X2["APR":4,X2["MAY":5,X2["JUN":6,X2["JUL":7,X2["AUG":8,X2["SEP":9,X2["OCT":10,X2["NOV":11,X2["DEC":12,1:"")
 F X3=X1:1:X2 S X1(X3)=$S(X3=1:"JAN",X3=2:"FEB",X3=3:"MAR",X3=4:"APR",X3=5:"MAY",X3=6:"JUN",X3=7:"JUL",X3=8:"AUG",X3=9:"SEP",X3=10:"OCT",X3=11:"NOV",X3=12:"DEC",1:"")
 S X=""
 S Y=0
 F  S Y=$O(X1(Y)) Q:'Y  S X=X_X1(Y)_" "
 Q
 ;-----
BM(X,VAL) ;EP;
 S X=$S(X=1:"JAN",X=2:"FEB",X=3:"MAR",X=4:"APR",X=5:"MAY",X=6:"JUN",X=7:"JUL",X=8:"AUG",X=9:"SEP",X=10:"OCT",X=11:"NOV",1:"DEC")
 I VAL[X S VAL=1
 E  S VAL=0
 Q VAL
 ;-----
