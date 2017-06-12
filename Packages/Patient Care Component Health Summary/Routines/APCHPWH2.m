APCHPWH2 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**4,6,7,8,10,11**;MAY 14, 2009;Build 58
 ;
ASK3 ;EP - called from pwh
 D SUBHEAD^APCHPWHU
 NEW X,T,J
 S T="ASK3T" F J=1:1 S X=$T(@T+J) Q:$P(X,";;",2)="ENDTEXT"  D S^APCHPWH1($P(X,";;",2))
 Q
 ;
ACTLEVEL ;EP - calld from pwh
 NEW APCHX
 S APCHX=$$LASTHF^APCHSMU(DFN,"ACTIVITY LEVEL","N")
 I APCHX="" Q
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("ACTIVITY LEVEL - ")
 I APCHX="VERY ACTIVE" D  Q
 .D S^APCHPWH1("Your level of physical activity is outstanding!  You are working hard")
 .D S^APCHPWH1("and it shows.  Keep up the good work and stay on track.")
 I APCHX="ACTIVE" D  Q
 .D S^APCHPWH1("Your level of physical activity is excellent!  Increasing your physical")
 .D S^APCHPWH1("activity level to 60 minutes each day (about 300 minutes each week) helps ")
 .D S^APCHPWH1("you get even more health benefits.")
 I APCHX="SOME ACTIVITY" D  Q
 .D S^APCHPWH1("Increasing your physical activity to 30 minutes each day (about 150 minutes")
 .D S^APCHPWH1("each week) helps you gain even more health benefits. Now you are on the way ")
 .D S^APCHPWH1("to losing weight and better health.")
 I APCHX="INACTIVE" D  Q
 .D S^APCHPWH1("Increasing your physical activity to 10 minutes each day helps you get")
 .D S^APCHPWH1("more energy, lowers stress, and helps to improve your strength. Being")
 .D S^APCHPWH1("active will help you feel better.")
 Q
 ;
ALLERGY ;EP - allergies component
 D SUBHEAD^APCHPWHU
 NEW APCHSPT,APCHENT,APCHX
 NEW APCHVER,APCHNN,APCRNUM,APCHREC,APCHALG,APCHENT,APCHCNT,APCHDATA,APCHDRUG,APCHMEC,APCHPIEN,APCHQ,APCHSNKA,APCHSP,APCHSLEN
 NEW D,P
 K APCHENT,APCHALG,APCHSALG,APCHSAPR
 I "PB"[$P(^APCHPWHT(APCHPWHT,1,APCHSORD,0),U,3) D PROBA^APCHPALG  ;get allergies from Problem List
 I "AB"[$P(^APCHPWHT(APCHPWHT,1,APCHSORD,0),U,3) D EN^APCHPALG  ;get allergies from allergy tracking
 D S^APCHPWH1("ALLERGIES - It is important to know what allergies and side effects you")
 D S^APCHPWH1("have to medicines or foods.  Below is a list of allergies that we know of.")
 D S^APCHPWH1("Please tell us if there are any that we missed.")
 D S^APCHPWH1(" ")
 I '$D(APCHSPT),'$D(APCHENT) S X="Allergies - No allergies are on file.  Please tell us if there are any that" D S^APCHPWH1(X) S X="we missed." D S^APCHPWH1(X) D ALLERGYX Q
 S (D,P)=0
 I $D(APCHENT("A")) F  S D=$O(APCHENT("A",D)) Q:D'=+D  D
 .Q:$G(D)']""
 .S P="" F  S P=$O(APCHENT("A",D,P)) Q:P=""  Q:D'=+D  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("A",D,P)) D S^APCHPWH1(X)
 ..Q
 I $D(APCHENT("P")) S D=0 F  S D=$O(APCHENT("P",D)) Q:D'=+D  D
 .Q:$G(D)']""
 .S P="" F  S P=$O(APCHENT("P",D,P)) Q:P=""  Q:D'=+D  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("P",D,P)) D S^APCHPWH1(X)
 ..Q
 I $D(APCHENT("U")) S D=0 F  S D=$O(APCHENT("U",D)) Q:D'=+D  D
 .Q:$G(D)']""
 .S P=0 F  I $D(APCHENT("U")) S P=$O(APCHENT("U",D,P)) Q:P=""  Q:D'=+D  D
 ..S APCHSALG=1
 ..S X="",$E(X,5)=$G(APCHENT("A",D,P)) D S^APCHPWH1(X)
 ..Q
 ; 
 S D=0,P=0,APCHSAPR=0
 D S^APCHPWH1(" ")
 F  S D=$O(APCHSPT(D)) Q:D'=+D  D
 .S P=$O(APCHSPT(P))
 .Q:P'=+P
 .S APCHSAPR=1
 .S X="",$E(X,5)=$G(APCHSPT(P)) D S^APCHPWH1(X)
 .Q
ALLERGYX ;
 K APCHVER,APCHNN,APCRNUM,APCHREC,APCHALG,APCHENT,APCHCNT,APCHDATA,APCHDRUG,APCHMEC,APCHPIEN,APCHQ,APCHSNKA,APCHSP,APCHSLEN
 Q
ASK3T ;;
 ;;ASK ME 3 - Every time you talk with a doctor, nurse, pharmacist, or other
 ;;health care worker, use the Ask Me 3 questions to better understand your 
 ;;health.  Make sure you know the answers to these three questions:
 ;;1.  What is my main problem?
 ;;2.  What do I need to do?
 ;;3.  Why is it important for me to do this?
 ;;ENDTEXT
 ;
IMMUNDUE ;EP - immunizations due
 NEW APCHIMM,APCHI
 K APCHIMM,APCH31,APCHBIER
 S APCHIMM=""
 S APCH31=$C(31)_$C(31)
 D IMMFORC^BIRPC(.APCHIMM,APCHSDFN)
 S APCHBIER=$P(APCHIMM,APCH31,2)
 I APCHBIER]"" D SUBHEAD^APCHPWHU,S^APCHPWH1("IMMUNIZATIONS (shots).  Ask your doctor if you are due for any immunizations.",1) K APCHIMM,APCHBIER,APCH31 Q
 D SUBHEAD^APCHPWHU
 I $E($G(APCHIMM),1,2)="No" S X="IMMUNIZATIONS (shots) NEEDED.  Getting shots protects you from some diseases" D S^APCHPWH1(X) D S^APCHPWH1("and illnesses.  Your immunizations are up to date.") Q
 I $E($G(APCHIMM),1,2)="  " F APCHIMMN=1:1 S APCHIMMT=$P($P(APCHIMM,U,APCHIMMN),"|") Q:$G(APCHIMMT)']""  D
 .I $E(APCHIMMT,1,2)="  " S APCHIMMT=$E(APCHIMMT,3,99)
 .I $G(APCHIMMT)]"" S APCHI(APCHIMMN)=APCHIMMT
 .Q
 I $D(APCHI) S APCHICTR=0 D
 .F  S APCHICTR=$O(APCHI(APCHICTR)) Q:'APCHICTR  D
 ..Q:$L(APCHI(APCHICTR))<3
 ..S APCHIMDU=APCHICTR
 .I +$G(APCHIMDU)>0 S X=APCHIMDU_$S(APCHIMDU>1:" Immunizations Due:",1:" Immunization Due") D S^APCHPWH1(X,1)
 .F I=1:1:APCHIMDU S X="",$E(X,5)=APCHI(I) D S^APCHPWH1(X)
 .Q
 Q
 ;
IMMUNREC ;EP - immunizations received
 N APCHSARR,APCH31,APCHBIER,APCHBIDE
 S APCHSARR=""
 S APCH31=$C(31)_$C(31),APCHSARR=""
 NEW APCHBIDE,I F I=4,26,27,60,33,44,57 S APCHBIDE(I)=""
 D IMMHX^BIRPC(.APCHSARR,APCHSDFN,.APCHBIDE)
 S APCHBIER=$P(APCHSARR,APCH31,2)
 I APCHBIER]"" K APCHSARR,APCHBIDE,APCHBIER,APCH31 D VIMMDISP Q
 S APCHSARR=$P(APCHSARR,APCH31,1)
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("IMMUNIZATION (shot) RECORD - It is important to keep track of your"),S^APCHPWH1("immunizations.")
 I $P(APCHSARR,U,1)["NO RECORDS" D S^APCHPWH1("No immunizations on file.") Q
 D S^APCHPWH1("You received the following immunization(s):")
 NEW APCHI,APCHV,APCHX,APCHY,APCHZ
 S APCHZ="",APCHV="|"
 F APCHI=1:1 S APCHY=$P(APCHSARR,U,APCHI) Q:APCHY=""  D
 .Q:$P(APCHY,APCHV)'="I"
 .I $P(APCHY,APCHV,4)'=APCHZ D S^APCHPWH1(" ") S APCHZ=$P(APCHY,APCHV,4)
 .S X="",$E(X,3)=$P(APCHY,APCHV,2)_" on "_$P(APCHY,APCHV,8) D S^APCHPWH1(X)
 .Q
 Q
 ;
VIMMDISP ;
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("IMMUNIZATION (shot) RECORD - It is important to keep track of your"),S^APCHPWH1("immunizations.")
 NEW X,Y,Z,D,V
 K Z
 S X=0 F  S X=$O(^AUPNVIMM("AC",APCHSDFN,X)) Q:X'=+X  D
 .S Y=$$VAL^XBDIQ1(9000010.11,X,.01)
 .S V=$$VALI^XBDIQ1(9000010.11,X,.03)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .S D=$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))
 .S Z(Y,D)=""
 I '$D(Z) D S^APCHPWH1("You have no immunizations on file.") Q
 D S^APCHPWH1("You received the following immunizations(s):")
 S X="" F  S X=$O(Z(X)) Q:X=""  S Y="" F  S Y=$O(Z(X,Y)) Q:Y=""  S D="",$E(D,5)=Y,$E(D,22)=X D S^APCHPWH1(X)
 Q
 ;
HTWTBMI ;EP - ht/wt/bmi component
 I $$AGE^AUPNPAT(APCHSDFN,DT)>12,$$AGE^AUPNPAT(APCHSDFN,DT)<19 D ADOLHTWT^APCHPWH8 Q  ;adolescent
 I $$AGE^AUPNPAT(APCHSDFN,DT)<13 D PEDHTWT^APCHPWH8 Q  ;pediatric
 ;GET LAST VISIT THAT IS A,O,H
 I $$LASTVPP(APCHSDFN,$$FMADD^XLFDT(DT,-(30*3)),DT) Q  ;last visit dx was pregnancy
 D SUBHEAD^APCHPWHU
 NEW APCHHT,APCHWT,APCHAGE,APCHNOBM,APCHHTA,APCHWTA,APCHFEET,APCHINCH,APCHHTNG,APCHWTNG,APCLBMI
 S APCHNOBM=0,APCHHTNG=0,APCHWTNG=0
 D S^APCHPWH1("HEIGHT/WEIGHT/BMI - Weight and Body Mass Index are good measures of your ")
 D S^APCHPWH1("health.  Determining a healthy weight and Body Mass Index also depends on")
 D S^APCHPWH1("how tall you are.")
 D S^APCHPWH1(" ")
 S APCHAGE=$$AGE^AUPNPAT(DT)
 S APCHHT=$$LASTITEM^APCLAPIU(APCHSDFN,"HT","MEASUREMENT",,,"A")
 S APCHHTA=$$FMDIFF^XLFDT(DT,$P(APCHHT,U))
 I APCHHT=""!(APCHAGE<51&(APCHHTA>(5*365)))!(APCHAGE>50&(APCHHTA>(2*365))) S APCHHTNG=1
 S APCHWT=$$LASTITEM^APCLAPIU(APCHSDFN,"WT","MEASUREMENT",,,"A")
 S APCHWTA=$$FMDIFF^XLFDT(DT,$P(APCHWT,U))
 I APCHWT=""!(APCHAGE<51&(APCHWTA>(5*365)))!(APCHAGE>50&(APCHWTA>(2*365))) S APCHWTNG=1
 I 'APCHHTNG S APCHFEET=$P(APCHHT,U,3)/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 I 'APCHWTNG S APCHWTLB=$J($P(APCHWT,U,3),3,0)
 I 'APCHWTNG,'APCHHTNG D
 .D S^APCHPWH1("You are "_APCHFEET_" feet and "_APCHINCH_" inches tall.")
 .D S^APCHPWH1("Your last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 .D S^APCHPWH1("We recommend that you have your weight rechecked at your next visit.")
 .;BMI
 .S APCLBMI=$$BMI($P(APCHHT,U,3),$P(APCHWT,U,3))
 .D S^APCHPWH1("Your Body Mass Index on "_$$FMTE^XLFDT($P(APCHWT,U,1))_" was "_APCLBMI_".",1)
 .I $L($P(APCLBMI,"."))>2 D  Q
 ..D S^APCHPWH1("You are above a healthy weight.  Ask your health care provider about")
 ..D S^APCHPWH1("a weight that is good for you.")
 .I $E(APCLBMI,1,2)>18,$E(APCLBMI,1,2)<26 D
 ..D S^APCHPWH1("You are at a healthy weight.  Keep up the good work!")
 .I $E(APCLBMI,1,2)<18 D
 ..D S^APCHPWH1("Your current BMI is below normal.  Ask your health care provider")
 ..D S^APCHPWH1("about a weight that is good for you.")
 .I $E(APCLBMI,1,2)>25 D
 ..D S^APCHPWH1("You are above a healthy weight.  Ask your health care provider about")
 ..D S^APCHPWH1("a weight that is good for you.")
 I APCHHTNG,'APCHWTNG D
 .D S^APCHPWH1("Your last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 .D S^APCHPWH1("No recent height on file.  We recommend that you have your height ") D S^APCHPWH1("rechecked at your next visit.")
 I APCHWTNG,'APCHHTNG D
 .D S^APCHPWH1("You are "_APCHFEET_" feet and "_APCHINCH_" inches tall.")
 .D S^APCHPWH1("No recent weight on file.  We recommend that you have your weight ") D S^APCHPWH1("rechecked at your next visit.")
 I APCHHTNG,APCHWTNG D
 .D S^APCHPWH1("No recent weight on file.  We recommend that you have your weight rechecked at ") D S^APCHPWH1("your next visit.")
 .D S^APCHPWH1("No recent height on file.  We recommend that you have your height rechecked at ") D S^APCHPWH1("your next visit.")
 Q
 ;
BMI(H,W) ;
 NEW %
 S %=""
 S W=W*.45359,H=(H*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 Q %
 ;
LASTVPP(P,BDATE,EDATE) ;EP
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW APCHV,A,B,X,E,V,RAPCHR,D
 K APCHV
 S A="APCHV(",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(APCHV) Q ""
 ;
 S X=0 F  S X=$O(APCHV(X)) Q:X'=+X  S V=$P(APCHV(X),U,5),APCHR((9999999-$P(APCHV(X),U,1)),V)=APCHV(X)
 S (X,G,R,D)=0 F  S D=$O(APCHR(D)) Q:D'=+D!(G)  S X=0 F  S X=$O(APCHR(D,X)) Q:X'=+X!(G)  S V=$P(APCHR(D,X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPOV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .S A=0 F  S A=$O(^AUPNVPOV("AD",V,A)) Q:A'=+A!(G)  D
 ..Q:'$D(^AUPNVPOV(A,0))
 ..S E=$P(^AUPNVPOV(A,0),U)
 ..Q:'$$ICD^ATXAPI(E,$O(^ATXAX("B","BGP PREGNANCY DIAGNOSES 2",0)),9)
 ..S G=1
 .Q
 Q G
 ;
BP ;EP - BP component
 I $$AGE^AUPNPAT(APCHSDFN,DT)<3 Q
 I $$AGE^AUPNPAT(APCHSDFN,DT)<18 D ADOLBP^APCHPWH9 Q
 D SUBHEAD^APCHPWHU
 NEW APCHBP,APCHDM,APCHCKD,APCHST,APCHDT
 D S^APCHPWH1("BLOOD PRESSURE - Blood Pressure is a good measure of health.")
 D S^APCHPWH1(" ")
 S APCHBP=$$LASTBP(APCHSDFN)
 S APCHST=$P($P(APCHBP,U,3),"/",1)
 S APCHDT=$P($P(APCHBP,U,3),"/",2)
 I APCHBP="" D S^APCHPWH1("You should have your blood pressure checked at your next visit.") D S^APCHPWH1(" ") Q
 I APCHBP]"" D S^APCHPWH1("Your blood pressure was "_$P(APCHBP,U,3)_" on "_$$FMTE^XLFDT($P(APCHBP,U,1))_".")
 I $P(APCHBP,U)<$$FMADD^XLFDT(DT,-365) D  Q
 .D S^APCHPWH1("You should have your blood pressure checked every year or more often.")
 .D S^APCHPWH1("Ask your provider to check your blood pressure at your next visit.")
 D S^APCHPWH1(" ")
 S APCHDM=$$DMDX(APCHSDFN)
 S APCHCKD=$$CKD^APCHPWH6(APCHSDFN)
 I 'APCHDM,'APCHCKD D  Q
 .I APCHDT>89!(APCHST>139) D  Q
 ..D S^APCHPWH1("Your last blood pressure was too high.  Eating healthy foods, cutting back on")
 ..D S^APCHPWH1("salt, and more physical activity can help lower blood pressure.  If you")
 ..D S^APCHPWH1("take medicine to lower your blood pressure, be sure to take it everyday.")
 .D S^APCHPWH1("Your blood pressure is good!  It is very important to have your blood")
 .D S^APCHPWH1("pressure checked often.")
 I APCHDT>79!(APCHST>129) D  Q
 .D S^APCHPWH1("Your last blood pressure was too high.  Eating healthy foods, cutting back on")
 .D S^APCHPWH1("salt, and more physical activity can help lower blood pressure.  If you")
 .D S^APCHPWH1("take medicine to lower your blood pressure, be sure to take it everyday.")
 D S^APCHPWH1("Your blood pressure is good!  It is very important to have your blood")
 D S^APCHPWH1("pressure checked often.")
 Q
 ;
DMDX(P) ;EP
 ;check problem list, icare tag or visit supplement logic
 N T,X,Y,I,APCHX,APCHY,APCHV,APCHSNVN,APCHSNYR,APCHVSTS,APCHSBD,D,V,APCHSVDT,APCHSCNT,APCHSFOK,APCHSUPI,%,E,APCHSCI
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="I",$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXAPI(Y,T,9) S I=1
 I I Q 1
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Diabetes") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 ;
PVCH ;IHS/CMI/LAB - now check for dx in past year per Bill and Charlton by pcp
 S APCHSUPI=$O(^APCHSUP("B","DIABETIC CARE SUMMARY",0))
 I 'APCHSUPI S APCHSNVN=1,APCHSNYR=365 G BD
 S APCHSNVN=$S($P($G(^APCHSITE(DUZ(2),11,APCHSUPI,0)),U,2):$P($G(^APCHSITE(DUZ(2),11,APCHSUPI,0)),U,2),1:1)
 S APCHSNYR=$S($P($G(^APCHSITE(DUZ(2),11,APCHSUPI,0)),U,3):$P($G(^APCHSITE(DUZ(2),11,APCHSUPI,0)),U,3),1:1)
BD ;
 S APCHSNYR=APCHSNYR*365
 S APCHSBD=$$FMADD^XLFDT(DT,-(APCHSNYR))
 S APCHY="APCHVSTS(",%=P_"^ALL VISITS;DURING "_APCHSBD_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,APCHY)
 I '$D(APCHVSTS) Q 0
 S (X,APCHSCNT,APCHSFOK)=0 F  S X=$O(APCHVSTS(X)) Q:X'=+X!(APCHSFOK)  S V=$P(APCHVSTS(X),U,5) D
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"DAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:'$D(^AUPNVPOV("AD",V))
 .S APCHSVDT=$P(+V,".")
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  S APCHSCM=$P($G(^AUPNVPOV(Y,0)),U) I APCHSCM S APCHSCM=$P($$ICDDX^ICDEX(APCHSCM,APCHSVDT),U,2) I APCHSCM]"" D CHKCODE
 .Q:'D
 .;S Y=$$PRIMPROV^APCLV(V,"F")
 .;Q:'Y
 .;Q:$P($G(^DIC(7,Y,9999999)),U,3)'="Y"
 .S APCHSCNT=APCHSCNT+1
 .I APCHSCNT'<APCHSNVN S APCHSFOK=1
 .Q
 Q APCHSFOK
 ;
CHKCODE ;
 S D=0
 F APCHSCI=0:0 S APCHSCI=$O(^APCHSUP(APCHSUPI,13,APCHSCI)) Q:'APCHSCI  D CHKCODE1 Q:D
 Q
CHKCODE1 ;
 S D=0
 S APCHSC1=$P(^APCHSUP(APCHSUPI,13,APCHSCI,0),U,1)
 I APCHSC1["-" S APCHSC2=$P(APCHSC1,"-",2),APCHSC1=$P(APCHSC1,"-",1)
 E  S APCHSC2=APCHSC1
 S APCHSC1=APCHSC1_" ",APCHSC2=APCHSC2_" "
 I APCHSC1'](APCHSCM_" "),(APCHSCM_" ")']APCHSC2 S D=1
 Q
LASTBP(P) ;EP
 ;exclude ER 
 NEW APCHD,APCHC,APCHX,V,M,T
 K APCHX
 S APCHX="",APCHD="",APCHC=0
 S T=$O(^AUTTMSR("B","BP",""))
 F  S APCHD=$O(^AUPNVMSR("AA",P,T,APCHD)) Q:APCHD=""!(APCHC=1)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,APCHD,M)) Q:M'=+M!(APCHC=1)  D
 ..Q:$P($G(^AUPNVMSR(M,2)),U,1)
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S APCHC=APCHC+1,APCHX(APCHC)=(9999999-APCHD)_U_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 Q $G(APCHX(1))
