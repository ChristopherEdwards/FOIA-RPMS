BHSDM2 ;IHS/CIA/MGH - Health Summary for Diabetic Supplement ;22-Dec-2010 10:21;DU
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2,4**;March 17, 2006;Build 13
 ;===================================================================
 ;Taken from APCHS9B2
 ;VA version of IHS components for supplemental summaries
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;  [ 05/04/04  10:31 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,7,8,9,10,11,12**;JUN 24, 1997
 ;IHS/CMI/LAB patch 3 - patch 3 fixes various problems
 ;IHS/CIA/MGH Updated to IHS patch 14
 ;=====================================================================
 ;
 ;1/13/98 IHS/CMI/LAB patch 3 - added Q APCHX to TD+3 and FLU+3
MORE ;EP
 S BHSBEG=$$FMADD^XLFDT(DT,-365)
 ;S X="SMBG: "_$$SELF^BHSDM3(BHSDFN,BHSBEG) D S(X,1)
 S X="DM Education Provided (in past yr): " D S(X,1)
 S X="   Last Dietitian Visit:   "_$$DIETV^BHSDM3(BHSDFN) D S(X)
 K BHSX D EDUC I $D(BHSX) D
 .S %=0 F  S %=$O(BHSX(%)) Q:%'=+%  S X="   "_BHSX(%) D S(X)
 K BHSX,BHSY,%
 D EDUCREF^BHSDM3 I $D(BHSX) S X="In the past year, the patient has refused the following Diabetes education:" D S(X,1) D
 .S %="" F  S %=$O(BHSX(%)) Q:%=""  S X="   "_%_"   "_BHSX(%) D S(X)
 K BHSX,BHSY,%
 S X="Immunizations:" D S(X,1)
 S X="Flu vaccine since August 1st:",$E(X,32)=$$FLU^BHSDM3(BHSDFN) D S(X)
 S X="Pneumovax ever:",$E(X,32)=$$PNEU^BHSDM5(BHSDFN) D S(X)
 S X="Td in past 10 yrs:",$E(X,32)=$$TD^BHSDM3(BHSDFN,(DT-100000)) D S(X)
 S Y=$$PPDS^BDMS9B5(BHSDFN) I Y]"" S X="PPD Status:  "_Y D S(X,1) S Y=$$CHEST^BHSDM6(BHSDFN),X="Last CHEST X-RAY:  "_Y D S(X)
 I Y="" S X="Last Documented TB Test: ",$E(X,27)=$$PPD^BDMS9B5(BHSDFN) D S(X)
 ;Chest X-ray added patch 1
 S X="Last TB Status Health Factor: "_$$TB(BHSDFN) S $E(X,50)="Last CHEST X-RAY: "_$$CHEST^BHSDM6(BHSDFN) D S(X)
 ;Modified patch 1
 S BHSEKG=$$EKG^BDMS9B7(BHSDFN),X="EKG: ",$E(X,32)=$P(BHSEKG,U,1) S:$P(BHSEKG,U,2)]"" $E(X,54)=$P(BHSEKG,U,2) D S(X)
 ;S X="EKG:",$E(X,32)=$$EKG^BHSDM7(BHSDFN) D S(X)
L ;
 S X="Laboratory Results (most recent):" D S(X,1)
 S X="HbA1c:" S Y=$$HBA1C(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 ;S X="Next most recent HbA1c:" S Y=$$NLHGB(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 ;S X="Nephropathy Assessment" D S(X)
 S X="  Creatinine:" S Y=$$CREAT(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Estimated GFR:" S Y=$$GFR(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Total Cholesterol:" S Y=$$TCHOL(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  LDL Cholesterol:" S Y=$$CHOL(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S V=$P(Y,"|||") I V'=+V D
 .;get last 3 and display next most recent 2
 .S BHSIEN=$P(Y,"|||",4)
 .S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0)) D LDLLAB
 .I $D(BHSX) S X="  Next most recent LDL values:" D S(X)
 .S BHSY=0 F  S BHSY=$O(BHSX(BHSY)) Q:BHSY'=+BHSY  S X="",$E(X,27)=$P(BHSX(BHSY),U),$E(X,42)=$$FMTE^XLFDT($P(BHSX(BHSY),U,2)) D S(X)
 S X="  HDL Cholesterol:" S Y=$$HDL(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="  Triglycerides:" S Y=$$TRIG(BHSDFN),$E(X,27)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Urine protein Assessment:" D S(X)
 S Z=0
 S Y=$$ACRATIO(BHSDFN) I Y]"" S X=" A/C Ratio:",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1 Q
 S Y=$$PCR^BDMS9B2(BHSDFN) I Y]"" S X=" P/C Ratio:",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1 Q
 S Y=$$HR24^BDMS9B2(BHSDFN) I Y]"" S X=" 24 Hr Urine Protein",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1 Q
 S Y=$$MICRO^BDMS9B2(BHSDFN) I Y]"" S X=" A/C Ratio (semi-quant)",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1
 S Y=$$MICRO^BDMS9B2(BHSDFN) I Y]"" S X=" Microalbumin only",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1 Q
 S Y=$$URIN^BDMS9B2(BHSDFN) I Y]"" S X=" Dipstick Protein",$E(X,27)=$P(Y,"|||"),$E(X,38)=$P(Y,"|||",2),$E(X,51)=$P(Y,"|||",3) D S(X) S Z=1 Q
 I 'Z D S("       No Urine Protein Assessment Lab Values on File")
 D S(" ")
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X,L
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("BHS",$J,"DCS",0),U)+1,$P(^TMP("BHS",$J,"DCS",0),U)=%
 S ^TMP("BHS",$J,"DCS",%)=X
 Q
EDUC ;EP - gather up all education provided in past year in BHSX
 K BHSX,BHSY S %=BHSDFN_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BHSBEG)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(%,"BHSY(") ;IHS/CMI/LAB patch 3 1/13/98 added $$FMTE^XLFDT to _DT replaced " - " with "-"
 I '$D(BHSY) S BHSX(1)="   <No Education Topics recorded in past year>" K BHSY Q
 NEW X,BHSP K BHSP S X=0,E="" F  S X=$O(BHSY(X)) Q:X'=+X  S E=+$P(BHSY(X),U,4) I $P(^AUPNVPED(E,0),U,6)'=5 S E=$P(^AUPNVPED(E,0),U) I $$EDT(E) S BHSP($P(BHSY(X),U,2))=$$FMTE^XLFDT($P(BHSY(X),U))
 S %=0,E="" F  S E=$O(BHSP(E)) Q:E=""  S %=%+1,BHSX(%)=$E(E,1,24),$E(BHSX(%),27)=BHSP(E)
 K BHSY,BHSP
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
 I $P(T,"-")["250" Q 1
 Q ""
TB(P) ;
 I '$G(P) Q ""
 NEW BHS,E,X
 K BHS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BHS(")
 I $D(BHS(1)) Q $P($G(BHS(1)),U,3)
 NEW %,Y
 S %=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I '% Q ""
 S (X,Y)=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 I 'Y Q ""
 Q $P(^AUTTHF(Y,0),U)
GFR(P) ;
 I '$G(P) Q ""
 N APCHC S APCHC=""
 NEW T,T1,T2
 S T=$O(^LAB(60,"B","ESTIMATED GFR",0))
 S T1=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0))
 S T2=$O(^ATXAX("B","DM AUDIT ESTIMATED GFR LOINC",0))
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
 NEW D,V,G,X,J,R S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=Y Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G S R=$$REF(P,T) Q $S(R:"||||||"_R,1:"")
 Q $P(^AUPNVLAB(G,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_$$VAL^XBDIQ1(9000010.09,G,.01)_" "_$$REF(P,T,$P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_G
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
LDLLAB ;EP
 K BHSX
 NEW LT S LT=$O(^ATXAX("B","BGP LDL LOINC CODES",0))
 NEW D,V,X,G S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",BHSPAT,D)) Q:D'=+D!(G>2)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",BHSPAT,D,X)) Q:X'=+X!(G>2)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",BHSPAT,D,X,Y)) Q:Y'=+Y!(G>2)  D
 ...Q:'$D(^AUPNVLAB(Y,0))     ;Patch 1
 ...I $P(^AUPNVLAB(Y,0),U,4)="" Q
 ...I Y=BHSIEN Q
 ...I $D(^ATXLAB(T,21,"B",X)) D   Q
 ....S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ....S BHSX(Y)=R_"^"_(9999999-D),G=G+1
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ...S BHSX(Y)=R_"^"_(9999999-D),G=G+1
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
 I %="R"!(%="") Q "Refused"
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
 NEW T S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)),LT=$O(^ATXAX("B","BGP URINE PROTEIN LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
MICRO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0)),LT=$O(^ATXAX("B","BGP MICROALBUM LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
ACRATIO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0)),LT=$O(^ATXAX("B","DM AUDIT A/C RATIO LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
