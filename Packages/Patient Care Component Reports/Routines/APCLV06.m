APCLV06 ; IHS/CMI/LAB - provider functions ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;IHS/TUCSON/LAB - add parameter to pass back event date&time on provider entry 05/19/97 patch 1
PRIMPROV ;EP - primary provider in many different formats
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,P,Z ;IHS/TUCSON/LAB - added ,Z patch 1 5/19/97
 S P="",Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPRV(Y,0),U,4)="P" S P=$P(^AUPNVPRV(Y,0),U),Z=Y ;IHS/TUCSON/LAB - added ,Z=Y patch 1 05/19/97
 I 'P Q P
 I $P(^DD(9000010.06,.01,0),U,2)[200,'$D(^VA(200,P)) Q -1
 I $P(^DD(9000010.06,.01,0),U,2)[6,'$D(^DIC(6,P)) Q -1
 I $G(F)="" S F="N"
 S %="" D @F
 Q %
 ;
SECPROV ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,Z ;IHS/TUCSON/LAB - PATCH 1
 S P="",(C,Y)=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPRV(Y,0),U,4)'="P" S C=C+1 I C=N S P=$P(^AUPNVPRV(Y,0),U),Z=Y  ;IHS/TUCSON/LAB - patch 1
 I 'P Q P
 I $P(^DD(9000010.06,.01,0),U,2)[200,'$D(^VA(200,P)) Q -1
 I $P(^DD(9000010.06,.01,0),U,2)[6,'$D(^DIC(6,P)) Q -1
 I $G(F)="" S F="N"
 S %="" D @F
 Q %
 ;
PROV ;EP
 NEW Z,C,%,S
 S (C,Y)=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AUPNVPRV(Y,0),U) D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,J)=%
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
I ;EP
 S %=P Q
T ;EP
 S %=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,0)),U,2),1:$P(^DIC(6,P,0),U,2)) Q
A ;EP
 S %=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,9999999)),U),1:$P($G(^DIC(6,P,9999999)),U)) Q
B ;EP
 S %=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,9999999)),U),1:$P($G(^DIC(6,P,9999999)),U))
 Q:%=""
 S %=$$EXTSET^XBFUNC(200,9999999.01,%)
 Q
D ;EP
 D F
 Q:%=""
 S %=$P($G(^DIC(7,%,9999999)),U)
 Q
 ;
E ;EP
 S %=$$VAL^XBDIQ1($S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6),P,$S($P(^DD(9000010.06,.01,0),U,2)[200:53.5,1:2))
 Q
F ;EP
 S %=$$VALI^XBDIQ1($S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6),P,$S($P(^DD(9000010.06,.01,0),U,2)[200:53.5,1:2))
 Q
C ;EP
 S %=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,9999999)),U,2),1:$P($G(^DIC(6,P,9999999)),U,2)) Q
N ;EP
 S %=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,0)),U),1:$P($G(^DIC(16,P,0)),U)) Q
O ;EP
 NEW A D A Q:%=""  S A=%,%="" D D Q:%=""  S %=A_% Q
P ;EP
 NEW A D A Q:%=""  S A=% NEW D D D Q:%=""  S D=%,%="" D C Q:%=""  S %=A_D_% Q
G ;EP - event date&time IHS/TUCSON/LAB - added this subroutine patch 1 05/19/97
 S %=$P($G(^AUPNVPRV(Z,12)),U) Q
 ;
1 ;
 S %=$$VD^APCLV($P(^AUPNVPRV(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AUPNVPRV(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AUPNVPRV(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AUPNVPRV(Y,0),U,3),"E")
 Q
5 ;
 S %=$P(^AUPNVPRV(Y,0),U)
 Q
6 D T Q
7 D A Q
8 D B Q
9 D C Q
10 D D Q
11 D E Q
12 D F Q
13 D N Q
14 D O Q
15 D P Q
16 S %=$P(^AUPNVPRV(Y,0),U,4) Q
17 S %=$$VAL^XBDIQ1(9000010.06,Y,.04) Q
18 S %=$$VALI^XBDIQ1(9000010.06,Y,.05) Q
19 S %=$$VAL^XBDIQ1(9000010.06,Y,.05) Q
20 S %=$$VAL^XBDIQ1(9000010.06,Y,1201) Q
ATTPHY ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,P
 S P="",(C,Y)=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPRV(Y,0),U,5)="A" S P=$P(^AUPNVPRV(Y,0),U)
 I 'P Q P
 I $P(^DD(9000010.06,.01,0),U,2)[200,'$D(^VA(200,P)) Q -1
 I $P(^DD(9000010.06,.01,0),U,2)[6,'$D(^DIC(6,P)) Q -1
 I $G(F)="" S F="N"
 S %="" D @F
 Q %
 ;
MIDWIFE ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I $P(^AUPNVSIT(V,0),U,7)'="H" Q ""
 NEW %,Y,P
 S P="",(C,Y)=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y  S P=$P(^AUPNVPRV(Y,0),U)
 I 'P Q P
 I $P(^DD(9000010.06,.01,0),U,2)[200,'$D(^VA(200,P)) Q -1
 I $P(^DD(9000010.06,.01,0),U,2)[6,'$D(^DIC(6,P)) Q -1
 S %="" D D
 Q $S(%=17:1,1:"")
 ;
 ;return a 1 if one of the providers is a midwife (ihs code=17)
