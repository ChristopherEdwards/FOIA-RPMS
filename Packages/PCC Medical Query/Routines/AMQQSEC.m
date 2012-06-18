AMQQSEC ; IHS/CMI/THL - CHECK SECURITY ACCESS FOR ATTRIBUTES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $D(Y),+Y,$D(^AMQQ(5,+Y,0)),$P(^(0),U,19)'="C" Q
 I $$KEYCHECK^AMQQUTIL("AMQQZCLIN") Q
 S Y=-1
 I '$D(AMQQNECO) W !,"Sorry, you do not have the security clearance to use this attribute",*7 Q
 S AMQQFAIL=8
 Q
 ;
PRINT ; ENTRY POINT FROM AMQQCMPL
 N X,Y,Z,%
 S Z=DUZ(2)
 S %=$P($G(^AMQQ(8,Z,0)),U,10)
 I %="" Q
 S Y=$P(^AMQQ(8,Z,0),U,9)
 S X=$O(^%ZIS(1,"C",IO,""))
 I 'X Q
 I Y="P" S Y=^%ZIS(1,X,"SUBTYPE"),Y=$P(^%ZIS(2,Y,0),U) I Y'["P-" Q
 I %="I",$D(^AMQQ(8,Z,1,"B",X)) Q
 I %="I" X "I 0" Q
 I '$D(^AMQQ(8,Z,1,"B",X)) Q
 I 0
 Q
 ;
