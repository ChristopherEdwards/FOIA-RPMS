APCHPWH8 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**7,8,11**;MAY 14, 2009;Build 58
 ;
 ;
ADOLHTWT ;EP - ht/wt/bmi component
 I $$LASTVPP^APCHPWH2(APCHSDFN,$$FMADD^XLFDT(DT,-(30*3)),DT) Q  ;last visit dx was pregnancy
 D SUBHEAD^APCHPWHU
 NEW APCHHT,APCHWT,APCHAGE,APCHNOBM,APCHHTA,APCHWTA,APCHFEET,APCHINCH,APCHHWO,APCLBMI
 D S^APCHPWH1("ADOLESCENT WEIGHT AND HEIGHT")
 D S^APCHPWH1("Weight and Body Mass Index are good measures of your health.  Determining")
 D S^APCHPWH1("a healthy weight and Body Mass Index also depends on your age and how")
 D S^APCHPWH1("tall you are.")
 D S^APCHPWH1(" ")
 S APCHAGE=$$AGE^AUPNPAT(DT)
 S APCHHWO=0,APCHFEET="",APCHINCH=""  ;ht/wt is good if 0
 S APCHHT=$$LASTITEM^APCLAPIU(APCHSDFN,"HT","MEASUREMENT",,,"A")
 I $P(APCHHT,U)<$$FMADD^XLFDT(DT,-365) S APCHHWO=1
 S APCHWT=$$LASTITEM^APCLAPIU(APCHSDFN,"WT","MEASUREMENT",,,"A")
 I $P(APCHWT,U)<$$FMADD^XLFDT(DT,-365) S APCHHWO=1
 I APCHHT]"" S APCHFEET=$P(APCHHT,U,3)/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 S APCHWTLB=$J($P(APCHWT,U,3),3,0)
 I 'APCHHWO D  Q
 .D S^APCHPWH1("You are "_APCHFEET_" feet and "_APCHINCH_" inches tall.")
 .D S^APCHPWH1("Your last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 I APCHWT]"" D
 .D S^APCHPWH1("Your last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 ;D S^APCHPWH1("No recent weight on file.  We recommend that you have your weight rechecked at ") D S^APCHPWH1("your next visit.")
 I APCHHT]"" D
 .D S^APCHPWH1("On "_$$FMTE^XLFDT($P(APCHHT,U,1))_" your height was "_APCHFEET_" feet and "_APCHINCH_" inches.")
 D S^APCHPWH1("We recommend that you have your height and weight rechecked at your next visit.")
 Q
 ;
PEDHTWT ;EP - ht/wt/bmi component
 ;GET LAST VISIT THAT IS A,O,H
 I $$LASTVPP^APCHPWH2(APCHSDFN,$$FMADD^XLFDT(DT,-(30*3)),DT) Q  ;last visit dx was pregnancy
 D SUBHEAD^APCHPWHU
 NEW APCHHT,APCHWT,APCHAGE,APCHNOBM,APCHHTA,APCHWTA,APCHFEET,APCHINCH,APCHHWO,APCLBMI,APCHHC,APCHAM,APCHHWOD
 D S^APCHPWH1("PEDIATRIC WEIGHT/HEIGHT/HEAD CIRCUMFERENCE")
 S APCHAGE=$$AGE^AUPNPAT(DT)
 I APCHAGE<4 D
 .D S^APCHPWH1("Weight, height, and head circumference can help you see how your")
 .D S^APCHPWH1("child is growing.")
 I APCHAGE>3,APCHAGE<13 D
 .D S^APCHPWH1("Weight and height can help you and your doctor see how well your")
 .D S^APCHPWH1("child is growing.")
 D S^APCHPWH1(" ")
 S APCHHWO=0,APCHFEET="",APCHINCH=""  ;ht/wt is good if 0
 S APCHAM=$$AGE(APCHSDFN,2)
 I APCHAM>24 S APCHHWOD=-365
 I APCHAM>6,APCHAM<25 S APCHHWOD=-90
 I APCHAM<7 S APCHHWOD=-30
 S APCHHWOD=$$FMADD^XLFDT(DT,APCHHWOD)
 S APCHHT=$$LASTITEM^APCLAPIU(APCHSDFN,"HT","MEASUREMENT",,,"A")
 I $P(APCHHT,U)<APCHHWOD S APCHHWO=1
 S APCHWT=$$LASTITEM^APCLAPIU(APCHSDFN,"WT","MEASUREMENT",,,"A")
 I $P(APCHWT,U)<APCHHWOD S APCHHWO=1
 I APCHHT]"" S APCHFEET=$P(APCHHT,U,3)/12,APCHINCH=$P(APCHFEET,".",2),APCHINCH="."_APCHINCH*12,APCHINCH=$J(APCHINCH,2,0),APCHFEET=$P(APCHFEET,".")
 S APCHWTLB=$J($P(APCHWT,U,3),3,0)
 I 'APCHHWO D  G HC
 .D S^APCHPWH1("Your child is "_APCHFEET_" feet and "_APCHINCH_" inches tall.")
 .D S^APCHPWH1("Your child's last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 I APCHWT]"" D  I 1
 .D S^APCHPWH1("Your child's last weight was "_APCHWTLB_" pounds on "_$$FMTE^XLFDT($P(APCHWT,U,1))_".")
 E  D S^APCHPWH1("No recent weight on file.  We recommend that you have your child's weight ") D S^APCHPWH1("rechecked at your next visit.")
 I APCHHT]"" D  I 1
 .D S^APCHPWH1("On "_$$FMTE^XLFDT($P(APCHHT,U,1))_" your child's height was "_APCHFEET_" feet and "_APCHINCH_" inches.",1)
 E  D S^APCHPWH1("No recent height on file.  We recommend that you have your child's height "),S^APCHPWH1("rechecked at your next visit.")
HC ;
 I APCHAGE<3 D HC1
 Q
HC1 ;
 S APCHHC=$$LASTITEM^APCLAPIU(APCHSDFN,"HC","MEASUREMENT",,,"A")
 ;I $P(APCHHT,U)<DT S APCHHWO=1
 D S^APCHPWH1(" ")
 I APCHHC]"" D  Q
 .D S^APCHPWH1("Your child's most recent head circumference is "_$J($P(APCHHC,U,3),5,2)_" on "_$$FMTE^XLFDT($P(APCHHC,U,1))_".")
 D S^APCHPWH1("No recent head circumference on file.  We recommend that you have your ") D S^APCHPWH1("child's head circumference rechecked at your next visit.")
 Q
BMI(H,W) ;
 NEW %
 S %=""
 S W=W*.45359,H=(H*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 Q %
 ;
LASTVPP(P,BDATE,EDATE) ;
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
 ..Q:'$$ICD^ATXAPI(E,$O(^ATXAX("B","BGP GPRA PREGNANCY DIAGNOSES",0)),9)
 ..S G=1
 .Q
 Q G
RECENTWT ;EP - called from various handouts
 D SUBHEAD^APCHPWHU
 NEW APCHHT,APCHWT,X,E
 D S^APCHPWH1("Here are "_$S($$AGE^AUPNPAT(APCHSDFN,DT)<13:"your child's",1:"your")_" most recent weights.")
 D S^APCHPWH1(" ")
 K APCHWT
 S X=APCHSDFN_"^LAST 5 MEAS WT;DURING "_$$DOB^AUPNPAT(APCHSDFN)_"-"_DT S E=$$START1^APCLDF(X,"APCHWT(")
 I '$D(APCHWT) D S^APCHPWH1("No weight values have been recorded.  We recommend that you have"),S^APCHPWH1($S($$AGE^AUPNPAT(APCHSDFN,DT)<13:"your child's",1:"your")_" weight rechecked at your next visit.") Q
 S E="",$E(E,5)="Date",$E(E,18)="Weight (lbs)" D S^APCHPWH1(E)
 S X=0 F  S X=$O(APCHWT(X)) Q:X'=+X  D
 .S E=""
 .S $E(E,2)=$$FMTE^XLFDT($P(APCHWT(X),U,1))
 .S $E(E,20)=$J($P(APCHWT(X),U,2),3,0)
 .D S^APCHPWH1(E)
 Q
TOBACCO ;EP
 NEW X,Y,G
 S G=0
 S X=$$LASTHF^APCHSMU(APCHSDFN,"TOBACCO (SMOKING)","N")
 S Y=$$LASTHF^APCHSMU(APCHSDFN,"TOBACCO (SMOKELESS - CHEWING/DIP)","N")
 I X["CURRENT"!(Y["CURRENT") S G=1
 Q:'G  ;last health factor was not a current user
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1(" ")
 D S^APCHPWH1("TOBACCO USE AND CESSATION")
 D S^APCHPWH1("Talk to your health care provider or smoking cessation program about")
 D S^APCHPWH1("ways that you can quit using tobacco.")
 I $P($G(^APCCCTRL(DUZ(2),12)),U,1)]"" D
 .D S^APCHPWH1("Your smoking cessation program's phone number is "_$P(^APCCCTRL(DUZ(2),12),U,1)_".")
 I $P($G(^APCCCTRL(DUZ(2),12)),U,2)]"" D
 .D S^APCHPWH1("For additional support, call your tobacco quit line at "_$P(^APCCCTRL(DUZ(2),12),U,2)_".")
 Q
INTAKE ;EP - PWH COMPONENT
 I '$O(^APCHPWHT(APCHPWHT,1,APCHSORD,12,0)) Q  ;no measures defined
 NEW APCHSTO,APCHSTM,APCHSTCE
 ;D SUBHEAD^APCHPWHU
 ;
 ;go through each one
 S APCHSTO=0 F  S APCHSTO=$O(^APCHPWHT(APCHPWHT,1,APCHSORD,12,APCHSTO)) Q:APCHSTO'=+APCHSTO  D
 .S APCHSTM=$P($G(^APCHPWHT(APCHPWHT,1,APCHSORD,12,APCHSTO,0)),U,2)
 .Q:'APCHSTM
 .Q:'$D(^APCHPWHF(APCHSTM,0))
 .S APCHSTCE=$P(^APCHPWHF(APCHSTM,0),U,1)
 .;D S^APCHPWH1(APCHSTCE_" INTAKE FORM")
 .I $G(^APCHPWHF(APCHSTM,1))]"" X ^APCHPWHF(APCHSTM,1) Q
 .;D WRITEF^APCHPWHU(APCHSTCE)  ;just write the text from the form file so sites can add their own
 .Q
 Q
EDUC ;EP - PWH COMPONENT
 I '$O(^APCHPWHT(APCHPWHT,1,APCHSORD,13,0)) Q  ;no measures defined
 NEW APCHSTO,APCHSTM,APCHSTCE
 ;D SUBHEAD^APCHPWHU
 ;
 ;go through each one
 S APCHSTO=0 F  S APCHSTO=$O(^APCHPWHT(APCHPWHT,1,APCHSORD,13,APCHSTO)) Q:APCHSTO'=+APCHSTO  D
 .S APCHSTM=$P($G(^APCHPWHT(APCHPWHT,1,APCHSORD,13,APCHSTO,0)),U,2)
 .Q:'APCHSTM
 .Q:'$D(^APCHPWHF(APCHSTM,0))
 .S APCHSTCE=$P(^APCHPWHF(APCHSTM,0),U,1)
 .;D S^APCHPWH1(APCHSTCE_" INTAKE FORM")
 .I $G(^APCHPWHF(APCHSTM,1))]"" X ^APCHPWHF(APCHSTM,1) Q
 .D WRITEF^APCHPWHU(APCHSTCE)  ;just write the text from the form file so sites can add their own
 .Q
 Q
BIGFIVE ;EP - form print
 I $$AGE^AUPNPAT(APCHSDFN)>21 Q  ;no one over 21
 D SUBHEAD^APCHPWHU
 I $$AGE^AUPNPAT(APCHSDFN)>15 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your health. ")
 .D S^APCHPWH1("Your answers will help your provider give you the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"OVER 15")
 I $$AGE^AUPNPAT(APCHSDFN)<16 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your child's health.")
 .D S^APCHPWH1("Your answers will help your provider give your child the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"UNDER 16")
 Q
AGEFORM ;
 D SUBHEAD^APCHPWHU
 I $$AGE^AUPNPAT(APCHSDFN)<1 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your child's health.")
 .D S^APCHPWH1("Your answers will help your provider give your child the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"0-1 YEAR")
 I $$AGE^AUPNPAT(APCHSDFN)>0,$$AGE^AUPNPAT(APCHSDFN)<5 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your child's health.")
 .D S^APCHPWH1("Your answers will help your provider give your child the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"1-4 YEARS")
 I $$AGE^AUPNPAT(APCHSDFN)>4,$$AGE^AUPNPAT(APCHSDFN)<12 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your child's health.")
 .D S^APCHPWH1("Your answers will help your provider give your child the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"5-11 YEARS")
 I $$AGE^AUPNPAT(APCHSDFN)>11,$$AGE^AUPNPAT(APCHSDFN)<19 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your child's health.")
 .D S^APCHPWH1("Your answers will help your provider give your child the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"12-18 YEARS")
 I $$AGE^AUPNPAT(APCHSDFN)>18 D
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your health. ")
 .D S^APCHPWH1("Your answers will help your provider give you the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"OVER 18 YEARS")
 I $$DMPV^APCHPWH9(APCHSDFN) D
 .I $$AGE^AUPNPAT(APCHSDFN)>18 D WRITEF^APCHPWHU(APCHSTM,"2 DIABETES POVS") Q
 .I $$AGE^AUPNPAT(APCHSDFN)>18 D WRITEF^APCHPWHU(APCHSTM,"2 DIABETES POVS <18")
 I $$AGE^AUPNPAT(APCHSDFN)>64 D
 .D WRITEF^APCHPWHU(APCHSTM,"OVER 65")
 Q
PATED ;EP
 D SUBHEAD^APCHPWHU
 I $$AGE^AUPNPAT(APCHSDFN)>0,$$AGE^AUPNPAT(APCHSDFN)<5 D
 .D WRITEF^APCHPWHU(APCHSTM,"1-4 YEARS")
 I $$AGE^AUPNPAT(APCHSDFN)>4,$$AGE^AUPNPAT(APCHSDFN)<12 D
 .D WRITEF^APCHPWHU(APCHSTM,"5-11 YEARS")
 Q
PREGNANT ;EP -
 I $P($G(^AUPNREP(APCHSDFN,11)),U,1)="Y" D
 .D SUBHEAD^APCHPWHU
 .D S^APCHPWH1(" ")
 .D S^APCHPWH1("Please answer the following questions that are related to your health. ")
 .D S^APCHPWH1("Your answers will help your provider give you the best health care.")
 .D S^APCHPWH1(" ")
 .D WRITEF^APCHPWHU(APCHSTM,"PREGNANT")
 .D S^APCHPWH1(" ")
 Q
PREGED ;EP
 I $P($G(^AUPNREP(APCHSDFN,11)),U,1)="Y" D
 .D SUBHEAD^APCHPWHU
 .D WRITEF^APCHPWHU(APCHSTM,"PREGNANCY")
 Q
 ;----------
AGE(DFN,APCHZ,APCHDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - APCHZ  (opt) APCHZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCHDT (opt) Date on which Age should be calculated.
 ;
 N APCHDOB,X,X1,X2  S:$G(APCHZ)="" APCHZ=2
 Q:'$G(DFN) ""
 S APCHDOB=$$DOB(DFN)
 Q:'APCHDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(APCHDT) APCHDT=DT
 Q:APCHDT<APCHDOB ""
 ;
 ;---> Age in Years.
 N APCHAGEY,APCHAGEM,APCHD1,APCHD2,APCHM1,APCHM2,APCHY1,APCHY2
 S APCHM1=$E(APCHDOB,4,7),APCHM2=$E(APCHDT,4,7)
 S APCHY1=$E(APCHDOB,1,3),APCHY2=$E(APCHDT,1,3)
 S APCHAGEY=APCHY2-APCHY1 S:APCHM2<APCHM1 APCHAGEY=APCHAGEY-1
 S:APCHAGEY<1 APCHAGEY="<1"
 Q:APCHZ=1 APCHAGEY
 ;
 ;---> Age in Months.
 S APCHD1=$E(APCHM1,3,4),APCHM1=$E(APCHM1,1,2)
 S APCHD2=$E(APCHM2,3,4),APCHM2=$E(APCHM2,1,2)
 S APCHAGEM=12*APCHAGEY
 I APCHM2=APCHM1&(APCHD2<APCHD1) S APCHAGEM=APCHAGEM+12
 I APCHM2>APCHM1 S APCHAGEM=APCHAGEM+APCHM2-APCHM1
 I APCHM2<APCHM1 S APCHAGEM=APCHAGEM+APCHM2+(12-APCHM1)
 S:APCHD2<APCHD1 APCHAGEM=APCHAGEM-1
 Q:APCHZ=2 APCHAGEM
 ;
 ;---> Age in Days.
 S X1=APCHDT,X2=APCHDOB
 D ^%DTC
 Q X
 ;
 ;----------
DOB(DFN) ;EP
 ;---> Return Patient's Date of APCLrth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
 ;
