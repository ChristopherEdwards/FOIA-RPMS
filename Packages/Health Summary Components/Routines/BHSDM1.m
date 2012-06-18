BHSDM1 ;IHS/CIA/MGH - Health Summary for Diabetic Supplement ;04-Aug-2011 14:30;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2,4,6**;March 17, 2006;Build 5
 ;===================================================================
 ;VA version of IHS components for supplemental summaries
 ;Taken from BDMS9B1
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;08-Nov-2004 15:52;MGH
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,8,9,10**;JUN 24, 1997
 ;Update to patch 15 of IHS health summary
 ;Patch 2 code set versoning changes
 ;Patch 4 includes removing entered in error readings
 ;Patch 6 updated for tobacco
 ;==================================================================
 ;
 ;IHS/CMI/LAB patch 3 many changes
 ;
EP ;EP - called from component
 Q:'$G(BHSPAT)
 D CKP^GMTSUP Q:$D(GMTSQIT)
 D EP2(BHSPAT)
W ;write out array
 K BHSQUIT
 S BHSX=0 F  S BHSX=$O(^TMP("BHS",$J,"DCS",BHSX)) Q:BHSX'=+BHSX!($D(GMTSQIT))  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W !,^TMP("BHS",$J,"DCS",BHSX)
 .Q
 I $D(BHSQUIT) S GMTSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K APCHIEN,BHSX,BHSQUIT,BHSY,BHSDFN,BHSBEG,BDMSPAT,BHSTOB,BHSUPI,BHSED,BHSTOPN,BHSTOP,BHSTEX,BHS,BHSP,BHSLAST,APCHP,APCHV,BHSC,BHSRF,BHSEKG,BHSEX,BHDTOB
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W,BD,ED,APCHC,APCHD,APCHX,APCHDEPP,APCHDEPS
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
 S BDMSPAT=BHSDFN
 S X="DIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient Name:  "_$P(^DPT(BHSDFN,0),U)_"    HRN: "_$$HRN^AUPNPAT(BHSDFN,DUZ(2)) D S(X)
 I $$DOD^AUPNPAT(BHSDFN)]"" S X="DATE OF DEATH: "_$$FMTE^XLFDT($$DOD^AUPNPAT(BHSDFN)) D S(X,1),S(" ")
 S X="Age:  "_$$AGE^AUPNPAT(BHSDFN),$E(X,15)="Sex:  "_$$SEX^AUPNPAT(BHSDFN),$E(X,31)="Date of DM Onset: "_$$DOO(BHSDFN) D S(X)
 S X="",X="Dob:  "_$$FMTE^XLFDT($$DOB^AUPNPAT(BHSDFN)) S Y=$$DMPN(BHSDFN),$E(X,31)="DM Problem #: "_$S(Y]"":Y,1:"*** NONE RECORDED ***") D S(X)
 S X="" I '$$NOTREG(BHSDFN) S X="**NOT ON DIABETES REGISTER**"
 S $E(X,31)="Designated PCP: "_$$VAL^XBDIQ1(9000001,BHSDFN,.14) D S(X)
 D GETHWB(BHSDFN) S X="Last Height:  "_BHSX("HT")_$S(BHSX("HT")]"":" inches",1:""),$E(X,31)=BHSX("HTD") D S(X)
 S X="Last Weight:  "_$S(BHSX("WT")]"":$J(BHSX("WT"),3,0),1:"")_$S(BHSX("WT")]"":" lbs",1:""),$E(X,31)=BHSX("WTD"),$E(X,45)="BMI: "_BHSX("BMI") D S(X)
 I BHSX("WC")]"" S X="Last Waist Cir: "_BHSX("WC"),$E(X,31)=BHSX("WCD") D S(X)
 ;Patch 6
 N BDMSDFN,BDMTOBC,BDMTOBS
 S BDMSDFN=BHSDFN
 D TOBACCO^BDMS9B3
 S X="Tobacco Use:  "_$P($G(BDMTOBS),U,1) D S(X)
 I $G(BDMTOBC)]"" S X="              "_$P(BDMTOBC,U,1) D S(X)
 S X="HTN Diagnosed:  "_$$HTN(BHSDFN) D S(X,1)
 S BHSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^BDMS9B5(BHSDFN,BHSBEG) ;get date of last ACE in last year
 S X="",X="ON ACE Inhibitor/ARB in past 6 months: "_% D S(X)
 K BHSX S BHSBEG=$$FMADD^XLFDT(DT,-365) S X="Aspirin Use (in past yr):  "_$E($$ASPIRIN(BHSDFN,BHSBEG),1,32) D S(X)
 S X="",X=$$ASPREF^BHSDM5(BHSDFN) I X]"" S X="     "_X D S(X)
 S APCHDEPP=$$DEPPL(BHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S APCHDEPS=$$DEPSCR^BDMD012(BHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S APCHDEPS=$P(APCHDEPS," ",2,99)
 S B=$$BP(BHSDFN)
 S X="Last 3 BP:  "_$P($G(BHSX(1)),U,2)_"     "_$$FMTE^XLFDT($P($G(BHSX(1)),U))
 S $E(X,40)="Is Depression on the Problem List?"
 D S(X)
 S X="(non ER)" I $D(BHSX(2)) S $E(X,13)=$P(BHSX(2),U,2)_"   "_$$FMTE^XLFDT($P(BHSX(2),U))
 S $E(X,42)=APCHDEPP
 D S(X,1)
 S X="" I $D(BHSX(3)) S X="",$E(X,13)=$P(BHSX(3),U,2)_"     "_$$FMTE^XLFDT($P(BHSX(3),U))
 I $E(APCHDEPP,1)="N" S $E(X,40)="If no, Depression Screening in past year?"
 D S(X)
 S X="" I $E(APCHDEPP,1)="N" S $E(X,42)=APCHDEPS
 D S(X)
M12 ;
 ;determine date range
 S BHSBEG=$$FMADD^XLFDT(DT,-365)
 S X="In past 12 months:" D S(X,1)
 S X="Diabetic Foot Exam:",$E(X,23)=$P($$DFE^BDMD017(BHSDFN,BHSBEG)," ",2,99) D S(X)
 S X="Diabetic Eye Exam:",$E(X,23)=$P($$EYE^BDMD017(BHSDFN,BHSBEG)," ",2,99) D S(X)
 S X="Dental Exam:",$E(X,23)=$P($$DENTAL^BDMD017(BHSDFN,BHSBEG)," ",2,99) D S(X)
 ;S X="Rectal Exam (age>40):",$E(X,27)=$$RECTAL^BHSDM4(BHSDFN,BHSBEG) D S(X)
 K BHSTEX,BHSDAT,BHSX
 D MORE^BHSDM2
 S X=$P(^DPT(BHSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(BHSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(BHSDFN,DUZ(2),2) D S(X,1) ;IHS/CMI/LAB - X,3 to X,2
 ;S X="" D S(X,1)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
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
HTN(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW BHSX
 S BHSX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"BHSX(") G:E HTNX I $D(BHSX(3)) S BHSX="Yes"
 I $G(BHSX)="" S BHSX="No"
HTNX ;
 Q BHSX
DMPN(P) ;return problem number of lowest DM code
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..;S D(+$P(^ICD9(I,0),U))=X
 ..S D(+$P($$ICDDX^ICDCODE(I),U,2))=X  ;cmi/anch/maw 8/27/2007 code set
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
 NEW APCHD,APCHC,T,M,V
 K BHSX
 S BHSX="",APCHD="",APCHC=0
 ;S X=P_"^LAST 3 MEASUREMENTS BP" S E=$$START1^APCLDF(X,"BHSX(") G:E BPX I $D(BHSX(1)) D
 S T=$O(^AUTTMSR("B","BP",""))
 F  S APCHD=$O(^AUPNVMSR("AA",P,T,APCHD)) Q:APCHD=""!(APCHC=3)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,APCHD,M)) Q:M'=+M!(APCHC=3)  D
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P($G(^AUPNVMSR(M,2)),U,1)  ;entered in error
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S APCHC=APCHC+1,BHSX(APCHC)=(9999999-APCHD)_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 I '$D(BHSX(1)) S BHSX(1)="None recorded"
BPX ;
 K APCHD,APCHC
 Q BHSX
GETHWB(P) ;get last height, height date, weight, weight date and BMI for patient P, return in BHSX("HT"),BHSX("HTD"),BHSX("WT"),BHSX("WTD"),BHSX("BMI")
 K BHSX
 S BHSX("HT")="",BHSX("HTD")="",BHSX("WT")="",BHSX("WTD")="",BHSX("BMI")="",BHSX("WC")="",BHSX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW BHSY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("HT")=$P($G(BHSY(1)),U,2),BHSX("HTD")=$$FMTE^XLFDT($P($G(BHSY(1)),U))
 S BHSX("HT")=$S(BHSX("HT")]"":$J(BHSX("HT"),2,0),1:"")
LASTWT ;
 K BHSY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("WT")=$P($G(BHSY(1)),U,2),BHSX("WTD")=$$FMTE^XLFDT($P($G(BHSY(1)),U))
LASTWC ;
 K BHSY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"BHSY(") S BHSX("WC")=$P($G(BHSY(1)),U,2),BHSX("WCD")=$$FMTE^XLFDT($P($G(BHSY(1)),U))
BMI ;
 I $$AGE^AUPNPAT(P)<19,(BHSX("WTD")'=BHSX("HTD")) Q
 I BHSX("WT")=""!('BHSX("HT")) Q
 S %=""
 ;S W=(BHSX("WT")/5)*2.3,H=(BHSX("HT")*2.5),H=(H*H)/10000,%=(W/H),%=$J(%,4,1)
 S W=BHSX("WT")*.45359,H=(BHSX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S BHSX("BMI")=%
 Q
ASPIRIN(P,D) ;
 I '$G(P) Q ""
 I '$G(D) S D=0 ;if don't pass date look at all time
 NEW V,I,%,G
 S %=""
 NEW T,T1
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S T1=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I 'T Q ""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  S G=$P(^AUPNVMED(V,0),U) D
 ..I $D(^ATXAX(T,21,"B",G)) S %=V Q
 ..I T1,$D(^ATXAX(T1,21,"B",G)) S %=V Q
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 Q "No"
DOO(P) ;get earliest date of onset
 NEW X,DOO
 S X=$$CMSFDX^BHSDM4(P,"I")
 I X]"",'$D(DOO(X)) S DOO(X)="Diabetes Register"
 S DOO="" S X=$$PLDMDOO^BHSDM4(P,"I")
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
 NEW BHS,X,Y,T
 K BHS
 S (G,X,I)=""
 ;is depression on the problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AUPNPROB(X,0)),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .;S G="Yes - Problem List "_$P(^ICD9(I,0),U)
 .S G="Yes - Problem List "_$P($$ICDDX^ICDCODE(I),U,2)  ;code set versioning
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
 .;S G="Yes - BH Problem List "_$P(^ICD9(I,0),U)
 .S G="Yes - BH Problem List "_$P($$ICDDX^ICDCODE(I),U,2) ;code set versioning
 .Q
 I G]"" Q G
 ;now check for 2 dxs in past year
 N %DT
 S Y="BHS("
 S X=P_"^LAST 2 DX [DM AUDIT DEPRESSIVE DISORDERS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(BHS(2)) Q "Yes 2 or more dxs in past year"
 S BHS=0,APCHV="" I $D(BHS(1)) S BHS=1,APCHV=$P(BHS(1),U,5)
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 ;go through BH record file and find up to 2 visits in date range
 S E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(BHS>1)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(BHS>1)  D
 .Q:'$D(^AMHREC(V,0))
 .I $P(^AMHREC(V,0),U,16)]"",APCHV]"",$P(^AMHREC(V,0),U,16)=APCHV Q           ;don't use same visit
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(BHS>1)  S BHSP=$P($G(^AMHPRO(X,0)),U) D
 ..Q:'BHSP
 ..S APCHP=$P($G(^AMHPROB(BHSP,0)),U)
 ..I BHSP=14 S BHS=BHS+1 Q
 ..I BHSP=15 S BHS=BHS+1 Q
 ..I BHSP=18 S BHS=BHS+1 Q
 ..I BHSP=24 S BHS=BHS+1 Q
 ..I $E(BHSP,1,3)=296 S BHS=BHS+1 Q
 ..I $E(BHSP,1,3)=300 S BHS=BHS+1 Q
 ..I $E(BHSP,1,3)=309 S BHS=BHS+1 Q
 ..I BHSP="301.13" S BHS=BHS+1 Q
 ..I BHSP=308.3 S BHS=BHS+1 Q
 ..I BHSP="311." S BHS=BHS+1 Q
 ..Q
 I BHS>1 Q "Yes 2 or more dxs in past year"
 Q "No"
BHSCR ;
 S BHSRF="",D=0,BHSC="",E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V  D
 .S BHSRF=$P($G(^AMHREC(V,14)),U,5) I BHSRF]"",$E(BHSRF)'="R",$E(BHSRF)'="U",(9999999-$P(D,"."))>$P(BHSLAST,U) S BHSLAST=(9999999-$P(D,"."))_U_"Yes BH Dep Scr "_$$FMTE^XLFDT((9999999-$P(D,".")),5) Q
 .I BHSRF]"" S BHSRF=$$VAL^XBDIQ1(9002011,V,1405)_" on "_$$FMTE^XLFDT((9999999-$P(D,".")),5)
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(BHSC]"")  S BHSP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'BHSP
 ..S BHSP=$P($G(^AMHPROB(BHSP,0)),U)
 ..I BHSP=14.1,(9999999-$P(D,"."))>$P(BHSLAST,U) S BHSLAST=(9999999-$P(D,"."))_U_"Yes BH 14.1 "_$$FMTE^XLFDT((9999999-$P(D,".")),5) Q
 ..I '$D(^AMHREDU("AD",V)) Q
 ..S Y=0 F  S Y=$O(^AMHREDU("AD",V,Y)) Q:Y'=+Y  D
 ...S T=$P(^AMHREDU(Y,0),U)
 ...Q:'T
 ...Q:'$D(^AUTTEDT(T,0))
 ...S T=$P(^AUTTEDT(T,0),U,2)
 ...I T="DEP-SCR",(9999999-$P(D,"."))>$P(BHSLAST,U) S BHSLAST=(9999999-$P(D,"."))_U_"Yes BH PT Ed "_T_" "_$$FMTE^XLFDT((9999999-$P(D,".")),5)
 ...Q
 I BHSLAST]"" Q $P(BHSLAST,U,2,99)
 ;now check for refusals
 S BHSC=$$REF^BHSMU(P,9999999.15,$O(^AUTTEXAM("B","DEPRESSION SCREENING",0)))
 I BHSC]"" S X=$P(BHSC,"DEPRESSION SCREENING ",1)_$P(BHSC,"DEPRESSION SCREENING ",2) Q X
 I BHSRF]"" Q BHSRF
 Q "No"
