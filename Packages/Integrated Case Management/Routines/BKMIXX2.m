BKMIXX2 ;PRXM/HC/BWF - TAXONOMY ACCESS UTILITIES ; 13 Apr 2005  4:53 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Generic Taxonomy Utilities
 ; Checks V-Files for patients that meet a Taxonomy's criteria, within
 ; a specific date range.
 ;
 ;**************NOTE***********************
 ; Input for all entry points are the same
 ;*****************************************
 ;
 ; Input:
 ;    DFN    = IEN from Patient file (#90000001)
 ;             (required)
 ;    TAX    = Name of Taxonomy (From Lab Taxonomy ^ATXLAB or ICD Taxonomy ^ATXAX)
 ;             (required)
 ;    EDATE  = End date of the report. The default is "Today"
 ;             (optional)
 ;    SDATE  = Start date of the report. 
 ;             (optional)
 ;    TARGET = Target root (global or local) for collection of data
 ;             (optional)
 ;             Example: ^TMP("RTN NAME",$J,"DESC",DFN,VSTDT,VISIT) or TEMP(VSTDT,VISIT)
 ; Output:
 ;    LDATE  = Last date found in the selected date range
 ;             (optional - pass by reference)
 ;    LIEN   = Last IEN found in the selected date range
 ;             (optional - pass by reference)
 ;    CNT    = Count of number of records found in selected date range
 ;             (optional - pass by reference)
 ;
 Q
 ;
 ; For this entry point only:
 ; 
 ; Input:
 ;     REFILE = FILE# to which the Refusal refers
 ;              (required)
 ;
REFUSAL(DFN,REFILE,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ;Refusal Taxonomy Check (by File)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,REFLAG
 N QFLAG,REFVAL,REFVAL1,REFVAL2,REFILE1,REFTYPE,IENS
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,"")),REFLAG=1
 ;Lab codes can be found in a different Taxonomy global
 I TXIEN="",REFILE=60 S TXIEN=$O(^ATXLAB("B",TAX,"")),REFLAG=0 I TXIEN="" Q
 ;Exam codes do not use a Taxonomy, but the same variables are used.
 I TXIEN="",REFILE=9999999.15 S TXIEN=$O(^AUTTEXAM("C",TAX,"")),REFLAG=2 I TXIEN="" Q
 ;Skin Test codes also do not use a Taxonomy, but the same variables are used.
 I TXIEN="",REFILE=9999999.28 S TXIEN=$O(^AUTTSK("C",TAX,"")),REFLAG=2 I TXIEN="" Q
 ;Most Patient Education Codes do not use a Taxonomy. Some need to be calculated separately.
 I TXIEN="" Q:REFILE'=9999999.09  D BLDTAX1^BKMIXX5(TAX,"TXIEN") S REFLAG=3 I $D(TXIEN)=0 Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNPREF("AC",DFN,TEST)) Q:TEST=""  D
 .S REFVAL="",REFVAL1=""
 .S REFILE1=$$GET1^DIQ(9000022,TEST,.05,"I")
 .;Skip NULL references as they are checked later.
 .I REFILE1]"",REFILE1'=REFILE Q
 .S REFVAL=$$GET1^DIQ(9000022,TEST,.06,"I")
 .;Exam Codes are checked differently because they do not use Taxonomies.
 .I REFLAG=2,REFVAL'=TXIEN Q
 .;^ATXLAB stores the LAB code IEN directly.
 .I REFLAG=0 D  Q:QFLAG=1
 ..S QFLAG=1
 ..I REFVAL]"" S:$D(^ATXLAB(TXIEN,21,"B",REFVAL)) QFLAG=0 Q
 ..;Currently LAB/PAP SMEAR tests do not have REFVAL set.
 ..;Setting this so calling program will know 'some' LAB was refused.
 ..I REFVAL="" S QFLAG=0 Q
 .I REFLAG=1 D  Q:QFLAG=1
 ..S QFLAG=1 ; Quit if REFILE not listed or REFVAL not found.
 ..I REFILE=71 D  Q  ;Radiology and Mammogram
 ...I REFVAL]"" S REFVAL1=$$GET1^DIQ(71,REFVAL,9,"I")
 ...I REFVAL1]"" S:$$ICD^BKMIXX5(REFVAL1,TXIEN,1)'=0 QFLAG=0 Q
 ..I REFILE=9999999.14 D  Q  ;Immunizations
 ...I REFVAL]"" S REFVAL1=$$GET1^DIQ(9999999.14,REFVAL,.03,"E")
 ...I REFVAL1]"" S:$D(^ATXAX(TXIEN,21,"B",REFVAL1)) QFLAG=0 Q
 ..I REFILE=9999999.15 D  Q  ;Exams
 ...I REFVAL]"" S REFVAL1=$$GET1^DIQ(9999999.15,REFVAL,.01,"E")
 ...I REFVAL1]"" S:$D(^ATXAX(TXIEN,21,"B",REFVAL1)) QFLAG=0 Q
 ..I REFILE=9999999.09 D  Q  ;Patient Education
 ...I REFVAL]"" S REFVAL1=$$GET1^DIQ(9999999.09,REFVAL,.01,"E")
 ...I REFVAL1]"",REFLAG=1 S:$D(^ATXAX(TXIEN,21,"B",REFVAL1)) QFLAG=0 Q
 ...I REFVAL1]"",REFLAG=3 S REFVAL2=$$GET1^DIQ(9999999.09,REFVAL,.01,"I") S:$D(TXIEN(REFVAL2)) QFLAG=0 Q
 ..I REFILE=50 D  Q  ;NDC codes or MED IENS
 ...;Use Taxonomy to build a list of DRUG code IENs.
 ...D BLDTAX^BKMIXX5(TAX,"IENS")
 ...I REFVAL]"" S:$D(IENS(REFVAL)) QFLAG=0 Q
 ..I REFILE=81 D  Q  ;CPT Codes
 ...;Use Taxonomy to build a list of CPTs
 ...D BLDTAX^BKMIXX5(TAX,"IENS")
 ...I REFVAL]"" S:$D(IENS(REFVAL)) QFLAG=0 Q
 ..I REFILE=60 D  Q  ;LOINC codes
 ...;Use LOINC Taxonomy to build a list of LAB code IENs.
 ...D BLDTAX^BKMIXX5(TAX,"IENS")
 ...I REFVAL]"" S:$D(IENS(REFVAL)) QFLAG=0 Q
 ...;Currently LAB/PAP SMEAR tests do not have REFVAL set.
 ...;Setting this so calling program will know 'some' LAB was refused.
 ...I REFVAL="" S QFLAG=0 Q
 .; Not related to Visit File (#9000010)
 .S VISIT="N/A"
 .; VSTDT is the Date of Patient Refusal
 .S VSTDT=$$GET1^DIQ(9000022,TEST,.03,"I")
 .I VSTDT="" S VSTDT="Unknown"
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000022,TEST,.07,"E")
 .I RESULT="" S RESULT="Not Specified"
 .I REFVAL="" S REFVAL="Not Specified"
 .S REFTYPE=$$GET1^DIQ(9000022,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_REFTYPE
 Q
 ;
 ; For this entry point only:
 ; 
 ; Input:
 ;     TAX = PROVIDER CLASS (external) to search for
 ;           (required)
 ;     
 ; Taxonomies not available for this type of data.
 ; Variables are still named the same for consistency with other functions.
 ;
PRVTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Provider Check (using Provider Class)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PRV,PRVCLS
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^DIC(7,"D",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPRV("AC",DFN,TEST)) Q:TEST=""  D
 .S PRV=$$GET1^DIQ(9000010.06,TEST,.01,"I")
 .I PRV="" Q
 .S PRVCLS=$$GET1^DIQ(200,PRV,53.5,"I")
 .I PRVCLS'=TXIEN Q
 .S VISIT=$$GET1^DIQ(9000010.06,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .;Nothing identified in file as a 'RESULT'. Using "N/A" for now for consistency with other functions.
 .;S RESULT=$$GET1^DIQ(9000010.06,TEST,.04,"I")
 .S RESULT="N/A"
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = CODE/CLINIC STOP (external) to search for
 ;           (required)
 ;
 ; Taxonomies not available for this type of data.
 ; Variables are still named the same for consistency with other functions.
 ;
CLNTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Clinic Check (using Code/Clinic Stop)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,CLN,CLNSCD
 I DFN="" Q
 I TAX="" Q
 ;Not really needed, but set to maintain same variable list as other functions.
 S TXIEN=TAX
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVSIT("AC",DFN,TEST)) Q:TEST=""  D
 .S CLN=$$GET1^DIQ(9000010,TEST,.08,"I")
 .I CLN="" Q
 .S CLNSCD=$$GET1^DIQ(40.7,CLN,1,"E")
 .I CLNSCD'=TXIEN Q
 .S VISIT=TEST
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .;Nothing identified in file as a 'RESULT'. Using "N/A" for now for consistency with other functions.
 .;S RESULT=$$GET1^DIQ(9000010,TEST,.04,"I")
 .S RESULT="N/A"
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = WOMEN'S HEALTH PROCEDURE TYPE (external) to search for
 ;           (required)
 ;
 ; Taxonomies not available for this type of data.
 ; Variables are still named the same for consistency with other functions.
 ;
WHTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Women's Health (using Women's Health Procedure Type)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,WH
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^BWPN("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^BWPCD("C",DFN,TEST)) Q:TEST=""  D
 .S WH=$$GET1^DIQ(9002086.1,TEST,.04,"I")
 .I WH="" Q
 .I WH'=TXIEN Q
 .S VISIT=TEST
 .; Using 'Date of Procedure' as 'Visit Date'
 .S VSTDT=$$GET1^DIQ(9002086.1,VISIT_",",.12,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9002086.1,TEST,.05,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = ICD OPERATION/PROCEDURE CODE NUMBER (external) to search for
 ;           (required)
 ;
 ; Taxonomies have not been created for this data.
 ; Variables are still named the same for consistency with other functions.
 ;
PROCTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Procedure Check (using Procedure Code number)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PRC
 I DFN="" Q
 I TAX="" Q
 ;Not really needed, but set to maintain same variable list as other functions.
 S TXIEN=TAX
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPRC("AC",DFN,TEST)) Q:TEST=""  D
 .S PRC=$$GET1^DIQ(9000010.08,TEST,.01,"E")
 .I PRC'=TXIEN Q
 .S VISIT=$$GET1^DIQ(9000010.08,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.08,TEST,.04,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = ICD DIAGNOSIS CODE NUMBER (external) to search for
 ;           (required)
 ;
 ; Taxonomies have not been created for this data.
 ; Variables are still named the same for consistency with other functions.
 ;
POVTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; V POV Check (using the POV code)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,POV
 I DFN="" Q
 I TAX="" Q
 ;Not really needed, but set to maintain same variable list as other functions.
 S TXIEN=TAX
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPOV("AC",DFN,TEST)) Q:TEST=""  D
 .S POV=$$GET1^DIQ(9000010.07,TEST,.01,"E")
 .I POV'=TXIEN Q
 .S VISIT=$$GET1^DIQ(9000010.07,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.07,TEST,.04,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET="N/A"_U_RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = Array of MHSS PROBLEM/DSM IV POV CODES (external) to search for
 ;           (required)
 ;
 ; Taxonomies have not been created for this data.
 ; Variables are still named the same for consistency with other functions.
 ;
BHPTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Behavioral Health Problem/POV Check (using Problem/POV code)
 ;
 N TXIEN,TEST,VCIEN,VCODE,RIEN,DATE,VSTDT,RESULT
 I DFN="" Q
 I $O(TAX(""))="" Q
 ; Set up the visit codes
 S TXIEN=""
 F  S TXIEN=$O(TAX(TXIEN)) Q:TXIEN=""  D
 . S VCIEN=$O(^AMHPROB("B",TXIEN,"")) Q:VCIEN=""
 . S VCODE(VCIEN)=TXIEN
 ;
 ; Check in the MHSS files
 S RIEN="",TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S RIEN=$O(^AMHREC("C",DFN,RIEN)) Q:RIEN=""  D
 . S DATE=$P($G(^AMHREC(RIEN,0)),U,1)
 . Q:DATE<SDATE&(SDATE'="")!(DATE>EDATE&(EDATE'=""))
 . S TEST=""
 . F  S TEST=$O(^AMHRPRO("AD",RIEN,TEST),-1) Q:TEST=""  D
 .. S VCIEN=$P(^AMHRPRO(TEST,0),U,1) Q:VCIEN=""
 .. I '$D(VCODE(VCIEN)) Q
 .. S RESULT=VCODE(VCIEN)
 .. S VSTDT=DATE
 .. I DATE>LDATE S LDATE=DATE,LIEN=TEST
 .. I DATE=LDATE,TEST>LIEN S LIEN=TEST
 .. ;S RESULT="N/A"
 .. S CNT=CNT+1
 .. I $G(TARGET)]"" S @TARGET="N/A"_U_RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = Array of MHSS PROBLEM CODES (external) to search for
 ;           (required)
 ;
 ; Taxonomies have not been created for this data.
 ; Variables are still named the same for consistency with other functions.
 ;
BHPRBTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; EP
 ; Behavioral Health Problem Check (using Problem code)
 ;
 N TXIEN,TEST,VCIEN,VCODE,RIEN,DATE,VSTDT,RESULT,DTENT,DTONS
 I DFN="" Q
 I $O(TAX(""))="" Q
 ; Set up the visit codes
 S TXIEN=""
 F  S TXIEN=$O(TAX(TXIEN)) Q:TXIEN=""  D
 . S VCIEN=$O(^AMHPROB("B",TXIEN,"")) Q:VCIEN=""
 . S VCODE(VCIEN)=TXIEN
 ;
 ; Check in the MHSS files
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AMHPPROB("AC",DFN,TEST)) Q:TEST=""  D
 . Q:'$D(^AMHPPROB(TEST,0))
 . S VCIEN=$P(^AMHPPROB(TEST,0),U,1) Q:VCIEN=""
 . I '$D(VCODE(VCIEN)) Q
 . S RESULT=VCODE(VCIEN)
 . S DTENT=$P($G(^AMHPPROB(TEST,0)),U,8),DTONS=$P($G(^AMHREC(TEST,0)),U,13)
 . S DATE=$S(DTONS'="":DTONS,1:DTENT)
 . Q:DATE<SDATE&(SDATE'="")!(DATE>EDATE&(EDATE'=""))
 . S VSTDT=DATE
 . I DATE>LDATE S LDATE=DATE,LIEN=TEST
 . I DATE=LDATE,TEST>LIEN S LIEN=TEST
 . ;S RESULT="N/A"
 . S CNT=CNT+1
 . I $G(TARGET)]"" S @TARGET="N/A"_U_RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = Array of MEASUREMENT TYPES (external) to search for
 ;           (required)
 ;
 ; Taxonomies have not been created for this data.
 ; Variables are still named the same for consistency with other functions.
 ;
MSRTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; V MEASUREMENT Check (using the Measurement type)
 ;
 N TXIEN,TEST,VCIEN,VCODE,MSR,CNT,VISIT,VSTDT,RIEN,DATE,RESULT
 I DFN="" Q
 I $O(TAX(""))="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVMSR("AC",DFN,TEST)) Q:TEST=""  D
 .S MSR=$$GET1^DIQ(9000010.01,TEST,.01,"E")
 .Q:MSR=""  I '$D(TAX(MSR)) Q
 .S VISIT=$$GET1^DIQ(9000010.01,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.01,TEST,.04,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET="N/A"_U_RESULT
 Q
