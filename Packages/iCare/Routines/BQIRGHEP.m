BQIRGHEP ;GDHD/HCD/ALA-Hepatitis Immunizations ; 25 May 2016  12:09 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
HEPA(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPHEPA,C,X,ED,BD,G,V,Y,T,I,R,BGPIMM,BGPNMI
 K BGPC,BGPG,BGPX,HCT
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHEPA
 ;get all immunizations
 S C="31^52^83^84^85^104"
 D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHEPA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S T=$O(^ATXAX("B","BGP HEPATITIS A CPTS",0))
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^BGP6UTL2(Y,T,1) S BGPHEPA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^BGP6UTL2(Y,T,1) S BGPHEPA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHEPA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S HCT=0,X=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S HCT=HCT+1
 I HCT=1 Q "1 dose Hep A"
 I HCT>1 Q "YES"
 ;check for Evidence of disease and Contraindications and if yes, then quit
 K BGPG S %=P_"^LAST DX [BGP HEPATITIS A EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q "Evidence of Hep A"
 I $$PLTAX^BGP6DU(P,"BGP HEPATITIS A EVIDENCE") Q "Evidence of Hep A"
 ;
 F BGPZ=31,52,83,84,85,104 S X=$$ANCONT^BGP6D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q "Contra Hep A"
 ;
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=31,52,83,84,85,104 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:"NMI",1:"Ref")_" Hep A"
 S R=$$CPTREFT^BGP6UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HEPATITIS A CPTS",0)))
 I R,$P(R,U,3)="N" S BGPNMI=1 Q $S(BGPNMI:"NMI",1:"Ref")_" Hep A"
 Q ""
