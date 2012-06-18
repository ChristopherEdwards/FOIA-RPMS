APCHPMH1 ; IHS/CMI/LAB - Patient Wellness Handout ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
 ;
EP(APCHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHPHS",$J,"PMH"
 ;CHANGE TO GO TO NEW PWH 
 S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 D EP^APCHPWH1(APCHSDFN,APCHPWHT)
 Q
 K ^TMP("APCHPHS",$J,"PMH")
 S ^TMP("APCHPHS",$J,"PMH",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="PATIENT WELLNESS HANDOUT                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X=$P($P(^DPT(APCHSDFN,0),U),",",2)_" "_$P($P(^DPT(APCHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,2)
 I $G(APCDVSIT)]"",$D(^AUPNVSIT("AC",APCHSDFN,APCDVSIT)) S APCHPROV=$$PRIMPROV^APCLV(APCDVSIT)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.111),$E(X,50)=$S($G(APCHPROV)]"":APCHPROV,1:$$VAL^XBDIQ1(9000001,APCHSDFN,.14)) D S(X)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.114)_$S($$VAL^XBDIQ1(2,APCHSDFN,.114)]"":",  ",1:" ")_$$VAL^XBDIQ1(2,APCHSDFN,.115)_"   "_$$VAL^XBDIQ1(2,APCHSDFN,.116),Y=$P(^AUTTLOC(DUZ(2),0),U,11),$E(X,50)=Y D S(X)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.131) D S(X)
 S X="Hello "_$S($$SEX^AUPNPAT(APCHSDFN)="M":"Mr. ",1:"Ms. ")_$E($P($P(^DPT(APCHSDFN,0),U),","))_$$LOW^XLFSTR($E($P($P(^DPT(APCHSDFN,0),U),","),2,99))_"," D S(X,1)
 S X="Thank you for choosing "_$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U))_"." D S(X,1)
 S X="This sheet is a new way for you and your doctor to look at your health." D S(X,1)
 ;
IMMUN ;
 K APCHIMM
 S X="Immunizations(shots).  Getting shots protects you from some diseases and"  D S(X,1)
 S X="illnesses." D S(X)
 S X="" D S(X)  ;*17*
 D IMMFORC^BIRPC(.APCHIMM,APCHSDFN)
 I $E($G(APCHIMM),1,2)="No" S X="",$E(X,5)="You have all your immunizations.  That's Great!" D S(X)
 I $E($G(APCHIMM),1,2)="  " F APCHIMMN=1:1 S APCHIMMT=$P($P(APCHIMM,U,APCHIMMN),"|") Q:$G(APCHIMMT)']""  D
 .I $E(APCHIMMT,1,2)="  " S APCHIMMT=$E(APCHIMMT,3,99)
 .I $G(APCHIMMT)]"" S APCHI(APCHIMMN)=APCHIMMT
 .Q
 I $D(APCHI) S APCHICTR=0 D
 .F  S APCHICTR=$O(APCHI(APCHICTR)) Q:'APCHICTR  D
 ..Q:$L(APCHI(APCHICTR))<3
 ..S APCHIMDU=APCHICTR
 .I +$G(APCHIMDU)>0 S X=APCHIMDU_$S(APCHIMDU>1:" Immunizations Due:",1:" Immunization Due") D S(X,1)
 .F I=1:1:APCHIMDU S X="",$E(X,5)=APCHI(I) D S(X)
 .Q
 ;
MEAS ;
 S X="Weight is a good measure of health - and it depends on how tall you are." D S(X,1)
 S X="" D S(X)  ;*17*
 D GETHWBBP(APCHSDFN)
 ;Convert APCHX("HT") to ft & inches
 I $G(APCHX("HT"))]"" S APCHFEET=APCHX("HT")/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 I $G(APCHX("HT"))]"" S X="",$E(X,5)="You are "_APCHFEET_" feet and "_APCHINCH_" inches tall." D S(X)
 ;
 I $G(APCHX("WT"))="" S X="",$E(X,5)="No weight on file." D S(X)
 I $G(APCHX("HT"))']"" S X="",$E(X,5)="No height on file." D S(X)
 I $G(APCHX("WT"))]"" S X="",$E(X,5)="Your last weight was "_$J(APCHX("WT"),3,0)_" pounds on "_$$FMTE^XLFDT(APCHX("WTD"))_"." D S(X)
 I $G(APCHX("WT"))]"",$$FMDIFF^XLFDT(DT,APCHX("WTD"))>120 S X="",$E(X,5)="You should have your weight rechecked at your next visit"  D S(X)
 I $G(APCHX("WTD"))]"",APCHX("WTD")=DT,$G(APCHX("BMI"))]"" D
 .S X="",$E(X,5)="Your Body Mass Index today was "_APCHX("BMI")_".  This is a good way to" D S(X)
 .S X="",$E(X,5)="compare your height and weight." D S(X)
 .Q
 I $G(APCHX("WTD"))]"",APCHX("WTD")<DT,$G(APCHX("BMI"))]"" D
 .S X="",$E(X,5)="Your Body Mass Index on "_$$FMTE^XLFDT(APCHX("WTD"))_" was "_APCHX("BMI")_"." D S(X)
 .Q
 I $G(APCHX("BMI"))]"",APCHX("BMI")<25 S X="",$E(X,5)="You are at a healthy weight.  Keep up the good work!" D S(X)
 I APCHX("BMI")>26 D
 .S X="",$E(X,5)="You are above a healthy weight.  Too much weight can lead to lots" D S(X)
 .S X="",$E(X,5)="of health problems - diabetes, heart disease, back pain, leg pains," D S(X)
 .S X="",$E(X,5)="and more.  Ask your provider about things you can do to fix your weight." D S(X)
 .Q
 ;
 I $G(APCHX("BP"))]"" S APCHSBP=$P(APCHX("BP"),"/"),APCHDBP=$P(APCHX("BP"),"/",2),X="Blood pressure is a good measure of health." D S(X,1)
 S X="" D S(X)  ;*17*
 I $G(APCHX("BP"))]"" S X="",$E(X,5)="Your last blood pressure was "_APCHSBP_" over "_APCHDBP_" on "_$$FMTE^XLFDT(APCHX("BPD"))_"." D S(X) D
 .I $$AGE^AUPNPAT(APCHSDFN)>21,$$FMDIFF^XLFDT(DT,APCHX("BPD"))>365 S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 .I $$AGE^AUPNPAT(APCHSDFN)>3,$$AGE^AUPNPAT(APCHSDFN)<22,$$FMDIFF^XLFDT(DT,APCHX("BPD"))>720 S X="You should have your blood pressure checked at your next visit" D S(X)
 .Q
 I $$AGE^AUPNPAT(APCHSDFN)>21,$G(APCHX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 I $$AGE^AUPNPAT(APCHSDFN)>3,$$AGE^AUPNPAT(APCHSDFN)<22,$G(APCHX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
CKDP ;
 ;does pt have chronic kidney disease?
 D CKD
 I $G(APCHX("BP"))]"" S APCHHBP=0 D
 .I $G(APCHDBP)<80,$G(APCHSBP)<140 Q
 .I $G(APCHDBP)>90!($G(APCHSBP)>140) S APCHHBP=1 Q
 .I $$DMDX(APCHSDFN)="Yes",$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 .I $G(APCHCKD)=1,$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 I $G(APCHHBP)=0 S X="",$E(X,5)="Your blood pressure is good.  That's great news!" D S(X)
 I $G(APCHHBP)=1 D
 .S X="",$E(X,5)="Your blood pressure is too high. Easy ways to make it better are" D S(X)
 .S X="",$E(X,5)="eating healthy foods and walking or getting more physical activity." D S(X)
 .S X="",$E(X,5)="If you take medicine to lower your blood pressure, be sure to take" D S(X)
 .S X="",$E(X,5)="it every day." D S(X)
 .;S X="" D S(X)
 ;
ALLERG ;
 S X="Allergies, reactions that you've had to medicines or other things are very" D S(X,1)
 S X="important.  Below are the allergies that we know.  If anything is wrong or" D S(X)
 S X="missing, please let your provider know." D S(X)
 S X="" D S(X)
 S APCHSALD=0,APCHSALP=0,APCHSALG=0
 D EN^APCHPALG  ;get allergies from allergy tracking and problem list
 ;I $D(APCHENT) S X="",$E(X,5)="From Allergy Tracking System:",$E(X,45)="(v)=verified   (u)=unverified" D S(X)
 I $D(APCHENT) S X="",$E(X,5)="From Allergy Tracking System:" D S(X)
 I $D(APCHENT("A")) F  S APCHSALD=$O(APCHENT("A",APCHSALD)) Q:APCHSALD'=+APCHSALD  D
 .Q:$G(APCHSALD)']""
 .F  I $D(APCHENT("A")) S APCHSALP=$O(APCHENT("A",APCHSALD,APCHSALP)) Q:APCHSALP=""  Q:APCHSALD'=+APCHSALD  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("A",APCHSALD,APCHSALP)) D S(X)
 ..Q
 I $D(APCHENT("P")) F  S APCHSALD=$O(APCHENT("P",APCHSALD)) Q:APCHSALD'=+APCHSALD  D
 .Q:$G(APCHSALD)']""
 .F  I $D(APCHENT("P")) S APCHSALP=$O(APCHENT("P",APCHSALD,APCHSALP)) Q:APCHSALP=""  Q:APCHSALD'=+APCHSALD  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("P",APCHSALD,APCHSALP)) D S(X)
 ..Q
 I $D(APCHENT("U")) F  S APCHSALD=$O(APCHENT("U",APCHSALD)) Q:APCHSALD'=+APCHSALD  D
 .Q:$G(APCHSALD)']""
 .F  I $D(APCHENT("U")) S APCHSALP=$O(APCHENT("U",APCHSALD,APCHSALP)) Q:APCHSALP=""  Q:APCHSALD'=+APCHSALD  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("A",APCHSALD,APCHSALP)) D S(X)
 ..Q
 ; 
 S APCHSALD=0,APCHSALP=0,APCHSAPR=0
 D PROBA^APCHPALG  ;get allergies from Problem List
 I $D(APCHSPT) S X="",$E(X,5)="From Problem List" D S(X,1)
 I $D(APCHSPT) F  S APCHSALD=$O(APCHSPT(APCHSALD)) Q:APCHSALD'=+APCHSALD  D
 .S APCHSALP=$O(APCHSPT(APCHSALP))
 .Q:APCHSALP'=+APCHSALP
 .S APCHSAPR=1
 .S X="",$E(X,5)=$G(APCHSPT(APCHSALP)) D S(X)
 .Q
 I APCHSALG=0,APCHSAPR=0 S X="",$E(X,5)="No allergies on file." D S(X)
 ;
 D MEDS^APCHPMH3
 D CLOSE^APCHPMH3  ;CMI/GRL 12/3/07 *17*
 Q
CKD ;Does patient have chronic kidney disease (CKD)?
 S APCHCKD=0
 ;get last serum creatinine value
 S T=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0)) I $G(T)]"" S APCHLCRV=$$LAB^APCHPMH2(APCHSDFN,T),APCHLCRD=$P($G(APCHLCRV),"|||",2),APCHLCRV=$P($G(APCHLCRV),"|||") I $G(APCHLCRV)]"" D
 .I $$SEX^AUPNPAT(APCHSDFN)="F",APCHLCRV>1.3 S APCHCKD=1
 .I $$SEX^AUPNPAT(APCHSDFN)="M",APCHLCRV>1.5 S APCHCKD=1
 ;get last urine protein value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)) I $G(T)]"" S APCHLUPV=$$LAB^APCHPMH2(APCHSDFN,T),APCHLUPD=$P($G(APCHLUPV),"|||",2),APCHLUPV=$P($G(APCHLUPV),"|||") I $G(APCHLUPV)]"" D
 .I +APCHLUPV>200 S APCHCKD=1
 ;get last A/C ratio value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0)) I $G(T)]"" S APCHLACV=$$LAB^APCHPMH2(APCHSDFN,T),APCHLACD=$P($G(APCHLACV),"|||",2),APCHLACV=$P($G(APCHLACV),"|||") I $G(APCHLACV)]"" D
 .I +APCHLACV>200 S APCHCKD=1
 ;get estimated GFR
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0)) I $G(T)]"" S APCHLEGV=$$LAB^APCHPMH2(APCHSDFN,T),APCHLEGD=$P($G(APCHLEGV),"|||",2),APCHLEGV=$P($G(APCHLEGV),"|||") I $G(APCHLEGV)]"" D
 .I APCHLEGV<60 S APCHCKD=1
 Q
 ;
 ;
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
 S %=$P(^TMP("APCHPHS",$J,"PMH",0),U)+1,$P(^TMP("APCHPHS",$J,"PMH",0),U)=%
 S ^TMP("APCHPHS",$J,"PMH",%)=X
 Q
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
GETHWBBP(P)  ;get last height, height date, weight, weight date, BMI and BP for patient P, return in APCHX("HT"),APCHX("HTD"),APCHX("WT"),APCHX("WTD"),APCHX("BMI")
 K APCHX
 S APCHX("HT")="",APCHX("HTD")="",APCHX("WT")="",APCHX("WTD")="",APCHX("BMI")="",APCHX("WC")="",APCHX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW APCHY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("HT")=$P($G(APCHY(1)),U,2),APCHX("HTD")=$P($G(APCHY(1)),U)
 S APCHX("HT")=$S(APCHX("HT")]"":$J(APCHX("HT"),2,0),1:"")
LASTWT ;
 K APCHY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("WT")=$P($G(APCHY(1)),U,2),APCHX("WTD")=$P($G(APCHY(1)),U)
LASTBP ;
 K APCHY S %=P_"^LAST MEAS BP" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("BP")=$P($G(APCHY(1)),U,2),APCHX("BPD")=$P($G(APCHY(1)),U)
LASTWC ;
 K APCHY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("WC")=$P($G(APCHY(1)),U,2),APCHX("WCD")=$P($G(APCHY(1)),U)
BMI ;
 I $$AGE^AUPNPAT(P)<19,(APCHX("WTD")'=APCHX("HTD")) Q
 I APCHX("WT")=""!('APCHX("HT")) Q
 S %=""
 S W=APCHX("WT")*.45359,H=(APCHX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S APCHX("BMI")=%
 Q
 ;
DMDX(P) ;
  ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCHX
 S APCHX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"APCHX(") G:E DMX I $D(APCHX(3)) S APCHX="Yes"
 I $G(APCHX)="" S APCHX="No"
DMX ;
 Q APCHX
 ;
