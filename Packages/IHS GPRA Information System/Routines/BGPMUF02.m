BGPMUF02 ; IHS/MSC/MMT - MI measure NQF0038 support routines ;02-Mar-2011 11:44;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
HEPA(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 N B,C,X,ED,BD,G,D,E,I,BGP00743,V,Y,Z,R,BGPIMM,BGPNMI
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHEPA
 ;get all immunizations
 S C="83" ;per CMS specification spreadsheet, only CVX 83, CPT 90633
 D GETIMMS^BGPMUUT2(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHEPA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S BGP00743=0 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90633 S BGPHEPA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90633 S BGPHEPA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHEPA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPHEPA=0,X=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S BGPHEPA=BGPHEPA+1
 I BGPHEPA>1 Q 1_U_"2 HEP A"
 ;check for allergy to vaccine
 ;look in file 120.8
 S R=""
 ;check refusals in imm pkg
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=83 S R=$$IMMREF^BGPMUUT2(P,BGPIMM,B,EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" hep A"
 ;contraindication
 F BGPZ=83 S X=$$ANCONT(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - HEP A"
 ;NO! This should not stop here - this code needs to be reinstated and reworked!
 ;QUIT here since CMS specs do not call for exclusions based on disease, refusals or contraind.
 Q ""
 ;check for evidence of disease and contraindications and if yes, then quit
 K BGPG S %=P_"^LAST DX [BGP HEP EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 4_U_"evid hep A"
 I $$PLTAX^BGP0DU(P,"BGP HEP EVIDENCE") Q 4_U_"evid hep A"
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=83  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" hep A"
 ;now check refusals in imm pkg
 F BGPIMM=83 S R=$$IMMREF^BGP0D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" hep A"
 F BGPZ=83 S X=$$ANCONT^BGP0D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - HEP A"
 Q ""
ROTA(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 N B,C,X,ED,BD,G,BGP00743,V,Y,Z,R,BGPIMM,BGPNMI
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPROTA
 ;get all immunizations
 S C="116^119" ;per CMS specification spreadsheet, only CVX 116&119, CPT 90680 & 90681
 D GETIMMS^BGPMUUT2(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPROTA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S BGP00743=0 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680!(Y=90681) S BGPROTA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680!(Y=90681) S BGPROTA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPROTA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPROTA=0,X=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S BGPROTA=BGPROTA+1
 I BGPROTA>1 Q 1_U_"2 ROTA"
 ;check for allergy to vaccine
 S R=""
 ;check refusals in imm pkg
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=116,119 S R=$$IMMREF^BGPMUUT2(P,BGPIMM,B,EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" ROTA"
 ;check contraindications
 F BGPZ=116,119 S X=$$ANCONT(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - ROTA A"
 ;for diag chks, $$LASTDX and $$PLCODE
 ;QUIT here since CMS specs do not call for exclusions based on disease, refusals or contraind.
 Q ""
FLU(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 N B,C,X,ED,BD,G,BGP00743,V,Y,Z,R,BGPIMM,BGPNMI
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPFLU
 ;get all immunizations
 S C="135^15" ;per CMS specification spreadsheet, only CVX 135 & 15, CPTs 90655, 90657, 90661, 90662
 D GETIMMS^BGPMUUT2(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPFLU(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S BGP00743=0 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90655!(Y=90657)!(Y=90661)!(Y=90662) S BGPFLU(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90655!(Y=90657)!(Y=90661)!(Y=90662) S BGPFLU(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPFLU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPFLU(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPFLU=0,X=0 F  S X=$O(BGPFLU(X)) Q:X'=+X  S BGPFLU=BGPFLU+1
 I BGPFLU>1 Q 1_U_"2 FLU"
 ;check for allergy to vaccine
 S R=""
 ;now check refusals in imm pkg
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=135,15 S R=$$IMMREF^BGPMUUT2(P,BGPIMM,B,EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" FLU"
 F BGPZ=135,15 S X=$$ANCONT(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - FLU"
 ;QUIT here since CMS specs do not call for exclusions based on disease, refusals or contraind.
 Q ""
ANCONT(P,C,ED) ;EP - ANALPHYLAXIS CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contraindication: Anaphylaxis"
 Q G
