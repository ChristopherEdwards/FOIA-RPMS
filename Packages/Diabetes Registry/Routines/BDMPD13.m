BDMPD13 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in PLDMDXS,IFG,IGT,MS,ABNG
 ;
LASTWT(P,EDATE,F) ;PEP - return last wt
 I 'P Q ""
 I $G(F)="" S F="E"
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW %,BDMARRY,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,W,H,BDMC
 ;NEW BDMV221 S BDMV221=$O(^ICD9("BA","V22.1 ",""))
 K BDM S BDMW="" S BDMX=P_"^LAST 30 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMC=0,BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMC>2)  D
 . S BDMZ=$P(BDM(BDMN),U,5)
 . I '$D(^AUPNVPOV("AD",BDMZ)) S BDMC=BDMC+1,BDMW=BDMW_"|"_$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U)) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. ;lets change this code here to look at the taxonomy p8 06/04/2014
 .. N TAX,CODE
 .. S TAX=$O(^ATXAX("B","BGP PREGNANCY DIAGNOSES 2",0))
 .. S CODE=$P($G(^AUPNVPOV(BDMD,0)),U)
 .. I '$$ICD^BDMUTL(CODE,"BGP PREGNANCY DIAGNOSES 2",9) S BDMC=BDMC+1,BDMW=BDMW_"|"_$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U))
 ..Q
 Q $S(F="E":BDMW,1:+BDMW)
LASTWC(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW %,BDMARRY,H,E,W
 S %=P_"^LAST MEAS WC;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMARRY(") S H=$P($G(BDMARRY(1)),U,2)
 Q H_"  "_$$FMTE^XLFDT($P($G(BDMARRY(1)),U))
 ;
IFG(P,BDMRET) ;EP
 K BDMRET
 NEW BDMC,BDM
 S BDMC=0
 K BDM
 ;look at problem list then povs
 ;return  where found^dx code^provider narr^date (either visit date or doo from pl)
 ;look for first and last pov
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .;ihs/cmi/maw 06/04/2014 p8
 .;S I=$P($$ICDDX^BDMUTL(I),U,2)
 .;Q:I'="790.21"
 .Q:'$$ICD^BDMUTL(I,"BGP IMPAIRED FASTING GLUCOSE",9)
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_$P($$ICDDX^BDMUTL(I),U,2)_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX [BGP IMPAIRED FASTING GLUCOSE;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX [BGP IMPAIRED FASTING GLUCOSE;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="First POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 Q
IGT(P,BDMRET) ;EP
 K BDMRET
 NEW BDMC,BDM
 S BDMC=0
 K BDM
 ;look at problem list then povs
 ;return  where found^dx code^provider narr^date (either visit date or doo from pl)
 ;look for first and last pov
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .;ihs/cmi/maw 06/04/2014 p8
 .;S I=$P($$ICDDX^BDMUTL(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .;Q:I'="790.22"
 .Q:'$$ICD^BDMUTL(I,"DM AUDIT IGT DXS",9)
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_$P($$ICDDX^BDMUTL(I),U,2)_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX [DM AUDIT IGT DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX [DM AUDIT IGT DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="First POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 Q
MS(P,BDMRET) ;EP
 K BDMRET
 NEW BDMC,BDM
 S BDMC=0
 K BDM
 ;look at problem list then povs
 ;return  where found^dx code^provider narr^date (either visit date or doo from pl)
 ;look for first and last pov
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .;ihs/cmi/maw 06/04/2014 p8
 .;S I=$P($$ICDDX^BDMUTL(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .;Q:I'="277.7"
 .Q:'$$ICD^BDMUTL(I,"DM AUDIT METABOLIC SYNDROME",9)
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_$P($$ICDDX^BDMUTL(I),U,2)_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX [DM AUDIT METABOLIC SYNDROME;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX [DM AUDIT METABOLIC SYNDROME;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="First POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 Q
ABNG(P,BDMRET) ;EP
 K BDMRET
 NEW BDMC
 S BDMC=0
 ;look at problem list then povs
 ;return  where found^dx code^provider narr^date (either visit date or doo from pl)
 ;look for first and last pov
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .;ihs/cmi/maw 06/04/2014 p8
 .;S I=$P($$ICDDX^BDMUTL(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .;Q:I'="790.29"
 .Q:'$$ICD^BDMUTL(I,"DM AUDIT ABNORMAL GLUCOSE",9)
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_$P($$ICDDX^BDMUTL(I),U,2)_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX [DM AUDIT ABNORMAL GLUCOSE;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX [DM AUDIT ABNORMAL GLUCOSE;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="First POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 Q
