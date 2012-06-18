BGPMUD10 ; IHS/MSC/SAT - MI measure NQF0385 ;08-Sep-2011 14:56
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
 ;Code to collect meaningful use report for Oncology Colon Cancer Stage III 0385
ENTRY ;EP
 N START,END,BGPNUM,STRING,STRING2
 N IEN,INV,RFOUND,VISIT,DATA,VDATE,VALUE,EXCEPT,FIRST,VIEN
 N CNT,DIAB,NUM,DIAB,DIABDX,OUTENC,OPHENC,NONENC,VENC,INENC,ERENC
 N BGPEN,BGPEND,BGPEXC,BGPH
 N BGPDEN,BGPNOT,BGPNUM
 N DEPV1,DEPVA
 S (BGPDEN,BGPEN,BGPEXC,BGPNUM,BGPNOT)=""
 S BGPEND=0
 ;Pts must be >=18 at the end of the reporting period
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPEDATE)
 ;No need to check further if no age match
 Q:BGPAGEE<18
 ;
 ;look for 2 encounters with EP
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE,VALUE=0
 S START=START_".2359"
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with E&M codes
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...I $$EM1(DFN,VIEN,0) D
 ....S:$L(BGPEN,";")'>1 BGPEN=$S(BGPEN'="":BGPEN_";",1:"")_"EN:"_$$DATE^BGPMUUTL($P(BGPDT,".",1))
 ....S BGPEND=$S(BGPDT>BGPEND:BGPDT,1:BGPEND)
 ;
 Q:$L(BGPEN,";")'>1
 S X=0
 S X=$$LASTDX^BGPMUUT2(DFN,0,BGPEND,"BGPMU ONC COLON CANCER DX")
 S:'+X X=$$PLTAX^BGPMUD09(DFN,"BGPMU ONC COLON CANCER DX","C",0,BGPEND)
 S:'+X X=$$LASTDX^BGPMUUT2(DFN,0,BGPEND,"BGPMU ONC COLON CANCER HIST DX")
 S:'+X X=$$PLTAX^BGPMUD09(DFN,"BGPMU ONC COLON CANCER HIST DX","I",0,BGPEND)
 Q:'+X
 S BGPDEN="CCDX:"_$$DATE^BGPMUUTL($P(X,U,3))
 S X=0
 S X=$$CPT^BGPMUUT1(DFN,0,BGPEND,"BGPMU STAGE III COLON CAN CPT")
 Q:'+X
 S BGPDEN=BGPDEN_";"_"CCST:"_$$DATE^BGPMUUTL($P(X,U,3))_";"_BGPEN   ;patient is in the denominator
 ;
 ;check PRESCRIPTION for colon cancer chemotherapy meds
 S X=$$FIND^BGPMUUT4(DFN,"BGPMU COLON CANCER CHEMO NDCS",BGPBDATE,"",BGPEDATE)
 I +X S BGPNUM="M:MED "_$$DATE^BGPMUUTL($P(X,U,3))  ;patient is in the numerator
 I '+X S BGPNOT="NM:"
 ;
 ;check exclusions
 S X=0
 I '+X S BGPEXC=$$EXCLUDE(DFN)
 I BGPEXC'="" S BGPNOT=""
 ;
 D TOTAL(DFN)
 Q
 ;
TOTAL(DFN) ;See where this patient ends up
 N PTCNT,EXCCT,DENCT,NUMCT1,NUMCT2,NOTNUM1,NOTNUM2,TOTALS
 S TOTALS=$G(^TMP("BGPMU0385",$J,BGPMUTF,"TOT"))
 S DENCT=+$G(^TMP("BGPMU0385",$J,BGPMUTF,"DEN",1))
 S NUMCT1=+$G(^TMP("BGPMU0385",$J,BGPMUTF,"NUM",1))
 S NOTNUM1=+$G(^TMP("BGPMU0385",$J,BGPMUTF,"NOT",1))
 S EXCCT=+$G(^TMP("BGPMU0385",$J,BGPMUTF,"EXC",1))
 S PTCNT=TOTALS
 S PTCNT=PTCNT+1
 S DENCT=DENCT+1 S ^TMP("BGPMU0385",$J,BGPMUTF,"DEN",1)=DENCT
 ;
 I BGPNOT'="" D
 .S NOTNUM1=NOTNUM1+1 S ^TMP("BGPMU0385",$J,BGPMUTF,"NOT",1)=NOTNUM1
 .I BGPMUTF="C" S ^TMP("BGPMU0385",$J,"PAT",BGPMUTF,"NOT",1,PTCNT)=DFN_U_BGPDEN_U_BGPNOT
 ;
 I BGPNUM'="" D
 .S NUMCT1=NUMCT1+1 S ^TMP("BGPMU0385",$J,BGPMUTF,"NUM",1)=NUMCT1
 .I BGPMUTF="C" S ^TMP("BGPMU0385",$J,"PAT",BGPMUTF,"NUM",1,PTCNT)=DFN_U_BGPDEN_U_BGPNUM
 ;
 I BGPEXC'="" D
 .S EXCCT=EXCCT+1 S ^TMP("BGPMU0385",$J,BGPMUTF,"EXC",1)=EXCCT
 .I BGPMUTF="C" S ^TMP("BGPMU0385",$J,"PAT",BGPMUTF,"EXC",1,PTCNT)=DFN_U_BGPDEN_U_BGPEXC
 S ^TMP("BGPMU0385",$J,BGPMUTF,"TOT")=PTCNT
 ;Setup iCare array for patient
 ; BGPICARE(INDICATOR_ID,Timeframe)=Denom Flag
 ;                                    ^ Num Flag     ^ Excl Flag    ^ Denom disp ; Num disp ^ Excl disp
 S BGPICARE("MU.EP.0385.1",BGPMUTF)=1_U_(BGPNUM'="")_U_(BGPEXC'="")_U_BGPDEN_";"_$S(BGPNUM'="":BGPNUM,1:"")_U_$S(BGPEXC="":BGPEXC,1:"")
 Q
 ;
EM1(DFN,VIEN,FLG) ;check visit for at least 1 E&M code indicating outpatient
 N BGPI,BGPTMP
 S BGP2=0
 S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,"BGPMU ENC OFFICE VISIT")
 S:+X BGP2=1
 Q BGP2
 ;
EXCLUDE(DFN) ;check PATIENT ALLERGIES for allergy to IUD
 N BGPALL,BGPH
 S BGPALL=""
 S X=0
 S BGPH="" F  S BGPH=$O(^GMR(120.8,"B",DFN,BGPH)) Q:BGPH=""  D  Q:X=1
 .S BGPALL=$P(^GMR(120.8,BGPH,0),U,2)
 .I (BGPALL="AMINOGLUTETHIMIDE")!(BGPALL="ANASTROZOLE")!(BGPALL="CAPECITABINE")!(BGPALL="EXEMESTANE")!(BGPALL="FLUOROURACIL")!(BGPALL="LEUCOVORIN") D
 ..S X=1
 Q:+X "Excluded"
 ;checks of VPOV and PROBLEM for Matastatic sites, Acute renal insufficiency, Neutropenia, Leukopenia
 S X=0
 S X=$$LASTDX^BGPMUUT2(DFN,0,BGPEND,"BGPMU 0385 EXCLUSIONS DX")
 Q:+X "Excluded"
 S:'+X X=$$PLTAX^BGPMUD09(DFN,"BGPMU 0385 EXCLUSIONS DX","C",0,BGPEND)
 Q:+X "Excluded"
 ;check Health Factors
 S X=0
 S X=$$HF^BGPMUD07(DFN,"BGPMU ECOG POOR")
 Q:+X "Excluded"
 ;check refusals
 S X=0
 S X=$$MEDREF^BGPMUUT2(DFN,0,BGPEN_".2359","BGPMU COLON CANCER CHEMO NDCS")
 Q:+X "Excluded"
 Q ""
 ;
TEST ; debug target
 S U="^"
 S DT=$$DT^XLFDT()
 S DFN=65             ;  DFN      = patient code from VA PATIENT file
 S BGPBDATE=3100101   ;  BGPBDATE = begin date of report
 S BGPEDATE=3101231   ;  BGPEDATE = end date of report
 S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 D ENTRY
 Q
