BHSPMH3 ;IHS/MSC/MGH - Health Summary for Patient wellness handout ;16-Jan-2009 14:46;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;March 17,2006
 ;===================================================================
 ;Taken from APCHPMH1 routine
 ;
EP(BHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("BHSPHS",$J,"PMH"
 K ^TMP("BHSPHS",$J,"PMH")
 S ^TMP("BHSPHS",$J,"PMH",0)=0
 N BHSVSIT,BHSPROV,X,Y
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="Report Date:  "_GMTSDTM D S(X)
 S X=$P($P(^DPT(BHSDFN,0),U),",",2)_" "_$P($P(^DPT(BHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(BHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,2)
 I $G(BHSVSIT)]"",$D(^AUPNVSIT("AC",BHSDFN,BHSVSIT)) S BHSPROV=$$PRIMPROV^APCLV(BHSVSIT)
 S X=$$VAL^XBDIQ1(2,BHSDFN,.111),$E(X,50)=$S($G(BHSPROV)]"":BHSPROV,1:$$VAL^XBDIQ1(9000001,BHSDFN,.14)) D S(X)  ;GARY - ADD CHECK FOR CURRENT VISIT PROVIDER
 S X=$$VAL^XBDIQ1(2,BHSDFN,.114)_$S($$VAL^XBDIQ1(2,BHSDFN,.114)]"":",  ",1:" ")_$$VAL^XBDIQ1(2,BHSDFN,.115)_"   "_$$VAL^XBDIQ1(2,BHSDFN,.116),Y=$P(^AUTTLOC(DUZ(2),0),U,11),$E(X,50)=Y D S(X)
 S X=$$VAL^XBDIQ1(2,BHSDFN,.131) D S(X)
 S X="Hello "_$S($$SEX^AUPNPAT(BHSDFN)="M":"Mr. ",1:"Ms. ")_$E($P($P(^DPT(BHSDFN,0),U),","))_$$LOW^XLFSTR($E($P($P(^DPT(BHSDFN,0),U),","),2,99))_"," D S(X,1)
 S X="Thank you for choosing "_$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U))_"." D S(X,1)
 S X="This sheet is a new way for you and your doctor to look at your health." D S(X,1)
IMMUN ;
 N APCHIMM,APCHIMMT,APCHIMMN,X,APCHI,APCHICTR,APCHIMDU
 S X="Immunizations(shots).  Getting shots protects you from some diseases and"  D S(X,1)
 S X="illnesses." D S(X)
 D IMMFORC^BIRPC(.APCHIMM,BHSDFN)
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
 N BHSX,APCHFEET,APCHINCH,X,APCHSBP,APCHDBP,APCHHBP,E,H,W
 S X="Weight is a good measure of health - and it depends on how tall you are." D S(X,1)
 D GETHWBBP(BHSDFN)
 ;Convert BHSX("HT") to ft & inches
 I $G(BHSX("HT"))]"" S APCHFEET=BHSX("HT")/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 I $G(BHSX("HT"))]"" S X="",$E(X,5)="You are "_APCHFEET_" feet and "_APCHINCH_" inches tall." D S(X)
 ;
 I $G(BHSX("WT"))="" S X="",$E(X,5)="No weight on file." D S(X)
 I $G(BHSX("HT"))']"" S X="",$E(X,5)="No height on file." D S(X)
 I $G(BHSX("WT"))]"" S X="",$E(X,5)="Your last weight was "_$J(BHSX("WT"),3,0)_" pounds on "_$$FMTE^XLFDT(BHSX("WTD"))_"." D S(X)
 I $G(BHSX("WT"))]"",$$FMDIFF^XLFDT(DT,BHSX("WTD"))>120 S X="",$E(X,5)="You should have your weight rechecked at your next visit"  D S(X)
 I $G(BHSX("WTD"))]"",BHSX("WTD")=DT,$G(BHSX("BMI"))]"" D
 .S X="",$E(X,5)="Your Body Mass Index today was "_BHSX("BMI")_".  This is a good way to" D S(X)
 .S X="",$E(X,5)="compare your height and weight." D S(X)
 .Q
 I $G(BHSX("WTD"))]"",BHSX("WTD")<DT,$G(BHSX("BMI"))]"" D
 .S X="",$E(X,5)="Your Body Mass Index on "_$$FMTE^XLFDT(BHSX("WTD"))_" was "_BHSX("BMI")_"." D S(X)
 .Q
 I $G(BHSX("BMI"))]"",BHSX("BMI")<25 S X="",$E(X,5)="You are at a healthy weight.  Keep up the good work!" D S(X)
 I BHSX("BMI")>26 D
 .S X="",$E(X,5)="You are above a healthy weight.  Too much weight can lead to lots" D S(X)
 .S X="",$E(X,5)="of health problems - diabetes, heart disease, back pain, leg pains," D S(X)
 .S X="",$E(X,5)="and more.  Ask your provider about things you can do to fix your weight." D S(X)
 .Q
 ;
 I $G(BHSX("BP"))]"" S APCHSBP=$P(BHSX("BP"),"/"),APCHDBP=$P(BHSX("BP"),"/",2),X="Blood pressure is a good measure of health." D S(X,1)
 I $G(BHSX("BP"))]"" S X="",$E(X,5)="Your last blood pressure was "_APCHSBP_" over "_APCHDBP_" on "_$$FMTE^XLFDT(BHSX("BPD"))_"." D S(X) D
 .I $$AGE^AUPNPAT(BHSDFN)>21,$$FMDIFF^XLFDT(DT,BHSX("BPD"))>365 S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 .I $$AGE^AUPNPAT(BHSDFN)>3,$$AGE^AUPNPAT(BHSDFN)<22,$$FMDIFF^XLFDT(DT,BHSX("BPD"))>720 S X="You should have your blood pressure checked at your next visit" D S(X)
 .Q
 I $$AGE^AUPNPAT(BHSDFN)>21,$G(BHSX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 I $$AGE^AUPNPAT(BHSDFN)>3,$$AGE^AUPNPAT(BHSDFN)<22,$G(BHSX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
CKDP ;
 ;does pt have chronic kidney disease?
 D CKD
 I $G(BHSX("BP"))]"" S APCHHBP=0 D
 .I $G(APCHDBP)<80,$G(APCHSBP)<140 Q
 .I $G(APCHDBP)>90!($G(APCHSBP)>140) S APCHHBP=1 Q
 .I $$DMDX(BHSDFN)="Yes",$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 .I $G(APCHCKD)=1,$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 I $G(APCHHBP)=0 S X="",$E(X,5)="Your blood pressure is good.  That's great news!" D S(X)
 I $G(APCHHBP)=1 D
 .S X="",$E(X,5)="Your blood pressure is too high. Easy ways to make it better are" D S(X)
 .S X="",$E(X,5)="eating healthy foods and walking or getting more physical activity." D S(X)
 .S X="",$E(X,5)="If you take medicine to lower your blood pressure, be sure to take" D S(X)
 .S X="",$E(X,5)="it every day." D S(X)
 ;
ALLERG ;
 S X="Allergies, reactions that you've had to medicines or other things are very" D S(X,1)
 S X="important.  Below are the allergies that we know.  If anything is wrong or" D S(X)
 S X="missing, please let your provider know." D S(X)
 S X="" D S(X)
 N APCHENT,APCHSPT,APCHALG,APCHSALD,APCHSALP,APCHSAPR,APCHSALG,APCHSP
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
MEDS ;
 N X,APCHSDLM,APCHSIVD,APCHSMCT,APCHSM,APCHSMED,APCHSIG,APCHSMX,APCHSMCT,APCHSQ,APCHSSGY
 N J,APCHMFX,APCHSMFX,APCHLUPD,APCHHM,APCHHMED
 S X="Medicines are important - it helps to know" D S(X,1)
 S X="",$E(X,5)="Why you will take it?" D S(X)
 S X="",$E(X,5)="When to take it?" D S(X)
 S X="",$E(X,5)="How much to take?"  D S(X)
 S X="",$E(X,5)="What to do if you forget to take it?"  D S(X)
 S X="",$E(X,5)="What could happen if you forget or take too much."  D S(X)
 S X="Knowing these things will help the medicine work best for you." D S(X)
 S X="Here is a list of the medicines you are taking:"  D S(X)
 S X="" D S(X)
 ;
 ;get all "active" meds
 S APCHSDLM=$$FMADD^XLFDT(DT,-365),APCHSDLM=9999999-APCHSDLM
 S APCHSIVD=0,APCHSMCT=0 F APCHSQ=0:0 S APCHSIVD=$O(^AUPNVMED("AA",BHSDFN,APCHSIVD)) Q:APCHSIVD=""!(APCHSIVD>APCHSDLM)  S APCHSMX=0 F APCHSQ=0:0 S APCHSMX=$O(^AUPNVMED("AA",BHSDFN,APCHSIVD,APCHSMX)) Q:APCHSMX=""  D MEDBLD^BHSPMH1A
 I $G(APCHSMCT)=0 S X="",$E(X,5)="No current meds on file" D S(X)
 S APCHSMED=""
 F  S APCHSMED=$O(APCHSM(APCHSMED)) Q:$G(APCHSMED)']""  D
 .S X="",$E(X,5)=APCHSMED D S(X)
 .;S X="",$E(X,7)="Directions: "_$P($G(APCHSM(APCHSMED)),U,5) D S(X)  ;sig
 .K ^UTILITY($J,"W") S APCHSIG=$P($G(APCHSM(APCHSMED)),U,5),X=APCHSIG,DIWL=0,DIWR=58 D ^DIWP
 .S X="",$E(X,7)="Directions: "_$G(^UTILITY($J,"W",0,1,0)) D S(X)
 .I $G(^UTILITY($J,"W",0))>1 F I=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,7)=$G(^UTILITY($J,"W",0,I,0)) D S(X)
 .K ^UTILITY($J,"W")
 .Q
 D HOLD
 I '$D(APCHHM) Q
 S X="Medications ordered, but not yet dispensed" D S(X,1)
 S X="" D S(X)
 S APCHHMED=""
 F  S APCHHMED=$O(APCHHM(APCHHMED)) Q:$G(APCHHMED)']""  D
 .S X="",$E(X,5)=APCHHMED D S(X)
 Q
CKD ;Does patient have chronic kidney disease (CKD)?
 N APCHCKD,APCHLUPV,APCHLACV,APCHLEGV,APCHLACD,APCHLCRD,APCHLCRV,APCHLEGD
 S APCHCKD=0
 ;get last serum creatinine value
 S T=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0)) I $G(T)]"" S APCHLCRV=$$LAB^BHSPMH2(BHSDFN,T),APCHLCRD=$P($G(APCHLCRV),"|||",2),APCHLCRV=$P($G(APCHLCRV),"|||") I $G(APCHLCRV)]"" D
 .I $$SEX^AUPNPAT(BHSDFN)="F",APCHLCRV>1.3 S APCHCKD=1
 .I $$SEX^AUPNPAT(BHSDFN)="M",APCHLCRV>1.5 S APCHCKD=1
 ;get last urine protein value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)) I $G(T)]"" S APCHLUPV=$$LAB^BHSPMH2(BHSDFN,T),APCHLUPD=$P($G(APCHLUPV),"|||",2),APCHLUPV=$P($G(APCHLUPV),"|||") I $G(APCHLUPV)]"" D
 .I +APCHLUPV>200 S APCHCKD=1
 ;get last A/C ratio value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0)) I $G(T)]"" S APCHLACV=$$LAB^BHSPMH2(BHSDFN,T),APCHLACD=$P($G(APCHLACV),"|||",2),APCHLACV=$P($G(APCHLACV),"|||") I $G(APCHLACV)]"" D
 .I +APCHLACV>200 S APCHCKD=1
 ;get estimated GFR
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0)) I $G(T)]"" S APCHLEGV=$$LAB^BHSPMH2(BHSDFN,T),APCHLEGD=$P($G(APCHLEGV),"|||",2),APCHLEGV=$P($G(APCHLEGV),"|||") I $G(APCHLEGV)]"" D
 .I APCHLEGV<60 S APCHCKD=1
 Q
 ;
RXSTAT ; EP gets status of rx ... TAKEN FROM PSOFUNC ROUTINE
 Q:$D(^PSRX(APCHSRXP,"STA"))  ;USING V7
 Q:$G(APCHSRXP)'>0
 S J=APCHSRXP
 S ST0=+$P(RX0,"^",15) I ST0<12,$O(^PS(52.5,"B",J,0)),$D(^PS(52.5,+$O(^(0)),0)),'$G(^("P")) S ST0=5
 I ST0<12,$P(RX2,"^",6),$P(RX2,"^",6)'>DT S ST0=11
 S ST=$P("ERROR^ACTIVE^NON-VERIFIED^REFILL FILL^HOLD^PENDING DUE TO DRUG INTERACTION^SUSPENDED^^^^^DONE^EXPIRED^CANCELLED^DELETED","^",ST0+2),$P(RX0,"^",15)=ST0
 Q
 ;
 ;
HOLD ;Now get meds in Pharmacy yet to be completed
 Q:'BHSDFN
 N APCHNMED,APCHSDT
 S APCHSDT=DT
 F  S APCHSDT=$O(^PS(55,BHSDFN,"P","A",APCHSDT)) Q:APCHSDT'=+APCHSDT  D
 .S APCHNMED=0 F  S APCHNMED=$O(^PS(55,BHSDFN,"P","A",APCHSDT,APCHNMED)) Q:'APCHNMED  D
 ..I $G(^PSRX(APCHNMED,"STA"))=3!($G(^PSRX(APCHNMED,"STA"))=5) D
 ...S APCHHMED=$P(^PSRX(APCHNMED,0),U,6) I $G(APCHHMED)]"" S APCHHMED=$P(^PSDRUG(APCHHMED,0),U)
 ...S APCHHM(APCHHMED)=APCHNMED
 ..Q
 Q
 ;
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
 S %=$P(^TMP("BHSPHS",$J,"PMH",0),U)+1,$P(^TMP("BHSPHS",$J,"PMH",0),U)=%
 S ^TMP("BHSPHS",$J,"PMH",%)=X
 Q
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
GETHWBBP(P) ;get last height, height date, weight, weight date, BMI and BP for patient P, return in BHSX("HT"),BHSX("HTD"),BHSX("WT"),BHSX("WTD"),BHSX("BMI")
 K BHSX
 S BHSX("HT")="",BHSX("HTD")="",BHSX("WT")="",BHSX("WTD")="",BHSX("BMI")="",BHSX("WC")="",BHSX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW BHSY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("HT")=$P($G(BHSY(1)),U,2),BHSX("HTD")=$P($G(BHSY(1)),U)
 S BHSX("HT")=$S(BHSX("HT")]"":$J(BHSX("HT"),2,0),1:"")
LASTWT ;
 K BHSY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("WT")=$P($G(BHSY(1)),U,2),BHSX("WTD")=$P($G(BHSY(1)),U)
LASTBP ;
 K BHSY S %=P_"^LAST MEAS BP" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("BP")=$P($G(BHSY(1)),U,2),BHSX("BPD")=$P($G(BHSY(1)),U)
LASTWC ;
 K BHSY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("WC")=$P($G(BHSY(1)),U,2),BHSX("WCD")=$P($G(BHSY(1)),U)
BMI ;
 I $$AGE^AUPNPAT(P)<19,(BHSX("WTD")'=BHSX("HTD")) Q
 I BHSX("WT")=""!('BHSX("HT")) Q
 S %=""
 S W=BHSX("WT")*.45359,H=(BHSX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S BHSX("BMI")=%
 Q
 ;
DMDX(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW BHSX
 S BHSX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"BHSX(") G:E DMX I $D(BHSX(3)) S BHSX="Yes"
 I $G(BHSX)="" S BHSX="No"
DMX ;
 Q BHSX
 ;
