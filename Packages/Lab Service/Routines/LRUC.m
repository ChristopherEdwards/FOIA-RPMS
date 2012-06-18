LRUC ; IHS/DIR/AAB - GET PATIENT LOCATION 5/30/96 22:22 ; [ 07/22/2002  1:54 PM ]
 ;;5.2;LR;**1002,1013**;JUL 15, 2002
 ;;5.2;LAB SERVICE;**72**;Sep 27, 1994
 S B=0 F C=0:0 S C=$O(^SC("B",X,C)) Q:'C  I DUZ(2)=+$$SITE^VASITE(DT,($P($G(^SC(C,0)),U,15))) S B=1 Q
 Q:B  D REST G END
REST D END I $O(^SC("C",X,0)) K C,B,A D XR Q
 S A(2)="",A=X,Z=0 I A=+A S A=A_$C(32)
 W ! F B=0:1 S A=$O(^SC("B",A)) Q:$E(A,1,$L(X))'=X!(A(2)?1P)  F C=0:0 S C=$O(^SC("B",A,C)) Q:'C!(A(2)?1P)  I DUZ(2)=+$$SITE^VASITE(DT,($P($G(^SC(C,0)),U,15))) S Z=Z+1,^TMP("LRLOC",$J,Z)=A W $J(Z,2),?5,A,! I Z#5=0 D C Q:A(2)?1P
 Q:A(2)?1P  I B W ! D C K:A(2)="" X Q
 W !!,"NON-STANDARD LOCATION !  OK " S %=2 D YN^LRU K:%'=1 X Q
C I Z=1 S A(2)=1 G F
 W $C(13),"TYPE '^' TO STOP OR",!,"CHOOSE 1-",Z R ": ",A(2):DTIME I A(2)?1P!'$T S A=$C(126) K X Q
 I A(2)="" W ! Q
F I A(2)>0,A(2)<(Z+1) S X=^TMP("LRLOC",$J,A(2)) S %=1 W ?($X+5),X,"  OK " D YN^LRU K:%'=1 X
 S A(2)=$S(A(2)>Z:"",1:"^"),A=$C(126) Q
 ;
XR W ! S Z=0 F A=0:0 S A=$O(^SC("C",X,A)) Q:'A  I DUZ(2)=+$$SITE^VASITE(DT,($P($G(^SC(A,0)),U,15))) S Z=Z+1,A(1)=$P(^SC(A,0),"^"),^TMP("LRLOC",$J,Z)=A(1) W $J(Z,2),?5,A(1),?40,"Abbrev: ",X,! I Z#5=0 D C Q:A(2)?1P
 D C K:A(2)="" X Q
EN ;
 I '$D(^SC("B")) W $C(7),"No STANDARD LOCATIONS to choose from.",!,"You may enter a NON-STANDARD LOCATION",! Q
 I X'["??" W !,"ANSWER WITH ",$P(^SC(0),"^"),!,"DO YOU WANT THE ENTIRE ",$P(^(0),"^")," LIST ? " S (%,LR("%"))="" D RX^LRU Q:%'=1
 S (A,A(2))=0,A(1)=$Y+21 W !?3 F B=0:0 S A=$O(^SC("B",A)) Q:A=""!(A(2)?1P)  F C=0:0 S C=$O(^SC("B",A,C)) Q:'C!(A(2)?1P)  D:$Y>A(1)!'$Y MORE Q:A(2)?1P  N LRDIV S LRDIV=$P($G(^SC(C,0)),U,15) Q:'LRDIV  Q:DUZ(2)'=+$$SITE^VASITE(DT,LRDIV)  W A,!?3
 Q
MORE R "'^' TO STOP: ",A(2):DTIME I A(2)?1P S A=$C(126) Q
 S A(1)=A(1)+21 W $C(13),$J("",15),$C(13),?3 Q
 ;
END K ^TMP("LRLOC",$J) Q
