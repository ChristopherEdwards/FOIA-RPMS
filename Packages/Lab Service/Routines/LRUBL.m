LRUBL ; IHS/DIR/FJE - FIND PATIENT MISMATCHES 13:24 ; 
 ;;5.2;LR;**1013**;JUL 15, 2002
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 D END W !!,"FIND PATIENT MISMATCHES IN VA PATIENT NUMBER FIELD OF FILE 65"
 S ZTRTN="QUE^LRUBL" D BEG^LRUTL G:POP!($D(ZTSK)) END
QUE U IO D H S (A,C,M)=0 F LRC=0:1 S A=$O(^LRD(65,A)) Q:'A  F B=0:0 S B=$O(^LRD(65,A,3,B)) Q:'B  S X=^(B,0),P=$P(X,"^",6),DFN=$P(X,"^",7) I DFN,$D(^DPT(DFN,0)) S C=C+1,Y=^(0) I $P(Y,"^")'=P D W
 W !!,"# units: ",LRC,!,"# relocations: ",C,!,"# missmatches: ",M D END^LRUTL,END Q
W ;W !!,P," not ",$P(Y,"^")," (SSN: ",$P(Y,"^",9),") Unit IFN:",A S M=M+1
 D SSN^LRU W !!,P," not ",$P(Y,"^")," (HRCN: ",HRCN,") Unit IFN:",A S M=M+1  ;IHS/ANMC/CLS 11/1/95
 W !,"DATE/TIME RELOCATION: " S Y=+X D D^DIQ W Y,?45,"Unit ID: ",$P(^LRD(65,A,0),"^") Q
 ;
H S X="N",%DT="T" D ^%DT,D^DIQ W @IOF,Y," ",$$INS^LRU,!,"PATIENT MISMATCHES IN 65.03,.07 DATA ELEMENT" Q
END D V^LRU Q
