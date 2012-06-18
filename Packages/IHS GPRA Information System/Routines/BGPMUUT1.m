BGPMUUT1 ; IHS/MSC/MGH - Meaningful use utility calls ;01-Mar-2011 15:35;MGH
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ;
WH(P,BDATE,EDATE,T,F) ;EP
 I '$G(P) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 I $G(T)="" Q ""
 I '$G(F) S F=1
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V,O
 S (G,V)=0,I="" F  S V=$O(^BWPCD("C",P,V)) Q:V=""  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .S D=$P(^BWPCD(V,0),U,12)
 .Q:D<BDATE
 .Q:D>EDATE
 .S I=$O(G(0)) I I>D Q
 .S G=V,G(D)=""
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S D=$P(^BWPCD(G,0),U,12) Q D
 I F=4 S D=$P(^BWPCD(G,0),U,12) Q $$FMTE^XLFDT(D)
 Q ""
PLCODE(P,A) ;EP
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 N T
 ;S T=$O(^ICD9("AB",A,0))
 S T=+$$CODEN^ICDCODE(A,80)
 I T'>0 Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I Y=T S I=1
 Q I
PLTAX(DFN,TAX,STAT,CDATE) ;EP - is DX on problem list 1 or 0
 ;Input variables
 ;STAT - A for all problems, C for active problems, I for inactive
 ;DFN=IEN of the patient
 ;TAX=Name of the taxonomy
 ;CDATE=Date to check against
 I $G(CDATE)="" S CDATE=0
 I $G(DFN)="" Q 0
 I $G(TAX)="" Q 0
 I $G(STAT)="" S STAT="A"
 N TIEN,PLSTAT S TIEN=$O(^ATXAX("B",TAX,0))
 I 'TIEN Q 0
 N PROB,ICD,I,SDTE,EDTE,PDTE,EDT
 S (PROB,ICD,I)=0
 F  S PROB=$O(^AUPNPROB("AC",DFN,PROB)) Q:PROB'=+PROB!(+I)  D
 .I $D(^AUPNPROB(PROB,0)) S ICD=$P($G(^AUPNPROB(PROB,0)),U),PLSTAT=$P($G(^AUPNPROB(PROB,0)),U,12)
 .S EDT=$P($G(^AUPNPROB(PROB,0)),U,8)
 .S SDTE=$P($G(^AUPNPROB(PROB,0)),U,13)
 .I SDTE'="" S EDT=SDTE
 .Q:+CDATE&(EDT>CDATE)
 .I $$ICD^ATXCHK(ICD,TIEN,9) D
 ..S SDTE=$P($G(^AUPNPROB(PROB,0)),U,13)
 ..S EDTE=$P($G(^AUPNPROB(PROB,0)),U,8)
 ..I +SDTE S PDTE=SDTE
 ..E  S PDTE=EDTE
 ..I STAT="A" S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 ..I (STAT="C")&(PLSTAT="A") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 ..I (STAT="I")&(PLSTAT="I") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 Q I
CPT(DFN,BDATE,EDATE,TAX) ;EP - return ien of CPT entry if patient had this CPT
 N TIEN,ED,BD,G,CPTT,CPTDATE,VDATE,VST
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(EDATE)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN 0
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpt
 NEW D,BD,ED,X,Y,D,G,V
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",DFN,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",DFN,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),TIEN,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q 0
 I G D
 .S VDATE=""
 .S CPT=$P($G(^AUPNVCPT(G,0)),U,1),CPTT=$P($G(^ICPT(CPT,0)),U,1)
 .S CPTDATE=$P($G(^AUPNVCPT(G,12)),U,1)
 .S VST=$P($G(^AUPNVCPT(G,0)),U,3),VDATE=$P($G(^AUPNVSIT(VST,0)),U,1)
 .S G=1_U_CPTT_U_CPTDATE_U_VDATE_U_VST
 Q $S(G:G,1:0)
VSTCPT(DFN,VIEN,TAX) ;EP Check to see if the patient had a CPT on a particular visit
 N TIEN,X,G,CPTT,CPT,EVDT
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVCPT("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVCPT("AD",VIEN,X)) Q:X'=+X!(G)  D
 .I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),TIEN,1) S G=X
 .Q
 I 'G Q 0
 I G D
 .S EVDT=$P($G(^AUPNVCPT(G,12)),U,1)
 .S CPT=$P($G(^AUPNVCPT(G,0)),U,1),CPTT=$P($G(^ICPT(CPT,0)),U,1)
 .S G=1_U_CPTT_U_EVDT_U_G
 Q $S(G:G,1:0)
RAD(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 I $G(T)="" Q ""
 I '$G(F) S F=1
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V,C,TIEN
 S TIEN="" S TIEN=$O(^ATXAX("B",T,TIEN)) Q:'TIEN
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...S EVDATE=$P($G(^AUPNVRAD(X,12)),U)
 ...Q:EVDATE<BDATE!(EVDATE>EDATE)
 ...S C=$P(^AUPNVRAD(X,0),U) Q:C=""  S C=$P($G(^RAMIS(71,C,0)),U,9) Q:C=""
 ...I $$ICD^ATXCHK(C,TIEN,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U,9)
 I F=6 S V=$P(^AUPNVRAD(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U)_"^"_G
 I F=7 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVRAD(G,12)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U,9)
 Q ""
CPTI(DFN,BDATE,EDATE,CPTI,SCEX,SCLN,SMOD) ;EP - did patient have this cpt (ien) in date range
 I '$G(P) Q ""
 I $G(CPTI)="" Q ""
 I $G(BDATE)="" Q ""
 I $G(EDATE)="" Q ""
 S SCEX=$G(SCEX)
 S SCLN=$G(SCLN)
 S SMOD=$G(SMOD)
 I '$D(^ICPT(CPTI)) Q ""  ;not a valid cpt ien
 I '$D(^AUPNVCPT("AA",P)) Q ""  ;no cpts for this patient
 NEW D,BD,ED,X,Y,D,G,V,I,M,M1,Z,J,K,Q
 S ED=9999999-EDATE-1,BD=9999999-BDATE,G=""
 F  S ED=$O(^AUPNVCPT("AA",P,CPTI,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S I=0 F  S I=$O(^AUPNVCPT("AA",P,CPTI,ED,I)) Q:I'=+I!(G)  D
 ..S V=$P($G(^AUPNVCPT(I,0)),U,3)
 ..I SCEX]"",SCEX[$P(^AUPNVSIT(V,0),U,7) Q
 ..I SCLN]"",$$CLINIC^APCLV(V,"C")=SCLN Q
 ..S M=$$VAL^XBDIQ1(9000010.18,I,.08)
 ..S M1=$$VAL^XBDIQ1(9000010.18,I,.09)
 ..S Q=0
 ..I SMOD]"" F J=1:1 S K=$P(SMOD,";",J) Q:K=""  I K=M S Q=1
 ..Q:Q
 ..I SMOD]"" F J=1:1 S K=$P(SMOD,";",J) Q:K=""  I K=M1 S Q=1
 ..Q:Q
 ..S G="1"_"^"_(9999999-ED)
 Q G
 ;
LASTITEM(P,BD,ED,BGPT,BGPV) ;PEP - return last item APCLV OF TYPE APCLT DURING BD TO ED IN FORM APCLF
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(BGPT)="" Q ""
 I $G(BGPV)="" Q ""
 NEW BGPR,%,E,Y K R S %=P_"^LAST "_BGPT_" "_BGPV_";DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"BGPR(")
 I '$D(BGPR(1)) Q ""
 Q 1_U_$P(BGPR(1),U,1)_U_$P(BGPR(1),U,3)_U_$P(BGPR(1),U,2)
 ;
PRV(VISIT,PROV) ;Is this provider a provider for this visit
 ;CHANGED ON 10/26 TO ONLY RETURN TRUE IF PRIMARY PROVIDER - PER Aneel Advani
 N I,PRVIEN,PRVDATA
 S I=""
 S PRVIEN="" F  S PRVIEN=$O(^AUPNVPRV("AD",VISIT,PRVIEN)) Q:'+PRVIEN!(I)  D
 .S PRVDATA=$G(^AUPNVPRV(PRVIEN,0))
 .I $P(PRVDATA,U,1)=PROV&($P(PRVDATA,U,4)="P") S I=1
 Q $S(I=1:1,1:"")
PRVOLD(VISIT,PROV) ;Is this provider a provider for this visit - NO PRIMARY/SECONDARY CHECK
 N I,PRVIEN
 S I=""
 S PRVIEN="" F  S PRVIEN=$O(^AUPNVPRV("AD",VISIT,PRVIEN)) Q:'+PRVIEN!(I)  D
 .I $P($G(^AUPNVPRV(PRVIEN,0)),U,1)=PROV S I=1
 Q $S(I=1:1,1:"")
