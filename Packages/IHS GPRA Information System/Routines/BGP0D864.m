BGP0D864 ; IHS/CMI/LAB - measure C ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
NDC(A,B) ;
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
GOLDLAB(P,BDATE,EDATE) ;EP
 K BGPIM,BGPLAB
 K BGPMEDS1
 D GETMEDS^BGP0UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T1=$O(^ATXAX("B","BGP RA IM GOLD MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA IM GOLD NDC",0))
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S BGPIM($P($P(^AUPNVSIT(V,0),U),"."))=""
 I '$D(BGPIM) Q ""  ;no gold im
 ;CBC'S
 K BGPC
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$CPTI^BGP0DU(P,BDATE,EDATE,E)
 I %]"" S BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$CPTI^BGP0DU(P,BDATE,EDATE,E)
 I %]"" S BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85025),%=$$TRANI^BGP0DU(P,BDATE,EDATE,E)
 I %]"" S BGPC($P(%,U,2))=""
 S %="",E=+$$CODEN^ICPTCOD(85027),%=$$TRANI^BGP0DU(P,BDATE,EDATE,E)
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
 ...Q:'$$LOINC^BGP0D21(J,T)
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
 ...Q:'$$LOINC^BGP0D21(J,T)
 ...S BGPC(9999999-D)=""
 ...Q
 I '$D(BGPC) Q "0^no Urine Protein tests"
 S G=1,X=0 F  S X=$O(BGPIM(X)) Q:X'=+X  I '$D(BGPC(X)) S G=0
 I 'G Q G_U_"no Urine Protein for each IM GOLD"
 Q 1_U_"CBC and Urine protein w/each IM Gold"
