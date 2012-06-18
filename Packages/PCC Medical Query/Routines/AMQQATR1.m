AMQQATR1 ;IHS/CMI/THL - SAMPLES BY RESULTS AND RESULT DATES ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;-----
RUN S AMQQSER=-.1
 I $D(^UTILITY("AMQQ",$J,"SQXQ",AMQQUATN)) S %=$O(^(AMQQUATN,"")) I %,$D(^UTILITY("AMQQ",$J,"SQ",%,"NULL")) G SET
 S %=$P(AMQQQ,U,9)
 I $P(%,";",6) G SET
 I %="" G SET
 I $P(%,";",4)="ALL" S Z=$P(AMQQQ,U,3),$P(%,";",4)=$S(Z="T":">:-888888888",Z="N":">:-888888888",Z="Z":"'<:NEGATIVE",Z="S":"'=:|||",1:"ALL"),$P(AMQQQ,U,9)=%
 I '+%,$P(%,";",4)=">:-999999999"!($P(%,";",4)="") G SET
 I +%,$P(%,";",4)=">:-999999999"!($P(%,";",4)="") D SETXY,DATE G SET
 I $P(AMQQQ,U,3)="E"!($P(AMQQQ,U,3)="V") D:%["~" EN^AMQQATR4,PSET S %=$P(AMQQQ,U,9) G PRESET:+%,SET
 I $P(^AMQQ(1,+AMQQQ,0),U,11)[";" D VFILE^AMQQATR2 G SET
 S X=$P(%,";",4)
 S Y=$P(X,":",2)
 S A=$P(^AMQQ(1,+AMQQQ,0),U,5)
 I A=20 G PS
 I A,$D(^AMQQ(4,A,0)) S A=$P(^(0),U)
 I $D(^AMQQ(1,+AMQQQ,0)),$P(^(0),U,10)="AUPNVLAB","ZSTQ"[A,AMQQQ'[";ALL",AMQQQ'["EXISTS",AMQQQ'["'=:|||" D @("LTR"_A_U_"AMQQATR3") G PS
 I $P($G(^AMQQ(1,+AMQQQ,0)),U,10)="AUPNVLAB",AMQQQ["ALL"!(AMQQQ["EXISTS")!(AMQQQ["'=:|||") D ALLLAB G SET
 I $P($G(^AMQQ(1,+AMQQQ,0)),U,10)="AUPNVXAM"!($P($G(^(0)),U,10)="AUPNVNTS") D LTRQ^AMQQATR3 G PS ;PATCH XXX
 I Y'=+Y S AMQQSER=-.1 D SETXY G PRESET:+%,SET
PS I '+% D RESULT G SET
 D RESULT
PRESET S AMQQSER(1)=AMQQSER
 D DATE
 I +AMQQSER<+AMQQSER(1) S AMQQSER=AMQQSER(1)
SET S $P(AMQQQ,U,11)=AMQQSER
EXIT K AMQQSER,P,AMQQRTXT,AMQQLTR,AMQQLTR1,AMQQLTR2,AMQQLTB1,AMQQLTB2
 Q
 ;
RESULT I $P(^AMQQ(1,+AMQQQ,0),U,15)="" Q
 D SETXY
 S %=+AMQQQ
 S %=$P(^AMQQ(1,%,0),U,3)
 S %=^DIC(%,0,"GL")
 S %=%_"""AQ"")"
 I '$D(@%) Q
 S %=AMQQY
 S Y=$P(%,";",4)_$P(%,";",5)
 S Z=$P(%,";",6)_$P(%,";",7)
PSET S T=$P(AMQQY,";",2)
 S K=$P(AMQQY,";",3)
 S P=$P(^DPT(0),U,4)
 S (B,I,J)=0
 S A=(P\50)+(P<50)
LVTEST ; S A=0 ; USED IN LOW VOLUME TESTS
 S F=U_$P(AMQQY,";")
 S G=F_"(""AA"")"
RINCI S I=I+1 W:'$D(AMQQHIDE) "." I I>50 G RSET
 S B=B+A
 S B=$O(@G@(B))
 G RSET:'B
 S D=0
 S N=0
RINCD S D=$O(@G@(B,T,D))
 G RINCI:'D
 S C=-999999999
RINCC S C=$O(@G@(B,T,D,C))
 G RINCD:'C
 S N=N+1
 I N>10 G RINCI
 S R=$P(@F@(C,0),U,4)
 I $D(AMQQLTR) X AMQQLTR S Y=AMQQLTB1_AMQQLTR1,Z=AMQQLTB2_AMQQLTR2
 I $D(AMQQRTXT) X AMQQRTXT G INCJ
 I Z="" S %="I R"_Y X % G INCJ
 S %="I R"_Y_",R"_Z
 X %
INCJ I  S J=J+1 G RINCI
 G RINCC
RSET S:'K K=1
 S %=(J/I)
 S:'% %=.01
 S %=(1-%)/(%*K)
 S %=$J(%,1,2)
 S AMQQSER=%
 D BSET
REXIT K %,A,B,C,D,E,F,G,H,I,J,K,M,N,R,S,T
 Q
 ;
DATE I '$P(^AMQQ(1,+AMQQQ,0),U,7)!($P(^AMQQ(1,+AMQQQ,0),U,2)'=2) Q
 I '$D(AMQQY) Q
 S %=AMQQY
 S P=$P(^DPT(0),U,4)
 S (B,I,J)=0
 S A=(P\50)+(P<50)
 S T=$P(%,";",2)
 S F=U_$P(AMQQY,";")
 S G=F_"(""AA"")"
 S X1=$P(%,";",9)
 S X2=$P(%,";",8)
 S S=9999999-X2
 S E=9999999-X1
 I X1'<9999999 S X1=DT+1
 I X2=0 S X2=0010101
 D ^%DTC
 I X>100 S AMQQSER(1)=-999 D REXIT Q
DINCI S I=I+1
 W:'$D(AMQQHIDE) "."
 I I>50 G DSET
 S B=B+A
 S B=$O(@G@(B))
 G DSET:'B
 S D=0
DINCD S D=$O(@G@(B,T,D))
 G DINCI:'D
 I D'>S,D'<E S J=J+1 G DINCI
 G DINCD
 ;
DSET S %=(J/I)
 S:'% %=.01
 S %=(1-%)/(%*4.2)
 S %=$J(%,1,2)
 S AMQQSER=%_":2"
 D REXIT
 Q
 ;
BSET I $P(^AMQQ(1,+AMQQQ,0),U,5)=20 S:AMQQQ'[";A;" AMQQSER=AMQQSER_":11" Q
 S %=$P(^AMQQ(1,+AMQQQ,0),U,15)
 S X=$P(^(0),U,10)
 I %=""!(X="") Q
 I X="AUPNVLAB"!(X="AUPNVXAM")!(X="AUPNVSK")!(X="AUPNVNTS") S %=%_";" ;PATCH XXX
 S Y=U_X_"(""AQ"","""_%_""")"
 S Z=$O(@Y)
 I $E(Z,1,$L(%))=%,$E(Z,$L(%)+1)?1NP
 E  Q
 I +AMQQQ=168!(+AMQQQ=170)!(+AMQQQ=171) S %=$P(AMQQQ,U,9),%=$P(%,"~",3) S AMQQSER=AMQQSER_$S(%="&":":3",%="!":":4",1:":1") Q
 I $P(^AMQQ(1,+AMQQQ,0),U,10)="AUPNVXAM"!($P(^(0),U,10)="AUPNVNTS") S AMQQSER=AMQQSER_":"_81 Q  ;PATCH XXX
 I $P(^AMQQ(1,+AMQQQ,0),U,10)="AUPNVSK" S AMQQSER=AMQQSER_":"_51 Q
 I Z[";",+Z,$G(X)="AUPNVDXP" S Y=$P(^AUTTDXPR(+Z,0),U,2),Y=$S(Y="N":5,Y="Z":6,Y="T":7,Y="Q":8,1:0) Q:'Y  S Y=Y*100,AMQQSER=AMQQSER_":"_Y Q
 I Z[";",+Z S Y=$O(^AMQQ(5,"AQ",+Z,"")),Y=$S(Y="N":5,Y="Z":6,Y="T":7,Y="Q":8,1:0) Q:'Y  S AMQQSER=AMQQSER_":"_Y Q
 S AMQQSER=AMQQSER_":1"
 Q
 ;
SETXY S %=$P(AMQQQ,U,9)
 S X=$P(^AMQQ(1,+AMQQQ,0),U,10)
 S Y=+$P(^AMQQ(1,+AMQQQ,0),U,11)_";"_$P(^(0),U,12)
 S Z=$P(%,";",4)
 I X="AUPNVIMM" S AMQQY=X_";"_Y_";=;"_Z G SETXY1
 S AMQQY=X_";"_Y_";"_$P(Z,":")_";"_$P(Z,":",2)_";"_$S($P(Z,":",3)="":"<;999999999",1:($P(Z,":",3)_";"_$P(Z,":",4)))_";"_$P(%,";",1,2)
SETXY1 I '$D(AMQQHIDE) W !!,"Computing Search Efficiency Rating...."
 Q
 ;
ALLLAB N X,Y,Z,N,%,I
 I '$D(AMQQHIDE) W !,"Computing Search Efficiency Rating...."
 S (Z,%,I)=0
 S N=$P($G(^AMQQ(1,+AMQQQ,0)),U,11)
 I 'N Q
 S X=$P(^DPT(0),U,4)
 S Y=(X\100)+(X<100)
 F I=1:1:100 S %=$O(^DPT(%)) S:'% %=$O(^DPT($R(Y))) S:$D(^AUPNVLAB("AA",%,N)) Z=Z+1 S %=%+Y I '$D(AMQQHIDE),I#2 W "."
 S X=$P(^AUPNVLAB(0),U,4)
 S Y=$P(^DPT(0),U,4)
 S %=1
 I X,Y S %=Y/X,%=$J(%,2,2)
 S AMQQSER=+$J(((Z/100)*%),1,2)
 Q
 ;
