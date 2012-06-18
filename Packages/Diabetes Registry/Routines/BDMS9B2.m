BDMS9B2 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
 ;
MORE ;EP
 S X="Immunizations:" D S(X,1)
 S X="Seasonal Flu vaccine since August 1st: "_$$FLU^BDMS9B3(BDMSDFN) D S(X)
 S X="Pneumovax ever:",$E(X,32)=$$PNEU^BDMS9B4(BDMSDFN) D S(X)
 S X="Td in past 10 yrs:",$E(X,32)=$$TD^BDMS9B3(BDMSDFN,(DT-100000)) D S(X)
 S Y=$$PPDS^BDMS9B4(BDMSDFN) I Y]"" S X="PPD Status:  "_Y D S(X)
 I Y="" S X="Last Documented TB Test:",$E(X,27)=$$PPD^BDMS9B4(BDMSDFN) D S(X)
 S X="Last TB Status Health Factor: "_$$TB(BDMSDFN) S $E(X,50)="Last CHEST X-RAY: "_$$CHEST^BDMS9B3(BDMSDFN) D S(X)
 S BDMEKG=$$EKG^BDMS9B3(BDMSDFN),X="EKG:",$E(X,32)=$P(BDMEKG,U,1) S:$P(BDMEKG,U,2)]"" $E(X,54)=$P(BDMEKG,U,2) D S(X)
L ;
 S X="Laboratory Results (most recent):",$E(X,55)="RPMS LAB TEST NAME" D S(X,1)
 S X=" HbA1c:" S Y=$$HBA1C(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 I $P(Y,"|||",4)]"" S X="   Note: "_$P(Y,"|||",4) D S(X)
 S X=" Next most recent HbA1c:" S Y=$$NLHGB(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 ;S X="Nephropathy Assessment" D S(X)
 S X=" Creatinine:" S Y=$$CREAT(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 I $P(Y,"|||",4)]"" S X="   Note: "_$P(Y,"|||",4) D S(X)
 S X=" Estimated GFR:" S Y=$$GFR(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" Total Cholesterol:" S Y=$$TCHOL(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X="  LDL Cholesterol:" S Y=$$CHOL(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X="  HDL Cholesterol:" S Y=$$HDL(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X="  Triglycerides:" S Y=$$TRIG(BDMSDFN),$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X="Urine Protein Assessment:" D S(X)
 S Z=0
 S Y=$$ACRATIO(BDMSDFN)
 I Y="" S X=" UACR (Quant A/C Ratio):",$E(X,25)="<None Found>" D S(X)
 I Y]"" S X=" UACR (Quant A/C Ratio):",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) I $P(Y,"|||",2)>$$FMADD^XLFDT(DT,-365) G EDUCD
 ;if no a/c ratio in the past year display next best in past year
 S X=" Alternate Urine Protein Test in past year:" D S(X)
 S Y=$$PCR(BDMSDFN) I Y]"" S X=" UPCR (P/C Ratio:",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) S Z=1 G EDUCD
 S Y=$$HR24(BDMSDFN) I Y]"" S X=" Urine Protein/24 Hr",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) S Z=1 G EDUCD
 S Y=$$SEMI(BDMSDFN) I Y]"" S X=" UACR (Semi-Quant A/C)",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) S Z=1 G EDUCD
 S Y=$$MICRO(BDMSDFN) I Y]"" S X=" Microalbumin only",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) S Z=1 G EDUCD
 S Y=$$URIN(BDMSDFN) I Y]"" S X=" Dipstick Protein",$E(X,25)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X) S Z=1 G EDUCD
 I 'Z D S("       No Urine Protein Assessment Lab Values on File in the past year")
EDUCD D S(" ")
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S X="DM Education Provided (in past yr): " D S(X)
 S X="  Last Dietitian Visit:     "_$$DIETV^BDMS9B3(BDMSDFN) D S(X)
 S X="" K BDMX D EDUC I $D(BDMX) D
 .S C=0
 .S %=0 F  S %=$O(BDMX(%)) Q:%'=+%  D
 ..S C=C+1
 ..I (C#2) S X="" S X="  "_BDMX(%) Q
 ..S $E(X,42)=BDMX(%) D S(X) S X=""
 I X]"" D S(X)
 K BDMX,BDMY,%
 D EDUCREF I $D(BDMX) S X="In the past year, the patient has refused the following Diabetes education:" D S(X) D
 .S %="" F  S %=$O(BDMX(%)) Q:%=""  S X="  "_%_"     "_BDMX(%) D S(X)
 K BDMR,BDMY,%
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
EDUC ;EP - gather up all education provided in past year in BDMX
 K BDMX,BDMY,BDMP S %=BDMSDFN_"^ALL EDUC;DURING "_$$DATE^BDMS9B1(BDMSBEG)_"-"_$$DATE^BDMS9B1(DT) S E=$$START1^APCLDF(%,"BDMY(") ;IHS/CMI/LAB patch 3 1/13/98 added $$DATE^BDMS9B1 to _DT replaced " - " with "-"
 I '$D(BDMY) S BDMX(1)="   <No Education Topics recorded in past year>" K BDMY Q
 NEW X K BDMP S X=0,E="" F  S X=$O(BDMY(X)) Q:X'=+X  S E=+$P(BDMY(X),U,4) I $P(^AUPNVPED(E,0),U,6)'=5 S E=$P(^AUPNVPED(E,0),U) I $$EDT(E) S BDMP($$UP^XLFSTR($P(BDMY(X),U,2)))=$$DATE^BDMS9B1($P(BDMY(X),U))
 S %=0,E="" F  S E=$O(BDMP(E)) Q:E=""  S %=%+1,BDMX(%)=$E(E,1,25),$E(BDMX(%),28)=BDMP(E)
 K BDMY
 Q
EDUCREF ;EP - gather up all education provided in past year in BDMR
 K BDMX,BDMY
 S BDMY=0 F  S BDMY=$O(^AUPNPREF("AA",BDMSPAT,9999999.09,BDMY)) Q:BDMY'=+BDMY  I $$EDT(BDMY) S BDMD=$O(^AUPNPREF("AA",BDMSPAT,9999999.09,BDMY,0)) I BDMD<(9999999-BDMSBEG) D
 .Q:$D(BDMP($$UP^XLFSTR($P(^AUTTEDT(BDMY,0),U))))  ;already displayed
 .S BDMX($P(^AUTTEDT(BDMY,0),U))=$$DATE^BDMS9B1(9999999-BDMD)
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
 NEW BDMS,E,X
 K BDMS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q $P($G(BDMS(1)),U,3)
 NEW %,Y
 S %=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I '% Q ""
 S (X,Y)=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 I 'Y Q ""
 Q $P(^AUTTHF(Y,0),U)
GFR(P) ;
 I '$G(P) Q ""
 S BDMC=""
 NEW T,T1,T2
 S T=$O(^LAB(60,"B","ESTIMATED GFR",0))
 S T1=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0))
 S T2=$O(^ATXAX("B","BGP ESTIMATED GFR LOINC",0))
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(BDMC]"")  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(BDMC]"")  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y  D
 ...Q:'$D(^AUPNVLAB(Y,0))
 ...I T,$P(^AUPNVLAB(Y,0),U)=T D
 ....I BDMC]"",$P(^AUPNVLAB(Y,0),U,4)="" Q
 ....S BDMC=$$LBLK($P(^AUPNVLAB(Y,0),U,4),6)_" "_$P($G(^AUPNVLAB(Y,11)),U)_"|||"_$P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),".")_"|||"_$E($$VAL^XBDIQ1(9000010.09,Y,.01),1,25)_"|||"_Y Q
 ...I T1,$P(^AUPNVLAB(Y,0),U),$D(^ATXLAB(T1,21,"B",$P(^AUPNVLAB(Y,0),U))) D
 ....I BDMC]"",$P(^AUPNVLAB(Y,0),U,4)="" Q
 ....S BDMC=$$LBLK($P(^AUPNVLAB(Y,0),U,4),6)_" "_$P($G(^AUPNVLAB(Y,11)),U)_"|||"_$P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),".")_"|||"_$E($$VAL^XBDIQ1(9000010.09,Y,.01),1,25)_"|||"_Y Q
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T2)
 ...S BDMC=$$LBLK($P(^AUPNVLAB(Y,0),U,4),6)_" "_$P($G(^AUPNVLAB(Y,11)),U)_"|||"_$P($P(^AUPNVSIT($P(^AUPNVLAB(Y,0),U,3),0),U),".")_"|||"_$E($$VAL^XBDIQ1(9000010.09,Y,.01),1,25)_"|||"_Y
 ...Q
 I BDMC]"" Q BDMC
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
PCR(P) ;EP
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT P/C RATIO TAX",0)),LT=$O(^ATXAX("B","DM AUDIT P/C RATIO LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT,1)
LAB(P,T,LT,YEAR) ;EP
 I '$G(LT) S LT=""
 S YEAR=$G(YEAR)
 NEW BDATE
 S BDATE=$S(YEAR:$$FMADD^XLFDT(DT,-365),1:$$DOB^AUPNPAT(P))
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..Q:(9999999-D)<BDATE
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
 S R=$$LBLK($P(^AUPNVLAB(G,0),U,4),6)_" "_$P($G(^AUPNVLAB(G,11)),U)_"|||"
 S R=R_$P($P($G(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0)),U),".")_"|||"_$E($$VAL^XBDIQ1(9000010.09,G,.01),1,25)_"|||"_$$REF(P,T,$P($P($G(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0)),U),"."))_"|||"_G
 Q R
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
LDLLAB ;EP
 K BDMX
 NEW LT S LT=$O(^ATXAX("B","BGP LDL LOINC CODES",0))
 NEW D,V,X,G S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",BDMSPAT,D)) Q:D'=+D!(G>2)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",BDMSPAT,D,X)) Q:X'=+X!(G>2)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",BDMSPAT,D,X,Y)) Q:Y'=+Y!(G>2)  D
 ...Q:'$D(^AUPNVLAB(Y,0))
 ...I $P(^AUPNVLAB(Y,0),U,4)="" Q
 ...I Y=BDMIEN Q
 ...I $D(^ATXLAB(T,21,"B",X)) D   Q
 ....S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ....S BDMX(Y)=R_"^"_(9999999-D),G=G+1
 ...;Q  ;IHS/CMI/LAB - don't check loinc codes for now
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S R=$P(^AUPNVLAB(Y,0),U,4) Q:R'=+R
 ...S BDMX(Y)=R_"^"_(9999999-D),G=G+1
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
 N BDMREF,BDMT,V S BDMT=0 F  S BDMT=$O(^ATXLAB(T,21,"B",BDMT)) Q:BDMT'=+BDMT  D
 .S V=$$REF1(P,60,BDMT,D) I V]"" S BDMREF(9999999-$P(V,U,3))=V
 I $D(BDMREF) S %=0,%=$O(BDMREF(%)) I % S V=BDMREF(%) Q V
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
 Q $$LBLK($P(^AUPNVLAB(E,0),U,4),6)_" "_$P($G(^AUPNVLAB(E,11)),U)_"|||"_$P($P(^AUPNVSIT($P(^AUPNVLAB(E,0),U,3),0),U),".")_"|||"_$E($$VAL^XBDIQ1(9000010.09,E,.01),1,25)
HBA1C(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0)),LT=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
URIN(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)),LT=$O(^ATXAX("B","DM AUDIT URINE PROTEIN LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT,1)
MICRO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0)),LT=$O(^ATXAX("B","DM AUDIT MICROALBUMIN LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT,1)
ACRATIO(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT QUANT UACR",0)),LT=$O(^ATXAX("B","DM AUDIT A/C RATIO LOINC",0)) I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT)
HR24(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT 24HR URINE PROTEIN",0)),LT="" I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT,1)
SEMI(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT SEMI QUANT UACR",0)),LT="" I 'T Q "<Taxonomy Missing>"
 Q $$LAB(P,T,LT,1)
LBLK(V,L) ;EP LEFT blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
