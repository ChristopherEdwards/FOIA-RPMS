BHSDMPR1 ;IHS/CIA/MGH - Health Summary for Pre-Diabetic Supplement ;19-Jun-2008 12:37;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;Mar 17,2006
 ;====================================================================
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;07-Jul-2006 16:02;MGH
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,7,8,9,10,11,12,14**;JUN 24, 1997
 ;IHS/CMI/LAB patch 3 - patch 3 fixes various problems
 ;Copied from APCHS9B2
 ;======================================================================
 ;
 ;
MORE ;EP
 N X,BHSX,BHSY,BHSIEN,V,Y
 S BHSBEG=$$FMADD^XLFDT(DT,-(6*30))
 S X="On Metformin: "_$$MET(BHSDFN,BHSBEG,DT) D S(X,1)
 S X="On TZD: "_$$TROG(BHSDFN,BHSBEG,DT) D S(X)
 S X="On Acarbose: "_$$ACAR(BHSDFN,BHSBEG,DT) D S(X)
 S X="On Lipid Lowering Drugs: "_$$LLOW(BHSDFN,BHSBEG,DT) D S(X)
 S BHSX=$$STATIN(BHSDFN,BHSBEG,DT) I $E(BHSX,1,3)="Yes" S X="                       :"_BHSX D S(X)
 S X="Laboratory Results (most recent):" D S(X,1)
 S X="Last Fasting Glucose:" S Y=$$FGLUCOSE(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Last 75 GM 2 hour Glucose:" S Y=$$GM75(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="Total Cholesterol:" S Y=$$TCHOL^BHSDM2(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X,1)
 S X="  LDL Cholesterol:" S Y=$$CHOL^BHSDM2(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S V=$P(Y,"|||") I V'=+V D
 .;get last 3 and display next most recent 2
 .S BHSIEN=$P(Y,"|||",4)
 .S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0)) D LDLLAB^BHSDM2
 .I $D(BHSX) S X="  Next most recent LDL values:" D S(X)
 .S BHSY=0 F  S BHSY=$O(BHSX(BHSY)) Q:BHSY'=+BHSY  S X="",$E(X,28)=$P(BHSX(BHSY),U),$E(X,42)=$$FMTE^XLFDT($P(BHSX(BHSY),U,2)) D S(X)
 S X="  HDL Cholesterol:" S Y=$$HDL^BHSDM2(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
 S X="    Triglycerides:" S Y=$$TRIG^BHSDM2(BHSDFN),$E(X,28)=$P(Y,"|||"),$E(X,42)=$P(Y,"|||",2),$E(X,56)=$P(Y,"|||",3) D S(X)
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
EDUC ;gather up all education provided in past year in APCHX
 K APCHX,APCHY S %=BHSDFN_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365))_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(%,"APCHY(")
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
 N LT
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0)),LT="DM AUDIT FASTING GLUC LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^BHSDM2(P,T,LT)
GM75(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT 75GM 2HR GLUCOSE",0)),LT="DM AUDIT 75GM 2HR GLUC LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^BHSDM2(P,T,LT)
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
