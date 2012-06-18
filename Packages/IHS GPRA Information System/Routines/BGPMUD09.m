BGPMUD09 ; IHS/MSC/SAT - MI measure NQF0105 ;01-Sep-2011 14:56
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ; BGPMUD01 = tobacco use assessment               0028a
 ; BGPMUD02 = tobacco use cessation                0028b
 ; BGPMUD03 = Heart Failure w/ACE Inhibitor or ARB 0081
 ; BGPMUD04 = Prenatal HIV Screening               0012
 ; BGPMUD05 = Prenatal Anti-D Immune Globulin      0014
 ; BGPMUD06 = Control High Blood Pressure          0018
 ; BGPMUD07 = SMOKING CESSATION MEDICAL ASSIST     0027
 ; BGPMUD08 = Chlamydia Measure                    0033
 ; BGPMUD09 = Antidepressant Medication Management 0105
 ; BGPMUD10 = Oncology Colon Cancer Stage III      0385
 ;
 ;Code to collect meaningful use report for Antidepressant Med Management 0105
ENTRY ;EP
 N START,END,STRING,STRING2
 N IEN,INV,RFOUND,VISIT,DATA,VDATE,VALUE,EXCEPT,FIRST,VIEN
 N CNT,DIAB,NUM,DIAB,DIABDX,OUTENC,OPHENC,NONENC,VENC,INENC,ERENC
 N BGPALL,BGPEXC,BGPH
 N BGPDEN,BGPNOT1,BGPNOT2,BGPNUM1,BGPNUM2
 N BGPX
 ; BGPNUM1 = Prescription for AntiDepressant Meds =>  84 days
 ; BGPNUM2 = Prescription for AntiDepressant Meds => 180 days
 S (BGPDEN,BGPEXC,BGPNUM1,BGPNUM2,BGPNOT1,BGPNOT2)=""
 S BGPX=0
 ;Pts must be >=18 245 days before the end of the reporting period
 S BGPAGEE=$$AGE^AUPNPAT(DFN,$$FMADD^XLFDT(BGPEDATE,-245))
 ;No need to check further if no age match
 Q:BGPAGEE<18
 ;
 ;1, 2 & 3) look for encounter with the EP with a 1st diagnosis of major depression and possibly subsequent diagnosis for outpatient
 S START=9999999-$$FMADD^XLFDT(BGPBDATE,-245),END=9999999-$$FMADD^XLFDT(BGPEDATE,-245),VALUE=0
 S START=START_".2359"
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:BGPDEN'=""
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:BGPDEN'=""
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with E&M codes
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...S BGPX=0
 ...S BGPX=$$VSTPOV(DFN,VIEN,"BGPMU MAJOR DEPRESSION DX")
 ...I +BGPX D
 ....I $$EM1(DFN,VIEN,0) D  ; (1)
 .....S:$P(BGPX,U,4)=1 BGP1D=$P($P(BGPX,U,3),".",1),BGPDEN="DEP:"_$$DATE^BGPMUUTL(BGP1D)_";"_"EN:"_$$DATE^BGPMUUTL($P(BGPDT,".",1))
 ....Q:BGPDEN'=""
 ....I $$EM2(DFN,VIEN) D  ; (3)
 .....S:$P(BGPX,U,4)=1 BGP1D=$P($P(BGPX,U,3),".",1),BGPDEN="DEP:"_$$DATE^BGPMUUTL(BGP1D)_";"_"EN:"_$$DATE^BGPMUUTL($P(BGPDT,".",1))
 ....Q:BGPDEN'=""
 ;
 Q:BGPDEN=""
 ;check PRESCRIPTION for antidepressant meds
 S BGPX=$$FIND^BGPMUUT8(DFN,"BGPMU ANTIDEPRESSANT MEDS NDCS",$$FMADD^XLFDT(BGP1D,-30),"",$$FMADD^XLFDT(BGP1D,14))
 I '+BGPX S BGPDEN=""
 Q:BGPDEN=""
 ;check for depression or major depression within 120 days before first diagnosis
 S BGPX=$$LASTDX^BGPMUUT2(DFN,$$FMADD^XLFDT(BGP1D,-120),$$FMADD^XLFDT(BGP1D,-1),"BGPMU DEPRESSION DX")
 I +BGPX S BGPDEN=""
 Q:BGPDEN=""
 S BGPX=$$LASTDX^BGPMUUT2(DFN,$$FMADD^XLFDT(BGP1D,-120),$$FMADD^XLFDT(BGP1D,-1),"BGPMU MAJOR DEPRESSION DX")
 I +BGPX S BGPDEN=""
 Q:BGPDEN=""
 S BGPX=$$PLTAX(DFN,"BGPMU DEPRESSION DX","C",$$FMADD^XLFDT(BGP1D,-120),BGP1D)
 I +BGPX S BGPDEN=""
 Q:BGPDEN=""
 S BGPX=$$PLTAX(DFN,"BGPMU MAJOR DEPRESSION DX","C",$$FMADD^XLFDT(BGP1D,-120),BGP1D)
 I +BGPX S BGPDEN=""
 Q:BGPDEN=""
 ;patient is in the denominator
 ;
 ;NUM1
 ;check PRESCRIPTION for antidepressant meds after 84 days of FIRST diagnosis
 S BGPX=0
 S BGPX=$$FIND^BGPMUUT8(DFN,"BGPMU ANTIDEPRESSANT MEDS NDCS",$$FMADD^XLFDT(BGP1D,84),"",$S($P($$NOW^XLFDT(),".",1)>BGPEDATE:$$NOW^XLFDT,1:BGPEDATE),"")
 I +BGPX S BGPNUM1="M:MED "_$$DATE^BGPMUUTL($P(BGPX,U,3))
 S:BGPNUM1="" BGPNOT1="NM:"
 ;NUM2
 ;check PRESCRIPTION for antidepressant meds after 180 days of FIRST diagnosis
 S BGPX=0
 I BGPNUM1'="" D
 .S BGPX=$$FIND^BGPMUUT8(DFN,"BGPMU ANTIDEPRESSANT MEDS NDCS",$$FMADD^XLFDT(BGP1D,180),"",$S($P($$NOW^XLFDT(),".",1)>BGPEDATE:$$NOW^XLFDT,1:BGPEDATE),"")
 .I +BGPX S BGPNUM2="M:MED "_$$DATE^BGPMUUTL($P(BGPX,U,3))
 S:BGPNUM2="" BGPNOT2="NM:"
 ;
 ;no exclusions
 ;
 D TOTAL(DFN)
 Q
 ;
TOTAL(DFN) ;See where this patient ends up
 N PTCNT,EXCCT,DENCT,NUMCT1,NUMCT2,NOTNUM1,NOTNUM2,TOTALS
 S TOTALS=$G(^TMP("BGPMU0105",$J,BGPMUTF,"TOT"))
 S DENCT=+$G(^TMP("BGPMU0105",$J,BGPMUTF,"DEN",1))
 S NUMCT1=+$G(^TMP("BGPMU0105",$J,BGPMUTF,"NUM",1))
 S NUMCT2=+$G(^TMP("BGPMU0105",$J,BGPMUTF,"NUM",2))
 S NOTNUM1=+$G(^TMP("BGPMU0105",$J,BGPMUTF,"NOT",1))
 S NOTNUM2=+$G(^TMP("BGPMU0105",$J,BGPMUTF,"NOT",2))
 S PTCNT=TOTALS
 S PTCNT=PTCNT+1
 S DENCT=DENCT+1 S ^TMP("BGPMU0105",$J,BGPMUTF,"DEN",1)=DENCT
 ;
 I BGPNOT1'="" D
 .S NOTNUM1=NOTNUM1+1 S ^TMP("BGPMU0105",$J,BGPMUTF,"NOT",1)=NOTNUM1
 .I BGPMUTF="C" S ^TMP("BGPMU0105",$J,"PAT",BGPMUTF,"NOT",1,PTCNT)=DFN_U_BGPDEN_U_BGPNOT1
 I BGPNOT2'="" D
 .S NOTNUM2=NOTNUM2+1 S ^TMP("BGPMU0105",$J,BGPMUTF,"NOT",2)=NOTNUM2
 .I BGPMUTF="C" S ^TMP("BGPMU0105",$J,"PAT",BGPMUTF,"NOT",2,PTCNT)=DFN_U_BGPDEN_U_BGPNOT2
 ;
 I BGPNUM1'="" D
 .S NUMCT1=NUMCT1+1 S ^TMP("BGPMU0105",$J,BGPMUTF,"NUM",1)=NUMCT1
 .I BGPMUTF="C" S ^TMP("BGPMU0105",$J,"PAT",BGPMUTF,"NUM",1,PTCNT)=DFN_U_BGPDEN_U_BGPNUM1
 I BGPNUM2'="" D
 .S NUMCT2=NUMCT2+1 S ^TMP("BGPMU0105",$J,BGPMUTF,"NUM",2)=NUMCT2
 .I BGPMUTF="C" S ^TMP("BGPMU0105",$J,"PAT",BGPMUTF,"NUM",2,PTCNT)=DFN_U_BGPDEN_U_BGPNUM2
 S ^TMP("BGPMU0105",$J,BGPMUTF,"TOT")=PTCNT
 ;Setup iCare array for patient
 ; BGPICARE(INDICATOR_ID,Timeframe)=Denom Flag
 ;                                    ^ Num Flag     ^ Excl Flag    ^ Denom disp ; Num disp ^ Excl disp
 S BGPICARE("MU.EP.0105.1",BGPMUTF)=1_U_(BGPNUM1'="")_U_0_U_BGPDEN_";"_$S(BGPNUM1'="":BGPNUM1,1:"")_U_""
 Q
 ;
EM1(DFN,VIEN,FLG) ;check visit for at least 1 E&M code indicating ED, outpatient BH, or outpatient BH requirements POS with a POS modifier
 N BGPI,BGPTMP
 S BGP2=0
 F BGPI=1:1 Q:BGP2'=0  S BGPTMP=$P($T(EM1T+BGPI),";;",2) Q:BGPTMP=""  D
 .S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,BGPTMP)
 .I +X S BGP2=1
 I 'BGP2 D
 .S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,"BGPMU OUTPT BEHAVIOR POS ENC")
 .I +X D
 ..S BGP2=1
 ..;I $E(FLG,1)=1 S X1=$$VSTMOD(DFN,VIEN,"BGPMU BEHAVIOR HLT MODIFIER") S:+X1 BGP2=1
 ..;I $E(FLG,1)'=1 S BGP2=1
 Q BGP2
EM1T ;
 ;;BGPMU ENCOUNTER ED CPT
 ;;BGPMU OUTPT BEHAVIOR HLTH ENC
 ;
VSTMOD(DFN,VIEN,TAX) ;EP Check to see if the patient had a CPT on a particular visit
 N TIEN,X,G,CPTT,CPT,EVDT,MOD1,MOD2
 S G=0
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(VIEN)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN
 I '$D(^AUPNVSIT(VIEN,0)) Q 0
 I '$D(^AUPNVCPT("AD",VIEN)) Q 0
 S X=0 F  S X=$O(^AUPNVCPT("AD",VIEN,X)) Q:X'=+X!(G)  D  Q:+G
 .S MOD1=$P(^AUPNVCPT(X,0),U,8)
 .I $D(^ATXAX(TIEN,21,"B",MOD1)) S G=1_U_MOD1_U_$P($G(^AUPNVCPT(X,12)),U,1)
 .I '+G D
 ..S MOD2=$P(^AUPNVCPT(X,0),U,9)
 ..I $D(^ATXAX(TIEN,21,"B",MOD2)) S G=1_U_MOD2_U_$P($G(^AUPNVCPT(X,12)),U,1)
 Q G
 ;
EM2(DFN,VIEN) ;check visit for at least 1 E&M code indicating acute inpatient or non-acute inpatient
 N BGPI,BGPTMP
 S BGP2=0
 F BGPI=1:1 Q:BGP2'=0  S BGPTMP=$P($T(EM2T+BGPI),";;",2) Q:BGPTMP=""  D
 .S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,BGPTMP)
 .I +X S BGP2=1
 Q BGP2
EM2T ;
 ;;BGPMU NON-ACUTE INPT CPT
 ;;BGPMU ACUTE INPT ENC
 ;
VSTPOV(DFN,VIEN,TAX) ;EP Check to see if the patient had an ICD on a particular visit
 N TIEN,X,G,ICD,ICDT,EVDT,FR
 S FR=0
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
 .S FR=$P($G(^AUPNVPOV(G,0)),U,8)
 .S G=1_U_ICDT_U_EVDT_U_(FR'=2)
 Q $S(G:G,1:0)
 ;
PLTAX(DFN,TAX,STAT,BDATE,EDATE) ;EP - is DX on problem list 1 or 0
 ;Input variables
 ;STAT - A for all problems, C for active problems, I for inactive
 ;DFN=IEN of the patient
 ;TAX=Name of the taxonomy
 ;CDATE=Date to check against
 I $G(BDATE)="" S BDATE=0
 I $G(EDATE)="" S EDATE=$P($$NOW^XLFDT(),".",1)
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
 .Q:(+BDATE&(EDT>BDATE))!(+EDATE&(EDT<EDATE))
 .I $$ICD^ATXCHK(ICD,TIEN,9) D
 ..S SDTE=$P($G(^AUPNPROB(PROB,0)),U,13)
 ..S EDTE=$P($G(^AUPNPROB(PROB,0)),U,8)
 ..I +SDTE S PDTE=SDTE
 ..E  S PDTE=EDTE
 ..I STAT="A" S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 ..I (STAT="C")&(PLSTAT="A") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 ..I (STAT="I")&(PLSTAT="I") S Y=$$GET1^DIQ(80,ICD,.01) S I=1_U_Y_U_PDTE_U_PROB
 Q I
 ;
TEST ; debug target
 S U="^"
 S DT=$$DT^XLFDT()
 S DFN=876             ;  DFN      = patient code from VA PATIENT file
 S BGPBDATE=3100101   ;  BGPBDATE = begin date of report
 S BGPEDATE=3101231   ;  BGPEDATE = end date of report
 S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 D ENTRY
 Q
