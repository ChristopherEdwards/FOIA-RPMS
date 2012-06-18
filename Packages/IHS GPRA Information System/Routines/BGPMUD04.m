BGPMUD04 ; IHS/MSC/SAT - MU measure NQF0012 ;06-JUN-2011 15:43;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;code to collect meaningful use report Prenatal HIV Screening
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ; Print Routine:     PENTRY^BGPMUDP2
 ; Delimited Routine: DENTRY^BGPMUDD2
 N BGPP,BGPDEN,BGPNUM,BGPDT,BGPSEX,END,FIRST,IEN,START,VDATE,VIEN,VIEN1
 N BGPEDC,BGPENSTR,BGPEXC,BGPHFI,BGPHIV1,BGPHIV2,BGPLDATE,BGPSCRN
 S BGPDEN=0
 S BGPNUM=0
 S BGPEXC=0
 S BGPNSTR=""   ; <NDC code> OR <CPT code> ; [date in FM format]
 S BGPDSTR=""
 S (BGPEDC,BGPENSTR,BGPLDATE,BGPP,BGPSCRN)=""
 K BGPPNA
 ;only check female
 S BGPSEX=$$SEX^AUPNPAT(DFN)
 Q:BGPSEX'="F"
 ;
 S BGPD=""  ; diagnosis found for prenatal visit (list of dates by ;)
 ;
 ;look for a delivery live birth procedure during the reporting period
 S BGPP=$$DLBCPT(DFN,BGPBDATE,BGPEDATE,"BGPMU DELIVERY LIVE BIRTH CPT")
 ;S BGPP=$$CPT^BGPMUUT1(DFN,BGPBDATE,BGPEDATE,"BGPMU DELIVERY LIVE BIRTH CPT")
 I 'BGPP S BGPP=$$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU DELIVERY LIVE BIRTH DX")
 Q:'BGPP
 ;
 ;look for prenatal visit with EP within 300 days of birth
 S START=9999999-$$FMADD^XLFDT($P(BGPP,U,3),-300),END=9999999-$P(BGPP,U,3)
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with ICD codes for prenatal visit
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...S BGPD=""
 ...D EMD(DFN,VIEN,.BGPD,BGPDT)  ;determine if ICD for prenatal visit
 ...S:BGPD'="" BGPPNA(BGPDT)=VIEN
 ;quit if no diagnosis for prenatal visit
 Q:'$D(BGPPNA)
 ;getting here means this patient is in the denominator
 S BGPDEN=1
 S VIEN1="",VIEN1=$O(BGPPNA(VIEN1))
 S BGPDSTR="DEL:"_$$DATE^BGPMUUTL($P(BGPP,U,3))_";"_"EN:"_$$DATE^BGPMUUTL(VIEN1)
 ;
 ;check for HIV screening within 30 days of first 2 prenatal visits
 S BGPCNT=0
 S BGPH="" F  S BGPH=$O(BGPPNA(BGPH)) Q:BGPH=""  Q:BGPCNT>1  Q:+BGPSCRN  D
 .S BGPCNT=BGPCNT+1
 .S BGPDT=BGPH
 .K LABDATA
 .D LAB(.LABDATA,DFN,"BGPMU HIV PRENATAL SCRN LOINC","BGPMU HIV PRENATAL SCREEN CPT",BGPDT,$$FMADD^XLFDT(BGPDT,30))
 .I +LABDATA&($P($P(LABDATA,U,2),".",1)<=$$FMADD^XLFDT(BGPDT,30)) D
 ..S BGPNUM=1
 ..S BGPNSTR="M:HIV "_$$DATE^BGPMUUTL($P($P(LABDATA,U,2),".",1))
 ;
 ;setup 'not met' string
 I 'BGPNUM S BGPNSTR="NM:"
 ;
 ;Check exclusions if not in numerator
 I 'BGPNUM S BGPEXC=$$EXCLUDE(DFN)
 S:+BGPEXC BGPNSTR="Excluded"
 D TOTAL(DFN)
 ; check these
 K BGPP,BGPDEN,BGPNUM,BGPDT,BGPSEX,END,FIRST,IEN,START,VDATE,VIEN
 K BGPEDC,BGPENSTR,BGPEXC,BGPHFI,BGPHIV1,BGPHIV2,BGPLDATE,BGPPNA,BGPSCRN
 Q
 ;
TOTAL(DFN) ;See where this patient ends up
 ;  BGPNSTR = Numerator String:         <Delivery Date text> ";" <Prenatal encounter date text> ";" <Numerator met LOINC and Date text>
 ;  BGPDSTR = Numerator Not Met String: <Delivery Date text> ";" <Prenatal encounter date text> ";" <Numerator not met text>
 ;  BGPESTR = Excluded String:          <Delivery Date text>   (empty 3rd ; piece indicates Excluded)
 ;if we got here, this patient is in the denominator
 N BGPDT,PTCNT,DENCT,NUMCT,NOTCT,TOTALS,PT1
 S TOTALS=$G(^TMP("BGPMU0012",$J,BGPMUTF,"TOT"))
 S NUMCT=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"NUM"))
 S NOTCT=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"NOT"))
 S DENCT=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"DEN"))
 S EXCCT=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"EXC"))
 S PTCNT=$P(TOTALS,U,1),PT1=$P(TOTALS,U,2)
 S PTCNT=PTCNT+1
 S PT1=PT1+1
 I BGPDEN D
 .S DENCT=DENCT+1 S ^TMP("BGPMU0012",$J,BGPMUTF,"DEN")=DENCT
 .S ^TMP("BGPMU0012",$J,"PAT",BGPMUTF,"DEN",DENCT)=DFN
 .I +BGPEXC D
 ..S EXCCT=EXCCT+1
 ..S ^TMP("BGPMU0012",$J,BGPMUTF,"EXC")=EXCCT
 ..S ^TMP("BGPMU0012",$J,"PAT",BGPMUTF,"EXC",PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 .I '+BGPEXC D
 ..I BGPNUM D
 ...S NUMCT=NUMCT+1
 ...S ^TMP("BGPMU0012",$J,BGPMUTF,"NUM")=NUMCT
 ...S ^TMP("BGPMU0012",$J,"PAT",BGPMUTF,"NUM",PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 ..I 'BGPNUM D
 ...S NOTCT=NOTCT+1
 ...S ^TMP("BGPMU0012",$J,BGPMUTF,"NOT")=NOTCT
 ...S ^TMP("BGPMU0012",$J,"PAT",BGPMUTF,"NOT",PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 S ^TMP("BGPMU0012",$J,BGPMUTF,"TOT")=PTCNT_U_PT1
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0012.1",BGPMUTF)=BGPDEN_U_BGPNUM_U_""_U_$G(BGPDSTR)_";"_$G(BGPNSTR)
 Q
 ;
 ;look for ICD codes for prenatal visit
EMD(DFN,VIEN,BGPD,BGPDT) ;
 N BGPI,BGPTMP
 S X=$$VSTPOV^BGPMUUT3(DFN,VIEN,"BGPMU PRENATAL VISIT DX")
 I +X S BGPD=BGPD_$S(BGPD'="":";",1:"")_$G(BGPDT)
 Q BGPD
 ;
EXCLUDE(DFN) ;
 N BGPADM,BGPBIRTH,BGPHIV
 S REASON=0
 S BGPCNT=0
 S BGPBIRTH=$$GET1^DIQ(2,DFN_",",.03,"I")
 S BGPH="" F  S BGPH=$O(BGPPNA(BGPH)) Q:BGPH=""  Q:BGPCNT>2  Q:+REASON  D
 .S BGPCNT=BGPCNT+1
 .S BGPDT=BGPH
 .S VIEN=BGPPNA(BGPH)
 .;check for HIV diagnosis during prenatal visit
 .S X=$$VSTPOV^BGPMUUT3(DFN,VIEN,"BGPMU HIV DX")
 .I +X S REASON=X Q
 .;check for HIV diagnosis prior to prenatal visit
 .S BGPADM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 .S X=$$LASTDX^BGPMUUT2(DFN,$P(BGPBIRTH,".",1),$P(BGPADM,".",1),"BGPMU HIV DX")
 .I +X S REASON=X Q
 .;check for Lab refusal
 .S X=$$LABREF^BGPMUUT2(DFN,$P(BGPADM,".",1),$$FMADD^XLFDT($P(BGPADM,".",1),30),"BGPMU HIV PRENATAL SCRN LOINC","BGPMU HIV PRENATAL SCREEN CPT")
 .I +X S REASON=X Q
 ;check for active/inactive HIV diagnosis on problem list
 S BGPHIV=$$PLTAX^BGPMUUT1(DFN,"BGPMU HIV DX")
 I +BGPHIV S REASON=BGPHIV
 Q REASON
 ;
DLBCPT(DFN,BDATE,EDATE,TAX) ;check for event date of CPT to be within date range
 N BGPR,BGPVCPT
 N CPTT,RESULT,TIEN,VCPT
 S (BGPR,BGPVCPT)=""
 S (CPTT,TIEN,VCPT)=""
 S RESULT=0
 ;check for valid input
 I '$G(DFN) Q 0
 I $G(TAX)="" Q 0
 I $G(EDATE)="" Q 0
 S TIEN="" S TIEN=$O(^ATXAX("B",TAX,TIEN)) Q:'TIEN 0
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;check for CPT for patient checking CPT event dates
 F  S BGPVCPT=$O(^AUPNVCPT("C",DFN,BGPVCPT)) Q:BGPVCPT=""  Q:RESULT'=0  D
 .S VCPT=$P($G(^AUPNVCPT(BGPVCPT,0)),U,1),CPTT=$P($G(^ICPT(VCPT,0)),U,1)
 .I $$ICD^ATXCHK(CPTT,TIEN,1) D
 ..S CPTDATE=$P($P($G(^AUPNVCPT(BGPVCPT,12)),U,1),".",1)
 ..I (CPTDATE>=BDATE)&(CPTDATE<=EDATE) D
 ...S VST=$P($G(^AUPNVCPT(BGPVCPT,0)),U,3),VDATE=$P($G(^AUPNVSIT(VST,0)),U,1)
 ...S RESULT=1_U_CPTT_U_CPTDATE_U_VDATE
 Q RESULT
 ;
LAB(LABDATA,DFN,LTAX,CTAX,BGPDT,EDATE) ;Look for LABs
 N BDT,CPT,CPTP,EDT,LOINC,LOINCP,VIEN,VLABP
 S LABDATA=0   ;1 U <COLLECTION DATE/TIME> U LOINC U CPT U <RESULT DATE/TIME>
 S LTIEN="" S LTIEN=$O(^ATXAX("B",LTAX,0))
 S CTIEN="" S CTIEN=$O(^ATXAX("B",CTAX,0))
 Q:('LTIEN)&('LTIEN) 0
 S BDT=9999999-BGPDT,EDT=9999999-EDATE
 F  S EDT=$O(^AUPNVSIT("AA",DFN,EDT)) Q:EDT=""  Q:$P(EDT,".",1)>BDT  D
 .S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,EDT,VIEN)) Q:VIEN=""  D
 ..Q:'$D(^AUPNVLAB("AD",VIEN))
 ..I +LTIEN D
 ...S VLABP="" F  S VLABP=$O(^AUPNVLAB("AD",VIEN,VLABP)) Q:VLABP=""  Q:+LABDATA  D
 ....S LOINCP=$P($G(^AUPNVLAB(VLABP,11)),U,13)
 ....S VLABDT=$P($G(^AUPNVLAB(VLABP,12)),U,1)
 ....S VLABRDT=$P($G(^AUPNVLAB(VLABP,12)),U,12)
 ....I +LOINCP D
 .....S LOINC=$P($G(^LAB(95.3,LOINCP,0)),U,1)_"-"_$P($G(^LAB(95.3,LOINCP,0)),U,15)
 .....I $D(^ATXAX(LTIEN,21,"B",LOINC)) S LABDATA=1_U_VLABDT_U_LOINC_U_U_VLABRDT
 ....I ('LABDATA)&(+CTIEN) D
 .....S LAB60=$P(^AUPNVLAB(VLABP,0),U,1)
 .....S SITE="" F  S SITE=$O(^LAB(60,LAB60,1,SITE)) Q:SITE=""  D
 ......S CPT=$P($G(^LAB(60,LAB60,1,SITE,3)),U,1)
 ......I (+CPT) I $D(^ATXAX(CTIEN,21,"B",CPT)) S LABDATA=1_U_VLABDT_U_U_CPT_U_VLABRDT
 Q LABDATA
 ;
TEST ; debug target
 S U="^"
 S DT=$$DT^XLFDT()
 S DFN=608            ;  DFN      = patient code from VA PATIENT file
 S BGPBDATE=3100101   ;  BGPBDATE = begin date of report
 S BGPEDATE=3101231   ;  BGPEDATE = end date of report
 S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 D ENTRY
 Q
