APCLV08 ; IHS/CMI/LAB - procedure functions ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in E,C,P
 ;
PROC ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVPRC("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVPRC(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^ICD0(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
PRC ;EP
 NEW Z,C,%,S
 S (C,Y)=0 F  S Y=$O(^AUPNVPRC("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AUPNVPRC(Y,0),U),Z=Y  D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,J)=%
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
I ;
 S %=P Q
E ;
 ;S %=$P(^ICD0(P,0),U,4) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P($$ICDOP^ICDCODE(P),U,5) Q  ;cmi/anch/maw 9/12/2007 csv
C ;
 ;S %=$P(^ICD0(P,0),U) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P($$ICDOP^ICDCODE(P),U,2) Q  ;cmi/anch/maw 9/12/2007 csv
D ;
 S %=$P(^AUPNVPRC(Z,0),U,6) Q
G ;
 D D I %]"" S %=$$FMTE^XLFDT(%) Q
P ;
 ;S %=$P(^AUPNVPRC(Z,0),U,16) I % S %=$P(^ICPT(%,0),U) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P(^AUPNVPRC(Z,0),U,16) I % S %=$P($$CPT^ICPTCOD(%),U,2) Q  ;cmi/anch/maw 9/12/2007 csv
 Q
T ;
 S %=$P(^AUPNVPRC(Z,0),U,16) Q
N ;
 S %=$P(^AUPNVPRC(Z,0),U,4) I % S %=$P(^AUTNPOV(%,0),U)
 Q
F ;
 S %=$P(^AUPNVPRC(Z,0),U,8) Q
R ;
 S P=$P(^AUPNVPRC(Z,0),U,11) I P D O^APCLV06
 Q
X ;diagnosis done for
 NEW M S M=$P(^AUPNVPRC(Z,0),U,5)
 S I=$$PRIMPOV^APCLV(V,"I") I M=I S %=1 Q
 F I=1:1:15 S J=$$SECPOV^APCLV(V,"I",I) I J]"",J=M S %=I+1 Q
 Q
