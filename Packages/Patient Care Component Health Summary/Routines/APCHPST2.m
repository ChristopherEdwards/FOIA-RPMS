APCHPST2 ; IHS/CMI/LAB - Patient Health Summary - Post Visit ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
EP ;EP - meds/ allergies/ measurements
MEDS ; 
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
 S APCHSIVD=0,APCHSMCT=0 F APCHSQ=0:0 S APCHSIVD=$O(^AUPNVMED("AA",APCHSDFN,APCHSIVD)) Q:APCHSIVD=""!(APCHSIVD>APCHSDLM)  S APCHSMX=0 F APCHSQ=0:0 S APCHSMX=$O(^AUPNVMED("AA",APCHSDFN,APCHSIVD,APCHSMX)) Q:APCHSMX=""  D MEDBLD
 I $G(APCHSMCT)=0 S X="",$E(X,5)="No current meds on file" D S(X)
 S APCHSMED=""
 F  S APCHSMED=$O(APCHSM(APCHSMED)) Q:$G(APCHSMED)']""  D
 .S X="",$E(X,10)=APCHSMED D S(X)
 .Q
 S X="Some other questions to ask your doctor, nurse or pharmacist about" D S(X,1)
 S X="your medications:" D S(X)
 S X="",$E(X,5)="Each medicine has 2 names -- the company name and a generic name" D S(X)
 S X="",$E(X,5)="of the ingredient."  D S(X)
 S X="",$E(X,5)="What is the medicine supposed to do?" D S(X)
 S X="",$E(X,5)="When should I see or feel that the medicine is working?" D S(X)
 S X="",$E(X,5)="What are things that I might see or feel, called side effects?" D S(X)
 S X="",$E(X,5)="What should I do if they occur?"  D S(X)
 S X="",$E(X,5)="Is the medicine for just a short time -- days or weeks -- or months/years?"  D S(X)
 S X="",$E(X,5)="Are there any foods, drinks, other medicines, dietary supplements that"  D S(X)
 S X="",$E(X,5)="will keep the medicine from working or make it dangerous?" D S(X)
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
MEAS ;
 S X="Weight is a good measure of health - and it depends on how tall you are." D S(X,1)
 D GETHWBBP(APCHSDFN)
 ;Convert APCHX("HT") to ft & inches
 I $G(APCHX("HT"))]"" S APCHFEET=APCHX("HT")/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 I $G(APCHX("HT"))]"" S X="",$E(X,5)="You are "_APCHFEET_" feet and "_APCHINCH_" inches tall." D S(X)
 ;
 I $G(APCHX("WT"))="" S X="",$E(X,5)="No weight on file." D S(X)
 I $G(APCHX("HT"))']"" S X="",$E(X,5)="No height on file." D S(X)
 I $G(APCHX("WT"))]"" S X="",$E(X,5)="Your last weight is "_$J(APCHX("WT"),3,0)_" pounds." D S(X)
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
 I $G(APCHX("BP"))]"" S X="",$E(X,5)="Your last blood pressure was "_APCHSBP_" over "_APCHDBP_" on "_$$FMTE^XLFDT(APCHX("BPD"))_"." D S(X) D
 .I $$AGE^AUPNPAT(APCHSDFN)>21,$$FMDIFF^XLFDT(DT,APCHX("BPD"))>365 S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 .I $$AGE^AUPNPAT(APCHSDFN)>3,$$AGE^AUPNPAT(APCHSDFN)<22,$$FMDIFF^XLFDT(DT,APCHX("BPD"))>720 S X="You should have your blppd pressure checked at your next visit" D S(X)
 .Q
 I $$AGE^AUPNPAT(APCHSDFN)>21,$G(APCHX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
 I $$AGE^AUPNPAT(APCHSDFN)>3,$$AGE^AUPNPAT(APCHSDFN)<22,$G(APCHX("BP"))']"" S X="Blood pressure is a good measure of health." D S(X,1) S X="",$E(X,5)="You should have your blood pressure checked at your next visit." D S(X)
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
 S %=$P(^TMP("APCHPHS",$J,"PHS",0),U)+1,$P(^TMP("APCHPHS",$J,"PHS",0),U)=%
 S ^TMP("APCHPHS",$J,"PHS",%)=X
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
MEDBLD ;BUILD ARRAY OF MEDICATIONS 
 ;
 K APCHSRXP,APCHSCOT
 Q:'$D(^AUPNVMED(APCHSMX,0))
 S APCHSN=^AUPNVMED(APCHSMX,0)
 Q:'$D(^PSDRUG($P(APCHSN,U,1)))
 S APCHSDTM=-APCHSIVD\1+9999999  ;Visit date from V Med .03 field
 Q:$P(APCHSN,U,8)]""  ;date discontinued
 S APCHSRXP=$S($D(^PSRX("APCC",APCHSMX)):$O(^(APCHSMX,0)),1:0)  ;RX IEN
 I APCHSRXP>0 S RX0=^PSRX(APCHSRXP,0),RX2=^PSRX(APCHSRXP,2) D RXSTAT Q:ST="EXPIRED"!(ST="CANCELLED")!(ST="DELETED")  ;CALCULATE RX STATUS
 I $G(APCHSRXP)'>0 S APCHSCOT=1  ;may be using COTS or med entered via PCC data entry
 I $P($G(^AUPNVMED(APCHSMX,12)),U,9)]"" S APCHSCOT=1  ;external key present
 S APCHSSTA=$P($G(^PSRX(APCHSRXP,0)),U,15)  ;Active? RX File status
 Q:$G(APCHSSTA)>10  ;status is expired, deleted or cancelled
 S APCHSDYS=$P($G(APCHSN),U,7)  ;days supply
 ;Q:APCHSDYS=1  ;quit if only 1 day supply
 I $G(APCHSCOT)=1,$G(APCHSDYS)]"",$$FMDIFF^XLFDT(DT,APCHSDTM)>$G(APCHSDYS) Q
 Q:$P($G(^AUPNVMED(APCHSMX,0)),U,6)=1  ;quit if qty=1
 S APCHSMFX=$P(^PSDRUG(+APCHSN,0),U)  D  ;compare Drug File .01 field & V Med Name of Non Table Drug
 .Q:$P(APCHSN,U,4)=""
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)=$P(^PSDRUG(+APCHSN,0),U) Q
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)'=$P(^PSDRUG(+APCHSN,0),U) S APCHSMFX=$P(APCHSN,U,4)
 .Q
 I $G(APCHSM(APCHSMFX)) Q  ;quit if med already exists
 S APCHSM(APCHSMFX)=+APCHSN_U_APCHSDYS  ;PSDRUG ien^days supply
 I $G(APCHSRXP)>0 S $P(APCHSM(APCHSMFX),U,3)=APCHSRXP  ;^PSRX ien
 S $P(APCHSM(APCHSMFX),U,4)=$G(ST)  ;status from RXSTAT
 S APCHSMCT=APCHSMCT+1  ;number of active meds
 Q
 ;
GETLABSX ;get lab tests ordered today
 ;
 S APCHLR=$G(^DPT(APCHSDFN,"LR"))
 I $G(APCHLR)]"" S APCHLRO=0,APCHTSTP=0 D
 .F  S APCHLRO=$O(^LRO(69,DT,1,"AA",APCHLR,APCHLRO)) Q:APCHLRO=""  Q:APCHLRO'=+APCHLRO  D
 ..F  S APCHTSTP=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP)) Q:APCHTSTP'=+APCHTSTP  D
 ...S APCHTCTR=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP,0))
 ...S APCHTEST=$P(^LAB(60,APCHTSTP,0),U)
 ...S APCHTST(APCHTEST)=""
 ...Q
 ;
 ;
RXSTAT ;gets status of rx ... TAKEN FROM PSOFUNC ROUTINE
 Q:$G(APCHSRXP)'>0
 S J=APCHSRXP
 S ST0=+$P(RX0,"^",15) I ST0<12,$O(^PS(52.5,"B",J,0)),$D(^PS(52.5,+$O(^(0)),0)),'$G(^("P")) S ST0=5
 I ST0<12,$P(RX2,"^",6)'>DT S ST0=11
 S ST=$P("ERROR^ACTIVE^NON-VERIFIED^REFILL FILL^HOLD^PENDING DUE TO DRUG INTERACTION^SUSPENDED^^^^^DONE^EXPIRED^CANCELLED^DELETED","^",ST0+2),$P(RX0,"^",15)=ST0
 Q
