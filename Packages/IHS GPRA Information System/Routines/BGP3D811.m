BGP3D811 ; IHS/CMI/LAB - PCR, MMR
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;
PCR(P,BDATE,EDATE) ;EP
 NEW BGPG,%,E,A,T,X,G,J,I
 S %=P_"^LAST LAB [BGP HIV VIRAL LOAD TAX;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 1_U_$P(BGPG(1),U,1)_U_$P(BGPG(1),U,2)
 S E=+$$CODEN^ICPTCOD(87536),%=$$CPTI^BGP3DU(P,BDATE,EDATE,E) I %]"" Q 1_U_$P(%,U,2)_"^87536"
 S E=+$$CODEN^ICPTCOD(87539),%=$$CPTI^BGP3DU(P,BDATE,EDATE,E) I %]"" Q 1_U_$P(%,U,2)_"^87539"
 S E=+$$CODEN^ICPTCOD(87536),%=$$TRANI^BGP3DU(P,BDATE,EDATE,E) I %]"" Q 1_U_$P(%,U,2)_"^87536 TRAN"
 S E=+$$CODEN^ICPTCOD(87539),%=$$TRANI^BGP3DU(P,BDATE,EDATE,E) I %]"" Q 1_U_$P(%,U,2)_"^87539 TRAN"
 ;now go through all labs and check loinc codes
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",%=P_"^ALL LAB;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,A)
 I '$D(^TMP($J,"A",1)) Q ""
 ;now go through all lab tests and see if any are the loinc codes in the taxonomy
 S T=$O(^ATXAX("B","BGP VIRAL LOAD LOINC CODES",0))
 I 'T Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S I=+$P(^TMP($J,"A",X),U,4) I $P($G(^AUPNVLAB(I,11)),U,13)]"" D
 .S J=$P(^AUPNVLAB(I,11),U,13)
 .I $$LOINC^BGP3D21(J,T) S G=1_U_$$VD^APCLV($P(^AUPNVLAB(I,0),U,3))_U_$$VAL^XBDIQ1(9000010.09,I,.01)
 Q G
MMR(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPMMR,ED,BD,V,X,Y,C,D,BGPME,BGPMU,BGPRUB,BGPMR,BGPRM,BGPNMI,BGPIMM
 K ^TMP($J,"CPT")
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=+Y,$T(@Y)]"" S ^TMP($J,"CPT",9999999-ED,Y)=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=+Y,$T(@Y)]"" S ^TMP($J,"CPT",9999999-ED,Y)=""
 S BGPMMR=0
 S C="3^94"
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPMMR)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMMR(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90707!(Y=90710) S BGPMMR(D)=""
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 1_U_"2 MMR"
MR ;see if one M/R, Mumps or R/M
 S (BGPMR,BGPRM,BGPME,BGPMU,BGPRUB)=0
 S C=4
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMR(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90708 S BGPMR(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMR(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPMR(X)) Q:X'=+X  S BGPMR=BGPMR+1
RM ;
 S C=38
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPRM(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90709 S BGPRM(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPRM(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRM(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPRM(X)) Q:X'=+X  S BGPRM=BGPRM+1
ME S C=5
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPME(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90705 S BGPME(D)=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
MU S C=7
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMU(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90704 S BGPMU(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
RUB S C=6
 K BGPX D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPRUB(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90706 S BGPRUB(D)=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 I BGPMR>1,BGPMU>1 Q 1_U_"2 m/r 2 mu"
 I BGPRM>1,BGPME>1 Q 1_U_"2 r/m 2 me"
 I BGPME>1,BGPMU>1,BGPRUB>1 Q 1_U_"2 me 2 mu 2 rub"
 ;now add diagnoses and proc codes for code 2
PVS ;
 K BGPG S %=P_"^ALL DX [BGP MMR IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMMR($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 2_U_"2 MMR (DX/IMM)"
 K BGPG D SETPRC^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,"BGP MMR IZ PROCS",.BGPG)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMMR($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 2_U_"2 MMR (PROC/IMM)"
MEPV ;
 K BGPG S %=P_"^ALL DX [BGP MEASLES IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPME($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPME=0,X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
 K BGPG D SETPRC^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,"BGP MEASLES IZ PROCS",.BGPG)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPME($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPME=0,X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
MUPV ;
 K BGPG S %=P_"^ALL DX [BGP MUMPS IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMU($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMU=0,X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
 K BGPG D SETPRC^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,"BGP MUMPS IZ PROCS",.BGPG)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMU($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMU=0,X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
RUBPV ;
 K BGPG S %=P_"^ALL DX [BGP RUBELLA IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPRUB($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPRUB=0,X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 K BGPG D SETPRC^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,"BGP RUBELLA IZ PROCS",.BGPG)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPRUB($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPRUB=0,X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 ;
 I BGPMR>1,BGPMU>1 Q 2_U_"m/r mu"
 I BGPRM>1,BGPME>1 Q 2_U_"r/m me"
 I BGPME>1,BGPMU>1,BGPRUB>1 Q 2_U_"me mu rub"
REF ;
 ;now get a Refusal of MMR if there is one
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",BGPMMR=0,R=""
 F BGPIMM=3,94 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI MMR",1:"Ref MMR")
 F BGPIMM=90707,90710 D
 .S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI MMR",1:"Ref MMR")
 ;now check Refusals in imm pkg
 ;S R="" F BGPIMM=3,94 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_"Ref MMR"
MMRC ;K BGPG S %=P_"^LAST DX [BGP MMR CONTRAINDICATIONS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 ;I $D(BGPG(1)) Q 4_U_"Contra MMR"
 ;I $$PLTAX^BGP3DU(P,"BGP MMR CONTRAINDICATIONS") Q 4_U_"Contra MMR"
 F BGPZ=3,94 S X=$$MMRCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"Contra MMR"
REFMR ;
 I BGPMR=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI=""
 .F BGPIMM=4 D
 ..S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMR=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 .F BGPIMM=90708 D
 ..S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMR=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 ;now check Refusals in imm pkg
 ;F BGPIMM=4 I $$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPMR=3
REFRM I BGPRM=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=38 D
 ..S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRM=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 .F BGPIMM=90709 D
 ..S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRM=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 ;F BGPIMM=38 I $$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPRM=3
MEX ;
 I BGPME=0 K BGPG S %=P_"^LAST DX [BGP MEASLES EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPME=1
 I $$PLTAX^BGP3DU(P,"BGP MEASLES EVIDENCE") S BGPME=1
 I BGPME=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=5 D
 ..S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPME=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 .F BGPIMM=90705 D
 ..S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPME=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 ;F BGPIMM=7 I $$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPME=3
MUX ;
 I BGPMU=0 K BGPG S %=P_"^LAST DX [BGP MUMPS EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPMU=1
 I $$PLTAX^BGP3DU(P,"BGP MUMPS EVIDENCE") S BGPMU=1
 I BGPMU=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=7 D
 ..S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMU=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 .F BGPIMM=90704 D
 ..S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMU=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 ;now check Refusals in imm pkg
 ;F BGPIMM="7" I $$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPMU=3
RUBX ;
 I BGPRUB=0 K BGPG S %=P_"^LAST DX [BGP RUBELLA EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPRUB=1
 I $$PLTAX^BGP3DU(P,"BGP RUBELLA EVIDENCE") S BGPRUB=1
 I BGPRUB=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=6 D
 ..S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRUB=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 .F BGPIMM=90706 D
 ..S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 ..S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRUB=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:"")
 ;F BGPIMM=6 I $$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPRUB=3
 I BGPMR,BGPMU S X=1 S:BGPMR=3 X=3 S:BGPMU=3 X=3 S:BGPMR=4 X=4 S:BGPMU=4 X=4 Q X_U_"mr & mu"_$S(X=4:" NMI",X=3:" Ref",1:"")
 I BGPRM,BGPME S X=1 S:BGPRM=3 X=3 S:BGPME=3 X=3 S:BGPRM=4 X=4 S:BGPME=4 X=4 Q X_U_"RM & ME"_$S(X=4:" NMI",X=3:" Ref",1:"")
 I BGPME,BGPMU,BGPRUB S X=1 S:BGPME=3 X=3 S:BGPMU=3 X=3 S:BGPRUB=3 X=3 S:BGPME=4 X=4 S:BGPMU=4 X=4 S:BGPRUB=4 X=4 Q X_U_"ME&MU&RUB"_$S(X=4:" NMI",X=3:" Ref",1:"")
 Q ""
90707 ;;
90710 ;;
90708 ;;
90709 ;;
90705 ;;
90704 ;;
90706 ;;
