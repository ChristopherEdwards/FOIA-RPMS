AMQQDFN ;IHS/CMI/THL - CHECK TO SEE IF ANY ^AUTT FILE DFNS HAVE CHANGED ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;-----
EN ; ENTRY POINT
 N %,A,B,C,I,X,Y,Z,DFN,%Z
 S U="^"
 ;PATCH XXX
 D IMM^AMQQMGR9
 D MSR^AMQQMGR9
 ;D EXAM^AMQQMGR9
 I '$D(AMQQXX) W !,"Qman is now waking up "
 F X=0:0 S X=$O(^AMQQ(5,X)) Q:'X  S Y=^(X,0),Z=$P(Y,U,12) I Z'="" W:'$D(AMQQXX) "." D G1
 D IEN^AMQQMGR9
 Q
 ;
G1 S (%,B)=$P(Y,U,5)
 S %=$G(^AMQQ(1,%,2))
 I %="" Q
 I %["AUPNVXAM" S %=$P(%,";",2) G G11
 S A="AUPNV"_$P(Z,";")_";",%=+$P(%,A,2)
G11 S %Z=$P(Z,";",2)
 S Z="^AUTT"_$P(Z,";")_"(""C"","""_$P(Z,";",2)_""","""")"
 S Z=$O(@Z)
 I Z,Z=% Q
 I 'Z Q
 S DFN=%
 D RESET
 Q
 ;
RESET ;
 S $P(^AMQQ(1,B,0),U,11)=Z
 I Z S $P(^(0),U,15)=Z
 S A=^AMQQ(1,B,1)
 I A'["IMM" S C=" I $D(^(AMQP(0)," S %=$P(A,C,2),%="))"_$P(%,"))",2,999),%=Z_%,A=$P(A,C)_C_%,^AMQQ(1,B,1)=A
 F I=1,2 D
 .S A=^AMQQ(1,B,I)
 .S C=$P(^AMQQ(5,X,0),U,12)
 .S C=$P(C,";")
 .S:C="EXAM" C="XAM"
 .S C="AUPNV"_C_";"
 .S %=$P(A,C,2)
 .S %=Z_";"_$P(%,";",2,999)
 .S A=$P(A,C)_C_%
 .S ^AMQQ(1,B,I)=A
 I A["IMM",'$D(^AUTTIMM(101,0)) D IMM
 Q
 ;
IMM ; Check compound immunization links to see if need to change a dfn
 N %A,%B,%C,%D,%E,%F,%I,%LINK
 F %I=1:1 S %A=$P($T(IMMUN+%I),";;",2) Q:%A=""  D
 .S %C=$P(%A,U) F I=1:1 S %D=$P(%C,":",I) Q:%D=""  I %D=%Z S %LINK=$P(%A,U,2) D  Q
 ..F I=1,2 S A=^AMQQ(1,%LINK,I),C="AUPNVIMM;",%=$P(A,C,2),%C=$P(%,";") D  S %=%C_";"_$P(%,";",2,999),A=$P(A,C)_C_%,^AMQQ(1,%LINK,I)=A
 ...F %E=1:1 S %F=$P(%C,":",%E)  Q:%F=""  I %F=DFN S $P(%C,":",%E)=Z
 Q
 ;
IMMUN ; Table of Compound Immunizations - IHS CODE:IHS CODE^QMAN LINK ENTRY ;
 ;;02:03:04:34:42^180
 ;;02:04^186
 ;;03:04:34:42^185
 ;;15:17^199
 ;;14:17:18^198
 ;;35:37:38:39^306
 ;;11:17:18^197
