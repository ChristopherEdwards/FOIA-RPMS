APCLV11 ; IHS/CMI/LAB - provider functions ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - patch 4 1/5/1999 for new immunization package
 ;
IMM ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVIMM("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVIMM(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AUTTIMM(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 S %=$P(^AUTTIMM(P,0),U) Q
S ;
 S %=$P(^AUPNVIMM(Z,0),U,4) Q
C ;
 ;IHS/CMI/LAB - modified line below for patch 4 1/5/1999
 S %=$P(^AUTTIMM(P,0),U,$S($$BI:20,1:3)) Q
 ;
BI() ;IHS/CMI/LAB - new subroutine patch 4 1/5/1999
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;end new subrotuine IHS/CMI/LAB
