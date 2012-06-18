AMHUTIL3 ; IHS/CMI/LAB - provider functions ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;IHS/CMI/LAB - added stage as output parameter
 ;
 ;IHS/TUCSON/LAB - patch 1 05/19/97 - fixed setting of array
DLM(V) ;EP date last modified
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW R
 S R=""
 S R=$S($P($G(^AMHREC(V,11)),U,14)]"":$$DATE^AMHUTIL($P(^AMHREC(V,11),U,14)),1:$$DATE^AMHUTIL($P(^AMHREC(V,0),U,21)))
 Q R
TLM(V) ;
 NEW R
 S R=$P($G(^AMHREC(V,11)),U,14)
 I R="" Q ""
 S R=$$FMTE^XLFDT(R,"2P")
 Q $$UP^XLFSTR($P($P(R," ",2),":",1,2))_$$UP^XLFSTR($P(R," ",3))
 ;
DLMSF(V) ;EP date last modified
 I 'V Q ""
 I '$D(^AMHPSUIC(V)) Q ""
 NEW R
 S R=""
 S R=$S($P($G(^AMHPSUIC(V,0)),U,27)]"":$$DATE^AMHUTIL($P(^AMHPSUIC(V,0),U,27)),1:$$DATE^AMHUTIL($P(^AMHPSUIC(V,0),U,21)))
 Q R
TLMSF(V) ;
 NEW R
 S R=$P($G(^AMHPSUIC(V,0)),U,27)
 I R="" Q ""
 S R=$$FMTE^XLFDT(R,"2P")
 Q $$UP^XLFSTR($P($P(R," ",2),":",1,2))_$$UP^XLFSTR($P(R," ",3))
 ;
MSR6(V) ;EP - return first 6 measurements and values
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW Y,R,C,F,S
 S R="",(Y,C)=0,F=1,S=2
 F  S Y=$O(^AMHRMSR("AD",V,Y)) Q:Y'=+Y!(C>5)  S C=C+1,$P(R,U,F)=$$VAL^XBDIQ1(9002011.12,Y,.01),$P(R,U,S)=$P(^AMHRMSR(Y,0),U,4) S F=F+2,S=S+2
 Q R
PED(V,N) ;EP - return nth v patient ed on this visit
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AMHREDU("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AMHREDU(Y,0),"^"),Z=Y
 I 'P Q P
 I '$D(^AUTTEDT(P)) Q ""
 S R=$P(^AUTTEDT(P,0),U,2)
 S %="" D  S R=R_U_%
 .S P=$P(^AMHREDU(Z,0),U,4) I %="" Q
 .NEW A D A^AMHUTIL Q:%=""  S A=% NEW D D D^AMHUTIL Q:%=""  S D=%,%="" D C^AMHUTIL1 Q:%=""  S %=A_D_% Q
 S R=R_U_$P(^AMHREDU(Z,0),U,5)_U_$P(^AMHREDU(Z,0),U,6)_U_$$VAL^XBDIQ1(9002011.05,Z,.07)_U_$P(^AMHREDU(Z,0),U,8)_U_$$VAL^XBDIQ1(9002011.05,Z,1102)
 Q R
 ;
HF(V,N) ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AMHRHF("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AMHRHF(Y,0),"^"),Z=Y
 I 'P Q P
 I '$D(^AUTTHF(P)) Q ""
 S R=$P(^AUTTHF(P,0),U,1)
 S %="" D  S R=R_U_%
 .S P=$P(^AMHRHF(Z,0),U,5) I %="" Q
 .NEW A D A^AMHUTIL Q:%=""  S A=% NEW D D D^AMHUTIL Q:%=""  S D=%,%="" D C^AMHUTIL1 Q:%=""  S %=A_D_% Q
 S R=R_U_$P(^AMHRHF(Z,0),U,4)_U_$P(^AMHRHF(Z,0),U,6)
 Q R
 ;
PRIMPA(V,F) ;EP - primary provider in many different formats
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=$O(^AMHRPA("AD",V,0)) I Y S P=$P(^AMHRPA(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AMHTPA(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
SECPA(V,N,F) ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0,C=-1 F  S Y=$O(^AMHRPA("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AMHRPA(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AMHTPA(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
PA ;EP
 NEW Z,C,%,S,I,J
 S (C,Y)=0 F  S Y=$O(^AMHRPA("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AMHRPA(Y,0),U),Z=Y D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,I)=% ;IHS/TUCSON/LAB - patch 1 05/19/97 changed ,I TO ,J
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
ADMDX ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S P=$P(^AUPNVINP(Z,0),U,12)
 I 'P Q P
 I '$D(^AMHTPA(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 S %=$P(^AMHTPA(P,0),U,3) Q
C ;
 S %=$P(^AMHTPA(P,0),U,2) Q
D ;
 S %=$P(^AMHRPA(Z,0),U,7) Q
J ;
 S %=$P(^AMHRPA(Z,0),U,9) I % S %=$P(^AMHTPA(%,0),U) Q
 Q
P ;
 S %=$P(^AMHRPA(Z,0),U,11) Q
N ;
 S %=$P(^AMHRPA(Z,0),U,4) I %,$D(^AUTNPOV(%,0)) S %=$P(^AUTNPA(%,0),U)
 Q
S ;stage
 S %=$P(^AMHRPA(Z,0),U,5) Q
A ;
 NEW I,H,R,L,E,D
 S I=$P(^AMHTPA(P,0),U)
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
 S %=$$VD^APCLV($P(^AMHRPA(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AMHRPA(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AMHRPA(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AMHRPA(Y,0),U,3),"E")
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
15 S %=$P(^AMHRPA(Y,0),U,12) Q
16 S %=$$VAL^XBDIQ1(9000010.07,Y,.12) Q
17 S %=$$VAL^XBDIQ1(9000010.07,Y,.13) Q
18 S %=$$VAL^XBDIQ1(9000010.07,Y,.05) Q
19 S %=$$VALI^XBDIQ1(9000010.07,Y,.06) Q
20 S %=$$VAL^XBDIQ1(9000010.07,Y,.06) Q
