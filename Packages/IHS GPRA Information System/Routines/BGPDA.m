BGPDA ; IHS/CMI/LAB - indicator A ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
IA ;EP ;EP - indicator A
 ;Q:'$D(BGPIND(27))
 Q:'$$DM^BGPD1(DFN,BGPEDATE)
 S BGPSEX=$P(^DPT(DFN,0),U,2),BGPSEX=$S(BGPSEX="M":1,1:2)
 S BGPP=$$DEP(DFN,BGPEDATE)
 I BGPP D SAGE(BGPRPT,$S(BGPTIME=1:15,BGPTIME=0:45,BGPTIME=8:85,1:999),18,BGPSEX,1)
 I BGPP]"",$D(BGPLIST(27)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",27,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)="Depressive Disorder DX"
 Q
SAGE(R,N,P,S,V) ;set age into file
 I 'V Q  ;no value
 NEW X,Y
 S X=$P($G(^BGPD(R,N)),U,P)
 S $P(X,"!",S)=$P(X,"!",S)+V
 S $P(^BGPD(R,N),U,P)=X
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
 ;
DEP(P,EDATE) ;is there a dx of depression?
 I $G(P)="" Q ""
 ;check povs
 NEW X,E,BGPG,Y,BDATE
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP DEPRESSIVE DISORDERS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1  ;has a dx
 Q 0
 ;
 ;
