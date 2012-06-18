AMQQMGR6 ; IHS/CMI/THL - AMQQMGR CONTINUED ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 N %,%Y
 K ^UTILITY("AMQQ LC",$J),^UTILITY("AMQQ DEL",$J)
 W !!,"Want to view/print the existing set of Q-Man lab tests"
 S %=2
 D YN^DICN
 I %Y?1."^" Q
 I %=1 D SYN1^AMQQMGR8
 W !!,"Want to update the existing set of Q-Man lab tests"
 S %=2
 D YN^DICN
 I %=1 D EN^AMQQMGR3
 S TMP="^TMP(""AMQQ LAB IEN"","_$J_")"
 S AMQQCNT=0
 K @TMP
 W !!
 S AMQQLIEN=0
 F  S AMQQLIEN=$O(^LAB(60,AMQQLIEN)) Q:'AMQQLIEN  D INV(AMQQLIEN)
 W AMQQCNT," lab unique lab tests have been detected.      ",!!
 D GETAKA^AMQQMGR8
 W !!
 D SYN^AMQQMGR8
 K AMQQSTOP
 W !!,"The Q-Man LAB TEST update is now complete!",!!
 Q
 ;
INV(AMQQLIEN) ; MAINTAIN INVENTORY OF LAB TESTS
 N I,J,%,Z,AMQQSIEN,AMQQDA,AMQQSTOP,AMQQX
 S (AMQQSIEN,I,J)=0
 F I=0:1 S AMQQSIEN=$O(^LAB(60,AMQQLIEN,1,AMQQSIEN)) Q:'AMQQSIEN  ; COUNT S/Ss
 I 'I S %=AMQQLIEN_"."_44 D DETECT(%) Q  ; NO S/S
 I I=1 S Z=$O(^LAB(60,AMQQLIEN,1,0)),%=AMQQLIEN_"."_Z D DETECT(%) Q  ; ONLY ONE SITE/SPECIMEN
 S %=AMQQLIEN_"."_44 D DETECT(%) ; CAPTURE THE UNKNOWN S/S IF IT EXISTS
 S AMQQDA=0 F  S AMQQDA=$O(^AUPNVLAB("B",AMQQLIEN,AMQQDA)) Q:'AMQQDA  D  I $G(AMQQSTOP) Q
 .S Z=$P($G(^AUPNVLAB(AMQQDA,11)),U,3) I Z="" Q  ; UNKNOWN S/S
 .I $D(AMQQX(Z)) Q  ; IT ALREADY IN THERE
 .S %=AMQQLIEN_"."_Z
 .D DETECT(%)
 .S J=J+1,AMQQX(%)=J
 .I J=I S AMQQSTOP=1 ; ALL S/Ss ACCOUNTED FOR
 Q
DETECT(%) ; DETECT LAB TEST TYPES
 N X,Y,N,Z,J,K
 S Z=$P(%,".",2)
 S J=+%
 S K=(%\1)_"."_$P(J,".",2)
 I $D(@TMP@(K)) Q
 S X=$P($G(^LAB(60,+(%\1),0)),U)
 I X="" Q
 S Y=$P($G(^LAB(61,+Z,0)),U)
 S N=X
 I $L(Y) S N=N_", "_Y I Y="UNKNOWN" S N=N_" SOURCE"
 S @TMP@(K)=N
 S @TMP@("B",N,K)=""
 S @TMP@("C",K)=Z
 I $P($G(^AMQQ(5,(K+1000),4)),U,8) Q
 S AMQQCNT=AMQQCNT+1
 W AMQQCNT," unique lab tests have been detected so far",$C(13)
 Q
 ;
ATTRIB ;EP;TO CHECK FOR USE OF LAB BY V LAB
 I $D(^AUPNVLAB("B",$P(+Y,".")/1000))
 Q
