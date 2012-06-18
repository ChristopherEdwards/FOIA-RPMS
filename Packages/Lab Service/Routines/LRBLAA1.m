LRBLAA1 ; IHS/DIR/FJE - XM:TX BY TREATING SPECIALTY REPORT 4/12/92 08:41 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 S A=0
 F LRA=0:0 S A=$O(^TMP($J,A)) Q:A=""!(LR("Q"))  S X=^(A),LRJ=$P(X,U),LRT=$P(X,U,2) D:$Y>(IOSL-6) H^LRBLAA Q:LR("Q")  W !!,A,?34,"Units Xm'd:",?45,$J(LRJ,4),?54,"Tx'd:",?57,$J(LRT,4),?67,"C/T: " W $S(LRT:$J(LRJ/LRT,5,3),1:"NA") D M
 W !!,"ALL TREATING SPECIALTIES",?34,"Total Xm'd:",?45,$J(LRL,4),?54,"Tx'd:",?57,$J(LRM,4),?67,"C/T: " W $S(LRM:$J(LRL/LRM,5,3),1:"NA") Q
M S B=0 F B(1)=0:0 S B=$O(^TMP($J,A,B)) Q:B=""!(LR("Q"))  S X=^(B),LRK=$P(X,U),LRD=$P(X,U,2) D:$Y>(IOSL-6) H1 Q:LR("Q")  W !?2,B,?34,"Units Xm'd:",?45,$J(LRK,4),?54,"Tx'd:",?57,$J(LRD,4),?67,"C/T: " W $S(LRD:$J(LRK/LRD,5,3),1:"NA")
 Q
 ;
H1 D H^LRBLAA Q:LR("Q")  W !,A," (cont'd from ",LRQ-1,")" Q
