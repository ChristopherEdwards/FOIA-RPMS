LRBLB ; IHS/DIR/FJE - BLOOD BANK BAR CODE READER 11/12/88 15:15 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
X S X=$E(X,LR,$L(X)),A=$E(X),B=$E(X,$L(X)) Q
W W ?32,"(Bar code)" Q
U ;from LRBLDRR, LRBLJLG
 D X I 'LR(3),X?7N S A=+$E(X,1,2),B=A\20,B=$E("FGKL",B),A=A#20+1,A=$E("CEFGHJKLMNPQRSTVWXYZ",A),A=B_A S X=A_$E(X,3,7) D W W ?45,"UNIT ID: ",X Q
 Q
A ;ABO/RH GROUPING
 D X I X?3N,$E(X,3)=0 S A=$T(@(+$E(X,1,2))),X=$P(A,";",3) K:X="" X Q:'$D(X)  D W W ?46,"ABO/Rh: ",X S LRABO=$P(X," "),LRRH=$P(X," ",2) Q
 Q
P ;PRODUCT CODE
 D X I X?7N&(A=0!(A=3))&(B=3) S X=$E(X,2,6),Y=0 D W,C
 Q
C F A=1:1 S Y=$O(^LAB(66,"D",X,Y)) Q:'Y  S X(A)=Y_"^"_^LAB(66,Y,0)
 I A=2 S W(4)=+X(1),P=$P(X(1),U,2),W(9)=$P(X(1),U,20),LRV=$P(X(1),U,11),LRJ=$P(X(1),U,26),X=P W !?24,P Q
 W ! S Y=0 F A=0:1 S Y=$O(X(Y)) Q:'Y  W !?2,Y,")",?5,$P(X(Y),U,2)
 I A=0 K X Q
H W !,"CHOOSE 1-",A,": " R X:DTIME I X=""!(X[U) K X Q
 I X<1!(X>A) W $C(7) G H
 S W(4)=+X(X),P=$P(X(X),U,2),W(9)=$P(X(X),U,20),LRV=$P(X(X),U,11),LRJ=$P(X(X),U,26),X=P W ?25,P Q
R ;FDA REG #
 D X I X?9N&(B=1)&(A=0!(A=1)) S X=$E(X,2,8) D W W !?2,"Registration number: ",X Q
 Q
D ;DATE CODE
 D X I X'?6N Q
 S %DT="" D ^%DT S W(6)=Y I Y<1 K X Q
 D D^LRU D W W ?44,"Exp date: ",Y Q
BAR ;TEST BAR CODE READER
 S LR="" W !!?28,"To use BAR CODE READER",!?15,"Pass reader wand over a GROUP-TYPE (ABO/Rh) label",!?25,"=> " R X:DTIME Q:X=""!(X["^")  W " (bar code)"
 F A=1:1 S Y=$P($T(G+A),";",4) Q:Y=""  S X(1)=$F(X,Y) I X(1),$L(X)<X(1) S LR=$L(X)-3,LR(2)=$E(X,1,LR),LR=LR+1 Q
 I LR="" W $C(7),!!?28,"Not a GROUP-TYPE label",!?15,"Press <RETURN> key if BAR CODE READER is not used",! G BAR
 W " ",$P($T(G+A),";",3) K X Q
 ;
T ;from LRBLDRR1, LRBLJLG
 F A=1:1 S Y=$P($T(G+A),";",3) Q:Y=""  S:X=$E(Y,1,$L(X)) X(A)=Y
 I $D(X)'=11 K X D S Q
 K Y S Y=0 F A=1:1 S Y=$O(X(Y)) Q:'Y  S Y(A)=X(Y) K X(Y)
 I A=2 S LRABO=$P(Y(1)," ",1),LRRH=$P(Y(1)," ",2) W $E(Y(1),$L(X)+1,$L(Y(1))) Q
 W ! S Y=0 F A=0:1 S Y=$O(Y(Y)) Q:'Y  W !?2,Y,")",?5,Y(Y)
AG W !,"CHOOSE 1-",A,": " R X:DTIME I X=""!(X["^") K X Q
 I X<1!(X>A) W $C(7) G AG
 W " ",Y(X) S LRABO=$P(Y(X)," ",1),LRRH=$P(Y(X)," ",2) Q
S W !!,"Select from (NA=not applicable): " F A=1:1 W !?15,$P($T(G+A),";",3) Q:$T(G+A)=""
 Q
G ;;
51 ;;O POS;510
62 ;;A POS;620
73 ;;B POS;730
84 ;;AB POS;840
95 ;;O NEG;950
6 ;;A NEG;060
17 ;;B NEG;170
28 ;;AB NEG;280
55 ;;O;550
66 ;;A;660
77 ;;B;770
88 ;;AB;880
 ;;NA NA;
