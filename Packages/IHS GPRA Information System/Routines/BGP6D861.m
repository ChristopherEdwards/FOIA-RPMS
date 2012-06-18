BGP6D861 ; IHS/CMI/LAB - measure C ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
NDC(A,B) ;
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
GOLDLAB(P,BDATE,EDATE) ;EP
 K BGPIM,BGPLAB
 K ^TMP($J,"A")
 S S="^TMP($J,""A"",",R=P_"^ALL MEDS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),F=$$START1^APCLDF(R,S)
 I '$D(^TMP($J,"A")) Q ""  ;no meds in time window so quit
 S T1=$O(^ATXAX("B","BGP RA IM GOLD MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA IM GOLD NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S BGPIM($P($P(^AUPNVSIT(V,0),U),"."))=""
 I '$D(BGPIM) Q ""  ;no gold im
 ;CBC'S
 K BGPC
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC($P(%,U,2))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CBC LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CBC TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC(9999999-D)=""
 ...Q
 I '$D(BGPC) Q "0^no CBC tests"
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 ;S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 ;.I C=1 S Y=X Q
 ;.I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 ;.S Y=X
 ;check to see if there is one for every med
 S G=1,X=0 F  S X=$O(BGPIM(X)) Q:X'=+X  I '$D(BGPC(X)) S G=0
 I 'G Q G_U_"no CBC for each IM GOLD"
 ;now urine protein
 K BGPC
 S T=$O(^ATXAX("B","BGP URINE PROTEIN LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) D
 ....S BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC(9999999-D)=""
 ...Q
 I '$D(BGPC) Q "0^no Urine Protein tests"
 S G=1,X=0 F  S X=$O(BGPIM(X)) Q:X'=+X  I '$D(BGPC(X)) S G=0
 I 'G Q G_U_"no Urine Protein for each IM GOLD"
 Q 1_U_"CBC and Urine protein w/each IM Gold"
CBC4(P,BDATE,EDATE) ;EP
 K BGPC,BGPLAB
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CBC LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CBC TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>3:1,1:"")
CBC6(P,BDATE,EDATE) ;EP
 K BGPC,BGPLAB
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CBC LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CBC TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>5:1,1:"")
SERUM6(P,BDATE,EDATE) ;EP
 K BGPC,BGPLAB
 S BGPC=0
 S T=$O(^ATXAX("B","BGP CREATININE CPTS",0))
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPT^BGP6DU(P,BDATE,EDATE,T,3)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,1))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CREATININE LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>5:1,1:"")
LFT6(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(84460),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(84450),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(80076),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,2))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP ALT LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT ALT TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now get all AST
 S T=$O(^ATXAX("B","BGP AST LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT AST TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP LIVER FUNCTION LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP LIVER FUNCTION TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>5:1,1:"")
CBC(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"85025"
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"85027"
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CBC LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CBC TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 Q BGPC
POT(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(84132),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"84132"
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP POTASSIUM LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP POTASSIUM TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 Q BGPC
LFT(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S %="",E=+$$CODEN^ICPTCOD(84460),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"84460"
 S %="",E=+$$CODEN^ICPTCOD(84450),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"84450"
 S %="",E=+$$CODEN^ICPTCOD(80076),%=$$CPTI^BGP6DU(P,BDATE,EDATE,E)
 I %]"" S BGPC=1_U_$P(%,U,2)_U_"80076"
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP ALT LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT ALT TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 I BGPC Q BGPC
 ;now get all AST
 S T=$O(^ATXAX("B","BGP AST LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT AST TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 I BGPC Q BGPC
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP LIVER FUNCTION LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP LIVER FUNCTION TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 Q BGPC
SERUM12(P,BDATE,EDATE) ;EP
 K BGPC,BGPLAB
 S BGPC=0
 S T=$O(^ATXAX("B","BGP CREATININE CPTS",0))
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPT^BGP6DU(P,BDATE,EDATE,T,3)
 I %]"" S BGPC=BGPC+1,BGPC($P(%,U,1))=""
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CREATININE LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>11:1,1:"")
UP4(P,BDATE,EDATE) ;EP
 K BGPC,BGPLAB
 S BGPC=0
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","DM AUDIT URINE PROTEIN TAX",0))
 S BGPLT=$O(^ATXLAB("B","BGP URINE PROTEIN LOINC CODES",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC(9999999-D)="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP6D21(J,T)
 ...S BGPC=BGPC+1,BGPC(9999999-D)=""
 ...Q
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPC(X) Q
 .S Y=X
 S C=0,X=0 F  S X=$O(BGPC(X)) Q:X'=+X  S C=C+1
 Q $S(C>3:1,1:"")
