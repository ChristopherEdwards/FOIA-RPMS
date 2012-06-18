BDMP913 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;LORI - ADD V04,81
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in PLDMDXS,IFG,IGT,MS,ABNG
 ;
BPS(P,BDATE,EDATE,F) ;EP ;
 I $G(F)="" S F="E"
 NEW X,BDM,E,BDML,BDMLL,BDMV
 S BDMLL=0,BDMV=""
 K BDM
 S X=P_"^LAST 50 MEAS BP;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 S BDML=0 F  S BDML=$O(BDM(BDML)) Q:BDML'=+BDML!(BDMLL=3)  S BDMBP=$P($G(BDM(BDML)),U,2) D
 .Q:$$CLINIC^APCLV($P(BDM(BDML),U,5),"C")=30
 .S BDMLL=BDMLL+1
 .I F="E" S $P(BDMV,";",BDMLL)=BDMBP_"  "_$$FMTE^XLFDT($P(BDM(BDML),U))
 .I F="I" S $P(BDMV,";",BDMLL)=$P(BDMBP," ")
 Q BDMV
HTNDX(P,EDATE) ;EP - is HTN on problem list
 I '$G(P) Q ""
 I '$D(^DPT(P)) Q ""
 NEW %,BDM,E
 K BDM
 S %=P_"^PROBLEM [DM AUDIT PROBLEM HTN DIAGNOSES" S E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) Q "Yes"
 K BDM
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(") I $D(BDM(3)) Q "Yes"
 Q "No"
LASTHT(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,BDMARRY,H,E,W
 S %=P_"^LAST MEAS HT;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMARRY(") S H=$P($G(BDMARRY(1)),U,2)
 I H="" Q H
 S H=$J(H,4,1)
 I F="I" Q H
 Q H_" inches "_$$FMTE^XLFDT($P(BDMARRY(1),U))
LASTWC(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW %,BDMARRY,H,E,W
 S %=P_"^LAST MEAS WC;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMARRY(") S H=$P($G(BDMARRY(1)),U,2)
 Q H_"  "_$$FMTE^XLFDT($P($G(BDMARRY(1)),U))
LASTWT(P,EDATE,F) ;PEP - return last wt
 I 'P Q ""
 I $G(F)="" S F="E"
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW %,BDMARRY,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,W,H,BDMC
 NEW BDMV221 S BDMV221=$O(^ICD9("BA","V22.1 ",""))
 K BDM S BDMW="" S BDMX=P_"^LAST 30 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMC=0,BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMC>2)  D
 . S BDMZ=$P(BDM(BDMN),U,5)
 . I '$D(^AUPNVPOV("AD",BDMZ)) S BDMC=BDMC+1,BDMW=BDMW_"|"_$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U)) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. I $P(^AUPNVPOV(BDMD,0),U)'=BDMV221 S BDMC=BDMC+1,BDMW=BDMW_"|"_$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U))
 ..Q
 Q $S(F="E":BDMW,1:+BDMW)
CMSFDX(P,R,T) ;EP - return date/dx of dm in register
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW D1,Y,X,D,G S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X!(G)  I $P(^ACM(44,X,0),U,4)=R D
 .S D=$P($G(^ACM(44,X,"SV")),U,2),D1=D,D=$$FMTE^XLFDT(D)
 .S Y=$$VAL^XBDIQ1(9002244,X,.01)
 Q $S(T="D":$G(D),T="DX":$G(Y),T="ID":$G(D1),1:"")
 ;
PLDMDOO(P,F) ;EP
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
 S D=$O(D(0)) Q $S(F="E":$$FMTE^XLFDT(D),1:$O(D(0)))
PLDMDXS(P) ;EP - get all DM dxs from problem list
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q "<diabetes taxonomy missing>"
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .;I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P(^ICD9(I,0),U)  ;cmi/anch/maw 9/12/2007 orig line
 .I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q
 Q D
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(BDM(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
LASTDMDX(P,D) ;EP - last pcc dm dx
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^LAST DX [DM AUDIT TYPE II DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q "Type 2"
 K BDM S X=P_"^LAST DX [DM AUDIT TYPE I DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q "Type 1"
 Q ""
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
 .;S I=$P($G(^ICD9(I,0)),U)  ;cmi/anch/maw 9/12/2007 orig line
 .S I=$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q:I'="790.21"
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_I_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX 790.21;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX 790.21;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
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
 .;S I=$P($G(^ICD9(I,0)),U)  ;cmi/anch/maw 9/12/2007 orig line
 .S I=$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q:I'="790.22"
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_I_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX 790.22;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX 790.22;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
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
 .;S I=$P($G(^ICD9(I,0)),U)  ;cmi/anch/maw 9/12/2007 orig line
 .S I=$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q:I'="277.7"
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_I_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX 277.7;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX 277.7;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
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
 .;S I=$P($G(^ICD9(I,0)),U)  ;cmi/anch/maw 9/12/2007 orig line
 .S I=$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q:I'="790.29"
 .S BDMC=BDMC+1,BDMRET(BDMC)="Problem List: "_I_"  Date of Onset: "_$$VAL^XBDIQ1(9000011,X,.13)
 .Q
 ;now look at first and last pov
 S Y="BDM("
 S X=P_"^LAST DX 790.29;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="Last POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM S X=P_"^FIRST DX 790.29;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_DT S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) S BDMC=BDMC+1,BDMRET(BDMC)="First POV in PCC: "_$P(BDM(1),U,2)_"  Date: "_$$FMTE^XLFDT($P(BDM(1),U))
 Q
