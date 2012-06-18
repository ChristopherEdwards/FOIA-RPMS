BHSDMPRE ;IHS/CIA/MGH - Health Summary for Pre-Diabetic Supplement ;04-Aug-2011 14:34;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2,4,6**;March 17, 2006;Build 5
 ;===================================================================
 ;VA version of IHS components for supplemental summaries
 ;Taken from APCHS9D1
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;  [ 05/10/04  2:03 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,8,9,10,11,12**;JUN 24, 1997
 ;Patch 4 skip vitals entered in error
 ;====================================================================
 ;
EP ;EP - called from component
 N BHSPAT
 S BHSPAT=DFN
 Q:'$G(BHSPAT)
 I $$PLTAX^BHSMU(BHSPAT,"SURVEILLANCE DIABETES") Q  ;has diabetes
 S X=$$LASTITEM^BHSMU(BHSPAT,"[SURVEILLANCE DIABETES","DX")
 I X>$$FMADD^XLFDT(DT,-366) Q  ;if date of last dm dx is w/in past year then quit
 D CKP^GMTSUP Q:$D(GMTSQIT)
 D EP2(BHSPAT)
W ;write out array
 W:$D(IOF) @IOF
 K APCHQUIT
 S APCHX=0 F  S APCHX=$O(^TMP("BHS",$J,"DCS",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W !,^TMP("BHS",$J,"DCS",APCHX)
 .Q
 I $D(APCHQUIT) S GMTSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K APCHX,APCHQUIT,APCHY,APCHIEN,APCHHT,BHSDFN,BHSBEG,BHSTOB,BHSUPI,BHSDD,BHSINT,BHSWD,BHSED,APCHTOBN,APCHTOB,BHSTEX,BDMSDFN,BSMSBEG
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W,M
 Q
EP2(BHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("BHS",$J,"DCS"
 K ^TMP("BHS",$J,"DCS")
 S ^TMP("BHS",$J,"DCS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="PREDIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient Name:  "_$P(^DPT(BHSDFN,0),U)_"    HRN: "_$$HRN^AUPNPAT(BHSDFN,DUZ(2)) D S(X)
 S X="Age:  "_$$AGE^AUPNPAT(BHSDFN),$E(X,15)="Sex:  "_$$SEX^AUPNPAT(BHSDFN)_"    DOB:  "_$$FMTE^XLFDT($$DOB^AUPNPAT(BHSDFN)) D S(X)
 S X="Classification:" D S(X,1)
 S Y=$$IFG(BHSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Impaired Fasting Glucose" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S Y=$$IGT(BHSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Impaired Glucose Tolerance" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S Y=$$MS(BHSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Metabolic Syndrome" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S X=" " D S(X)
 S X="Case Manager:  "_$$CMSMAN(BHSDFN) D S(X)  ;HOW TO FIND CASE MANAGER - LORI
 S X="Primary Care Provider: "_$$VAL^XBDIQ1(9000001,BHSDFN,.14) D S(X)
 S X=" " D S(X)
 D GETHWB(BHSDFN,DT)
 S X="  Last Height:  "_APCHX(1,"HT")_$S(APCHX(1,"HT")]"":" inches",1:""),$E(X,33)=APCHX(1,"HTD") D S(X)
 S X="Last 3 Weight:  "_$S(APCHX(1,"WT")]"":$J(APCHX(1,"WT"),3,0),1:"")_$S(APCHX(1,"WT")]"":" lbs",1:""),$E(X,33)=APCHX(1,"WTD"),$E(X,47)="BMI: "_APCHX(1,"BMI") D S(X)
 S X="",$E(X,17)=$S(APCHX(2,"WT")]"":$J(APCHX(2,"WT"),3,0),1:"")_$S(APCHX(2,"WT")]"":" lbs",1:""),$E(X,33)=APCHX(2,"WTD"),$E(X,47)="BMI: "_APCHX(2,"BMI") D S(X)
 S X="",$E(X,17)=$S(APCHX(3,"WT")]"":$J(APCHX(3,"WT"),3,0),1:"")_$S(APCHX(3,"WT")]"":" lbs",1:""),$E(X,33)=APCHX(3,"WTD"),$E(X,47)="BMI: "_APCHX(3,"BMI") D S(X)
 I APCHX(1,"WC")]"" S X="Last Waist Circumference: "_APCHX(1,"WC"),$E(X,33)=APCHX(1,"WCD") D S(X,1)
 S B=$$BP(BHSDFN)
 S X="Last 3 non-ER BP:  "_$P($G(APCHX(1)),U,2)_"     "_$$FMTE^XLFDT($P($G(APCHX(1)),U))
 D S(X,1)
 S X="" I $D(APCHX(2)) S X="",$E(X,20)=$P(APCHX(2),U,2)_"     "_$$FMTE^XLFDT($P(APCHX(2),U))
 D S(X)
 S X="" I $D(APCHX(3)) S X="",$E(X,20)=$P(APCHX(3),U,2)_"     "_$$FMTE^XLFDT($P(APCHX(3),U))
 D S(X)
 ;Patch 6
 N BDMSDFN,BDMTOBC,BDMTOBS,BDMSBEG
 S BDMSDFN=BHSDFN
 D TOBACCO^BDMS9B3
 S X="Tobacco Use:  "_$P($G(BDMTOBS),U,1) D S(X)
 I $G(BDMTOBC)]"" S X="              "_$P(BDMTOBC,U,1) D S(X)
 S X="Prediabetes Education Provided (in past yr):" D S(X,1)
 S X="   Last Dietitian Visit:   "_$$DIETV^BDMS9B3(BHSDFN) D S(X)
 S (BHSBEG,BDMSBEG)=$$FMADD^XLFDT(DT,-366)
 K APCHX D EDUC^BDMS9B2 I $D(APCHX) D
 .S %=0 F  S %=$O(APCHX(%)) Q:%'=+%  S X="   "_APCHX(%) D S(X)
 K APCHX,APCHY,%
 D EDUCREF^BHSDM3 I $D(APCHX) S X="In the past year, the patient has refused the following Diabetes education:" D S(X,1) D
 .S %="" F  S %=$O(APCHX(%)) Q:%=""  S X="   "_%_"   "_APCHX(%) D S(X)
 K APCHX,APCHY,%
 S X="HTN Diagnosed:  "_$$HTN(BHSDFN) D S(X,1)
 S BHSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^BDMS9B5(BHSDFN,BHSBEG) ;get date of last ACE in last year
 S X="",X="ON ACE Inhibitor/ARB in past 6 months: "_% D S(X)
 K BHSX S BHSBEG=$$FMADD^XLFDT(DT,-365) S X="Aspirin Use (in past yr):  "_$E($$ASPIRIN(BHSDFN,BHSBEG),1,32) D S(X)
 S X="",X=$$ASPREF^BDMS9B5(BHSDFN) I X]"" S X="     "_X D S(X)
M12 ;
 ;Patch 1001, new routine to call
 D MORE^BHSDMPR1
 S X=$P(^DPT(BHSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(BHSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(BHSDFN,DUZ(2),2) D S(X,1)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
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
CMSMAN(P,F) ;EP - return date/dx of dm in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""!(D]"")  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R!(D]"")  I N["DIAB" D
 .S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(41,"C",P,X)) Q:X'=+X!(D]"")  I $P(^ACM(41,X,0),U,4)=R D
 ..S D=$P($G(^ACM(41,X,"DT")),U,6) I D]"" S D=$P(^VA(200,D,0),U)
 Q $G(D)
 ;
MS(P) ;
 NEW X,Y,I,APCHY,%
 S X=$$PLCODE^BHSMU(P,"277.7",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K APCHY S %=P_"^FIRST DX 277.7",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) Q 1_U_$P(APCHY(1),U)_U_"Date of first DX in PCC"
 Q ""
IGT(P) ;
 NEW X,Y,I,APCHY,%
 S X=$$PLCODE^BHSMU(P,"790.22",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K APCHY S %=P_"^FIRST DX 790.22",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) Q 1_U_$P(APCHY(1),U)_U_"Date of first DX in PCC"
 Q ""
IFG(P) ;
 NEW X,Y,I,APCHY,%
 S X=$$PLCODE^BHSMU(P,"790.21",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K APCHY S %=P_"^FIRST DX 790.21",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) Q 1_U_$P(APCHY(1),U)_U_"Date of first DX in PCC"
 Q ""
HTN(P) ;
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCHX
 S APCHX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"APCHX(") G:E HTNX I $D(APCHX(3)) S APCHX="Yes"
 I $G(APCHX)="" S APCHX="No"
HTNX ;
 Q APCHX
BP(P) ;last 3 BPs - NON ER
 NEW APCHD,APCHC
 K APCHX
 S APCHX="",APCHD="",APCHC=0
 S T=$O(^AUTTMSR("B","BP",""))
 F  S APCHD=$O(^AUPNVMSR("AA",P,T,APCHD)) Q:APCHD=""!(APCHC=3)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,APCHD,M)) Q:M'=+M!(APCHC=3)  D
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P($G(^AUPNVMSR(M,2)),U,1)  ;entered in error
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S APCHC=APCHC+1,APCHX(APCHC)=(9999999-APCHD)_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 I '$D(APCHX(1)) S APCHX(1)="None recorded"
BPX ;
 K APCHD,APCHC
 Q APCHX
GETHWB(P,EDATE) ;get last height, height date, weight, weight date and BMI for patient P, return in APCHX("HT"),APCHX("HTD"),APCHX("WT"),APCHX("WTD"),APCHX("BMI")
 K APCHX
 F X=1:1:3 S APCHX(X,"HT")="",APCHX(X,"HTD")="",APCHX(X,"WT")="",APCHX(X,"WTD")="",APCHX(X,"BMI")="",APCHX(X,"WC")="",APCHX(X,"WCD")="",APCHX(X,"WTI")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW APCHY
 S %=P_"^LAST 3 MEAS HT" NEW X S E=$$START1^APCLDF(%,"APCHY(")
 S APCHX(1,"HT")=$P($G(APCHY(1)),U,2),APCHX(1,"HTD")=$$FMTE^XLFDT($P($G(APCHY(1)),U))
 S APCHX(1,"HT")=$S(APCHX(1,"HT")]"":$J(APCHX(1,"HT"),2,0),1:"")
 S APCHX(2,"HT")=$P($G(APCHY(2)),U,2),APCHX(2,"HTD")=$$FMTE^XLFDT($P($G(APCHY(2)),U))
 S APCHX(2,"HT")=$S(APCHX(2,"HT")]"":$J(APCHX(2,"HT"),2,0),1:"")
 S APCHX(3,"HT")=$P($G(APCHY(3)),U,2),APCHX(3,"HTD")=$$FMTE^XLFDT($P($G(APCHY(3)),U))
 S APCHX(3,"HT")=$S(APCHX(3,"HT")]"":$J(APCHX(3,"HT"),2,0),1:"")
LASTWT ;
 K APCHY S %=P_"^LAST 3 MEAS WT" NEW X S E=$$START1^APCLDF(%,"APCHY(")
 S APCHX(1,"WT")=$P($G(APCHY(1)),U,2),APCHX(1,"WTD")=$$FMTE^XLFDT($P($G(APCHY(1)),U)),APCHX(1,"WTI")=$P($G(APCHY(1)),U)
 S APCHX(2,"WT")=$P($G(APCHY(2)),U,2),APCHX(2,"WTD")=$$FMTE^XLFDT($P($G(APCHY(2)),U)),APCHX(2,"WTI")=$P($G(APCHY(2)),U)
 S APCHX(3,"WT")=$P($G(APCHY(3)),U,2),APCHX(3,"WTD")=$$FMTE^XLFDT($P($G(APCHY(3)),U)),APCHX(3,"WTI")=$P($G(APCHY(3)),U)
LASTWC ;
 K APCHY S %=P_"^LAST 3 MEAS WC" NEW X S E=$$START1^APCLDF(%,"APCHY(")
 S APCHX(1,"WC")=$P($G(APCHY(1)),U,2),APCHX(1,"WCD")=$$FMTE^XLFDT($P($G(APCHY(1)),U))
 S APCHX(2,"WC")=$P($G(APCHY(2)),U,2),APCHX(2,"WCD")=$$FMTE^XLFDT($P($G(APCHY(2)),U))
 S APCHX(3,"WC")=$P($G(APCHY(3)),U,2),APCHX(3,"WCD")=$$FMTE^XLFDT($P($G(APCHY(3)),U))
BMI ;
 F APCHY=1:1:3 D
 .I APCHX(APCHY,"WT")="" Q  ;no weight
 .S APCHHT=""
 .I $$AGE^AUPNPAT(P)<19 D  Q:APCHHT=""
 ..;Get weight on that date
 ..S Y=0 F  S Y=$O(APCHX(Y)) Q:Y'=+Y  I APCHX(Y,"HTD")=APCHX(APCHY,"WTD") S APCHHT=APCHX(Y,"HT")
 .I $$AGE^AUPNPAT(P)>18 D  Q:APCHHT=""
 ..S Y=0 F  S Y=$O(APCHX(Y)) Q:Y'=+Y  I APCHX(Y,"HTD")=APCHX(APCHY,"WTD") S APCHHT=APCHX(Y,"HT") Q
 ..S APCHHT=APCHX(1,"HT")
 .S %=""
 .S W=APCHX(APCHY,"WT")*.45359,H=(APCHHT*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .S APCHX(APCHY,"BMI")=%
 Q
ASPIRIN(P,D) ;
 I '$G(P) Q ""
 I '$G(D) S D=0 ;if don't pass date look at all time
 NEW V,I,%
 S %=""
 NEW T,T1 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S T1=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I 'T Q ""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V!(%)  S G=$P(^AUPNVMED(V,0),U) D
 ..I $D(^ATXAX(T,21,"B",G)) S %=V Q
 ..I T1,$D(^ATXAX(T1,21,"B",G)) S %=V Q
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 Q "No"
