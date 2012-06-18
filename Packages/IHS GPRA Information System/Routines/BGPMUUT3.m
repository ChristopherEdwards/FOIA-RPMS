BGPMUUT3 ; IHS/MSC/MGH - Meaningful use utility calls ;02-Mar-2011 10:38;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
VSTPOV(DFN,VIEN,TAX) ;EP Check to see if the patient had an ICD on a particular visit
 N TIEN,X,G,ICD,ICDT,EVDT
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPOV("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:X'=+X!(G)  D
 .I $$ICD^ATXCHK($P(^AUPNVPOV(X,0),U),TIEN,9) S G=X
 .Q
 I 'G Q 0
 I G D
 .S ICD=$P($G(^AUPNVPOV(G,0)),U,1),ICDT=$P($G(^ICD9(ICD,0)),U,1)
 .S EVDT=$P($G(^AUPNVPOV(G,12)),U,1)
 .S G=1_U_ICDT_U_EVDT
 Q $S(G:G,1:0)
VSTICD0(DFN,VIEN,TAX) ;EP Check to see if the patient had an ICD on a particular visit
 N TIEN,X,G,ICD,ICDT,EVDT
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPRC("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPRC("AD",VIEN,X)) Q:X'=+X!(G)  D
 .I $$ICD^ATXCHK($P(^AUPNVPRC(X,0),U),TIEN,0) S G=X
 .Q
 I 'G Q 0
 I G D
 .S EVDT=$P($G(^AUPNVPRC(G,12)),U,1)
 .S ICD=$P($G(^AUPNVPRC(G,0)),U,1),ICDT=$P($G(^ICD0(ICD,0)),U,1)
 .S G=1_U_ICDT_U_EVDT_U_G
 Q $S(G:G,1:0)
VSTPOVA(DFN,VIEN,TAX) ;EP Check to see if the patient had an ICD on a particular visit
 ; ALSO checks that the PRIMARY/SECONDARY flag is active
 ; AND that the MODIFIER field is NOT C,D,M,O,P, or S
 N TIEN,X,G,ICD,ICDT,EVDT,PSFLG,INPT
 S PSFLG=""
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPOV("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:X'=+X!(G)  D
 .I $$ICD^ATXCHK($P(^AUPNVPOV(X,0),U),TIEN,9) S G=X
 .Q
 I 'G Q 0
 I G D
 .S ICD=$P($G(^AUPNVPOV(G,0)),U,1),ICDT=$P($G(^ICD9(ICD,0)),U,1)
 .S EVDT=$P($G(^AUPNVPOV(G,12)),U,1)
 .S INPT=$P($G(^AUPNVPOV(G,0)),U,0)
 .S PSFLG=$$GET1^DIQ(9000010.07,G_",",.12,"I")
 .S MODFLG=$$GET1^DIQ(9000010.07,G_",",.06,"I")
 .S G=0
 .I (PSFLG="P")&(MODFLG=""!("CDMOPS"'[MODFLG)) S G=1_U_ICDT_U_EVDT_U_INPT
 Q $S(G:G,1:0)
VSTPOVB(DFN,VIEN,TAX) ;EP Check to see if the patient had an ICD on a particular visit
 ; ALSO checks that the MODIFIER field is NOT C,D,M,O,P, or S
 N TIEN,X,G,ICD,ICDT,EVDT,INPT
 S PSFLG="",INPT=""
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPOV("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:X'=+X!(G)  D
 .I $$ICD^ATXCHK($P(^AUPNVPOV(X,0),U),TIEN,9) S G=X
 .Q
 I 'G Q 0
 I G D
 .S ICD=$P($G(^AUPNVPOV(G,0)),U,1),ICDT=$P($G(^ICD9(ICD,0)),U,1)
 .S EVDT=$P($G(^AUPNVPOV(G,12)),U,1)
 .S DONSET=$P($G(^AUPNVPOV(G,0)),U,17)
 .;if onset date is available use that over entry date
 .I +DONSET S EVDT=DONSET
 .S INPT=$P($G(^AUPNVPV(G,0)),U,22)
 .S MODFLG=$$GET1^DIQ(9000010.07,G_",",.06,"I")
 .S G=0
 .I MODFLG=""!("CDMOPS"'[MODFLG) S G=1_U_ICDT_U_EVDT_U_INPT
 Q $S(G:G,1:0)
MEDTAX(DFN,NDC,TAX) ;EP Check to see if the NDC code is in a taxonomy
 N TIEN,X,G,ICD,ICDT,ATXBEG,ATXFLG,ATXEND,ATXEND
 S G=0,ATXFLG=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(NDC)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 S ATXBEG=0
 ;F  S ATXBEG=$O(^ATXAX(TIEN,21,"AA",ATXBEG)) Q:ATXBEG=""!(ATXFLG=1)  D
 ;.S ATXEND=$O(^ATXAX(TIEN,21,"AA",ATXBEG,0)) Q:ATXEND=""
 ;.Q:NDC<ATXBEG
 ;.I NDC'>ATXEND S ATXFLG=1   ;found code in taxonomy
 S ATXEND="" S ATXEND=$O(^ATXAX(TIEN,21,"B",NDC,ATXEND))
 I +ATXEND S G=1_U_NDC
 Q $S(G:G,1:0)
COMFORT(DFN,VIEN,TAX,ADMIT,CMF) ;EP Check to see if the patient had this code in the first 24hrs of admisssion
 ; CMF = check modifier flag
 N TIEN,X,G,ICD,ICDT,ENT,FIRST
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPOV("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:'+X!(G)  D
 .S ENT=$P($G(^AUPNVPOV(X,12)),U,1)
 .I +ENT D
 ..S FIRST=$$FMADD^XLFDT(ADMIT,+1)
 ..I $P(ENT,".",1)=$P(ADMIT,".",1)!($P(ENT,".",1)=$P(FIRST,".",1)) D
 ...I $$ICD^ATXCHK($P(^AUPNVPOV(X,0),U),TIEN,9) S G=X
 I 'G Q 0
 I G&$G(CMF) D
 .S ICD=$P($G(^AUPNVPOV(G,0)),U,1),ICDT=$P($G(^ICD9(+ICD,0)),U,1)
 .S EVDT=$P($G(^AUPNVPOV(G,12)),U,1)
 .S MODFLG=$$GET1^DIQ(9000010.07,G_",",.06,"I")
 .S G=0
 .I MODFLG=""!("CDMOPS"'[MODFLG) S G=1_U_ICDT_U_EVDT
 I G&'$G(CMF) D
 .S ICD=$P($G(^AUPNVPOV(G,0)),U,1),ICDT=$P($G(^ICD9(+ICD,0)),U,1)
 .S G=1_U_ICDT
 Q $S(G:G,1:0)
PLSTART(DFN,TAX,STAT,ADMIT) ;EP - is DX on problem list on day of admission or following day
 ;Input variables
 ;STAT - A for all problems, C for active problems, I for inactive
 ;DFN=IEN of the patient
 ;TAX=Name of the taxonomy
 I $G(DFN)="" Q 0
 I $G(TAX)="" Q 0
 I $G(STAT)="" S STAT="A"
 N TIEN,PLSTAT,EDT,FIRST
 S TIEN=$O(^ATXAX("B",TAX,0))
 I 'TIEN Q 0
 N PROB,ICE,I,Y
 S (PROB,ICD,I)=0
 F  S PROB=$O(^AUPNPROB("AC",DFN,PROB)) Q:PROB'=+PROB!(+I)  D
 .I $D(^AUPNPROB(PROB,0)) S ICD=$P($G(^AUPNPROB(PROB,0)),U),PLSTAT=$P($G(^AUPNPROB(PROB,0)),U,12)
 .S EDT=$P($G(^AUPNPROB(PROB,0)),U,8)
 .I +EDT D
 ..S FIRST=$$FMADD^XLFDT(ADMIT,+1)
 ..I $P(EDT,".",1)=$P(ADMIT,".",1)!($P(EDT,".",1)=$P(FIRST,".",1)) D
 ...I $$ICD^ATXCHK(ICD,TIEN,9) D
 ....I STAT="A" S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y
 ....I (STAT="C")&(PLSTAT="A") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y
 ....I (STAT="I")&(PLSTAT="I") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y
 Q I
PALCPT(DFN,VIEN,TAX,ADMIT) ;EP - return ien of CPT entry if patient had this CPT in the first 24hrs after admission
 N TIEN,G,CPTT,CPT,FIRST,ENT
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 I $G(ADMIT)="" Q 0
 S G=0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVCPT("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVCPT("AD",VIEN,X)) Q:'+X!(G)  D
 .S ENT=$P($G(^AUPNVCPT(X,12)),U,1)
 .I +ENT D
 ..S FIRST=$$FMADD^XLFDT(ADMIT,+1)
 ..I $P(ENT,".",1)=$P(ADMIT,".",1)!($P(ENT,".",1)=$P(FIRST,".",1)) D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),TIEN,1) S G=X
 I 'G Q 0
 I G D
 .S CPT=$P($G(^AUPNVCPT(G,0)),U,1),CPTT=$P($G(^ICPT(CPT,0)),U,1)
 .S G=1_U_CPTT
 Q $S(G:G,1:0)
PALICD0(DFN,VIEN,TAX,ADMIT) ;EP Check to see if the patient had an ICD0 in the first 24hrs after admission
 N TIEN,X,G,ICD,ICDT,ENT,FIRST
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPRC("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPRC("AD",VIEN,X)) Q:X'=+X!(G)  D
 .S ENT=$P($G(^AUPNVCPT(X,12)),U,1)
 .I +ENT D
 ..S FIRST=$$FMADD^XLFDT(ADMIT,+1)
 ..I $P(ENT,".",1)=$P(ADMIT,".",1)!($P(ENT,".",1)=$P(FIRST,".",1)) D
 ...I $$ICD^ATXCHK($P(^AUPNVPRC(X,0),U),TIEN,0) S G=X
 I 'G Q 0
 I G D
 .S ICD=$P($G(^AUPNVPRC(G,0)),U,1),ICDT=$P($G(^ICD0(ICD,0)),U,1)
 .S G=1_U_ICDT
 Q $S(G:G,1:0)
DTECPT(DFN,VIEN,TAX,ADMIT,ENDDT) ;EP - return ien of CPT entry if patient had this CPT entered in the time frame
 N TIEN,ED,BD,G,CPTT,CPT
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 I $G(ADMIT)="" Q 0
 S G=0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVCPT("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVCPT("AD",VIEN,X)) Q:'+X!(G)  D
 .S ENT=$P($G(^AUPNVCPT(X,12)),U,1)
 .I +ENT D
 ..I (ENT>ADMIT)&(ENT<ENDDT) D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),TIEN,1) S G=X
 I 'G Q 0
 I G D
 .S CPT=$P($G(^AUPNVCPT(G,0)),U,1),CPTT=$P($G(^ICPT(CPT,0)),U,1)
 .S G=1_U_CPTT
 Q $S(G:G,1:0)
DTEICD0(DFN,VIEN,TAX,ADMIT,ENDDT) ;EP Check to see if the patient had an ICD0 stored in the dates selected
 N TIEN,X,G,ICD,ICDT,ENT,FIRST
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) I 'TIEN Q 0
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVPRC("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVPRC("AD",VIEN,X)) Q:X'=+X!(G)  D
 .S ENT=$P($G(^AUPNVCPT(X,12)),U,1)
 .I +ENT D
 ..I (ENT>ADMIT)&(ENT<ENDDT) D
 ...I $$ICD^ATXCHK($P(^AUPNVPRC(X,0),U),TIEN,0) S G=X
 I 'G Q 0
 I G D
 .S ICD=$P($G(^AUPNVPRC(G,0)),U,1),ICDT=$P($G(^ICD0(ICD,0)),U,1)
 .S G=1_U_ICDT
 Q $S(G:G,1:0)
