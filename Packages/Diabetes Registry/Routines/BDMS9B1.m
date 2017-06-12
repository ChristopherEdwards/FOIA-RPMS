BDMS9B1 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT 12 Jan 2011 12:27 PM ; [ 12 Jan 2011 12:27 PM ]
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4,5,6,7,8,9**;JUN 14, 2007;Build 78
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
 K ^TMP("APCHS",$J,"DCS")
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
 ;K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S BDMJOB=$J,BDMBTH=$H
 ;D UNFOLDTX^BDMUTL(2016)
 I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="DIABETES PATIENT CARE SUMMARY",$E(X,40)="Report Date:  "_$$DATE(DT) D S(X)
 S X="Patient: "_$E($P(^DPT(BDMSDFN,0),U),1,28),$E(X,40)="HRN: "_$$HRN^AUPNPAT(BDMSDFN,DUZ(2)) D S(X,1)
 I $$DOD^AUPNPAT(BDMSDFN)]"" S X="DATE OF DEATH: "_$$DATE($$DOD^AUPNPAT(BDMSDFN)) D S(X,1),S(" ")
 S X="Age:  "_$$AGE^BDMAPIU(BDMSDFN,1,DT)_" (DOB "_$$DATE($$DOB^AUPNPAT(BDMSDFN))_")",$E(X,40)="Sex: "_$$VAL^XBDIQ1(2,BDMSDFN,.02) D S(X)
 S X="CLASS/BEN: "_$$VAL^XBDIQ1(9000001,BDMSDFN,1111),$E(X,40)="Designated PCP: "_$E($$DPCP(BDMSDFN),1,25) D S(X)
 S X="Date of DM Onset: "_$$DOO(BDMSDFN) S Y=$$DMPN(BDMSDFN),$E(X,58)="DM Problem #: "_$S(Y]"":Y,1:"*NONE RECORDED*") D S(X,1)
 S X="" I '$$NOTREG(BDMSDFN) S X="**NOT ON DIABETES REGISTER**"
 D GETHWB(BDMSDFN)
 S X="BMI: "_BDMX("BMI"),$E(X,12)="Last Height:  "_$$STRIP^XLFSTR($J(BDMX("HT"),5,2)," ")_$S(BDMX("HT")]"":" inches",1:""),$E(X,40)=BDMX("HTD") D S(X,1)
 S X="",$E(X,12)="Last Weight:  "_$S(BDMX("WT")]"":BDMX("WT")\1,1:"")_$S(BDMX("WT")]"":" lbs",1:""),$E(X,40)=BDMX("WTD") D S(X)
 S BDMTOBC="",BDMTOBS=$$TOBACCO^BDMDD1T(BDMSDFN,$$DOB^AUPNPAT(BDMSDFN),DT)
 I BDMTOBS]"" S X="Tobacco Use:  "_$P($P($G(BDMTOBS),U,2),"  ",2,99) D S(X,1)
 I BDMTOBS="" S X="Tobacco Use:  NOT DOCUMENTED" D S(X,1)
 ;I $G(BDMTOBC)]"" S X="              "_$P(BDMTOBC,U,1) D S(X)
 ;COUNSELED?
 S X="",$E(X,15)="Counseled in the past year?  " D
 .I $E(BDMTOBS),$E(BDMTOBS)'=1 S X=X_"N/A" Q
 .S Y=$$CESS^BDMDD11(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 .I $E(Y)=1 S X=X_$P(Y,"  ",2,999) Q
 .I $E(Y)=2 S X=X_"No" Q
 D S(X)
 S X="HTN Diagnosed:  "_$$HTN(BDMSDFN) D S(X,1)
 S X="CVD Diagnosed:  "_$P($$CVD^BDMDD12(BDMSDFN,DT),"  ",2,999) D S(X)
 S B=$$BP(BDMSDFN)
 S X="Last 3 BP:      "_$P($G(BDMX(1)),U,2),$E(X,26)=$$DATE($P($G(BDMX(1)),U)) D S(X)
 S X="(non ER)" I $D(BDMX(2)) S $E(X,17)=$P(BDMX(2),U,2),$E(X,26)=$$DATE($P(BDMX(2),U)) D S(X)
 S X="" I $D(BDMX(3)) S X="",$E(X,17)=$P(BDMX(3),U,2),$E(X,26)=$$DATE($P(BDMX(3),U)) D S(X)
 S BDMSBEG=$$FMADD^XLFDT(DT,-(6*30.5))
 S %=$$ACE^BDMS9B4(BDMSDFN,BDMSBEG)
 S X="",X="ACE Inhibitor/ARB prescribed (in past 6 months): "
 I $E(%)="N" S $E(X,50)=% D S(X,1) I 1
 E  D S(X) S X="   "_% D S(X)
 K BDMSX
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S BDMSX=$E($$ASPIRIN(BDMSDFN,BDMSBEG),1,32)
 S X="Aspirin/Anti-platelet/Anticoagulant prescribed (in past yr):  "
 I $E(BDMSX)="N" S X=X_BDMSX D S(X) I 1
 E  D S(X) S X="   "_BDMSX D S(X)
 I BDMSX="No" S X="",X=$$ASPREF^BDMS9B4(BDMSDFN) I X]"" S X="     "_X D S(X)
 ;statin
 S X=""
 S BDMSBEG=$$FMADD^XLFDT(DT,-180)
 S Y=$$STATIN^BDMDD16(BDMSDFN,BDMSBEG,DT)
 S X="Statin prescribed (in past 6 months):"
 I $E(Y)=2 S $E(X,50)=$P(Y,"  ",2,99) D S(X)
 I $E(Y)=1 D S(X) S X="   "_$P(Y,"  ",2,99) D S(X)
 I $E(Y)=3 D S(X) S X="   Statin Note: "_$P(Y,"  ",2,99) D S(X)
 ;
M12 ;
 ;determine date range
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S X="Exams (in past 12 months):" D S(X,1)
 S X="   Foot:",$E(X,13)=$P($$DFE^BDMDD17(BDMSDFN,BDMSBEG,DT,"H"),"  ",2,99) D S(X)
 S X="   Eye:",$E(X,13)=$P($$EYE^BDMDD17(BDMSDFN,BDMSBEG,DT,"H"),"  ",2,99) D S(X)
 S X="   Dental:",$E(X,13)=$P($$DENTAL^BDMDD17(BDMSDFN,BDMSBEG,DT,"H"),"  ",2,99) D S(X)
 K BDMSTEX,BDMSDAT,BDMX
 S BDMDEPP=$$DEPDX^BDMDD12(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S BDMDEPP=$P(BDMDEPP,"  ",2,99)
 S BDMDEPS=$$DEPSCR^BDMDD12(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 S BDMDEPS=$P(BDMDEPS,"  ",2,99)
 S X="Depression: Active Problem: "_BDMDEPP D S(X,1)
 S X="",$E(X,13)="If no, screened in past year:  "_$S($E(BDMDEPP,1)="N":BDMDEPS,1:"") D S(X)
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
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
 Q
HTN(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE HYPERTENSION",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .S Y=$P(^AUPNPROB(X,0),U) I $$ICD^BDMUTL(Y,"SURVEILLANCE HYPERTENSION",9) S I=1 Q
 .I $P($G(^AUPNPROB(X,800)),U,1)]"",$$SNOMED^BDMUTL(2016,"HYPERTENSION DIAGNOSES",$P(^AUPNPROB(X,800),U,1)) S I=1
 I I Q "Yes"
 NEW BDMX
 S BDMX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"BDMX(") G:E HTNX I $D(BDMX(3)) S BDMX="Yes"
 I $G(BDMX)="" S BDMX="No"
HTNX ;
 Q BDMX
DMPN(P) ;return problem number of firt encountered DM problem
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(D]"")  D
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .I $$ICD^BDMUTL(I,"SURVEILLANCE DIABETES",9) S D=X Q
 .I $P($G(^AUPNPROB(X,800)),U,1)]"",$$SNOMED^BDMUTL(2016,"DIABETES DIAGNOSES",$P(^AUPNPROB(X,800),U,1)) S D=X
 I D="" Q D
 S X=D ;Ien of problem now return problem #
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
 I '$D(BDMX(1)) S BDMX(1)="^None recorded"
BPX ;
 K BDMD,BDMC
 Q BDMX
GETHWB(P)  ;get last height, height date, weight, weight date and BMI for patient P, return in BDMX("HT"),BDMX("HTD"),BDMX("WT"),BDMX("WTD"),BDMX("BMI")
 K BDMX
 NEW BDMWV
 S BDMX("HT")="",BDMX("HTD")="",BDMX("WT")="",BDMX("WTD")="",BDMX("BMI")="",BDMX("WC")="",BDMX("WCD")=""
LASTHT ;
 Q:'$D(^AUPNVSIT("AC",P))
 Q:'$D(^AUPNVMSR("AC",P))
 NEW BDMY
 S %=P_"^LAST MEAS HT" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("HT")=$$STRIP^XLFSTR($J($P($G(BDMY(1)),U,2),5,2)," "),BDMX("HTD")=$$DATE($P($G(BDMY(1)),U))
 ;S BDMX("HT")=$S(BDMX("HT")]"":$J(BDMX("HT"),2,0),1:"")
LASTWT ;
 K BDMY S %=P_"^LAST MEAS WT" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("WT")=$P($G(BDMY(1)),U,2)\1,BDMX("WTD")=$$DATE($P($G(BDMY(1)),U)),BDMWV=$P($G(BDMY(1)),U,5)
LASTWC ;
 ;K BDMY S %=P_"^LAST MEAS WC" NEW X S E=$$START1^APCLDF(%,"BDMY(") S BDMX("WC")=$P($G(BDMY(1)),U,2),BDMX("WCD")=$$DATE($P($G(BDMY(1)),U))
BMI ;
 I $$AGE^AUPNPAT(P)<19,(BDMX("WTD")'=BDMX("HTD")) Q
 I BDMX("WT")=""!('BDMX("HT")) Q
 ;is there a pregnancy dx on date of weight?
 ;
 NEW X K BDMY S %=P_"^LAST DX [BGP PREGNANCY DIAGNOSES 2;DURING "_BDMX("WTD")_"-"_BDMX("WTD") S E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) Q
 S %=""
 ;S W=BDMX("WT")*.45359,H=(BDMX("HT")*0.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S H=(BDMX("HT")*BDMX("HT")),W=BDMX("WT"),%=(W/H)*703,%=$J(%,4,1)
 S BDMX("BMI")=%
 Q
ASPIRIN(P,D) ;
 I '$G(P) Q ""
 I '$G(D) S D=0 ;if don't pass date look at all time
 NEW V,I,%
 S %=""
 NEW T,T1,T2 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S T1=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 S T2=$O(^ATXAX("B","DM AUDIT ANTIPLT/ANTICOAG RX",0))
 I 'T Q ""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V!(%)  S G=$P(^AUPNVMED(V,0),U) D
 ..I $D(^ATXAX(T,21,"B",G)) S %=V Q
 ..I T2,$D(^ATXAX(T2,21,"B",G)) S %=V Q
 ..I T1,$D(^ATXAX(T1,21,"B",G)) S %=V Q
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes  "_$$DATE($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued  "_$$DATE($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q
 Q "No"
DOO(P) ;get earliest date of onset
 NEW X,DOO
 S X=$$CMSFDX^BDMS9B4(P,"I")
 I X]"",'$D(DOO(X)) S DOO(X)=$E($$CMSFDXR^BDMS9B4(P),1,22)
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
 .Q:'$$ICD^BDMUTL(I,"DM AUDIT DEPRESSIVE DISORDERS",9)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .S G="Yes  Problem List ("_$P($$ICDDX^BDMUTL(I,,,"I"),U,2)_") " ;_$E($P($$ICDDX^BDMUTL(I,,,"I"),U,4),1,20)
 .I $P($G(^AUPNPROB(X,800)),U,1)]"",$$SNOMED^BDMUTL(2016,"DEPRESSION DIAGNOSES",$P(^AUPNPROB(X,800),U,1)) S G="Yes  Problem List (SNOMED: "_$P(^AUPNPROB(X,800),U,1)_") "
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
 .;S I=+$$CODEN^ICDCODE(I,80)
 .S I=+$$CODEN^BDMUTL(I,80)  ;cmi/maw 05/14/2014 patch 8 ICD-10
 .Q:I=""
 .Q:'$$ICD^BDMUTL(I,T,9)
 .Q:$P(^AMHPPROB(X,0),U,12)'="A"
 .;S G="Yes - BH Problem List "_$P(^ICD9(I,0),U)  cmi/anch/maw 8/27/2007 orig line
 .S G="Yes - BH Problem List "_$P($$ICDDX^BDMUTL(I,,,"I"),U,2)  ;cmi/anch/maw 8/27/2007 code set versioning
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
