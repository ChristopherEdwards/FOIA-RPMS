LRAPWKA1 ; IHS/DIR/FJE - STUFF SLIDE LABELS 10:18 ; [ 3/8/92 ]
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 Q:$D(LRF)
 F A=0:0 S A=$O(^LR(LRDFN,LRSS,LRI,.1,A)) Q:'A  F B=0:0 S B=$O(^LR(LRDFN,LRSS,LRI,.1,A,B)) Q:'B  S E=0 F G=1:1 S E=$O(^LR(LRDFN,LRSS,LRI,.1,A,B,E)) Q:'E  D T
 Q
T F LRT=0:0 S LRT=$O(^LR(LRDFN,LRSS,LRI,.1,A,B,E,1,LRT)) Q:'LRT  S X=^(LRT,0),Y=$P(X,"^",2)+$P(X,"^",3),X(6)=Y-$P(X,"^",6) I X(6)>0 S $P(X,"^",6)=Y,$P(X,"^",7)=X(6),^(0)=X
 Q
EN ;
 S LRK(2)=0 G:LRSS'="AU" LRAPWKA1
 F A=0:0 S A=$O(^LR(LRDFN,33,A)) Q:'A  F B=0:0 S B=$O(^LR(LRDFN,33,A,B)) Q:'B  S E=0 F G=1:1 S E=$O(^LR(LRDFN,33,A,B,E)) Q:'E  D AUT
 Q
AUT F LRT=0:0 S LRT=$O(^LR(LRDFN,33,A,B,E,1,LRT)) Q:'LRT  S X=^(LRT,0),Y=$P(X,"^",2)+$P(X,"^",3),X(6)=Y-$P(X,"^",6) I X(6)>0 S $P(X,"^",6)=Y,$P(X,"^",7)=X(6),^(0)=X
 Q
