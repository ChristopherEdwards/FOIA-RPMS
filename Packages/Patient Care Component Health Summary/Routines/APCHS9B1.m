APCHS9B1 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;
 ;;2.0;IHS PCC SUITE;**2,4,5**;MAY 14, 2009
 ;
 ;IHS/CMI/LAB patch 3 many changes
 ;patch 14 added depression screening
 ;patch 14 added loinc code lookups
 ;cmi/anch/maw 8/27/2007 code set versioning in DMPN and DEPPL
 ;
EP ;EP - called from component
 Q:'$G(APCHSPAT)
 I $E(IOST)="C",IO=IO(0) W !! S DIR("A")="DIABETES SUMMARY WILL NOW BE DISPLAYED (^ TO EXIT, RETURN TO CONTINUE)",DIR(0)="E" D ^DIR I $D(DIRUT) S APCHSQIT=1 Q  ;IHS/CMI/LAB fixed for slave printing
 ;NEW X S X="BDMS9B1" X ^%ZOSF("TEST") I $T D ^BDMS9B1 D EOJ Q
 D EP2(APCHSPAT)
W ;write out array
 W:$D(IOF) @IOF
 K APCHQUIT
 S APCHX=0 F  S APCHX=$O(^TMP("APCHS",$J,"DCS",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP("APCHS",$J,"DCS",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K APCHX,APCHQUIT,APCHY,APCHSDFN,APCHSBEG,APCHSTOB,APCHSUPI,APCHSED,APCHTOBN,APCHTOB,APCHSTEX
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,APCHSHDR,!
 W !,"Diabetes Patient Care Summary - continued"
 W !,"Patient: ",$P(^DPT(APCHSPAT,0),U),"  HRN: ",$$HRN^AUPNPAT(APCHSPAT,DUZ(2)),!
 Q
EP2(APCHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHS",$J,"DCS"
 NEW X S X="BDMS9B1" X ^%ZOSF("TEST") I $T D EP2^BDMS9B1(APCHSDFN) Q
 K ^TMP("APCHS",$J,"DCS")
 S ^TMP("APCHS",$J,"DCS",0)=0
 I '$D(APCHSCVD) S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="DIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient Name:  "_$P(^DPT(APCHSDFN,0),U)_"    HRN: "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)) D S(X)
 I $$DOD^AUPNPAT(APCHSDFN)]"" S X="DATE OF DEATH: "_$$FMTE^XLFDT($$DOD^AUPNPAT(APCHSDFN)) D S(X,1),S(" ")
 S X="Age:  "_$$AGE^AUPNPAT(APCHSDFN),$E(X,15)="Sex:  "_$$SEX^AUPNPAT(APCHSDFN),$E(X,31)="Date of DM Onset: "_$$DOO(APCHSDFN) D S(X)
 S X="",X="Dob:  "_$$FMTE^XLFDT($$DOB^AUPNPAT(APCHSDFN)) S Y=$$DMPN(APCHSDFN),$E(X,31)="DM Problem #: "_$S(Y]"":Y,1:"*** NONE RECORDED ***") D S(X)
 S X="" I '$$NOTREG(APCHSDFN) S X="**NOT ON DIABETES REGISTER**"
 S $E(X,31)="Designated PCP: "_$$VAL^XBDIQ1(9000001,APCHSDFN,.14) D S(X)
 D GETHWB(APCHSDFN) S X="Last Height:  "_APCHX("HT")_$S(APCHX("HT")]"":" inches",1:""),$E(X,31)=APCHX("HTD") D S(X)
 S X="Last Weight:  "_$S(APCHX("WT")]"":$J(APCHX("WT"),3,0),1:"")_$S(APCHX("WT")]"":" lbs",1:""),$E(X,31)=APCHX("WTD"),$E(X,45)="BMI: "_APCHX("BMI") D S(X)
 I APCHX("WC")]"" S X="Last Waist Circumference: "_APCHX("WC"),$E(X,31)=APCHX("WCD") D S(X)
 D TOBACCO^APCHS9B6
 S X="Tobacco Use:  "_$G(APCHTOB) D S(X)
 S X="HTN Diagnosed:  "_$$HTN(APCHSDFN) D S(X)
 S APCHSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^APCHS9B5(APCHSDFN,APCHSBEG) ;get date of last ACE in last year
 S X="",X="ON ACE Inhibitor/ARB in past 6 months: "_% D S(X)
 K APCHSX S APCHSBEG=$$FMADD^XLFDT(DT,-365) S X="Aspirin Use/Anti-platelet (in past yr):  "_$E($$ASPIRIN(APCHSDFN,APCHSBEG),1,32) D S(X)
 S X="",X=$$ASPREF^APCHS9B5(APCHSDFN) I X]"" S X="     "_X D S(X)
 S APCHDEPP=$$DEPPL(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S APCHDEPS=$$DEPSCR(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S B=$$BP(APCHSDFN)
 S X="Last 3 BP:  "_$P($G(APCHX(1)),U,2)_"   "_$$FMTE^XLFDT($P($G(APCHX(1)),U))
 S $E(X,40)="Is Depression on the Problem List?"
 D S(X)
 S X="(non ER)" I $D(APCHX(2)) S $E(X,13)=$P(APCHX(2),U,2)_"   "_$$FMTE^XLFDT($P(APCHX(2),U))
 S $E(X,42)=APCHDEPP
 D S(X)
 S X="" I $D(APCHX(3)) S X="",$E(X,13)=$P(APCHX(3),U,2)_"   "_$$FMTE^XLFDT($P(APCHX(3),U))
 I $E(APCHDEPP,1)="N" S $E(X,40)="If no, Depression Screening in past year?"
 D S(X)
 S X="" I $E(APCHDEPP,1)="N" S $E(X,42)=APCHDEPS
 D S(X)
M12 ;
 ;determine date range
 S APCHSBEG=$$FMADD^XLFDT(DT,-365)
 S X="In past 12 months:" D S(X)
 S X="Diabetic Foot Exam:",$E(X,23)=$$DFE^APCHS9B4(APCHSDFN,APCHSBEG) D S(X)
 S X="Diabetic Eye Exam:",$E(X,23)=$$EYE^APCHS9B4(APCHSDFN,APCHSBEG) D S(X)
 S X="Dental Exam:",$E(X,23)=$$DENTAL^APCHS9B6(APCHSDFN,APCHSBEG) D S(X)
 ;S X="Rectal Exam (age>40):",$E(X,27)=$$RECTAL^APCHS9B4(APCHSDFN,APCHSBEG) D S(X)
 K APCHSTEX,APCHSDAT,APCHX
 I $P(^DPT(APCHSDFN,0),U,2)="F" D
 .S X="(Females Only)"  D S(X)
 .K APCHSTEX,APCHSDAT
 .S APCHX=$$PAP^APCHS9B4(APCHSDFN) ;get date of last pap in pcc/refusal
 .S X="Last Pap Smear documented in PCC/WH: "_$$FMTE^XLFDT($P(APCHX,U)) D S(X)
 .I $P(APCHX,U,2)]"" S X=$P(APCHX,U,2) D S(X)
 .D PAP^APCHS9B5
 .S X="",$E(X,17)="WH Cervical TX Need:",$E(X,38)=$G(APCHSTEX(1)) D S(X)
 .S X="",Y=1 F  S Y=$O(APCHSTEX(Y)) Q:Y=""  S X="",$E(X,12)=APCHSTEX(Y) D S(X)
 .;S X="   Breast exam:",$E(X,27)=$$BREAST^APCHS9B4(APCHSDFN,APCHSBEG) D S(X)
 .K APCHSTEX,APCHSDAT D MAM^APCHS9B5 S X="Mammogram:",$E(X,12)=$$FMTE^XLFDT(APCHSDAT)_"  "_$G(APCHSTEX(1)) D S(X)
 .S X="",Y=1 F  S Y=$O(APCHSTEX(Y)) Q:Y=""  S X="",$E(X,23)=APCHSTEX(Y) D S(X)
 D MORE^APCHS9B2
 S X=$P(^DPT(APCHSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(APCHSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(APCHSDFN,DUZ(2),2) D S(X,1) ;IHS/CMI/LAB - X,3 to X,2
 ;S X="" D S(X,1)
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
HTN(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCHX
 S APCHX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"APCHX(") G:E HTNX I $D(APCHX(3)) S APCHX="Yes"
 I $G(APCHX)="" S APCHX="No"
HTNX ;
 Q APCHX
DMPN(P) ;return problem number of lowest DM code
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..;S D(+$P(^ICD9(I,0),U))=X  cmi/anch/maw 8/27/2007 orig line
 ..S D(+$P($$ICDDX^ICDCODE(I,,,1),U,2))=X  ;cmi/anch/maw 8/27/2007 code set versioning
 ..Q
 .Q
 S D=$O(D(""))
 I D="" Q D
 S X=D(D) ;ien of problem now return problem #
 NEW L S L=$P(^AUPNPROB(X,0),U,6)
 NEW Y S Y=$S(L:$P(^AUTTLOC(L,0),U,7),1:"???")_$P(^AUPNPROB(X,0),U,7)
 Q Y
BP(P) ;last 3 BPs
 ;IHS/CMI/LAB - fixed to exclude ER visits for BP's
 NEW APCHD,APCHC
 K APCHX
 S APCHX="",APCHD="",APCHC=0
 ;S X=P_"^LAST 3 MEASUREMENTS BP" S E=$$START1^APCLDF(X,"APCHX(") G:E BPX I $D(APCHX(1)) D
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
GETHWB(P)  ;get last height, height date, weight, weight date and BMI for patient P, return in APCHX("HT"),APCHX("HTD"),APCHX("WT"),APCHX("WTD"),APCHX("BMI")
 K APCHX
 S APCHX("HT")="",APCHX("HTD")="",APCHX("WT")="",APCHX("WTD")="",APCHX("BMI")="",APCHX("WC")="",APCHX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW APCHY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("HT")=$P($G(APCHY(1)),U,2),APCHX("HTD")=$$FMTE^XLFDT($P($G(APCHY(1)),U))
 S APCHX("HT")=$S(APCHX("HT")]"":$J(APCHX("HT"),2,0),1:"")
LASTWT ;
 K APCHY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("WT")=$P($G(APCHY(1)),U,2),APCHX("WTD")=$$FMTE^XLFDT($P($G(APCHY(1)),U))
LASTWC ;
 K APCHY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"APCHY(") S APCHX("WC")=$P($G(APCHY(1)),U,2),APCHX("WCD")=$$FMTE^XLFDT($P($G(APCHY(1)),U))
BMI ;
 I $$AGE^AUPNPAT(P)<19,(APCHX("WTD")'=APCHX("HTD")) Q
 I APCHX("WT")=""!('APCHX("HT")) Q
 S %=""
 ;S W=(APCHX("WT")/5)*2.3,H=(APCHX("HT")*2.5),H=(H*H)/10000,%=(W/H),%=$J(%,4,1)
 S W=APCHX("WT")*.45359,H=(APCHX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S APCHX("BMI")=%
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
DOO(P) ;get earliest date of onset
 NEW X,DOO
 S X=$$CMSFDX^APCHS9B4(P,"I")
 I X]"",'$D(DOO(X)) S DOO(X)="Diabetes Register"
 S DOO="" S X=$$PLDMDOO^APCHS9B4(P,"I")
 I X]"" S DOO(X)="Problem List"
 I $O(DOO(0))="" Q ""
 S X=$O(DOO(0)) Q $$FMTE^XLFDT(X)_" ("_DOO(X)_")"
NOTREG(P) ;is patient on any Diabetes register 1 if on reg, "" if not
 I $G(P)="" Q ""
 NEW X,Y
 S X=0,Y="" F  S X=$O(^ACM(41,"AC",P,X)) Q:X'=+X!(Y)  D
 .S N=$$UP^XLFSTR($P($G(^ACM(41.1,X,0)),U))
 .I N["DIABETES" S Y=1
 .I N["DIAB" S Y=1
 .I N["DM " S Y=1
 .I N[" DM" S Y=1
 .Q
 Q Y
DEPPL(P,BDATE,EDATE) ;EP
 NEW APCH,X
 K APCH
 S (G,X,I)=""
 ;is depression on the problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .S I=$P($G(^AUPNPROB(X,0)),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .;S G="Yes - Problem List "_$P(^ICD9(I,0),U)  cmi/anch/maw 8/27/2007 orig line
 .S G="Yes - Problem List "_$P($$ICDDX^ICDCODE(I,,,1),U,2)  ;cmi/anch/maw 8/27/2007 code set versioning
 .Q
 I G]"" Q G
 S (G,X,I)=""
 ;is depression on the BH problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AMHPPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AMHPPROB(X,0)),U)
 .S I=$P($G(^AMHPROB(I,0)),U,5)
 .Q:I=""
 .S I=+$$CODEN^ICDCODE(I,80)
 .Q:I=""
 .Q:'$$ICD^ATXCHK(I,T,9)
 .;S G="Yes - BH Problem List "_$P(^ICD9(I,0),U)  cmi/anch/maw 8/27/2007 orig line
 .S G="Yes - BH Problem List "_$P($$ICDDX^ICDCODE(I,,,1),U,2)  ;cmi/anch/maw 8/27/2007 code set versioning
 .Q
 I G]"" Q G
 ;now check for 2 dxs in past year
 S Y="APCH("
 S X=P_"^LAST 2 DX [DM AUDIT DEPRESSIVE DISORDERS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCH(2)) Q "Yes 2 or more dxs in past year"
 S APCH=0,APCHV="" I $D(APCH(1)) S APCH=1,APCHV=$P(APCH(1),U,5)
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 ;go through BH record file and find up to 2 visits in date range
 S E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(APCH>1)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCH>1)  D
 .Q:'$D(^AMHREC(V,0))
 .I $P(^AMHREC(V,0),U,16)]"",APCHV]"",$P(^AMHREC(V,0),U,16)=APCHV Q  ;don't use same visit
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(APCH>1)  S APCHP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'APCHP
 ..S APCHP=$P($G(^AMHPROB(APCHP,0)),U)
 ..I APCHP=14 S APCH=APCH+1 Q
 ..I APCHP=15 S APCH=APCH+1 Q
 ..I APCHP=18 S APCH=APCH+1 Q
 ..I APCHP=24 S APCH=APCH+1 Q
 ..I $E(APCHP,1,3)=296 S APCH=APCH+1 Q
 ..I $E(APCHP,1,3)=300 S APCH=APCH+1 Q
 ..I $E(APCHP,1,3)=309 S APCH=APCH+1 Q
 ..I APCHP="301.13" S APCH=APCH+1 Q
 ..I APCHP=308.3 S APCH=APCH+1 Q
 ..I APCHP="311." S APCH=APCH+1 Q
 ..Q
 I APCH>1 Q "Yes 2 or more dxs in past year"
 Q "No"
DEPSCR(P,BDATE,EDATE) ;EP
 NEW X
 I $G(P)="" Q ""
 K APCH S APCHLAST=""
 S Y="APCH("
 S X=P_"^LAST DX V79.0;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCH(1)) S APCHLAST=$P(APCH(1),U)_U_"Yes V79.0"_" "_$$FMTE^XLFDT($P(APCH(1),U),5)
 K APCH
 S Y="APCH("
 S X=P_"^LAST EXAM 36;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCH(1)),$P(APCH(1),U)>$P(APCHLAST,U) S APCHLAST=$P(APCH(1),U)_U_"Yes Exam 36-Dep Screen "_$$FMTE^XLFDT($P(APCH(1),U),5)
 K APCH
 S Y="APCH("
 S X=P_"^ALL EDUC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I '$D(APCH(1)) G BHSCR
 S (X,E)=0,%="",T="",D="" F  S X=$O(APCH(X)) Q:X'=+X!(D)  D
 .S T=$P(^AUPNVPED(+$P(APCH(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I T="DEP-SCR",$P(APCH(X),U)>$P(APCHLAST,U) S APCHLAST=$P(APCH(X),U)_U_"Yes Pt Ed "_T_" "_$$FMTE^XLFDT($P(APCH(X),U),5)
 K APCH
BHSCR ;
 S APCHRF="",D=0,APCHC="",E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V  D
 .S APCHRF=$P($G(^AMHREC(V,14)),U,5) I APCHRF]"",$E(APCHRF)'="R",$E(APCHRF)'="U",(9999999-$P(D,"."))>$P(APCHLAST,U) S APCHLAST=(9999999-$P(D,"."))_U_"Yes BH Dep Scr "_$$FMTE^XLFDT((9999999-$P(D,".")),5) Q
 .I APCHRF]"" S APCHRF=$$VAL^XBDIQ1(9002011,V,1405)_" on "_$$FMTE^XLFDT((9999999-$P(D,".")),5)
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(APCHC]"")  S APCHP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'APCHP
 ..S APCHP=$P($G(^AMHPROB(APCHP,0)),U)
 ..I APCHP=14.1,(9999999-$P(D,"."))>$P(APCHLAST,U) S APCHLAST=(9999999-$P(D,"."))_U_"Yes BH 14.1 "_$$FMTE^XLFDT((9999999-$P(D,".")),5) Q
 ..I '$D(^AMHREDU("AD",V)) Q
 ..S Y=0 F  S Y=$O(^AMHREDU("AD",V,Y)) Q:Y'=+Y  D
 ...S T=$P(^AMHREDU(Y,0),U)
 ...Q:'T
 ...Q:'$D(^AUTTEDT(T,0))
 ...S T=$P(^AUTTEDT(T,0),U,2)
 ...I T="DEP-SCR",(9999999-$P(D,"."))>$P(APCHLAST,U) S APCHLAST=(9999999-$P(D,"."))_U_"Yes BH PT Ed "_T_" "_$$FMTE^XLFDT((9999999-$P(D,".")),5)
 ...Q
 I APCHLAST]"" Q $P(APCHLAST,U,2,99)
 ;now check for refusals
 S APCHC=$$REFDF^APCHS9B3(P,9999999.15,$O(^AUTTEXAM("B","DEPRESSION SCREENING",0)))
 I APCHC]"" S X=$P(APCHC,"DEPRESSION SCREENING ",1)_$P(APCHC,"DEPRESSION SCREENING ",2) Q X
 I APCHRF]"" Q APCHRF
 Q "No"
