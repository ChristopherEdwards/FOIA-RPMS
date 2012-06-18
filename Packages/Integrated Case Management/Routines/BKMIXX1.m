BKMIXX1 ;PRXM/HC/BWF - TAXONOMY ACCESS UTILITIES ; 13 Apr 2005  4:50 PM
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
ICDTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; ICD Taxonomy Check (using V POV file) (includes POV)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,ICD,CODE
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPOV("AC",DFN,TEST)) Q:TEST=""  D
 .S ICD=$$GET1^DIQ(9000010.07,TEST,.01,"I")
 .I ICD="" Q
 .I $$ICD^BKMIXX5(ICD,TXIEN,9)=0 Q
 .S VISIT=$$GET1^DIQ(9000010.07,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.07,TEST,.04,"E")
 .S CODE=$$GET1^DIQ(9000010.07,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_CODE
 Q
 ;
PRCTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; ICD Procedure Taxonomy Check
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PRC
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPRC("AC",DFN,TEST)) Q:TEST=""  D
 .S PRC=$$GET1^DIQ(9000010.08,TEST,.01,"I")
 .I PRC="" Q
 .I $$ICD^BKMIXX5(PRC,TXIEN,0)=0 Q
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
PTEDTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Patient Education Taxonomy check (by Taxonomy)
 ; PTEDTAX^BKMIXX does this by Education Code List
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PTED
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPED("AC",DFN,TEST)) Q:TEST=""  D
 .S PTED=$$GET1^DIQ(9000010.16,TEST,.01,"E")
 .I PTED="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",PTED)) Q
 .S VISIT=$$GET1^DIQ(9000010.16,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.16,TEST,.04,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
CVXTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Immunization Taxonomy Check (includes Contraindicated Status)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,CVX,CVXCODE,CONTRIND
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVIMM("AC",DFN,TEST)) Q:TEST=""  D
 .S CVX=$$GET1^DIQ(9000010.11,TEST,.01,"I")
 .I CVX="" Q
 .S CVXCODE=$$GET1^DIQ(9999999.14,CVX,.03,"E")
 .I CVXCODE="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",CVXCODE)) Q
 .S VISIT=$$GET1^DIQ(9000010.11,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S CONTRIND=$$GET1^DIQ(9000010.11,TEST,.07,"I")
 .S RESULT=$$GET1^DIQ(9000010.11,TEST,.04,"I")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_CONTRIND
 Q
 ;
NDCTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Medication Taxonomy Check (using NDC Codes)
 ; 
 N TXIEN,TEST,VISIT,VSTDT,RESULT,DRGPTR,NDC,SIG,QTY,DAY
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVMED("AC",DFN,TEST)) Q:TEST=""  D
 .S DRGPTR=$$GET1^DIQ(9000010.14,TEST,.01,"I")
 .I DRGPTR="" Q
 .S NDC=$$GET1^DIQ(50,DRGPTR,31,"I")
 .I NDC="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",NDC)) Q
 .S VISIT=$$GET1^DIQ(9000010.14,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S SIG=$$GET1^DIQ(9000010.14,TEST,.05,"E")
 .S QTY=$$GET1^DIQ(9000010.14,TEST,.06,"E")
 .S DAY=$$GET1^DIQ(9000010.14,TEST,.07,"E")
 .S RESULT=$$GET1^DIQ(9000010.14,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_SIG_U_QTY_U_DAY
 Q
 ;
RADTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Radiology Taxonomy Check (using CPT Taxonomy)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,RAD
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVRAD("AC",DFN,TEST)) Q:TEST=""  D
 .S RAD=$$GET1^DIQ(9000010.22,TEST,.019,"E")
 .I RAD="" Q
 .I $$ICD^BKMIXX5(RAD,TXIEN,1)=0 Q
 .S VISIT=$$GET1^DIQ(9000010.22,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.22,TEST,.05,"E")
 .I RESULT="" S RESULT=$$GET1^DIQ(9000010.22,TEST,1101,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = EXAM CODE (external) to search for
 ;           (required)
 ;
 ; Taxonomies not available for this type of data.
 ; Variables are still named the same for consistency with other functions.
 ;
EXAMTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Patient Examination check (includes exam)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,EXAM,CODE
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^AUTTEXAM("C",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVXAM("AC",DFN,TEST)) Q:TEST=""  D
 .S EXAM=$$GET1^DIQ(9000010.13,TEST,.01,"I")
 .I EXAM="" Q
 .I EXAM'=TXIEN Q
 .S VISIT=$$GET1^DIQ(9000010.13,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.13,TEST,.04,"E")
 .S CODE=$$GET1^DIQ(9000010.13,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_CODE
 Q
 ;
 ; For this entry point only:
 ;
 ; Input:
 ;     TAX = SKIN TEST CODE (external) to search for
 ;           (required)
 ;
 ; Taxonomies not available for this type of data.
 ; Variables are still named the same for consistency with other functions.
 ;
SKNTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Skin Test check
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,SKIN
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^AUTTSK("C",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVSK("AC",DFN,TEST)) Q:TEST=""  D
 .S SKIN=$$GET1^DIQ(9000010.12,TEST,.01,"I")
 .I SKIN="" Q
 .I SKIN'=TXIEN Q
 .S VISIT=$$GET1^DIQ(9000010.12,TEST,.03,"I")
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .; Modified code to include the result as well as the reading
 .S RESULT=$$GET1^DIQ(9000010.12,TEST,.05,"E")_U_$$GET1^DIQ(9000010.12,TEST,.04,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
