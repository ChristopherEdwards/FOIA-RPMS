BDMS9B1 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT 12 Jan 2011 12:27 PM ; [ 12 Jan 2011 12:27 PM ]
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
 Q:'$G(APCHSPAT)
 S BDMSPAT=APCHSPAT
 S BDMSHDR=APCHSHDR
 D EN^XBNEW("EP^BDMS9B1","BDMSPAT;BDMSHDR;APCHSQIT")
 K ^TMP("APCHS",$J)
 K BDMSPAT
 Q
EP ;EP - called from xbnew
 D EP2(BDMSPAT)
W ;write out array
 W:$D(IOF) @IOF
 K BDMQUIT
 W !
 S BDMX=0 F  S BDMX=$O(^TMP("APCHS",$J,"DCS",BDMX)) Q:BDMX'=+BDMX!($D(BDMQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BDMQUIT)
 .W ^TMP("APCHS",$J,"DCS",BDMX),!
 .Q
 I $D(BDMQUIT) S APCHSQIT=1
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
 W !,"Diabetes Patient Care Summary - continued"
 W !,"Patient: ",$P(^DPT(BDMSPAT,0),U),"  HRN: ",$$HRN^AUPNPAT(BDMSPAT,DUZ(2)),!
 Q
EP2(BDMSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHS",$J,"DCS"
 K ^TMP("APCHS",$J,"DCS")
 S ^TMP("APCHS",$J,"DCS",0)=0
 D EN^XBNEW("EP21^BDMS9B1","BDMSDFN")
 Q
EP21 ;
 S BDMSPAT=BDMSDFN
 D SETARRAY
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="DIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$DATE(DT) D S(X)
 S X="Patient Name:  "_$P(^DPT(BDMSDFN,0),U)_"    HRN: "_$$HRN^AUPNPAT(BDMSDFN,DUZ(2))_"  "_$$VAL^XBDIQ1(9000001,BDMSDFN,1111) D S(X)
 I $$DOD^AUPNPAT(BDMSDFN)]"" S X="DATE OF DEATH: "_$$DATE($$DOD^AUPNPAT(BDMSDFN)) D S(X,1),S(" ")
 S X="Age:  "_$$AGE^AUPNPAT(BDMSDFN),$E(X,15)="Sex:  "_$$SEX^AUPNPAT(BDMSDFN),$E(X,31)="Date of DM Onset: "_$$DOO(BDMSDFN) D S(X)
 S X="",X="DOB:  "_$$DATE($$DOB^AUPNPAT(BDMSDFN)) S Y=$$DMPN(BDMSDFN),$E(X,31)="DM Problem #: "_$S(Y]"":Y,1:"*** NONE RECORDED ***") D S(X)
 S X="" I '$$NOTREG(BDMSDFN) S X="**NOT ON DIABETES REGISTER**"
 S $E(X,31)="Designated PCP: "_$$DPCP(BDMSDFN) D S(X)
 D GETHWB(BDMSDFN)
 S X="Last Height:  "_BDMX("HT")_$S(BDMX("HT")]"":" inches",1:""),$E(X,31)=BDMX("HTD") D S(X)
 S X="Last Weight:  "_$S(BDMX("WT")]"":$J(BDMX("WT"),3,0),1:"")_$S(BDMX("WT")]"":" lbs",1:""),$E(X,31)=BDMX("WTD"),$E(X,45)="BMI: "_BDMX("BMI") D S(X)
 I BDMX("WC")]"" S X="Last Waist Circumference: "_BDMX("WC"),$E(X,31)=BDMX("WCD") D S(X)
 I BDMX("WC")="" S X="Last Waist Circumference: <None Recorded>" D S(X)
 D TOBACCO^BDMS9B3
 S X="Tobacco Use:  "_$P($G(BDMTOBS),U,1) D S(X)
 I $G(BDMTOBC)]"" S X="              "_$P(BDMTOBC,U,1) D S(X)
 S X="HTN Diagnosed:  "_$$HTN(BDMSDFN) D S(X)
 S BDMSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^BDMS9B4(BDMSDFN,BDMSBEG) ;get date of last ACE in last 6 months
 S X="",X="ON ACE Inhibitor/ARB in past 6 months: "_% D S(X)
 K BDMSX
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S BDMSX=$E($$ASPIRIN(BDMSDFN,BDMSBEG),1,32)
 S X="Aspirin Use/Anti-platelet (in past yr):  "_BDMSX D S(X)
 I BDMSX="No" S X="",X=$$ASPREF^BDMS9B4(BDMSDFN) I X]"" S X="     "_X D S(X)
 S BDMDEPP=$$DEPPL(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S BDMDEPS=$$DEPSCR^BDMD112(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S BDMDEPS=$P(BDMDEPS,"  ",2,99)
 S B=$$BP(BDMSDFN)
 S X="Last 3 BP:  "_$P($G(BDMX(1)),U,2)_"   "_$$DATE($P($G(BDMX(1)),U))
 S $E(X,40)="Is Depression on the Problem List?"
 D S(X)
 S X="(non ER)" I $D(BDMX(2)) S $E(X,13)=$P(BDMX(2),U,2)_"   "_$$DATE($P(BDMX(2),U))
 S $E(X,42)=BDMDEPP
 D S(X)
 S X="" I $D(BDMX(3)) S X="",$E(X,13)=$P(BDMX(3),U,2)_"   "_$$DATE($P(BDMX(3),U))
 I $E(BDMDEPP,1)="N" S $E(X,40)="If no, Depression Screening in past year?"
 D S(X)
 S X="" I $E(BDMDEPP,1)="N" S $E(X,42)=BDMDEPS
 D S(X)
M12 ;
 ;determine date range
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S X="In past 12 months:" D S(X)
 S X="Diabetic Foot Exam:",$E(X,23)=$P($$DFE^BDMD117(BDMSDFN,BDMSBEG,DT,"H"),"  ",2,99) D S(X)
 S X="Diabetic Eye Exam:",$E(X,23)=$P($$EYE^BDMD117(BDMSDFN,BDMSBEG,DT,"H"),"  ",2,99) D S(X)
 S X="Dental Exam:",$E(X,23)=$P($$DENTAL^BDMD117(BDMSDFN,BDMSBEG,DT),"  ",2,99) D S(X)
 K BDMSTEX,BDMSDAT,BDMX
 I $P(^DPT(BDMSDFN,0),U,2)="F",$$AGE^AUPNPAT(BDMSDFN)>17 D
 .S BDMMAM=$$LASTMAM^APCLAPI1(BDMSDFN,,,"A"),BDMSDAT=$P(BDMMAM,U,1)
 .S BDMMAMR=$$MAMREF^BDMS9B4(BDMSDFN,BDMSDAT)
 .S X="Last Mammogram:",$E(X,23)=$$DATE($P(BDMMAM,U,1))_"  "_$P(BDMMAM,U,2) D S(X)
 .I BDMMAMR]"" S X="",$E(X,10)="Note: "_$P(BDMMAMR,U,2) D S(X)
 .S BDMX=$$PAP^BDMS9B4(BDMSDFN) ;get date of last pap in pcc/refusal
 .S X="Last Pap Smear: ",$E(X,23)=$$DATE($P(BDMX,U))_"  "_$P(BDMX,U,3) D S(X)
 .I $P(BDMX,U,2)]"" S X="",$E(X,10)="Note: "_$P(BDMX,U,2) D S(X)
 D MORE^BDMS9B2
 S X=$P(^DPT(BDMSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(BDMSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(BDMSDFN,DUZ(2),2) D S(X,1) ;IHS/CMI/LAB - X,3 to X,2
 Q
DPCP(P) ;EP
 NEW R
 D ALLDP^BDPAPI(P,"DESIGNATED PRIMARY PROVIDER",.R)
 I $D(R("DESIGNATED PRIMARY PROVIDER")) Q $P(^VA(200,$P(R("DESIGNATED PRIMARY PROVIDER"),U,2),0),U,1)
 S R=$P(^AUPNPAT(P,0),U,14) I R Q $P(^VA(200,R,0),U,1)
 S R=""
 Q R
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
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
 Q
HTN(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)="A" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW BDMX
 S BDMX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"BDMX(") G:E HTNX I $D(BDMX(3)) S BDMX="Yes"
 I $G(BDMX)="" S BDMX="No"
HTNX ;
 Q BDMX
DMPN(P) ;return problem number of lowest DM code
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..S D(+$P($$ICDDX^ICDCODE(I,,,1),U,2))=X
 ..Q
 .Q
 S D=$O(D(""))
 I D="" Q D
 S X=D(D) ;ien of problem now return problem #
 NEW L S L=$P(^AUPNPROB(X,0),U,6)
 NEW Y S Y=$S(L:$P(^AUTTLOC(L,0),U,7),1:"???")_$P(^AUPNPROB(X,0),U,7)
 Q Y
BP(P) ;last 3 BPs
 ;exclude ER visits for BP's
 NEW BDMD,BDMC
 K BDMX
 S BDMX="",BDMD="",BDMC=0
 S T=$O(^AUTTMSR("B","BP",""))
 F  S BDMD=$O(^AUPNVMSR("AA",P,T,BDMD)) Q:BDMD=""!(BDMC=3)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,BDMD,M)) Q:M'=+M!(BDMC=3)  D
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..Q:$P($G(^AUPNVMSR(M,2)),U,1)  ;deleted
 ..S BDMC=BDMC+1,BDMX(BDMC)=(9999999-BDMD)_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 I '$D(BDMX(1)) S BDMX(1)="None recorded"
BPX ;
 K BDMD,BDMC
 Q BDMX
GETHWB(P)  ;get last height, height date, weight, weight date and BMI for patient P, return in BDMX("HT"),BDMX("HTD"),BDMX("WT"),BDMX("WTD"),BDMX("BMI")
 K BDMX
 S BDMX("HT")="",BDMX("HTD")="",BDMX("WT")="",BDMX("WTD")="",BDMX("BMI")="",BDMX("WC")="",BDMX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW BDMY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("HT")=$P($G(BDMY(1)),U,2),BDMX("HTD")=$$DATE($P($G(BDMY(1)),U))
 S BDMX("HT")=$S(BDMX("HT")]"":$J(BDMX("HT"),2,0),1:"")
LASTWT ;
 K BDMY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("WT")=$P($G(BDMY(1)),U,2),BDMX("WTD")=$$DATE($P($G(BDMY(1)),U))
LASTWC ;
 K BDMY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("WC")=$P($G(BDMY(1)),U,2),BDMX("WCD")=$$DATE($P($G(BDMY(1)),U))
BMI ;
 I $$AGE^AUPNPAT(P)<19,(BDMX("WTD")'=BDMX("HTD")) Q
 I BDMX("WT")=""!('BDMX("HT")) Q
 S %=""
 S W=BDMX("WT")*.45359,H=(BDMX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S BDMX("BMI")=%
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
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$DATE($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$DATE($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 Q "No"
DOO(P) ;get earliest date of onset
 NEW X,DOO
 S X=$$CMSFDX^BDMS9B4(P,"I")
 I X]"",'$D(DOO(X)) S DOO(X)="Diabetes Register"
 S DOO="" S X=$$PLDMDOO^BDMS9B4(P,"I")
 I X]"" S DOO(X)="Problem List"
 I $O(DOO(0))="" Q ""
 S X=$O(DOO(0)) Q $$DATE(X)_" ("_DOO(X)_")"
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
 NEW BDM,X
 K BDM
 S (G,X,I)=""
 ;is depression on the problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AUPNPROB(X,0)),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .S G="Yes - Problem List "_$P($$ICDDX^ICDCODE(I,,,1),U,2)
 .Q
 I G]"" Q G
 S (G,X,I)=""
 ;is depression on the BH problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AMHPPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AMHPPROB(X,0)),U)
 .Q:I=""
 .S I=$P($G(^AMHPROB(I,0)),U,5)
 .Q:I=""
 .S I=+$$CODEN^ICDCODE(I,80)
 .Q:I=""
 .Q:'$$ICD^ATXCHK(I,T,9)
 .Q:$P(^AMHPPROB(X,0),U,12)'="A"
 .;S G="Yes - BH Problem List "_$P(^ICD9(I,0),U)  cmi/anch/maw 8/27/2007 orig line
 .S G="Yes - BH Problem List "_$P($$ICDDX^ICDCODE(I,,,1),U,2)  ;cmi/anch/maw 8/27/2007 code set versioning
 .Q
 I G]"" Q G
 ;now check for 2 dxs in past year
 S Y="BDM("
 S X=P_"^LAST 2 DX [DM AUDIT DEPRESSIVE DISORDERS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(BDM(2)) Q "Yes, 2 or more dxs in past year"
 S BDM=0,BDMV="" I $D(BDM(1)) S BDM=1,BDMV=$P(BDM(1),U,5)
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 ;go through BH record file and find up to 2 visits in date range
 S E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(BDM>1)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(BDM>1)  D
 .Q:'$D(^AMHREC(V,0))
 .I $P(^AMHREC(V,0),U,16)]"",BDMV]"",$P(^AMHREC(V,0),U,16)=BDMV Q  ;don't use same visit
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(BDM>1)  S BDMP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'BDMP
 ..S BDMP=$P($G(^AMHPROB(BDMP,0)),U)
 ..I BDMP=14 S BDM=BDM+1 Q
 ..I BDMP=15 S BDM=BDM+1 Q
 ..I BDMP=18 S BDM=BDM+1 Q
 ..I BDMP=24 S BDM=BDM+1 Q
 ..I $E(BDMP,1,3)=296 S BDM=BDM+1 Q
 ..I $E(BDMP,1,3)=300 S BDM=BDM+1 Q
 ..I $E(BDMP,1,3)=309 S BDM=BDM+1 Q
 ..I BDMP="301.13" S BDM=BDM+1 Q
 ..I BDMP=308.3 S BDM=BDM+1 Q
 ..I BDMP="311." S BDM=BDM+1 Q
 ..Q
 I BDM>1 Q "Yes, 2 or more dxs in past year"
 Q "No"
