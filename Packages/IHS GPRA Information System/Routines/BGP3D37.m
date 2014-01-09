BGP3D37 ; IHS/CMI/LAB - IMMUNIZATIONS ;
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;
FLU ;EP
 NEW BGPG,BGPLFLU,EDATE,X,E,%,I,T,J,V,G,D,R,CVX
 K BGPG
 S BGPLFLU=""
 I $G(BD)="" S BD=$$FMADD^XLFDT(ED,-365)
 S EDATE=$$FMTE^XLFDT(ED),BDATE=$$FMTE^XLFDT(BD)
 S T=$O(^ATXAX("B","BGP FLU IZ CVX CODES",0))
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNVIMM(X,0)),U,1)
 .I 'I Q
 .S CVX=$P($G(^AUTTIMM(I,0)),U,3)
 .Q:CVX=""
 .I '$D(^ATXAX(T,21,"B",CVX)) Q  ;NOT IN TAXONOMY
 .S D=$$VD^APCLV($P(^AUPNVIMM(X,0),U,3))
 .Q:D<BD
 .Q:D>ED
 .I $P(BGPLFLU,U)<D S BGPLFLU=D_U_"Imm "_CVX
 K BGPG S %=P_"^LAST DX [BGP FLU IZ DX V04.8;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) I $P(BGPLFLU,U)<$P(BGPG(1),U,1) S BGPLFLU=$P(BGPG(1),U,1)_U_$P(BGPG(1),U,2)
 S BGPG=$$LASTPRC^BGP3UTL1(P,"BGP FLU IZ PROCEDURES",BD,ED)
 I $P(BGPG,U,1)=1,$P(BGPLFLU,U)<$P(BGPG,U,3) S BGPLFLU=$P(BGPG,U,3)_U_"Proc "_$P(BGPG,U,2)
 K BGPG S %=P_"^LAST DX [BGP FLU IZ DXS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) D
 .S T=$O(^ATXAX("B","SURVEILLANCE CPT H1N1",0))
 .S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 ..S V=$P(BGPG(X),U,5)
 ..S G=0
 ..S J=0 F  S J=$O(^AUPNVCPT("AD",V,J)) Q:J'=+J  S I=$P(^AUPNVCPT(J,0),U,1) I $$ICD^ATXCHK(I,T,1)!($$H1(I)) S G=1
 ..Q:G=1
 ..I $P(BGPLFLU,U)<$P(BGPG(X),U,1) S BGPLFLU=$P(BGPG(1),U,1)_U_$P(BGPG(1),U,2)
 S T=$O(^ATXAX("B","BGP CPT FLU",0))
 I T D  I X]"" I $P(BGPLFLU,U)<X S BGPLFLU=$P(X,U)_U_"CPT "_$P(X,U,2)
 .S X=$$CPT^BGP3DU(P,,ED,T,5) I X]"" Q
 .S X=$$TRAN^BGP3DU(P,,ED,T,5)
 I BGPLFLU]"" Q BGPLFLU_U_1
 ;Contraindication new in 8.0
 F BGPZ=15,16,88,111,135,140,141 S X=$$FLCONT(P,BGPZ,$$DOB^AUPNPAT(P),ED) Q:X]""
 I X]"" Q X_U_3
 ;NMI Refusal
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",88,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",111,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",15,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",16,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",135,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",140,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",141,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP3UTL1(P,9999999.14,$O(^AUTTIMM("C",144,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 Q ""
FLCONT(P,C,BD,ED) ;EP
 NEW X,G,Y,R,D
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Egg Allergy" S G=D_U_"Contra: Egg Allergy"
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 Q G
H1(I) ;
 I $P($G(^ICPT(I,0)),U,1)=90664 Q 1
 I $P($G(^ICPT(I,0)),U,1)=90666 Q 1
 I $P($G(^ICPT(I,0)),U,1)=90667 Q 1
 I $P($G(^ICPT(I,0)),U,1)=90668 Q 1
 Q ""
ROTA2(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPROTA,C,X,ED,BD,G,V,Y,T,I,R,BGPIMM,BGPNMI
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPROTA
 ;get all immunizations
 S C="119"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPROTA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90681 S BGPROTA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90681 S BGPROTA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPROTA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPROTA=0,X=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S BGPROTA=BGPROTA+1
 I BGPROTA>1 Q 1_U_"2 Rota"
 F BGPZ=119 S X=$$ANIMCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Rota"
 ;
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=119 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Rota"
 ;now check Refusals in imm pkg
 S BGPNMI=""
 ;F BGPIMM=119 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_$S(BGPNMI:"NMI",1:"Ref")_" Rota"
 Q ""
ROTA3(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPROTA,C,X,ED,BD,G,V,Y,T,I,R,BGPIMM,BGPNMI
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPROTA
 ;get all immunizations
 S C="74^116^122^119"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPROTA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90680!(Z=90681) S BGPROTA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90680!(Z=90681) S BGPROTA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPOV(X,0),U,1) Q:'Y  S Z=$P(^ICD9(Y,0),U,1) I Z="V05.8" S BGPROTA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPROTA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPROTA=0,X=0 F  S X=$O(BGPROTA(X)) Q:X'=+X  S BGPROTA=BGPROTA+1
 I BGPROTA>2 Q 1_U_"3 Rota"
 F BGPZ=119,74,116,122 S X=$$ANIMCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Rota"
 ;
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=119,74,116,122 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Rota"
 F BGPIMM=90680,90681 D
 .S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Rota"
 ;now check Refusals in imm pkg
 S BGPNMI=""
 ;F BGPIMM=119,74,116,122 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_$S(BGPNMI:"NMI",1:"Ref")_" Rota"
 Q ""
HEPA(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPHEPA,C,X,ED,BD,G,V,Y,T,I,R,BGPIMM,BGPNMI
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHEPA
 ;get all immunizations
 S C="31^52^83^84^85^104"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHEPA(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S T=$O(^ATXAX("B","BGP HEPATITIS A CPTS",0))
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK(Y,T,1) S BGPHEPA(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK(Y,T,1) S BGPHEPA(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHEPA(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPHEPA=0,X=0 F  S X=$O(BGPHEPA(X)) Q:X'=+X  S BGPHEPA=BGPHEPA+1
 I BGPHEPA>1 Q 1_U_"2 Hep A"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 K BGPG S %=P_"^LAST DX [BGP HEPATITIS A EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 4_U_"Evid Hep A"
 I $$PLTAX^BGP3DU(P,"BGP HEPATITIS A EVIDENCE") Q 4_U_"Evid Hep A"
 ;
 F BGPZ=31,52,83,84,85,104 S X=$$ANCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Hep A"
 ;
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=31,52,83,84,85,104 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep A"
 S R=$$CPTREFT^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HEPATITIS A CPTS",0)))
 I R,$P(R,U,3)="N" S BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep A"
 ;now check Refusals in imm pkg
 S BGPNMI=""
 ;F BGPIMM=31,52,83,84,85,104 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep A"
 Q ""
