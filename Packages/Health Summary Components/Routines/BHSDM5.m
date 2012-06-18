BHSDM5 ;IHS/CIA/MGH - Health Summary for Diabetic Supplement ;11-May-2010 09:13;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**4**;Mar 17, 2006;Build 13
 ;===================================================================
 ;VA version of IHS components for supplemental summaries
 ;Taken from APCHS9B5
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;  [ 02/19/03  7:44 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,8,10,12**;JUN 24, 1997
 ;====================================================================
 ;
MAM ;EP
 K BHSDAT,BHSTEX
 N X1,X2
 S BHSDAT=""
 ;BHSdat=date of last, BHStex is display
 Q:$P(^DPT(BHSPAT,0),U,2)="M"
 K BHSEXD,BHSDF1
 S BHSTXN=0
 S BHSDAT=$$LASTMAM^APCLAPI1(BHSPAT)_"^"_$$MAMREF^APCHS9B4(BHSPAT,BHSDAT)
 I $$VERSION^XPDUTL("BW")>2.9 G MAMA
 S BHSBWR=0 S:$D(X) BHSAVX=X S X="BWUTL1" X ^%ZOSF("TEST") S:$D(BHSAVX) X=BHSAVX K BHSAVX I $T S BHSBWR=1
 I BHSBWR,$D(^BWP(BHSPAT,0)) S BHSTXN=BHSTXN+1,BHSTEX(BHSTXN)=$$BNEED^BWUTL1(BHSPAT) I BHSTEX(1)="UNKNOWN" K BHSTEX(1) S BHSTXN=0
 I $O(BHSTEX("")) Q
MAMA ;
 Q:$$AGE^AUPNPAT(BHSPAT,DT,"Y")<50
 Q:$$AGE^AUPNPAT(BHSPAT,DT,"Y")>69
 K BHSTXN
 S BHSINT=365
 I $P(BHSDAT,U,2)]"" S BHSTEX(1)=$P(BHSDAT,U,2),BHSDAT=$P(BHSDAT,U) Q
 I BHSDAT="" S BHSTEX(1)="MAY BE DUE NOW" Q
 K BHSBWR
 S X1=BHSDAT,X2=BHSINT D C^%DTC  D REGDT4^GMTSU  S BHSTEX(1)="Next Due: "_X,BHSWD=X
 S X2=BHSDAT,X1=DT D ^%DTC I X>BHSINT S BHSTEX(1)=$S('$D(BHSDD):"MAY BE DUE NOW (WAS DUE "_BHSWD_")",1:"MAY BE DUE NOW")
 Q
 ;
 ;
PAP ;EP
 K BHSDAT,BHSTEX,BHSTP
 S BHSDAT=""
 ;BHSdat=date of last, BHStex is display
 Q:$$AGE^AUPNPAT(BHSPAT,DT,"Y")<18!($P(^DPT(BHSPAT,0),U,2)="M")
 K BHSEXD,BHSDF1
 S BHSTXN=0
 I $$VERSION^XPDUTL("BW")>2.9 G PAPA
 S BHSBWR=0 S:$D(X) BHSAVX=X S X="BWUTL1" X ^%ZOSF("TEST") S:$D(BHSAVX) X=BHSAVX K BHSAVX I $T S BHSBWR=1
 I BHSBWR,$D(^BWP(BHSPAT,0)) S BHSTXN=BHSTXN+1,BHSTEX(BHSTXN)=$$CNEED^BWUTL1(BHSPAT) I BHSTEX(1)="UNKNOWN" K BHSTEX(1) S BHSTXN=0
 ;
PAPA S BHSTP=$$HYSTER^BHSDM4(BHSPAT,DT)
 I BHSTP]"" S BHSTXN=BHSTXN+1,BHSTEX(BHSTXN)="Pt had hysterectomy.  Pap may be necessary",BHSTXN=BHSTXN+1,BHSTEX(BHSTXN)="based on individual followup."
 I $O(BHSTEX("")) S BHSDAT="" Q
 Q
 ;
 ;
ACE(P,D) ;EP - return date of last ACE iNHIBITOR
 ;IHS/CMI/LAB patch 3 - added this subroutine
 ;go through all v meds until 9999999-D and find all drugs with class CV800 or CV805
 ;if none found check taxonomy
 I '$G(P) Q ""
 I '$G(D) S D=0 ;if don't pass date look at all time
 NEW V,I,%
 S %=""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  I $D(^AUPNVMED(V,0)) S G=$P(^AUPNVMED(V,0),U) I $P($G(^PSDRUG(G,0)),U,2)="CV800"!($P($G(^PSDRUG(G,0)),U,2)="CV805") S %=V
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 NEW T S T=$O(^ATXAX("B","DM AUDIT ACE INHIBITORS",0))
 I 'T Q ""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  I $D(^AUPNVMED(V,0)) S G=$P(^AUPNVMED(V,0),U) I $D(^ATXAX(T,21,"B",G)) S %=V
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 Q "No"
 ;
ASPREF(P) ;EP - CHECK FOR ASPIRIN NMI OR REFUSAL
 I '$G(P) Q ""
 NEW X,N,Z,D,IEN,DATE,DRUG
 K X
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I 'T Q ""
 S (D,G)=0 F  S D=$O(^AUPNPREF("AA",P,50,D)) Q:D'=+D!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",D))
 .S X=$O(^AUPNPREF("AA",P,50,D,0))
 .S N=$O(^AUPNPREF("AA",P,50,D,X,0))
 .S G=1,DATE=9999999-X,DRUG=D,IEN=N
 I 'G Q ""
 Q $$VAL^XBDIQ1(50,DRUG,.01)_" "_$$TYPEREF^BHSMU(IEN)_" on "_$$FMTE^XLFDT(DATE)
PNEU(P) ;EP
 NEW APCHY,PNEU,X,C S %=P_"^LAST 2 IMMUNIZATION "_$S($$BI:33,1:19),E=$$START1^APCLDF(%,"APCHY(") ;IHS/CMI/LAB patch 3 - changed line to support new imm package
 I $D(APCHY(1)) S PNEU(9999999-$P(APCHY(1),U))=""
 I $D(APCHY(2)) S PNEU(9999999-$P(APCHY(2),U))=""
 K APCHY S %=P_"^LAST 2 IMMUNIZATION 100",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S PNEU(9999999-$P(APCHY(1),U))=""
 I $D(APCHY(2)) S PNEU(9999999-$P(APCHY(2),U))=""
 K APCHY S %=P_"^LAST 2 IMMUNIZATION 109",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S PNEU(9999999-$P(APCHY(1),U))=""
 I $D(APCHY(2)) S PNEU(9999999-$P(APCHY(2),U))=""
 K APCHY S X=0,C=0 F  S X=$O(PNEU(X)) Q:X'=+X!(C>2)  S C=C+1,APCHY(C)=9999999-X
 I $D(APCHY(1)) Q "Yes  "_$$FMTE^XLFDT($P(APCHY(1),U))_"   "_$$FMTE^XLFDT($P($G(APCHY(2)),U))
 S G=$$REFDF^BHSDM3(BHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:33,1:19),0)),$P($G(APCHY(1)),U))
 I G]"" Q G
 S G=$$REFDF^BHSDM3(BHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:109,1:19),0)),$P($G(APCHY(1)),U))
 I G]"" Q G
 S G=$$REFDF^BHSDM3(BHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:100,1:19),0)),$P($G(APCHY(1)),U))
 I G]"" Q G
 Q "No"
PPD(P) ;EP
 NEW APCHY,Y,X,%,E S %=P_"^LAST SKIN PPD",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) Q $P(^AUPNVSK(+$P(APCHY(1),U,4),0),U,5)_"     "_$$FMTE^XLFDT($P(APCHY(1),U))
 K APCHY S X=P_"^LAST DX V74.1" S E=$$START1^APCLDF(X,"APCHY(")
 I $D(APCHY(1)) Q $$FMTE^XLFDT($P(APCHY(1),U))_"  (by Diagnosis)"
 S G=$$REFDF^BHSDM3(BHSPAT,9999999.28,$O(^AUTTSK("B","PPD",0)))
 I G]"" Q G
 Q ""
PPDS(P) ;EP
 ;check for tb health factor, problem list, povs if and
 ;indication of pos ppd then return "Known Positive PPD"
 NEW BHS,E,X
 K BHS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BHS(")
 I $D(BHS) Q "Known Positive PPD or Hx of TB (Health Factor recorded)"
 N T S T=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I 'T G PPDSPL
 N G S G=0,X=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(G)  I $D(^ATXAX(T,21,"B",X)) S G=1
 I G Q "Known Positive PPD or Hx of TB (Health Factor recorded)"
PPDSPL ;CHECK PL
 N T S T=$O(^ATXAX("B","SURVEILLANCE TUBERCULOSIS",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Known Positive PPD or Hx of TB (Problem List DX)"
 ;check povs
 K BHS S X=P_"^FIRST DX [SURVEILLANCE TUBERCULOSIS" S E=$$START1^APCLDF(X,"BHS(")
 I $D(BHS(1)) Q "Known Positive PPD or Hx of TB (POV/DX "_$$FMTE^XLFDT($P(BHS(1),U))_")"
 Q ""
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;end new subrotuine CMI/TUCSON/LAB
