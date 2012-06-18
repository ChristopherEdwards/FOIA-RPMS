LRBLPAB ; IHS/DIR/FJE - ANTIBODIES IDENTIFIED 2/18/93 09:37 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 W !!?20,"PATIENT ANTIBODIES IDENTIFIED"
 I DUZ(0)'["@"&(DUZ(0)'["l") W $C(7),!,"You do not have the proper access to proceed." G END
 S ZTRTN="QUE^LRBLPAB" D BEG^LRUTL G:POP!($D(ZTSK)) END
QUE U IO K ^TMP($J) D L^LRU,S^LRU S (LRW,LRC)=0 D H
 S LRX=0 F LRD=0:0 S LRX=$O(^DPT("B",LRX)) Q:LRX=""  F LRY=0:0 S LRY=$O(^DPT("B",LRX,LRY)) Q:'LRY  I $D(^DPT(LRY,"LR")) S LRDFN=^("LR"),LRC=LRC+1 I $O(^LR(LRDFN,1.7,0)) D W
 D:$Y>(IOSL-6) H W !,"Patients in lab data file: ",$J(LRC,6),!,"Patients with  antibodies: ",$J(LRW,6)
 F LRA=0:0 S LRA=$O(^TMP($J,LRA)) Q:'LRA  S LRA(1)=^(LRA) D:$Y>(IOSL-6) H W !,$P(^LAB(61.3,LRA,0),"^")," = ",LRA(1)
 D END^LRUTL,END Q
W ;S LRW=LRW+1,X=^LR(LRDFN,0),Y=$P(X,"^",3),(LRDPF,X)=$P(X,"^",2),X=^DIC(X,0,"GL"),X=@(X_Y_",0)"),LRP=$P(X,"^"),SSN=$P(X,"^",9) D:$Y>(IOSL-6) H
 S LRW=LRW+1,X=^LR(LRDFN,0),(DFN,Y)=$P(X,"^",3),(LRDPF,X)=$P(X,"^",2),X=^DIC(X,0,"GL"),X=@(X_Y_",0)"),LRP=$P(X,"^"),SSN=$P(X,"^",9) D:$Y>(IOSL-6) H D SSN^LRU  ;IHS/ANMC/CLS 11/1/95
 ;W !!,LRP,?35,"ID:",SSN
 W !!,LRP,?35,"ID:",HRCN  ;IHS/ANMC/CLS 11/1/95
 F LRA=0:0 S LRA=$O(^LR(LRDFN,1.7,LRA)) Q:'LRA  S:'$D(^TMP($J,LRA)) ^(LRA)=0 S ^(LRA)=^(LRA)+1 D:$Y>(IOSL-6) H1 W !?3,$P(^LAB(61.3,LRA,0),"^")
 Q
H S LRQ=LRQ+1,%DT="T",X="N" D ^%DT,D^LRU W @IOF,Y," BLOOD BANK ",LRQ(1),?(IOM-10),"Pg: ",LRQ,!,LR("%") Q
H1 ;D H W !,LRP,?35,"ID:",SSN,?50,"(continued from pg:",LRQ-1,")" Q
 D H W !,LRP,?35,"ID:",HRCN,?50,"(continued from pg:",LRQ-1,")" Q  ;IHS/ANMC/CLS 11/1/95
END D V^LRU Q
 ;LRW=count of pts with antibodies
