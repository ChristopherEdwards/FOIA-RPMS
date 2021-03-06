BGP3D35 ; IHS/CMI/LAB - measure C ; 01 Nov 2012  12:11 PM
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;
VAR(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPVARI,C,ED,BD,G,V,X,Y,BGPZ,B,BGPIMM,R,BGPNMI
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPVARI
 ;get all immunizations
 S C="21^94"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 I $O(BGPX(0)) Q 1_U_"Vari"
 ;now get cpts
 S ED=9999999-EDATE-1,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90710!(Y=90716) S BGPVARI(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90710!(Y=90716) S BGPVARI(9999999-$P(ED,"."))=""
 I $D(BGPVARI) Q 1_U_"Vari"
 K BGPG S %=P_"^ALL DX [BGP VARICELLA IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 2_U_"Vari"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 K BGPG S %=P_"^LAST DX [BGP VARICELLA EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 4_U_"Evid Vari"
 I $$PLTAX^BGP3DU(P,"BGP VARICELLA EVIDENCE") Q 4_U_"Evid Vari"
 F BGPZ=21,94 S X=$$EVIDVAR(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"Evid Vari"
 ;K BGPG S %=P_"^LAST DX [BGP VARICELLA CONTRA;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 ;I $D(BGPG(1)) Q 4_U_"Contra Vari"
 ;I $$PLTAX^BGP3DU(P,"BGP VARICELLA CONTRA") Q 4_U_"Contra Vari"
 F BGPZ=21,94 S X=$$MMRCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"Contra Vari"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=21,94  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI Vari",1:"Ref Vari")
 F BGPIMM=90710,90716  D
 .S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI Vari",1:"Ref Vari")
 ;now check Refusals in imm pkg
 ;F BGPIMM=21,94 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_"Ref imm pkg Vari"
 Q ""
HEP(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPHEP,X,ED,BD,G,T,BGP10743,V,Z,Y,C
 ;get all immunizations
 S C="8^42^43^44^45^51^102^104^110^132^146"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHEP(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S T=$O(^ATXAX("B","BGP HEPATITIS CPTS",0))
 S BGP10743=0 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) S:Z=90743 BGP10743=1 I $$ICD^ATXCHK(Y,T,1) S BGPHEP(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) S:Z=90743 BGP10743=1 I $$ICD^ATXCHK(Y,T,1) S BGPHEP(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHEP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHEP(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHEP=0,X=0 F  S X=$O(BGPHEP(X)) Q:X'=+X  S BGPHEP=BGPHEP+1
 ;I '$G(BGPADOL),BGPHEP=3,BGP10743 G I
 I BGPHEP>2 Q 1_U_"3 Hep B"
I I BGPHEP=2,BGP10743,$G(BGPADOL) Q 1_U_" 2 Hep B + 90743"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 K BGPG S %=P_"^LAST DX [BGP HEP EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 4_U_"Evid Hep B"
 I $$PLTAX^BGP3DU(P,"BGP HEP EVIDENCE") Q 4_U_"Evid Hep B"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM="8",42,43,44,45,51,102,104,110,132,146  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep B"
 S R=$$CPTREFT^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HEPATITIS CPTS",0)))
 I R,$P(R,U,3)="N" S BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep B"
 ;now check Refusals in imm pkg
 ;F BGPIMM=8,42,43,44,45,51,102,104,110,132,146 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hep B"
 F BGPZ=8,42,43,44,45,51,102,104,110,132,146 S X=$$ANCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Hep B"
 Q ""
HIB(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 K BGPHIB,BGPAHIB
 ;get all immunizations
 S C="17^22^46^47^48^49^50^51^102^120^132^146"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHIB(X)="",BGPAHIB(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 I BGPHIB>2 Q 1_U_"3 Hib"
 ;now get povs
 K BGPHIB M BGPHIB=BGPAHIB
 K BGPG S %=P_"^ALL DX [BGP HIB IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPHIB($P(BGPG(X),U))="",BGPAHIB($P(BGPG(X),U))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 I BGPHIB>2 Q 2_U_"3 Hib"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 ;K BGPG S %=P_"^LAST DX [BGP HIB EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 ;I $D(BGPG(1)) Q 4_U_"Evid Hib"
 ;I $$PLTAX^BGP3DU(P,"BGP HIB EVIDENCE") Q 4_U_"Evid Hib"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=22,46,47,48,49,50,51,102,120,132,146 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 S R=$$CPTREFT^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HIB CPT",0)))
 I R S:$P(R,U,3)="N" BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 ;now check Refusals in imm pkg
 F BGPIMM=17,22,46,47,48,49,50,51,102,120,132,146 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 F BGPZ=17,22,46,47,48,49,50,51,102,120,132,146 S X=$$ANCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Hib"
 Q ""
PNEUMO(P,EDATE,MINN) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPPNU,BGPAPNU
 ;get all immunizations
 S C="33^100^109^133"
 D GETIMMS^BGP3D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPPNU(X)="",BGPAPNU(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)),1) S BGPPNU(9999999-$P(ED,"."))="",BGPAPNU(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK($P(^AUPNVTC(X,0),U),$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)),1) S BGPPNU(9999999-$P(ED,"."))="",BGPAPNU(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPPNU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPNU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPPNU=0,X=0 F  S X=$O(BGPPNU(X)) Q:X'=+X  S BGPPNU=BGPPNU+1
 I BGPPNU>(MINN-1) Q 1_U_MINN_" Pneumo"
 ;now get povs
 K BGPPNU M BGPPNU=BGPAPNU
 K BGPG S %=P_"^ALL DX [BGP PNEUMO IZ DXS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPPNU($P(BGPG(X),U))="",BGPAPNU($P(BGPG(X),U))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPPNU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPNU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPPNU=0,X=0 F  S X=$O(BGPPNU(X)) Q:X'=+X  S BGPPNU=BGPPNU+1
 I BGPPNU>(MINN-1) Q 2_U_MINN_" Pneumo/DX"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=33,100,109,133 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="N" S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Pneumo"
 S R=$$CPTREFT^BGP3UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)))
 I R,$P(R,U,3)="N" S BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Pneumo"
 ;now check Refusals in imm pkg
 ;F BGPIMM=33,100,109,133 S R=$$IMMREF^BGP3D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Pneumo"
 F BGPZ=33,100,109,133 S X=$$ANCONT^BGP3D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Pneumo"
 Q ""
EVIDVAR(P,C,ED) ;EP - HX CHICKEN POX, IMMUNE
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Hx of Chicken Pox" S G=D_U_"Contra: Hx of Chicken Pox"
 .I $P(^BICONT(R,0),U,1)="Immune" S G=D_U_"Contra: Immune"
 Q G
