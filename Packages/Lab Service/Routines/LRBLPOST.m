LRBLPOST ; IHS/DIR/FJE - BLOOD BANK POST-INIT 15:48 ; [ 7/23/93 ]
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 D END I $D(^DD(60,0,"VR")),+^DD(60,0,"VR")<5.14 W !,$C(7),"YOU MUST HAVE AT LEAST VERSION 5.2 BEFORE I CAN RUN THIS ROUTINE",! G END
 I '$D(^LAB(66.5,0)) W $C(7),!,"Need OPERATION (MSBOS) FILE (#66.5) to run this option." G END
 S A=0 F  S A=$O(^ICPT(A)) Q:'A  D:$O(^(A,"LR",0)) A
 D END Q
A I '$D(^LAB(66.5,A,0)) S ^(0)=A,X=^LAB(66.5,0),^(0)=$P(X,"^",1,2)_"^"_A_"^"_($P(X,"^",1,2)+1)
 S (B,C)=0 F  S B=$O(^ICPT(A,"LR",B)) Q:'B  S X=^(B,0) I '$D(^LAB(66.5,A,1,B,0)) S ^(0)=X,C=C+1
 S:'$D(^LAB(66.5,A,1,0)) ^(0)="66.51PA^^" S X=^(0),X(1)=$O(^(0)),^(0)=$P(X,"^",1,2)_"^"_X(1)_"^"_($P(X,"^",4)+1) Q
 ;
END D V^LRU Q
