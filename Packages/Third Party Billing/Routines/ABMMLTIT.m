ABMMLTIT ; IHS/SD/SDR - Input transform-anes. mod field - 8/19/2005 1:28:34 PM
 ;;2.6;IHS 3P BILLING SYSTEM;**3**;NOV 12, 2009
 ;
 ; Input transform routine for multiples
 ;
 ;
LAB() ; EP
 S ABMF=0
 I (($P(^ICPT(Y,0),"^",1)>79999)&($P(^(0),"^",1)<90000)!($P(^(0),"^",1)=36415)&($$CHKCPT^ABMDUTL(Y)'=0))!($A($E($P($G(^ICPT(Y,0)),"^",1),1),1)>65)&($A($E($P(^(0),"^",1),1),1)<90) S ABMF=1
 Q ABMF
