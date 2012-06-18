LRBLSUM ; IHS/DIR/FJE - BLOOD BANK SUMMARY 3/28/94 12:10 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 Q:'$O(^LR(LRDFN,"BB",0))
 S LRAA=$O(^LRO(68,"B","BLOOD BANK",0)) Q:'LRAA  S LRAA(1)="BLOOD BANK",LRSS="BB" D L^LRU,S^LRU F X=2.91,8,10.3,11.3 S LRN(X)=$P(^DD(63.01,X,0),"^")
 ;S W=^LR(LRDFN,0),LRDPF=$P(W,U,2),Y=$P(W,"^",3),X=^DIC($P(W,"^",2),0,"GL"),X=@(X_Y_",0)"),Z=+$G(^(.104)),Z(1)="^"_$P($G(^DD(LRDPF,.104,0)),"^",3)
 S W=^LR(LRDFN,0),LRDPF=$P(W,U,2),(DFN,Y)=$P(W,"^",3),X=^DIC($P(W,"^",2),0,"GL"),X=@(X_Y_",0)"),Z=+$G(^(.104)),Z(1)="^"_$P($G(^DD(LRDPF,.104,0)),"^",3)
 I Z,$D(@(Z(1)_Z_",0)")) S LRMD=$P(^(0),"^")
 I 'Z S Z=$S($D(^LR(LRDFN,.2)):+^(.2),1:"") I Z,$D(^VA(200,Z,0)) S LRMD=$P(^(0),"^")
 ;S SSN=$P(X,"^",9) D SSN^LRU S N=$P(X,"^"),LR=$P(X,"^",3)_"^"_SSN_"^"_$P(W,"^",5)_"^"_$P(W,"^",6)_"^"_LRMD,G=LRLLOC
 S SSN=$P(X,"^",9) D SSN^LRU S N=$P(X,"^"),LR=$P(X,"^",3)_"^"_HRCN_"^"_$P(W,"^",5)_"^"_$P(W,"^",6)_"^",G=LRLLOC  ;IHS/ANMC/CLS 11/1/95
 D ^LRBLPBR1,K^LRU K LR,LRAA,LRSS,LRI,LRN Q
