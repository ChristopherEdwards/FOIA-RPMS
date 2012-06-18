LRBLPX1 ; IHS/DIR/FJE - XMATCH RESULTS (COND'T) 9/8/92 20:30 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 S LRI=+LRJ I '$D(^LRD(65,LRI,0)) K ^LR(LRDFN,1.8,E,1,B,0),^TMP($J,LRV) S X=^LR(LRDFN,1.8,E,1,0),X(1)=$O(^(0)),^(0)=$P(X,"^",1,2)_"^"_X(1)_"^"_$S(X(1)="":"",1:($P(X,"^",4)-1)),LRV=LRV-1 Q
 W:LRV=1 !?6,"Unit for XMATCHING",?49,"Exp date",?64,"Loc"
EN ;from LRBLPX
 D:'$D(LR("%")) L^LRU
 S X=^LRD(65,LRI,0),A=$P(X,"^",7),H=$P(X,"^",8),L=$O(^(3,0)),LRE=^LAB(66,$P(X,"^",4),0),L=$S(L:$P(^LRD(65,LRI,3,L,0),"^",4),1:"Blood Bank")
 W !!,$J(LRV,2),")",?6,$P(X,"^"),?17,$E($P(LRE,"^"),1,23),?42,$J(A,2),?45,H,?49 S Y=$P(X,"^",6) D DT^LRU S:L<0 L="Blood bank" W Y,?64,L
 S X=$S($D(^LRD(65,LRI,10)):$P(^(10),"^"),1:"") S:X="ND" X="" I X="" W $C(7),!,"ABO not rechecked"
 I X]"",X'=A W $C(7),!,"ABO recheck (group ",X,") does not match ABO group of unit.  Resolve discrepancy." S F(2)=1
 S X=$S($D(^LRD(65,LRI,11)):$P(^(11),"^"),1:"") S:X="ND" X="" I H="NEG",X="" W $C(7),!,"Rh NEG unit not rechecked"
 I X]"",X'=H W $C(7),!,"Rh recheck (type ",X,") does not match Rh  type  of unit.  Resolve discrepancy." S F(2)=1
 S X=$P(LRJ,"^",2),X(10)=$S('$D(^LR(LRDFN,LRSS,X,10)):0,$P(^(10),"^")="":0,1:1),X(11)=$S('$D(^(11)):0,$P(^(11),"^")="":0,1:1),X(6)=$S('$D(^(6)):0,$P(^(6),"^")="":0,1:1)
 S X=^LR(LRDFN,LRSS,X,0),(LRJ,^TMP($J,LRV))=LRJ_"^"_+X_"^"_$P(X,"^",6)_"^"_X(10)_"^"_X(11)_"^"_X(6) K X
 I '$P(LRJ,"^",6)!'$P(LRJ,"^",7) W $C(7),!?4,"No patient ABO &/or Rh results" S (F(1),X)=1
 I '$P(LRJ,"^",8) W !?4,"No antibody screen results" S (F(6),X)=1
 I $D(X) S Y=$P(LRJ,"^",4) D DT^LRU W ?31,"(spec date:",Y," acc#:",$P($P(LRJ,"^",5)," ",3),")"
C S Z(1)=0 I $D(R),$P(LRE,"^",9)=1,$P(LRE,"^",25)'=1 W ! F Z=0:0 S Z=$O(R(Z)) Q:'Z  I Z'=LRB,'$D(^LRD(65,LRI,70,Z,0)) W !,$P(^LAB(61.3,Z,0),"^"),$E("..............",$X,14),?15,"RBC ANTIGEN" S Z(1)=1
 I Z(1) W $C(7),!,"Above antigen(s) not entered in RBC ANTIGEN ABSENT field"
 Q
STF Q:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0))#2
 I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,0)) S ^(0)=LRT_"^50^^"_DUZ_"^"_LRK,^(1,0)="^68.14P^^",X=^LRO(68,LRAA,1,LRAD,1,LRAN,4,0),^(0)=$P(X,"^",1,2)_"^"_LRT_"^"_($P(X,"^",4)+1)
 F A=0:0 S A=$O(LRT(A)) Q:'A  D:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,A,0)) A S Y=^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,A,0),Z=$P(Y,U,3),X=$S('Z:$P(Y,U,2)+1,1:1),$P(Y,U,2,3)=X_U_0,$P(Y,U,7)=DUZ,$P(Y,U,6)=LRK,^(0)=Y
 S ^LRO(68,"AA",LRAA_"|"_LRAD_"|"_LRAN_"|"_LRT)="",$P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,0),"^",5)=LRK Q
A S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,A,0)=A_"^0^0^0^^"_LRK_"^"_DUZ_"^"_DUZ(2)_"^"_LRAA_"^"_LRAA_"^"_LRAA,X=^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,0),^(0)=$P(X,"^",1,2)_"^"_A_"^"_($P(X,"^",4)+1) Q
 ;
CK S LRT=$O(^LAB(60,"B","WKLD CROSSMATCH",0)) I LRT F B=0:0 S B=$O(^LAB(60,LRT,9,B)) Q:'B  S LRT(B)=""
 Q:$D(LRT)=11
 W $C(7),!,"Must have test in LAB TEST file (#60) called 'WKLD CROSSMATCH' with WKLD CODES." K LRT Q
