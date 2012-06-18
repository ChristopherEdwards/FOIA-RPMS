BGP9D862 ; IHS/CMI/LAB - measure C ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
RHEUAR(P,BDATE,EDATE) ;EP
 ;must have osteoarthritis on pl prior to BDATE or have a pov prior to bdate
 ;and have 2 povs between bdate and edate
 I '$G(P) Q ""
 S (G,X,Y,A,H,C)=""
 ;first check for pov prior to bdate
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP RHEUMATOID ARTHRITIS DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_BDATE S E=$$START1^APCLDF(X,Y)
 S H="" I $D(BGPG(1)) S H=$$DATE^BGP9UTL($P(BGPG(1),U))_" "_$P(BGPG(1),U,2)
 I H]"" G RPDXS
 ;now check for pl entry prior to BDATE
 S T=$O(^ATXAX("B","BGP RHEUMATOID ARTHRITIS DXS",0))
 S (X,B)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(H)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>BDATE  ;if added to pl after beginning of time period, no go
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S H=$$DATE^BGP9UTL($P(^AUPNPROB(X,0),U,8))_" "_$P($$ICDDX^ICDCODE(Y),U,2)_" Problem list"
 .Q
 I H="" Q ""  ;don't go further as patient does not have RHEU arthritis prior to the report period
RPDXS ;check for 2 dxs in time period
 K BGPG
 S Y="BGPG(",C=""
 S X=P_"^LAST 2 DX [BGP RHEUMATOID ARTHRITIS DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(2)) S C="2 dxs: "_$$DATE^BGP9UTL($P(BGPG(2),U))_" "_$$DATE^BGP9UTL($P(BGPG(1),U))
 I H=""!(C="") Q ""
 Q "1^prior: "_H_" rpt period: "_C
 ;
UG(P,BDATE,EDATE) ;
 K BGPC
 S BGPC=0
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP URINE GLUCOSE LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP URINE GLUCOSE",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP9D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 Q BGPC
 ;
