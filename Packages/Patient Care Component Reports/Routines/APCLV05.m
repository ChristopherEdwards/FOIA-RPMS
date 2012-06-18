APCLV05 ; IHS/CMI/LAB - provider functions ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
DENT ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVDEN("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVDEN(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AUTTADA(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 S %=$P(^AUTTADA(Z,0),U,2) Q
U ;
 S %=$P(^AUPNVDEN(Z,0),U,4) Q
C ;
 S %=$P(^AUTTADA(P,0),U) Q
R ;fee rounded to nearest $
 S %=$P(^AUPNVDEN(Z,0),U,7) Q
 I %="" Q
 S %=$P((%+.5),".")
 Q
F ;fee
 S %=$P(^AUPNVDEN(Z,0),U,5) Q
