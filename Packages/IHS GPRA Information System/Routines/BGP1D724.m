BGP1D724 ;IHS/CMI/LAB - CONTRA (CONT);
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
  ;
  ;
BETACONT ;EP
 NEW X,Y,BGPG,BGPD,G,N
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 S NMIBD=$G(NMIBD),NMIED=$G(NMIED)
 K BGPG,BGPD
 S Y="BGPG("
 S X=P_"^ALL DX [BGP ASTHMA DXS;DURING "_BDATE_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S (X,G)=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPD($P(BGPG(X),U))=""
 S (X,G)=0 K Y F  S X=$O(BGPD(X)) Q:X'=+X  S G=G+1,Y(G)=X
 I G>1 Q 1_U_$$DATE^BGP1UTL(Y(1))_" "_$$DATE^BGP1UTL(Y(2))_" Contra 2 dx asthma"
 S BGPG=$$LASTDX^BGP1UTL1(P,"BGP HYPOTENSION DXS",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_$$DATE^BGP1UTL($P(BGPG,U,3))_" Contra hypotension dx "_$P(BGPG,U,2)  ;has hypotension dx
 S BGPG=$$LASTDX^BGP1UTL1(P,"BGP CMS 2/3 HEART BLOCK DXS",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_$$DATE^BGP1UTL($P(BGPG,U,3))_" Contra 2/3 heart block dx "_$P(BGPG,U,2)
 S BGPG=$$LASTDXI^BGP1UTL1(P,"427.81",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_$$DATE^BGP1UTL($P(BGPG,U,3))_" Contra sinus brady dx "_$P(BGPG,U,2)  ;"sinus brady contra"
 K BGPG,BGPD
 S Y="BGPG("
 S X=P_"^ALL DX [BGP COPD DXS BB CONT;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S (X,G)=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPD($P(BGPG(X),U))=""
 S (X,G)=0 K Y F  S X=$O(BGPD(X)) Q:X'=+X  S G=G+1,Y(G)=X
 I G>1 Q 1_U_$$DATE^BGP1UTL(Y(1))_" "_$$DATE^BGP1UTL(Y(2))_" Contra 2 dx COPD"
 ;now check for NMI of beta blocker during RP
 ;
 S T=$O(^ATXAX("B","BGP HEDIS BETA BLOCKER MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not a Beta Blocker
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<NMIBD Q  ;documented more than 1 year before edate
 ..I Y>NMIED Q
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S G=1_U_$$DATE^BGP1UTL(Y)_" Contra NMI "_$P(^PSDRUG(X,0),U,1)
 ..Q
 .Q
 I G Q G
 ;now cpt 8011 in past year
 S X=$$CPTI^BGP1DU(P,NMIBD,NMIED,+$$CODEN^ICPTCOD("G8011"))
 I X Q "1^"_$$DATE^BGP1UTL($P(X,U,2))_" Contra CPT code G8011"
 S X=$$TRANI^BGP1DU(P,NMIBD,NMIED,+$$CODEN^ICPTCOD("G8011"))
 I X Q "1^"_$$DATE^BGP1UTL($P(X,U,2))_" Contra TRAN code G8011"
 Q 0
