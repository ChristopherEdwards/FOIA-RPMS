APCHPWH5 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ; 
 ;;2.0;IHS PCC SUITE;**2,5,7,11**;MAY 14, 2009;Build 58
 ;
CCI ;EP - EO measures
 I '$O(^APCHPWHT(APCHPWHT,12,0)) Q
 Q:$$AGE^AUPNPAT(APCHSDFN)<18
 NEW APCHSTO,APCHSTM,APCHSTCE
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("CCI Measures")
 ;
 ;go through each one
 S APCHSTO=0 F  S APCHSTO=$O(^APCHPWHT(APCHPWHT,12,APCHSTO)) Q:APCHSTO'=+APCHSTO  D
 .S APCHSTM=$P($G(^APCHPWHT(APCHPWHT,12,APCHSTO,0)),U,2)
 .Q:'APCHSTM
 .Q:'$D(^APCHPWHI(APCHSTM,0))
 .S APCHSTCE=$G(^APCHPWHI(APCHSTM,1))
 .I APCHSTCE="" Q
 .X APCHSTCE
 .Q
 Q
 ;
LDL ;EP - cholesterol CCI measure
 NEW APCHCHOL,APCHD,APCHDM
 Q:$$AGE^AUPNPAT(APCHSDFN)<18
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("CHOLESTEROL")
 D S^APCHPWH1("Controlling your cholesterol can keep your heart and blood vessels healthy.")
 S APCHCHOL=$$CHOLTST(APCHSDFN)
 D S^APCHPWH1("")
 I APCHCHOL="" D  Q
 .D S^APCHPWH1("No recent cholesterol is on file.  We recommend that you have your ")
 .D S^APCHPWH1("cholesterol rechecked at your next visit.")
 D S^APCHPWH1("Your total cholesterol result was "_$S($P(APCHCHOL,U,1)]"":$P(APCHCHOL,U,2)_" on "_$$FMTE^XLFDT($P(APCHCHOL,U,1))_".",1:"not found on file."))
 D S^APCHPWH1("Your last LDL (bad cholesterol) result was "_$S($P(APCHCHOL,U,3)]"":$P(APCHCHOL,U,4)_" on "_$$FMTE^XLFDT($P(APCHCHOL,U,3))_".",1:"not found on file."))
 D S^APCHPWH1("Your last HDL (good cholesterol) result was "_$S($P(APCHCHOL,U,5)]"":$P(APCHCHOL,U,6)_" on "_$$FMTE^XLFDT($P(APCHCHOL,U,5))_".",1:"not found on file."))
 D S^APCHPWH1("Your last triglyceride result was "_$S($P(APCHCHOL,U,7)]"":$P(APCHCHOL,U,8)_" on "_$$FMTE^XLFDT($P(APCHCHOL,U,7))_".",1:"not found on file."))
 S APCHDM=0 I $$DMDX^APCHPWH2(APCHSDFN)!($$AMIO(APCHSDFN,DT)) S APCHDM=1
 S APCHLDL=+$P(APCHCHOL,U,4),APCHD=$P(APCHCHOL,U,3)
 I $P(APCHCHOL,U,4)=""!($$FMDIFF^XLFDT(DT,APCHD)>$S(APCHDM:365,1:(5*365))) D  G LDL2
 .D S^APCHPWH1("No recent LDL cholesterol test is on file.  We recommend that you have your",1)
 .D S^APCHPWH1("cholesterol rechecked at your next visit.")
 I APCHDM,APCHLDL,APCHLDL<100 D
 .D S^APCHPWH1("LDL (bad cholesterol) should be under 100 mg/dL.  Your LDL cholesterol",1)
 .D S^APCHPWH1("is good!  You should have your cholesterol checked every year.")
 I APCHDM,APCHLDL,APCHLDL'<100 D
 .D S^APCHPWH1("It is best when your LDL (bad cholesterol) is less than 100 mg/dl.  Ask",1)
 .D S^APCHPWH1("your provider about ways to lower your cholesterol.")
 ;LDL1 ; 
 ;S APCHD=$P(APCHCHOL,U)
 ;S D=$P(APCHCHOL,U,3) I D]"",D>APCHD S APCHD=D
 ;S D=$P(APCHCHOL,U,5) I D]"",D>APCHD S APCHD=D
 ;S D=$P(APCHCHOL,U,7) I D]"",D>APCHD S APCHD=D
 ;I $$FMDIFF^XLFDT(DT,APCHD)>$S(APCHDM:365,1:(5*365)) D
 ;.D S^APCHPWH1("No recent cholesterol is on file.  You should have your cholesterol",1)
 ;.D S^APCHPWH1("rechecked at your next visit.")
LDL2 ;
 I +$P(APCHCHOL,U,8)>500 D
 .D S^APCHPWH1("High triglyceride levels can hurt your pancreas and cause health",1)
 .D S^APCHPWH1("problems such as pain and poor digestion.  Ask your provider about how")
 .D S^APCHPWH1("you can lower your triglycerides.")
 Q
 ;
CVD(P) ;EP
 ;check problem list OR must have 3 diagnoses
 N T,X,Y,I,APCHX,BDATE,EDATE
 S T=$O(^ATXAX("B","BGP IHD DXS",0))
 I 'T Q ""
 S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXAPI(Y,T,9) S I=1
 I I Q 1
 S BDATE=$$DOB^AUPNPAT(P)
 S EDATE=DT
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP IHD DXS",0))
 I 'T Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>3)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXAPI(%,T,9) S D=1
 .Q:'D
 .S G=G+1
 .Q
 K ^TMP($J,"A")
 Q $S(G<3:"",1:1)
 ;
AMIO(P,EDATE) ;
 NEW APCHG
 K APCHG
 S Y="APCHG("
 S X=P_"^LAST DX [BGP AMI DXS (HEDIS);DURING "_$$FMADD^XLFDT(EDATE,-365)_"-"_$$FMADD^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(APCHG(1)) Q 1
 ;check for procedure in BGP CABG PROCS
 S APCHG=$$LASTPRC^APCHSMU2(P,"BGP CABG PROCS",$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE))
 I $P(APCHG,U) Q 1
 ;now check cpts
 S APCHG=$$CPT^APCHPWHU(P,$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE),$O(^ATXAX("B","BGP CABG CPTS",0)),6)
 I $P(APCHG,U) Q 1
 S APCHG=$$TRAN^APCHPWHU(P,$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE),$O(^ATXAX("B","BGP CABG CPTS",0)),6)
 I $P(APCHG,U) Q 1
 ;check for procedure in BGP PTCA PROCS
 S APCHG=$$LASTPRC^APCHSMU2(P,"BGP PCI CM PROCS",$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE))
 I $P(APCHG,U) Q 1
 ;now check cpts
 S APCHG=$$CPT^APCHPWHU(P,$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE),$O(^ATXAX("B","BGP PTCA CPTS",0)),6)
 I $P(APCHG,U) Q 1
 S APCHG=$$TRAN^APCHPWHU(P,$$FMADD^XLFDT(EDATE,-365),$$FMADD^XLFDT(EDATE),$O(^ATXAX("B","BGP PTCA CPTS",0)),6)
 I $P(APCHG,U) Q 1
 ;now check IVD dxs
 S APCHG(1)=$$LASTDX^APCHSMU2(P,"BGP IVD DXS",$$FMADD^XLFDT(EDATE,-(365*2)),EDATE)
 I $P(APCHG(1),U) Q 1
 Q ""
 ;
CHOLTST(P) ;
 ;get all cholesterol tests in APCHC
 NEW APCHC,APCHL,APCHT,APCHH,D,R
 S R=""
 D LABS(P,"DM AUDIT CHOLESTEROL TAX","BGP TOTAL CHOLESTEROL LOINC",.APCHC)
 D LABS(P,"DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES",.APCHL)
 D LABS(P,"DM AUDIT HDL TAX","BGP HDL LOINC CODES",.APCHH)
 D LABS(P,"DM AUDIT TRIGLYCERIDE TAX","BGP TRIGLYCERIDE LOINC CODES",.APCHT)
 ;
 S D=0 S D=$O(APCHC(D)) I D S R=(9999999-D)_U_$P(APCHC(D),U,2)_" "_$P($G(^AUPNVLAB($P(APCHC(D),U,3),11)),U,1)
 S D=0 S D=$O(APCHL(D)) I D S $P(R,U,3)=$P(APCHL(D),U,1),$P(R,U,4)=$P(APCHL(D),U,2)
 S D=0 S D=$O(APCHH(D)) I D S $P(R,U,5)=$P(APCHH(D),U,1),$P(R,U,6)=$P(APCHH(D),U,2)
 S D=0 S D=$O(APCHT(D)) I D S $P(R,U,7)=$P(APCHT(D),U,1),$P(R,U,8)=$P(APCHT(D),U,2)
 Q R
 ;
LABS(P,APCHLT,APCHLOT,APCHT) ;EP - get result of HGBA1c in past year.  If no result pass null
 ;pass back date_u_result
 NEW APCHG,E,%,L,T,D,X,J,C,G
 ;now get all loinc/taxonomy tests
 I APCHLOT]"" S APCHLOT=$O(^ATXAX("B",APCHLOT,0))
 I APCHLT]"" S APCHLT=$O(^ATXLAB("B",APCHLT,0))
 S B=9999999-$$DOB^AUPNPAT(P),E=9999999-DT S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...Q:$$UP^XLFSTR($P(^AUPNVLAB(X,0),U,4))="COMMENT"
 ...Q:'+$P(^AUPNVLAB(X,0),U,4)
 ...I APCHLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHLT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X Q
 ...Q:'APCHLOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,APCHLOT)
 ...S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X
 ...Q
 Q
 ;
 ;
LOINC(A,B) ;EP
 NEW %
 I '$G(B) Q ""
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DC ;EP - diabetes comprehensive care
 NEW APCHA1C,R,V,APCHKT
 Q:'$$DMDX^APCHPWH2(APCHSDFN)  ;not diabetic
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("DIABETES CARE")
AIC ;a1c
 S APCHA1C=$$HGBA1C^APCHPWH4(APCHSDFN,,,1)
 D S^APCHPWH1("HEMOGLOBIN A1c",1)
 D S^APCHPWH1("Hemoglobin A1c is a test that measures your blood sugar control over a 3-month")
 D S^APCHPWH1("period.  We recommend that you have this test done every 3-6 months.")
 I APCHA1C]"" D S^APCHPWH1("Your last A1c test on file was "_$P(APCHA1C,U,2)_" done on "_$P(APCHA1C,U)_".")
 I APCHA1C=""!($$FMDIFF^XLFDT(DT,$P(APCHA1C,U,3))>365) D  G KT
 .D S^APCHPWH1("We recommend that you have your A1c tested. Ask your health care provider",1)
 .D S^APCHPWH1("to order an A1c test for you.")
 S V=$P(APCHA1C,U,2)
 S R=$S(V[">":3,V["<":1,$E(V)'=+$E(V):"",V<7.0:1,V>6.9&(V<9.0):2,V>8.9:3,1:"")
 I R=1 D
 .D S^APCHPWH1("An A1c value that is less than 7% shows great blood sugar control. You",1)
 .D S^APCHPWH1("are doing great!")
 I R=2 D
 .D S^APCHPWH1("Ask your health care provider how you can keep lowering your A1c.",1)
 I R=3 D
 .D S^APCHPWH1("Your A1c is too high. Ask your health care provider about ways to lower",1)
 .D S^APCHPWH1("your A1c.")
KT ;kidney assessment
 D S^APCHPWH1("DIABETES KIDNEY ASSESSMENT",1)
 D S^APCHPWH1("Diabetes can cause kidney damage. There are tests that can see how well your")
 D S^APCHPWH1("kidneys are working. Getting these tests at least once a year can help your ")
 D S^APCHPWH1("health care provider protect your kidneys and lower your risk of getting ")
 D S^APCHPWH1("kidney damage and dialysis.")
 S APCHKT=$$KIDNEYT(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 I APCHKT="" D
 .D S^APCHPWH1("We recommend that you have your kidneys tested to see how well they are ",1)
 .D S^APCHPWH1("working every year. Ask your health care provider to order a kidney ")
 .D S^APCHPWH1("function test for you.")
 I APCHKT]"" D
 .D S^APCHPWH1("Your kidneys were tested on "_$$FMTE^XLFDT($P(APCHKT,U))_".  We recommend that you ",1)
 .D S^APCHPWH1("have your kidneys tested again on "_$$FMTE^XLFDT($$FMADD^XLFDT($P(APCHKT,U),365))_".")
EYE ;EYE
 D S^APCHPWH1("DIABETES EYE EXAM",1)
 D S^APCHPWH1("Diabetes can affect your eyes and vision. Early detection of eye problems ")
 D S^APCHPWH1("can help you to get the treatment you need to lower your chances of having ")
 D S^APCHPWH1("problems such as blurred vision or blindness.")
 S APCHKT=$$EYET(APCHSDFN,$$DOB^AUPNPAT(APCHSDFN),DT)
 I 'APCHKT D  G FOOT
 .D S^APCHPWH1("We recommend that you have at least one diabetes eye exam every year.",1)
 .D S^APCHPWH1("Ask your health care provider to order a diabetes eye exam for you.")
 I APCHKT,$$FMDIFF^XLFDT(DT,$P(APCHKT,U,2))<365 D  G FOOT
 .D S^APCHPWH1("Your last diabetes eye exam was done on "_$$FMTE^XLFDT($P(APCHKT,U,2))_".  We recommend",1)
 .D S^APCHPWH1("that you have another eye exam by "_$$FMTE^XLFDT($$FMADD^XLFDT($P(APCHKT,U,2),365))_".")
 D S^APCHPWH1("Your last diabetes eye exam was done on "_$$FMTE^XLFDT($P(APCHKT,U,2))_".")
 D S^APCHPWH1("We recommend that you have at least one diabetes eye exam every year. ",1)
 D S^APCHPWH1("Ask your health care provider to order a diabetes eye exam for you.")
FOOT ;FOOT
 D S^APCHPWH1("DIABETES FOOT EXAM",1)
 D S^APCHPWH1("Diabetes can make your feet hurt or feel numb. Having a diabetes foot")
 D S^APCHPWH1("exam every year can help keep your feet healthy.")
 S APCHKT=$$FOOTEX^APCHPWH6(APCHSDFN,$$DOB^AUPNPAT(APCHSDFN),DT)
 I 'APCHKT D  Q
 .D S^APCHPWH1("We recommend that you have at least one diabetes foot exam every year.",1)
 .D S^APCHPWH1("Ask your health care provider to order a diabetes foot exam for you.")
 I APCHKT,$$FMDIFF^XLFDT(DT,$P(APCHKT,U))<365 D  Q
 .D S^APCHPWH1("Your last diabetes foot exam was done on "_$$FMTE^XLFDT($P(APCHKT,U))_".  We recommend",1)
 .D S^APCHPWH1("that you have another foot exam by "_$$FMTE^XLFDT($$FMADD^XLFDT($P(APCHKT,U),365))_".")
 D S^APCHPWH1("Your last diabetes foot exam was done on "_$$FMTE^XLFDT($P(APCHKT,U))_".")
 D S^APCHPWH1("We recommend that you have at least one diabetes foot exam every year. ",1)
 D S^APCHPWH1("Ask your health care provider to order a diabetes foot exam for you.")
 Q
KIDNEYT(P,BDATE,EDATE) ; 
 ;pass back date_u_result
 NEW APCHG,E,%,L,T,D,X,J,C,G,B,APCHACT,APCHACLT,APCHPCT,APCHPCLT,APCHQUT,APCHQULT,APCHT
 ;now get all loinc/taxonomy tests
 S APCHACT=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0))
 S APCHACLT=$O(^ATXAX("B","DM AUDIT A/C RATIO LOINC",0))
 S APCHPCT=$O(^ATXLAB("B","DM AUDIT P/C RATIO TAX",0))
 S APCHPCLT=$O(^ATXAX("B","DM AUDIT P/C RATIO LOINC",0))
 S APCHQULT=$O(^ATXAX("B","BGP QUANT URINE PROT LOINC",0))
 S APCHQUT=$O(^ATXLAB("B","BGP QUANT URINE PROTEIN",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:'$P(^AUPNVLAB(X,0),U)
 ...I APCHACT,$D(^ATXLAB(APCHACT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X Q
 ...I APCHPCT,$D(^ATXLAB(APCHACT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X Q
 ...I APCHQUT,$D(^ATXLAB(APCHACT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X Q
 ...;
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...I $$LOINC(J,APCHACLT)!($$LOINC(J,APCHPCLT))!($$LOINC(J,APCHQULT)) D  Q
 ....S APCHT(D)=(9999999-D)_U_+$P(^AUPNVLAB(X,0),U,4)_U_X
 ...Q
 I '$D(APCHT) Q ""
 S D=0,G=$O(APCHT(D))
 Q APCHT(G)
 ;
EYET(P,BDATE,EDATE) ;
 NEW A,%,APCHLEYE,APCHG,Y,X,D,R,T
 S APCHLEYE=""
 K APCHG S %=P_"^LAST EXAM DIABETIC EYE EXAM;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"APCHG(")
 I $D(APCHG(1)) S APCHLEYE="1^"_$P(APCHG(1),U)_"^Diab Eye Ex"
 K ^TMP($J,"A")
 S A="^TMP($J,""A"","
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,A)
 S X=0,Y=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C") I R="A2",'$$DNKA^APCHS9B4($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y,$P(APCHLEYE,U,2)<D S APCHLEYE=3_"^"_D_"^Cl: "_R
 S X=0,Y=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C") I (R=17!(R=18)!(R=64)),'$$DNKA^APCHS9B4($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y,$P(APCHLEYE,U,2)<D S APCHLEYE=$S(R="A2":3,1:3)_"^"_D_"^Cl: "_R
 S (X,Y)=0,D="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(^TMP($J,"A",X),U,5),"D") I (R=24!(R=79)!(R="08")),'$$DNKA^APCHS9B4($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y,$P(APCHLEYE,U,2)<D S APCHLEYE="3^"_D_"^Prv: "_R
 ;
 ;K APCHG S %=P_"^LAST DX V72.0;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"APCHG(")
 ;I $D(APCHG(1)),$P(APCHLEYE,U,2)<$P(APCHG(1),U) S APCHLEYE="3^"_$P(APCHG(1),U)_"^V72.0 POV"   ;GPRA TOOK THIS OUT IN V13
 ;check cpt taxonomies
 S T=$O(^ATXAX("B","BGP DM RETINAL EXAM CPTS",0))
 I T D  I X]"",$P(APCHLEYE,U,2)<$P(X,U,1) S APCHLEYE=1_U_$P(X,U,1)_U_"CPT: "_$P(X,U,2)
 .S X=$$CPT^APCHPWHU(P,BDATE,EDATE,T,5) I X]"" Q
 .S X=$$TRAN^APCHPWHU(P,BDATE,EDATE,T,5)
 S T=$O(^ATXAX("B","BGP DM EYE EXAM CPTS",0))
 I T D  I X]"",$P(APCHLEYE,U,2)<$P(X,U,1) S APCHLEYE=3_U_$P(X,U,1)_U_"CPT: "_$P(X,U,2)
 .S X=$$CPT^APCHPWHU(P,BDATE,EDATE,T,5) I X]"" Q
 .S X=$$TRAN^APCHPWHU(P,BDATE,EDATE,T,5)
 S X=$$LASTPRC^APCHSMU2(P,"BGP EYE EXAM PROCS",BDATE,EDATE) I X,$P(APCHLEYE,U,2)<$P(X,U,3) S APCHLEYE=3_U_$P(X,U,3)_U_"PROC: "
 Q APCHLEYE
 ;
