BGP1DHE2 ; IHS/CMI/LAB - measure HEDIS ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
MEDNEPH(P,BDATE,EDATE) ;EP
 K BGPC,BGPX,BGP1
 S BGPC=""
 S %="",E=+$$CODEN^ICPTCOD(82043),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82044),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82042),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(84156),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3060F"),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3061F"),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3062F"),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^URINE PROTEIN-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("4009F"),%=$$CPTI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^ACEI MED-CPT^^"_$P(%,U,2)
 ;TRAN
 S %="",E=+$$CODEN^ICPTCOD(82043),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82044),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82042),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(84156),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3060F"),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3061F"),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^MICROALB-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("3062F"),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^URINE PROTEIN-TRAN^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD("4009F"),%=$$TRANI^BGP1DU(P,BDATE,EDATE,E)
 I %]"" S BGPX(9999999-$P(%,U,2))="1^ACEI MED-TRAN^^"_$P(%,U,2)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP HEDIS NEPHROPTHY SCR LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S (BGPC,BGPX(D))="1^MICROALB^^"_(9999999-D) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S (BGPC,BGPX(D))="1^MICROALB^^"_(9999999-D) Q
 ...Q
 I $D(BGPX) S X=$O(BGPX(0)) Q BGPX(X)  ;quit on the latest one found, if one found
 ;
 S T=$O(^ATXAX("B","BGP HEDIS NEPHROPTHY SCR LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:$P(^AUPNVLAB(X,0),U,4)=""  ;MUST HAVE A RESULT
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
 I BGPC]"" Q BGPC
 ;NEPHEVID
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP NEPHROPATHY DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_$P(BGPG(1),U,2)_"^^"_$P(BGPG(1),U,1)  ;has a dx
 K BGPG
 S T=$O(^ATXAX("B","BGP NEPHROPATHY PROCEDURES",0))
 S (F,S)=0 F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S C=$P(^AUPNVPRC(F,0),U) D
 .S G=0 S:$$ICD^ATXCHK(C,T,0) G=1
 .Q:G=0
 .S D=$P(^AUPNVPRC(F,0),U,6) I D="" S D=$P($P(^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),U),".")
 .I D>EDATE Q
 .I D<BDATE Q
 .S S=1
 I S=1 Q 1_U_$P($$ICDOP^ICDCODE(C),U,2)_"^^"_D ;has a PROCEDURE
 S T=$O(^ATXAX("B","BGP NEPHROPATHY CPTS",0))
 S X=$$CPT^BGP1DU(P,BDATE,EDATE,T,5)
 I X]"" Q 1_U_$P(X,U,2)_"^^"_$P(X,U)
 S T=$O(^ATXAX("B","BGP NEPHROPATHY CPTS",0))
 S X=$$TRAN^BGP1DU(P,BDATE,EDATE,T,5)
 I X]"" Q 1_U_$P(X,U,2)_"^^"_$P(X,U)
 ;
 K ^TMP($J,"A")
 S A="^TMP($J,""A"","
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,A)
 S X=0,Y=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C") I R=49,'$$DNKA^BGP1D21($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q 2_"^Cl: "_R_"^^"_D
 S (X,Y)=0,D="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(^TMP($J,"A",X),U,5),"D") I R=69,'$$DNKA^BGP1D21($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q "2^Prv: "_R_"^^"_D
 ;
 ;ACE INHIBITOR
 NEW T,T1,T2,T3
 D GETMEDS^BGP1UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S T1=$O(^ATXAX("B","BGP HEDIS ACEI NDC",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS ARB NDC",0))
 S X=0,G="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(G)  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .Q:'$P(^AUPNVMED(Y,0),U,7)  ;NO DAYS SUPPLY
 .I $P(^AUPNVMED(Y,0),U,8)]"",$P(^AUPNVMED(Y,0),U,8)=$P(BGPMEDS1(X),U) Q
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1_U_$P(BGPMEDS1(X),U)_U_"acei/arb prescription" Q
 .I T2,$D(^ATXAX(T2,21,"B",D)) S G=1_U_$P(BGPMEDS1(X),U)_U_"acei/arb prescription" Q
 .S N=$P($G(^PSDRUG(D,2)),U,4)
 .I N]"",T1,$D(^ATXAX(T1,21,"B",N)) S G=1_U_$P(BGPMEDS1(X),U)_U_"acei/arb prescription" Q
 .I N]"",T3,$D(^ATXAX(T3,21,"B",N)) S G=1_U_$P(BGPMEDS1(X),U)_U_"acei/arb prescription" Q
 I G Q 1_U_$P(G,U,3)_"^^"_$P(G,U,2)
 Q ""
 ;;;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
