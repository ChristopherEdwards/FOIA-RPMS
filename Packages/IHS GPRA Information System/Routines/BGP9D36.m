BGP9D36 ; IHS/CMI/LAB - measure C 06 Nov 2007 2:03 PM ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
MEN(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPMENI
 ;get all immunizations
 S C="32^108^114"
 D GETIMMS^BGP9D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 I $O(BGPX(0)) Q 1_U_"meningococcal"
 ;now get cpts
 S ED=9999999-EDATE-1,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 I $D(BGPMENI) Q 1_U_"meningococcal"
 ;check for evidence of desease and contraindications and if yes, then quit
 F BGPZ=32,108,114 S X=$$ANCONT^BGP9D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra meningococcal"
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=32,108,114  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI meni",1:"ref meni")
 ;now check refusals in imm pkg
 F BGPIMM=32,108,114 S R=$$IMMREF^BGP9D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q 3_U_"ref imm pkg meni"
 Q ""
 ;
HPV(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHPV
 ;get all immunizations
 S C="62^118"
 D GETIMMS^BGP9D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHPV(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650) S BGPHPV(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650) S BGPHPV(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHPV(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHPV=0,X=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S BGPHPV=BGPHPV+1
 I BGPHPV>2 Q 1_U_"3 HPV"
 ;check for evidence of desease and contraindications and if yes, then quit
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=62,118  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" HPV"
 ;now check refusals in imm pkg
 F BGPIMM=62,118 S R=$$IMMREF^BGP9D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" HPV"
 F BGPZ=62,118 S X=$$ANCONT^BGP9D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - HPV"
 Q ""
