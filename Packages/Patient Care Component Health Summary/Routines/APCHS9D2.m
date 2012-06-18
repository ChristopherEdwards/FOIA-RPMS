APCHS9D2 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB patch 3 - patch 3 fixes various problems
 ;
 ;
MORE ;EP
 S APCHSBEG=$$FMADD^XLFDT(DT,-(6*30))
 S X="On Metformin: "_$$MET(APCHSDFN,APCHSBEG,DT) D S(X,1)
 S X="On TZD: "_$$TROG(APCHSDFN,APCHSBEG,DT) D S(X)
 S X="On Acarbose: "_$$ACAR(APCHSDFN,APCHSBEG,DT) D S(X)
 S X="On Lipid Lowering Drugs: "_$$LLOW(APCHSDFN,APCHSBEG,DT) D S(X)
 S APCHX=$$STATIN(APCHSDFN,APCHSBEG,DT) I $E(APCHX,1,3)="Yes" S X="                       :"_APCHX D S(X)
 S X="Laboratory Results (most recent):" D S(X,1)
 S X="Last Fasting Glucose:" S Y=$$FGLUCOSE(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Last 75 GM 2 hour Glucose:" S Y=$$GM75(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Total Cholesterol:" S Y=$$TCHOL^APCHS9B2(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X,1)
 S X="  LDL Cholesterol:" S Y=$$CHOL^APCHS9B2(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S V=$P(Y,"|||") I V'=+V D
 .;get last 3 and display next most recent 2
 .S APCHIEN=$P(Y,"|||",4)
 .S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0)) D LDLLAB^APCHS9B2
 .I $D(APCHX) S X="  Next most recent LDL values:" D S(X)
 .S APCHY=0 F  S APCHY=$O(APCHX(APCHY)) Q:APCHY'=+APCHY  S X="",$E(X,28)=$P(APCHX(APCHY),U),$E(X,42)=$$FMTE^XLFDT($P(APCHX(APCHY),U,2)) D S(X)
 S X="  HDL Cholesterol:" S Y=$$HDL^APCHS9B2(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="    Triglycerides:" S Y=$$TRIG^APCHS9B2(APCHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
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
EDUC ;gather up all education provided in past year in APCHX
 K APCHX,APCHY S %=APCHSDFN_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365))_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(%,"APCHY(")
 I '$D(APCHY) S APCHX(1)="   <No Education Topics recorded in past year>" K APCHY Q
 NEW X,APCHP K APCHP S X=0,E="" F  S X=$O(APCHY(X)) Q:X'=+X  S E=+$P(APCHY(X),U,4),E=$P(^AUPNVPED(E,0),U) I $$EDT(E) S APCHP($P(APCHY(X),U,2))=$$FMTE^XLFDT($P(APCHY(X),U))
 S %=0,E="" F  S E=$O(APCHP(E)) Q:E=""  S %=%+1,APCHX(%)=E,$E(APCHX(%),25)=APCHP(E)
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
 S T=$P(^AUTTEDT(E,0),U)
 I $P(T,"-")="DM" Q 1
 I $P(T,"-")="DMC" Q 1
 Q ""
FGLUCOSE(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0)),LT="DM AUDIT FASTING GLUC LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^APCHS9B2(P,T,LT)
GM75(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT 75GM 2HR GLUCOSE",0)),LT="DM AUDIT 75GM 2HR LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^APCHS9B2(P,T,LT)
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
LLOW(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 S X=P_"^LAST MEDS [DM AUDIT LIPID LOWERING DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
 ;
STATIN(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 S X=P_"^LAST MEDS [DM AUDIT STATIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
MET(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 S X=P_"^LAST MEDS [DM AUDIT METFORMIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
 ;
ACAR(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 S X=P_"^LAST MEDS [DM AUDIT ACARBOSE DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
 ;
TROG(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 I '$O(^ATXAX("B","DM AUDIT GLITAZONE DRUGS",0)) Q $$TROG1(P,BDATE,EDATE)
 S X=P_"^LAST MEDS [DM AUDIT GLITAZONE DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
TROG1(P,BDATE,EDATE) ;EP
 NEW X,APCH,E
 S X=P_"^LAST MEDS [DM AUDIT TROGLITAZONE DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCH(")
 I $D(APCH(1)) Q "Yes - "_$$VAL^XBDIQ1(9000010.14,+$P(APCH(1),U,4),.01)_"  "_$$FMTE^XLFDT($P(APCH(1),U))
 Q "No"
