BDMS9D1 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ; 01 Feb 2011  8:49 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
 ;
EP ;EP - called from component
 Q:'$G(BDMSPAT)
 I $$PLTAX^BDMSMU(BDMSPAT,"SURVEILLANCE DIABETES") Q  ;has diabetes
 S X=$$LASTITEM^BDMSMU(BDMSPAT,"[SURVEILLANCE DIABETES","DX")
 I X>$$FMADD^XLFDT(DT,-366) Q  ;if date of last dm dx is w/in past year then quit
 I $E(IOST)="C",IO=IO(0) W !! S DIR("A")="PRE-DIABETES CARE SUMMARY WILL NOW BE DISPLAYED (^ TO EXIT, RETURN TO CONTINUE)",DIR(0)="E" D ^DIR I $D(DIRUT) S BDMSQIT=1 Q
 D EP2(BDMSPAT)
W ;write out array
 W:$D(IOF) @IOF
 K BDMQUIT
 S BDMX=0 F  S BDMX=$O(^TMP("APCHS",$J,"DCS",BDMX)) Q:BDMX'=+BDMX!($D(BDMQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BDMQUIT)
 .W !,^TMP("APCHS",$J,"DCS",BDMX)
 .Q
 I $D(BDMQUIT) S BDMSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K BDMX,BDMQUIT,BDMY,BDMSDFN,BDMSBEG,BDMSTOB,BDMSUPI,BDMSED,BDMTOBN,BDMTOB,BDMSTEX
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,BDMSHDR,!
 W !,"PreDiabetes Patient Care Summary - continued"
 W !,"Patient: ",$P(^DPT(BDMSPAT,0),U),"  HRN: ",$$HRN^AUPNPAT(BDMSPAT,DUZ(2)),!
 Q
EP2(BDMSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHS",$J,"DCS"
 K ^TMP("APCHS",$J,"DCS")
 S ^TMP("APCHS",$J,"DCS",0)=0
 ;I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 D EN^XBNEW("EP21^BDMS9D1","BDMSDFN")
 Q
EP21 ;
 S BDMSPAT=BDMSDFN
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="PREDIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient Name:  "_$P(^DPT(BDMSDFN,0),U)_"    HRN: "_$$HRN^AUPNPAT(BDMSDFN,DUZ(2)) D S(X)
 S X="Age:  "_$$AGE^AUPNPAT(BDMSDFN),$E(X,15)="Sex:  "_$$SEX^AUPNPAT(BDMSDFN)_"    DOB:  "_$$FMTE^XLFDT($$DOB^AUPNPAT(BDMSDFN)) D S(X)
 S X="Classification:" D S(X,1)
 S Y=$$IFG(BDMSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Impaired Fasting Glucose" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S Y=$$IGT(BDMSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Impaired Glucose Tolerance" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S Y=$$MS(BDMSDFN) S X="",$E(X,2)=$S($P(Y,U)=1:"Yes",1:"No"),$E(X,8)="Metabolic Syndrome" I $P(Y,U)=1 S X=X_":  "_$P(Y,U,3)_":  "_$$FMTE^XLFDT($P(Y,U,2))
 D S(X)
 S X=" " D S(X)
 S X="Case Manager:  "_$$CMSMAN(BDMSDFN) D S(X)  ;HOW TO FIND CASE MANAGER - LORI
 S X="Primary Care Provider: "_$$VAL^XBDIQ1(9000001,BDMSDFN,.14) D S(X)
 S X=" " D S(X)
 D GETHWB(BDMSDFN,DT)
 S X="  Last Height:  "_BDMX(1,"HT")_$S(BDMX(1,"HT")]"":" inches",1:""),$E(X,33)=BDMX(1,"HTD") D S(X)
 S X="Last 3 Weight:  "_$S(BDMX(1,"WT")]"":$J(BDMX(1,"WT"),3,0),1:"")_$S(BDMX(1,"WT")]"":" lbs",1:""),$E(X,33)=BDMX(1,"WTD"),$E(X,47)="BMI: "_BDMX(1,"BMI") D S(X)
 S X="",$E(X,17)=$S(BDMX(2,"WT")]"":$J(BDMX(2,"WT"),3,0),1:"")_$S(BDMX(2,"WT")]"":" lbs",1:""),$E(X,33)=BDMX(2,"WTD"),$E(X,47)="BMI: "_BDMX(2,"BMI") D S(X)
 S X="",$E(X,17)=$S(BDMX(3,"WT")]"":$J(BDMX(3,"WT"),3,0),1:"")_$S(BDMX(3,"WT")]"":" lbs",1:""),$E(X,33)=BDMX(3,"WTD"),$E(X,47)="BMI: "_BDMX(3,"BMI") D S(X)
 I BDMX(1,"WC")]"" S X="Last Waist Circumference: "_BDMX(1,"WC"),$E(X,33)=BDMX(1,"WCD") D S(X,1)
 S B=$$BP(BDMSDFN)
 S X="Last 3 non-ER BP:  "_$P($G(BDMX(1)),U,2)_"     "_$$FMTE^XLFDT($P($G(BDMX(1)),U))
 D S(X,1)
 S X="" I $D(BDMX(2)) S X="",$E(X,20)=$P(BDMX(2),U,2)_"     "_$$FMTE^XLFDT($P(BDMX(2),U))
 D S(X)
 S X="" I $D(BDMX(3)) S X="",$E(X,20)=$P(BDMX(3),U,2)_"     "_$$FMTE^XLFDT($P(BDMX(3),U))
 D S(X)
 D TOBACCO^BDMS9B3
 S X="Tobacco Use:  "_$G(BDMTOB) D S(X,1)
 S X="Prediabetes Education Provided (in past yr):" D S(X,1)
 S X="   Last Dietitian Visit:   "_$$DIETV^BDMS9B3(BDMSDFN) D S(X)
 S BDMSBEG=$$FMADD^XLFDT(DT,-366)
 K BDMX D EDUC^BDMS9B2 I $D(BDMX) D
 .S %=0 F  S %=$O(BDMX(%)) Q:%'=+%  S X="   "_BDMX(%) D S(X)
 K BDMX,BDMY,%
 D EDUCREF^BDMS9B2 I $D(BDMX) S X="In the past year, the patient has refused the following Diabetes education:" D S(X,1) D
 .S %="" F  S %=$O(BDMX(%)) Q:%=""  S X="   "_%_"   "_BDMX(%) D S(X)
 K BDMX,BDMY,%
 S X="HTN Diagnosed:  "_$$HTN(BDMSDFN) D S(X,1)
 S BDMSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^BDMS9B4(BDMSDFN,BDMSBEG) ;get date of last ACE in last year
 S X="",X="ON ACE Inhibitor/ARB in past 6 months: "_% D S(X)
 K BDMSX S BDMSBEG=$$FMADD^XLFDT(DT,-365) S X="Aspirin Use (in past yr):  "_$E($$ASPIRIN(BDMSDFN,BDMSBEG),1,32) D S(X)
 S X="",X=$$ASPREF^BDMS9B4(BDMSDFN) I X]"" S X="     "_X D S(X)
M12 ;
 D MORE^BDMS9D2
 S X=$P(^DPT(BDMSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(BDMSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(BDMSDFN,DUZ(2),2) D S(X,1)
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
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
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
 NEW X,Y,I,BDMY,%
 S X=$$PLCODE^BDMSMU(P,"277.7",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K BDMY S %=P_"^FIRST DX 277.7",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) Q 1_U_$P(BDMY(1),U)_U_"Date of first DX in PCC"
 Q ""
IGT(P) ;
 NEW X,Y,I,BDMY,%
 S X=$$PLCODE^BDMSMU(P,"790.22",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K BDMY S %=P_"^FIRST DX 790.22",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) Q 1_U_$P(BDMY(1),U)_U_"Date of first DX in PCC"
 Q ""
IFG(P) ;
 NEW X,Y,I,BDMY,%
 S X=$$PLCODE^BDMSMU(P,"790.21",2) I X D  Q Y
 .S D=$P(^AUPNPROB(X,0),U,13) I D]"" S Y=1_U_D_U_"Date of Onset from Problem List" Q
 .S D=$P(^AUPNPROB(X,0),U,8) I D]"" S Y=1_U_D_U_"Date Added to Problem List" Q
 .S Y=1_U_D_U_"Problem List" Q
 K BDMY S %=P_"^FIRST DX 790.21",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) Q 1_U_$P(BDMY(1),U)_U_"Date of first DX in PCC"
 Q ""
HTN(P) ;
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW BDMX
 S BDMX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"BDMX(") G:E HTNX I $D(BDMX(3)) S BDMX="Yes"
 I $G(BDMX)="" S BDMX="No"
HTNX ;
 Q BDMX
BP(P) ;last 3 BPs - NON ER
 NEW BDMD,BDMC
 K BDMX
 S BDMX="",BDMD="",BDMC=0
 S T=$O(^AUTTMSR("B","BP",""))
 F  S BDMD=$O(^AUPNVMSR("AA",P,T,BDMD)) Q:BDMD=""!(BDMC=3)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,BDMD,M)) Q:M'=+M!(BDMC=3)  D
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S BDMC=BDMC+1,BDMX(BDMC)=(9999999-BDMD)_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 I '$D(BDMX(1)) S BDMX(1)="None recorded"
BPX ;
 K BDMD,BDMC
 Q BDMX
GETHWB(P,EDATE)  ;get last height, height date, weight, weight date and BMI for patient P, return in BDMX("HT"),BDMX("HTD"),BDMX("WT"),BDMX("WTD"),BDMX("BMI")
 K BDMX
 F X=1:1:3 S BDMX(X,"HT")="",BDMX(X,"HTD")="",BDMX(X,"WT")="",BDMX(X,"WTD")="",BDMX(X,"BMI")="",BDMX(X,"WC")="",BDMX(X,"WCD")="",BDMX(X,"WTI")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW BDMY
 S %=P_"^LAST 3 MEAS HT" NEW X S E=$$START1^APCLDF(%,"BDMY(")
 S BDMX(1,"HT")=$P($G(BDMY(1)),U,2),BDMX(1,"HTD")=$$FMTE^XLFDT($P($G(BDMY(1)),U))
 S BDMX(1,"HT")=$S(BDMX(1,"HT")]"":$J(BDMX(1,"HT"),2,0),1:"")
 S BDMX(2,"HT")=$P($G(BDMY(2)),U,2),BDMX(2,"HTD")=$$FMTE^XLFDT($P($G(BDMY(2)),U))
 S BDMX(2,"HT")=$S(BDMX(2,"HT")]"":$J(BDMX(2,"HT"),2,0),1:"")
 S BDMX(3,"HT")=$P($G(BDMY(3)),U,2),BDMX(3,"HTD")=$$FMTE^XLFDT($P($G(BDMY(3)),U))
 S BDMX(3,"HT")=$S(BDMX(3,"HT")]"":$J(BDMX(3,"HT"),2,0),1:"")
LASTWT ;
 K BDMY S %=P_"^LAST 3 MEAS WT" NEW X S E=$$START1^APCLDF(%,"BDMY(")
 S BDMX(1,"WT")=$P($G(BDMY(1)),U,2),BDMX(1,"WTD")=$$FMTE^XLFDT($P($G(BDMY(1)),U)),BDMX(1,"WTI")=$P($G(BDMY(1)),U)
 S BDMX(2,"WT")=$P($G(BDMY(2)),U,2),BDMX(2,"WTD")=$$FMTE^XLFDT($P($G(BDMY(2)),U)),BDMX(2,"WTI")=$P($G(BDMY(2)),U)
 S BDMX(3,"WT")=$P($G(BDMY(3)),U,2),BDMX(3,"WTD")=$$FMTE^XLFDT($P($G(BDMY(3)),U)),BDMX(3,"WTI")=$P($G(BDMY(3)),U)
LASTWC ;
 K BDMY S %=P_"^LAST 3 MEAS WC" NEW X S E=$$START1^APCLDF(%,"BDMY(")
 S BDMX(1,"WC")=$P($G(BDMY(1)),U,2),BDMX(1,"WCD")=$$FMTE^XLFDT($P($G(BDMY(1)),U))
 S BDMX(2,"WC")=$P($G(BDMY(2)),U,2),BDMX(2,"WCD")=$$FMTE^XLFDT($P($G(BDMY(2)),U))
 S BDMX(3,"WC")=$P($G(BDMY(3)),U,2),BDMX(3,"WCD")=$$FMTE^XLFDT($P($G(BDMY(3)),U))
BMI ;
 F BDMY=1:1:3 D
 .I BDMX(BDMY,"WT")="" Q  ;no weight
 .S BDMHT=""
 .I $$AGE^AUPNPAT(P)<19 D  Q:BDMHT=""
 ..;Get weight on that date
 ..S Y=0 F  S Y=$O(BDMX(Y)) Q:Y'=+Y  I BDMX(Y,"HTD")=BDMX(BDMY,"WTD") S BDMHT=BDMX(Y,"HT")
 .I $$AGE^AUPNPAT(P)>18 D  Q:BDMHT=""
 ..S Y=0 F  S Y=$O(BDMX(Y)) Q:Y'=+Y  I BDMX(Y,"HTD")=BDMX(BDMY,"WTD") S BDMHT=BDMX(Y,"HT") Q
 ..S BDMHT=BDMX(1,"HT")
 .S %=""
 .S W=BDMX(BDMY,"WT")*.45359,H=(BDMHT*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .S BDMX(BDMY,"BMI")=%
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
