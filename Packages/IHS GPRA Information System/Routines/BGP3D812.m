BGP3D812 ; IHS/CMI/LAB - measure C 03 Jul 2010 7:05 AM ; 21 Mar 2013  5:25 PM
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;
HIVTEST1(P,BDATE,EDATE) ;EP
 NEW BGPC,BGPT,T,X,BGPLT,E,D,B,L,J,G,BGPT1,BGPA
 NEW BD,ED,Y,D,V
 K BGPA
 S BGPC=0
 ;FIRST TABLE ALL TESTS IN HIV-1 AND HIV-2
 S T=$O(^ATXAX("B","BGP HIV-1 TEST LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","BGP HIV-1 TEST TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...;Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...S V=$P(^AUPNVLAB(X,0),U,3)
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) D  Q
 ....S BGPC=BGPC+1,BGPC(BGPC)=1_U_$$DATE^BGP3UTL((9999999-D))_" Lab"_U_$P(^AUPNVLAB(X,0),U,4)_U_D,BGPA((9999999-D))="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP3D21(J,T)
 ...S BGPC=BGPC+1,BGPC(BGPC)=1_U_$$DATE^BGP3UTL((9999999-D))_"  Lab "_$P($G(^LAB(95.3,J,0)),U)_"-"_$P($G(^LAB(95.3,J,0)),U,15)_U_$P(^AUPNVLAB(X,0),U,4)_U_D,BGPA((9999999-D))=""
 ...Q
 ..Q
 S T=$O(^ATXAX("B","BGP HIV-2 TEST LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","BGP HIV-2 TEST TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...;Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...S V=$P(^AUPNVLAB(X,0),U,3)
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) D  Q
 ....S BGPC=BGPC+1,BGPC(BGPC)=1_U_$$DATE^BGP3UTL((9999999-D))_" Lab"_U_$P(^AUPNVLAB(X,0),U,4)_U_D,BGPA((9999999-D))="" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP3D21(J,T)
 ...S BGPC=BGPC+1,BGPC(BGPC)=1_U_$$DATE^BGP3UTL((9999999-D))_"  Lab "_$P($G(^LAB(95.3,J,0)),U)_"-"_$P($G(^LAB(95.3,J,0)),U,15)_U_$P(^AUPNVLAB(X,0),U,4)_U_D,BGPA((9999999-D))=""
 ...Q
 ..Q
 I BGPC=0 D  ;check for cpt code
 .S T=$O(^ATXAX("B","BGP CPT HIV TESTS",0))
 .I T D
 ..;
 ..S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 ..F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 ...S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ....Q:'$D(^AUPNVSIT(V,0))
 ....Q:'$D(^AUPNVCPT("AD",V))
 ....S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 .....I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) I '$D(BGPA((9999999-$P(ED,".")))) S BGPC=BGPC+1,BGPC(BGPC)=1_U_$$DATE^BGP3UTL((9999999-$P(ED,".")))_" CPT "_$$VAL^XBDIQ1(9000010.18,X,.01)_U_U_$$VD^APCLV(V),BGPA((9999999-$P(ED,".")))=""
 I BGPC=0 Q ""  ;not tests done
 NEW POS,NEG,NR
 S POS="",NEG="",NR="",%=""
 S BGPC=0 F  S BGPC=$O(BGPC(BGPC)) Q:BGPC'=+BGPC!(%]"")  D
 .S X=$P(BGPC(BGPC),U,3)  ;result
 .S D=$P(BGPC(BGPC),U,4)  ;date
 .S X=$$UP^XLFSTR(X)
 .I X="",D S G=$$HIVDX1^BGP3D8(DFN,BGPED,D) I G S %=1_U_"Positive HIV DX "_$P(G,U,2)_" on "_$$DATE^BGP3UTL($P(G,U)) Q
 .I X="P"!(X="POSITIVE")!(X="POS")!(X="R")!(X="REACTIVE")!(X="REPEATEDLY REACTIVE")!(X="+")!(X[">") S %=1_U_"Positive Result: "_X_" on "_$$DATE^BGP3UTL(9999999-D)  ;positive result
 .;I X="N"!(X="NEGATIVE")!(X="NEG")!(X="NR")!(X="NON REACTIVE")!(X="NON-REACTIVE")!(X="-") S BGPN6=1,BGPDAFT="Negative"
 I %]"" Q %  ;has a positive result
 ;now look for negative
 S POS="",NEG="",NR="",%=""
 S BGPC=0 F  S BGPC=$O(BGPC(BGPC)) Q:BGPC'=+BGPC!(%]"")  D
 .S X=$P(BGPC(BGPC),U,3)  ;result
 .S D=$P(BGPC(BGPC),U,4)  ;date
 .S X=$$UP^XLFSTR(X)
 .I X="N"!(X="NEGATIVE")!(X="NEG")!(X="NR")!(X="NON REACTIVE")!(X="NON-REACTIVE")!(X="-") S %=2_U_"Negative Result: "_X_" on "_$$DATE^BGP3UTL(9999999-D)
 .;if neg result check for diagnosis after it
 .I $E(%)=2 S G=$$HIVDX1^BGP3D8(DFN,BGPED,D) I G S %=1_U_"Positive HIV DX "_$P(G,U,2)_" on "_$$DATE^BGP3UTL($P(G,U)) Q
 I %]"" Q %
 ;find last no result
 S POS="",NEG="",NR="",%=""
 S BGPC=0 F  S BGPC=$O(BGPC(BGPC)) Q:BGPC'=+BGPC!(%]"")  D
 .S X=$P(BGPC(BGPC),U,3)  ;result
 .S D=$P(BGPC(BGPC),U,4)  ;date
 .S %=3_U_"No Result: "_X_" on "_$$DATE^BGP3UTL(9999999-D)
 Q %
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
