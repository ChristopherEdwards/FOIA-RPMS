ACHSA2 ; IHS/ITSC/PMF - ENTER DOCUMENTS (3/8)-(BLANKET DESCRIPTION) ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
A1 ;
 K A
 S ACHSBLT=$G(ACHSBLT)
 I ACHSBLT]"" W !!?9,"Blanket Description" G E1
 W !!,"Blanket Description: "
 D READ^ACHSFU
 G END:$G(ACHSQUIT),Q1:Y?1"?".E
 I Y="" W *7,!!,"  The Description Is Required To Complete This Document" G A1
 S ACHSBLT=Y
E1 ;
 K A
 S C=0,J=99
 F I=1:1 S Y=$P(ACHSBLT," ",I) Q:Y=""  S:($L(Y)+J>37) C=C+1,A(C)="",J=0 S:A(C)]"" A(C)=A(C)_" ",J=J+1 S A(C)=A(C)_Y,J=J+$L(Y)
 W !!
 F I=1:1 Q:'$D(A(I))  W !,"Line ",I,": ",A(I)
 S L=I-1
E2 ;
 W !!,"Edit Line #: "
 D READ^ACHSFU
 G END:$G(ACHSQUIT)
 I Y?1"?".E W !,"  Enter The Number Of The Line You Wish To Edit",!,"  Select 1 to ",L G E2
 G E9:Y=""
 I +Y'=Y!(Y<1)!(Y>L) W *7,"  ??" G E2
 S X=A(Y),N=Y
E3 ;
 W !,X,!,"  Replace: "
 D READ^ACHSFU
 G E1:$D(DUOUT),END:$G(ACHSQUIT),Q2:Y?1"?".E
 I Y="END" S P=$C(1) G E6
 G E7:Y=""
 D SB1
 I P="" W *7,"  ??" G E3
E6 ;
 W:$X>60 !
 W "  With: "
 D READ^ACHSFU
 G E1:$D(DUOUT),END:$G(ACHSQUIT)
 I Y?1"?".E W !,"  Enter The New Characters or 'RETURN' If None" G E6
 S X=$P(X,P)_Y_$P(X,P,2,999)
 G E3:X]"",E7
E7 ;
 S ACHSBLT="",L=0,A(N)=X
 F I=1:1 Q:'$D(A(I))  I A(I)]"" S L=L+$L(A(I)) G E8:L>150 S:ACHSBLT]"" ACHSBLT=ACHSBLT_" " S ACHSBLT=ACHSBLT_A(I)
 G E1
 ;
E8 ;
 S ACHSBLT=ACHSBLT_$S(ACHSBLT="":"",1:" ")_$E(A(I),1,150-$L(ACHSBLT))
 W *7,!,"  Too Long... (150 Character Max.)"
 G E1
 ;
E9 ;
 K:ACHSBLT="" ACHSBLT
END ;
 K A,B,C,E,F,I,J,L,N,P,R,S,W,X
 Q
 ;
SB1 ;
 S F=$L(Y,"..."),(P,S)=""
 Q:F>2
 S R=$P(Y,"..."),E=$F(X,R)
 Q:'E
 S E=E-1
 S B=E-$L(R)+1
 I F>1 S Y=$P(Y,"...",2) S:Y="" E=999 I Y]"" S W=$F(X,Y,E+1) Q:'W  S E=W-1
 S P=$E(X,B,E)
 Q
 ;
Q1 ;
 W !!,"  Enter A Description For This Document.",!,"  It Will Be Printed In Place Of The",!,"  Patient Identification Data On The Form."
 W !!,"  The Maximun Length Allowed Is 150 Characters.",!,"  Type The Description In Single  Stream Of Characters",!,"  (ie. Don't Press The Return Key Until The End)."
 G A1
 ;
Q2 ;
 W !!,"  Enter The Characters You Wish To Delete.",!,"  Then You Will Be Asked To Enter The Characters To",!,"  Replace The Just Deleted Characters, If any.",!
 G E3
 ;
