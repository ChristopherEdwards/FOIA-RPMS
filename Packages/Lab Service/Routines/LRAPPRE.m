LRAPPRE ; IHS/DIR/FJE - ANATOMIC PATH PRE-INIT 12:29 ; [ 10/6/90 ]
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;Added to LRPRE1
 F A=0:0 S A=$O(^LR("AAUA",A)) Q:'A  F B=0:0 S B=$O(^LR("AAUA",A,B)) Q:'B  S LRDFN=+$O(^LR("AAUA",A,B,0)),E=$P($G(^LR(LRDFN,"AU")),"^",3) I E S $P(^("AU"),"^",15)=E
 Q
