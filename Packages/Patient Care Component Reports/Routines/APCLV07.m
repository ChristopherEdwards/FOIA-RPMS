APCLV07 ; IHS/CMI/LAB - provider functions ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;IHS/CMI/LAB - added stage as output parameter
 ;
 ;IHS/TUCSON/LAB - patch 1 05/19/97 - fixed setting of array
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning E,C,J,A
 ;
PRIMPOV ;EP - primary provider in many different formats
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 I $P(^AUPNVSIT(V,0),U,7)="H" F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPOV(Y,0),U,12)="P" S P=$P(^AUPNVPOV(Y,0),U),Z=Y
 I $P(^AUPNVSIT(V,0),U,7)'="H" S Y=$O(^AUPNVPOV("AD",V,0)) I Y S P=$P($G(^AUPNVPOV(Y,0)),U),Z=Y
 I 'P Q P
 I '$D(^ICD9(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
SECPOV ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 I $P(^AUPNVSIT(V,0),U,7)="H" F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPOV(Y,0),U,12)'="P" S C=C+1 I C=N S P=$P(^AUPNVPOV(Y,0),U),Z=Y
 I $P(^AUPNVSIT(V,0),U,7)'="H" S Y=0,C=-1 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVPOV(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^ICD9(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
POV ;EP
 NEW Z,C,%,S,I,J
 S (C,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AUPNVPOV(Y,0),U),Z=Y D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,I)=% ;IHS/TUCSON/LAB - patch 1 05/19/97 changed ,I TO ,J
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
ADMDX ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S P=$P(^AUPNVINP(Z,0),U,12)
 I 'P Q P
 I '$D(^ICD9(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 ;S %=$P(^ICD9(P,0),U,3) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P($$ICDDX^ICDCODE(P,,,1),U,4) Q  ;cmi/anch/maw 9/12/2007 csv
C ;
 ;S %=$P(^ICD9(P,0),U) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P($$ICDDX^ICDCODE(P,,,1),U,2) Q  ;cmi/anch/maw 9/12/2007 csv
D ;
 S %=$P(^AUPNVPOV(Z,0),U,7) Q
J ;
 ;S %=$P(^AUPNVPOV(Z,0),U,9) I % S %=$P(^ICD9(%,0),U) Q  ;cmi/anch/maw 9/12/2007 orig line
 S %=$P(^AUPNVPOV(Z,0),U,9) I % S %=$P($$ICDDX^ICDCODE(%),U,2) Q  ;cmi/anch/maw 9/12/2007 csc
 Q
P ;
 S %=$P(^AUPNVPOV(Z,0),U,11) Q
N ;
 S %=$P(^AUPNVPOV(Z,0),U,4) I %,$D(^AUTNPOV(%,0)) S %=$P(^AUTNPOV(%,0),U)
 Q
S ;stage
 S %=$P(^AUPNVPOV(Z,0),U,5) Q
A ;
 NEW I,H,R,L,E,D
 ;S I=$P(^ICD9(P,0),U)  ;cmi/anch/maw 9/12/2007 orig line
 S I=$P($$ICDDX^ICDCODE(P),U,2)  ;cmi/anch/maw 9/12/2007 csv
 I $E(I)="E" S %=999 Q
 I $E(I)="." D CODE10 G HIGH
 S R="09"_($P(I,".")_$P(I,".",2))_" "
 I $E(I)="V" S I=9_$E(I,2,9999),I=I-.000001,I="09V"_$E(I,2,9999),I=$P(I,".")_$P(I,".",2)_" " G HIGH
 S I="09"_I-.000001
 S %="",I="0"_($P(I,".")_$P(I,".",2))_" "
HIGH S H=$O(^AUTTRCD("AH",I)) I H="" S %=999 Q
 S D=$O(^AUTTRCD("AH",H,"")) I D="" S %="" Q
 S E=$O(^AUTTRCD("AH",H,D,""))
 S L=$P(^AUTTRCD(D,11,E,0),U)_" "
 I L]R S %=999 Q
 S %=$P(^AUTTRCD(D,0),U)
 Q
CODE10 ;
 S R="10"_$P(I,".",2)_" "
 S I="10"_I,I=I-.000001,I=$P(I,".")_$P(I,".",2)_" "
 Q
 ;
1 ;
 S %=$$VD^APCLV($P(^AUPNVPOV(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AUPNVPOV(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AUPNVPOV(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AUPNVPOV(Y,0),U,3),"E")
 Q
5 ;
 S %=Y
 Q
6 D E Q
7 D C Q
8 D A Q
9 D D Q
10 S %=$$VAL^XBDIQ1(9000010.07,Y,.07) Q
11 D J Q
12 D P Q
13 S %=$$VAL^XBDIQ1(9000010.07,Y,.11) Q
14 D N Q
15 S %=$P(^AUPNVPOV(Y,0),U,12) Q
16 S %=$$VAL^XBDIQ1(9000010.07,Y,.12) Q
17 S %=$$VAL^XBDIQ1(9000010.07,Y,.13) Q
18 S %=$$VAL^XBDIQ1(9000010.07,Y,.05) Q
19 S %=$$VALI^XBDIQ1(9000010.07,Y,.06) Q
20 S %=$$VAL^XBDIQ1(9000010.07,Y,.06) Q
