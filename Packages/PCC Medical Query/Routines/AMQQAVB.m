AMQQAVB ; IHS/CMI/THL - GETS BLOOD QUANTUM ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
COMPB I AMQQNOCO>1 D COMPB2 Q
 R !,"Blood Quantum: ",X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" Q
 I X?1."?" D HELPB G COMPB
 D CK
 I Y'=-1 S AMQQCOMP=X Q
 W "  ??",*7
 G COMPB
 ;
CK I X?1.N1"/"1.N,$P(X,"/",2)>+X S Y=X Q
 F %=1:1:4 S Z=$P("UNKNOWN^UNSPECIFIED^NONE^FULL",U,%) I $E(Z,1,$L(X))=X W $E(Z,$L(X)+1,99) S (X,Y)=Z G CKEXIT
 S Y=-1
 Q
CKEXIT I $E(X)="U",AMQQSYMB'="=" S Y=-1 Q
 I AMQQSYMB=">",$E(X)="F" S Y=-1 Q
 I AMQQSYMB="<",$E(X)="N" S Y=-1
 Q
 ;
TRANS ; ENTRY POINT FROM AMQQATL
 I X?1.N1"/"1.N S X=+X/$P(X,"/",2),X=$E(X,1,5)
 S X=$S(X=+X:X,$E(X)="F":1,$E(X,1,3)="UNK":1.1,$E(X,1,3)="UNS":1.2,$E(X)="N":0,1:"")
 Q
 ;
HELPB W !!,"Enter one of the following: 'FULL', 'NONE', 'UNKNOWN' or some fraction",!,"such as '1/2' or '5/8'.",!!
 Q
 ;
COMPB2 R !,"Blood Quantum (lower limit): ",X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" S X="NONE" W X
 I X?1."?" D HELPB G COMPB2
 I $E(X)="U" W "  ??",*7 G COMPB2
 D CK
 I Y=-1 W "  ??",*7 G COMPB2
 S X(1)=X
 G C21
C21 R !,"Blood Quantum (upper limit): ",X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" S X="FULL" W X
 I X?1."?" D HELPB G C21
 I $E(X)="U" W "  ??",*7 G C21
 D CK
 I Y=-1 W "  ??",*7
 S X(2)=X
 S AMQQCOMP=X(1)_";"_X(2)
 S X=X(1)
 D TRANS
 S X(1)=X
 S X=X(2)
 D TRANS
 S X(2)=X
 I X(2)<X(1) W "  WHOOPS...TRY AGAIN",*7,*7,! S AMQQCOMP="" G COMPB2
 Q
 ;
