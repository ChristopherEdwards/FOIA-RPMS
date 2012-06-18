BGP7DHE2 ; IHS/CMI/LAB - measure HEDIS ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
POSUR(P,BDATE,EDATE) ;EP
 K BGPC,BGPX,BGP1
 S BGPC=""
 S %="",E=+$$CODEN^ICPTCOD(82043),%=$$CPTI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82044),%=$$CPTI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(83518),%=$$CPTI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(84166),%=$$CPTI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGP1(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(81050),%=$$CPTI^BGP7DU(P,BDATE,EDATE,E)
 I %]"",$G(BGP1) S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)_" and 84166"
 ;TRAN
 S %="",E=+$$CODEN^ICPTCOD(82043),%=$$TRANI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82044),%=$$TRANI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(83518),%=$$TRANI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(84166),%=$$TRANI^BGP7DU(P,BDATE,EDATE,E)
 I %]"" S BGP1(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(81050),%=$$TRANI^BGP7DU(P,BDATE,EDATE,E)
 I %]"",$G(BGP1) S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)_" and 84166"
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP MICROALBUM LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S (BGPC,BGPX(D))="1^MICROALB^^"_(9999999-D) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S (BGPC,BGPX(D))="1^MICROALB^^"_(9999999-D) Q
 ...Q
 I $D(BGPX) S X=$O(BGPX(0)) Q BGPX(X)  ;quit on the latest one found, if one found
 ;
 S T=$O(^ATXAX("B","DM AUDIT A/C RATIO LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S (BGPC,BGPX(D))="1^A/C RATIO^^"_(9999999-D) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S (BGPC,BGPX(D))="1^A/C RATIO^^"_(9999999-D) Q
 ...Q
 I $D(BGPX) S X=$O(BGPX(0)) Q BGPX(X)  ;quit on the latest one found, if one found
 ;
 K BGPG S %=P_"^LAST LAB [DM AUDIT URINE PROTEIN TAX;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 S (%,R)="" I $D(BGPG(1)) D  Q R_"^"_"U"_"^"_%_"^"_$P(BGPG(1),U)
 .S %=$P(^AUPNVLAB(+$P(BGPG(1),U,4),0),U,4)
 .S R=$S(%="":"",%["+":1,%[">":1,$E(%)="P":1,$E(%)="p":1,$E(%)="L":1,$E(%)="l":1,$E(%)="M":1,$E(%)="m":1,$E(%)="S":1,$E(%)="s":1,$E(%)="c":"",$E(%)="C":"",+%>29:1,1:"")
 S T=$O(^ATXAX("B","BGP URINE PROTEIN LOINC CODES",0))
 S BGPC="",B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S %=$P(^AUPNVLAB(X,0),U,4)
 ...;S R=$S(%="":"",%["+":1,%[">":1,$E(%)="P":1,$E(%)="p":1,$E(%)="c":"",$E(%)="C":"",+%>29:1,1:"")
 ...S R=$S(%="":"",%["+":1,%[">":1,$E(%)="P":1,$E(%)="p":1,$E(%)="L":1,$E(%)="l":1,$E(%)="M":1,$E(%)="m":1,$E(%)="S":1,$E(%)="s":1,$E(%)="c":"",$E(%)="C":"",+%>29:1,1:"")
 ...S BGPC=R_"^U^"_%_"^"_(9999999-D)
 Q BGPC
 ;;;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
