ABMMLTIT ; IHS/SD/SDR - Input transform-anes. mod field - 8/19/2005 1:28:34 PM
 ;;2.6;IHS 3P BILLING SYSTEM;**3,14**;NOV 12, 2009;Build 238
 ;
 ; Input transform routine for multiples
 ;IHS/SD/SDR - 2.6*14 - Added input transform for ICD DX check; used on fields 17,.01 and .59
 ;
 ;
LAB() ; EP
 S ABMF=0
 I (($P(^ICPT(Y,0),"^",1)>79999)&($P(^(0),"^",1)<90000)!($P(^(0),"^",1)=36415)&($$CHKCPT^ABMDUTL(Y)'=0))!($A($E($P($G(^ICPT(Y,0)),"^",1),1),1)>65)&($A($E($P(^(0),"^",1),1),1)<90) S ABMF=1
 Q ABMF
 ;
 ;start new abm*2.6*14
ICDDX(X) ;EP
 S ABMF=0
 I $D(^ROUTINE("B","ICDEX")) D  Q ABMF
 .S ABMF=$P($$SAI^ICDEX(80,X,$P($G(^ABMDCLM(DUZ(2),DA,7)),U)),U)
 S ABMF=$TR(+$P($G(^ICD9(X,0)),U,9),"1","0")
 Q ABMF
 ;end new abm*2.6*14
