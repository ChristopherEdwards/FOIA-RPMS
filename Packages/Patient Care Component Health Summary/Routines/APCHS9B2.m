APCHS9B2 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;IHS/CMI/LAB patch 3 - patch 3 fixes various problems
 ;
 ;
 ;1/13/98 IHS/CMI/LAB patch 3 - added Q APCHX to TD+3 and FLU+3
MORE ;EP
 S APCHSBEG=$$FMADD^XLFDT(DT,-365)
 S X="SMBG: "_$$SELF^APCHS9B3(APCHSDFN,APCHSBEG) D S(X,1)
 S X="DM Education Provided (in past yr): " D S(X)
 S X="  Last Dietitian Visit:     "_$$DIETV^APCHS9B3(APCHSDFN) D S(X)
 K APCHX D EDUC I $D(APCHX) D
 .S %=0 F  S %=$O(APCHX(%)) Q:%'=+%  S X="  "_APCHX(%) D S(X)
 K APCHX,APCHY,%
 D EDUCREF^APCHS9B3 I $D(APCHX) S X="In the past year, the patient has declined the following Diabetes education:" D S(X,1) D
 .S %="" F  S %=$O(APCHX(%)) Q:%=""  S X="  "_%_"     "_APCHX(%) D S(X)
 K APCHX,APCHY,%
 S X="Immunizations:" D S(X,1)
 S X="Flu vaccine since August 1st:",$E(X,32)=$$FLU^APCHS9B3(APCHSDFN) D S(X)
 S X="Pneumovax ever:",$E(X,32)=$$PNEU^APCHS9B5(APCHSDFN) D S(X)
 S X="Td in past 10 yrs:",$E(X,32)=$$TD^APCHS9B3(APCHSDFN,(DT-100000)) D S(X)
 S Y=$$PPDS^APCHS9B5(APCHSDFN) I Y]"" S X="PPD Status:  "_Y D S(X)
 I Y="" S X="Last Documented PPD:",$E(X,27)=$$PPD^APCHS9B5(APCHSDFN) D S(X)
 S X="Last TB Status Health Factor: "_$$TB(APCHSDFN) S $E(X,50)="Last CHEST X-RAY: "_$$CHEST^APCHS9B6(APCHSDFN) D S(X)
 S APCHEKG=$$EKG^APCHS9B7(APCHSDFN),X="EKG:",$E(X,32)=$P(APCHEKG,U,1) S:$P(APCHEKG,U,2)]"" $E(X,54)=$P(APCHEKG,U,2) D S(X)
L ;
 S X="Laboratory Results (most recent):" D S(X,1)
 S X="HbA1c:" S Y=$$HBA1C(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Next most recent HbA1c:" S Y=$$NLHGB(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Nephropathy Assessment" D S(X)
 S X="  Urine Protein:" S Y=$$URIN(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Microalbuminuria:" S Y=$$MICRO(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  A/C Ratio:" S Y=$$ACRATIO(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Creatinine:" S Y=$$CREAT(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Estimated GFR:" S Y=$$GFR(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Total Cholesterol:" S Y=$$TCHOL(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  LDL Cholesterol:" S Y=$$CHOL(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S V=$P(Y,"|||") I V'=+V D
 .;get last 3 and display next most recent 2
 .S APCHIEN=$P(Y,"|||",4)
 .S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0)) D LDLLAB
 .I $D(APCHX) S X="  Next most recent LDL values:" D S(X)
 .S APCHY=0 F  S APCHY=$O(APCHX(APCHY)) Q:APCHY'=+APCHY  S X="",$E(X,27)=$P(APCHX(APCHY),U),$E(X,42)=$$FMTE^XLFDT($P(APCHX(APCHY),U,2)) D S(X)
 S X="  HDL Cholesterol:" S Y=$$HDL(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Triglycerides:" S Y=$$TRIG(APCHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
 Q
EDUC ;EP - gather up all education provided in past year in APCHX
 K APCHX,APCHY S %=APCHSDFN_"^ALL EDUC;DURING "_$$FMTE^XLFDT(APCHSBEG)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(%,"APCHY(") ;IHS/CMI/LAB patch 3 1/13/98 added $$FMTE^XLFDT to _DT replaced " - " with "-"
 I '$D(APCHY) S APCHX(1)="   <No Education Topics recorded in past year>" K APCHY Q
 NEW X,APCHP K APCHP S X=0,E="" F  S X=$O(APCHY(X)) Q:X'=+X  S E=+$P(APCHY(X),U,4) I $P(^AUPNVPED(E,0),U,6)'=5 S E=$P(^AUPNVPED(E,0),U) I $$EDT(E) S APCHP($P(APCHY(X),U,2))=$$FMTE^XLFDT($P(APCHY(X),U))
 S %=0,E="" F  S E=$O(APCHP(E)) Q:E=""  S %=%+1,APCHX(%)=$E(E,1,24),$E(APCHX(%),27)=APCHP(E)
 K APCHY,APCHP
 Q
EDT(E) ;
 ;is this ien in any taxonomy
 NEW T
 S T=$O(^ATXAX("B","DM AUDIT DIABETES EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$P(^AUTTEDT(E,0),U,2)
 I $P(T,"-")="DM" Q 1
 I $P(T,"-")="DMC" Q 1
 Q ""
TB(P) ;
 I '$G(P) Q ""
 NEW APCHS,E,X
 K APCHS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"APCHS(")
 I $D(APCHS(1)) Q $P($G(APCHS(1)),U,3)
 NEW %,Y
 S %=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I '% Q ""
 S (X,Y)=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 I 'Y Q ""
 Q $P(^AUTTHF(Y,0),U)
GFR(P) ;
 I '$G(P) Q ""
 S APCHC=""
 NEW T,T1,T2
 S T=$O(^LAB(60,"B","ESTIMATED GFR",0))
 S T1=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0))
 S T2=$O(^ATXAX("B","BGP ESTIMATED GFR LOINC",0))
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(APCHC]"")  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(APCHC]"")  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y  D
 ...Q:'$D(^AUPNVLAB(Y,0))
 ...I T,$P(^AUPNVLAB(Y,0),U)=T D
 ....I APCHC]"",$P(^AUPNVLAB(Y,0),U,4)="" Q
 ....S APCHC=$P(^AUPNVLAB(Y,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),"."))_"|||"_""_"|||"_Y Q
 ...I T1,$P(^AUPNVLAB(Y,0),U),$D(^ATXLAB(T1,21,"B",$P(^AUPNVLAB(Y,0),U))) D
 ....I APCHC]"",$P(^AUPNVLAB(Y,0),U,4)="" Q
 ....S APCHC=$P(^AUPNVLAB(Y,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),"."))_"|||"_""_"|||"_Y Q
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T2)
 ...S APCHC=$P(^AUPNVLAB(Y,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),"."))_"|||"_""_"|||"_Y
 ...Q
 I APCHC]"" Q APCHC
 S T=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0)) I 'T Q ""
 Q $$LAB(P,T)
CHOL(P) ;EP
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0)),LT=$O(^ATXAX("B","BGP LDL LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
HDL(P) ;EP
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT HDL TAX",0)),LT=$O(^ATXAX("B","BGP HDL LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
TCHOL(P) ;EP
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT CHOLESTEROL TAX",0)),LT=$O(^ATXAX("B","BGP TOTAL CHOLESTEROL LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
TRIG(P) ;EP
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT TRIGLYCERIDE TAX",0)),LT=$O(^ATXAX("B","BGP TRIGLYCERIDE LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
CREAT(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0)),LT=$O(^ATXAX("B","BGP CREATININE LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
 ;
LAB(P,T,LT) ;EP
 I '$G(LT) S LT=""
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=Y Q
 ...;IHS/CMI/LAB - don't check loinc code for now
 ...;IHS/CMI/LAB - yes, check loinc in patch 14
 ...;Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G S R=$$REF(P,T) Q "||||||"_R
 Q $P(^AUPNVLAB(G,0),U,4)_"|||"_$$FMTE^XLFDT($P($P($G(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0)),U),"."))_"|||"_$$VAL^XBDIQ1(9000010.09,G,.01)_"  "_$$REF(P,T,$P($P($G(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0)),U),"."))_"|||"_G
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
LDLLAB ;EP
 K APCHX
 NEW LT S LT=$O(^ATXAX("B","BGP LDL LOINC CODES",0))
 NEW D,V,X,G S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",APCHSPAT,D)) Q:D'=+D!(G>2)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",APCHSPAT,D,X)) Q:X'=+X!(G>2)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",APCHSPAT,D,X,Y)) Q:Y'=+Y!(G>2)  D
 ...Q:'$D(^AUPNVLAB(Y,0))
 ...I $P(^AUPNVLAB(Y,0),U,4)="" Q
 ...I Y=APCHIEN Q
 ...I $D(^ATXLAB(T,21,"B",X)) D   Q
 ....S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ....S APCHX(Y)=R_"^"_(9999999-D),G=G+1
 ...;Q  ;IHS/CMI/LAB - don't check loinc codes for now
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ...S APCHX(Y)=R_"^"_(9999999-D),G=G+1
 ...Q
 ..Q
 .Q
 Q
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
REF(P,T,D) ;return refusal string after date D for test is tax T
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(D) S D=""
 N APCHREF,APCHT,V S APCHT=0 F  S APCHT=$O(^ATXLAB(T,21,"B",APCHT)) Q:APCHT'=+APCHT  D
 .S V=$$REF1(P,60,APCHT,D) I V]"" S APCHREF(9999999-$P(V,U,3))=V
 I $D(APCHREF) S %=0,%=$O(APCHREF(%)) I % S V=APCHREF(%) Q V
 Q ""
REF1(P,F,I,D,T) ; ;
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 I $G(T)="" S T="E"
 NEW X,N S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_"-"_$$DATE(Y))
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_"-"_$$DATE(Y)
 ;
TYPEREF(N) ;
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Declined"
 I %="N" Q "Not Med Ind"
 I %="F" Q "No Resp to F/U"
 Q ""
NLHGB(P) ;return next to last HGBA1C
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0)) I 'T Q "<Taxonomy Missing>"
 NEW LT S LT=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0))
 NEW D,V,G,X,E S (D,G)=0,E="" F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G=2)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G=2)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G=2)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=G+1,E=Y Q
 ...;Q  ;IHS/CMI/LAB - DON'T CHECK LOINC CODES FOR NOW
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=G+1,E=Y
 ...Q
 ..Q
 .Q
 I G'=2 Q ""
 I 'E Q ""
 Q $P(^AUPNVLAB(E,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(E,0),U,3),0),U),"."))
HBA1C(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0)),LT=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
URIN(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)),LT=$O(^ATXAX("B","DM AUDIT URINE PROTEIN LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
MICRO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0)),LT=$O(^ATXAX("B","DM AUDIT MICROALBUMIN LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
ACRATIO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0)),LT=$O(^ATXAX("B","DM AUDIT A/C RATIO LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
