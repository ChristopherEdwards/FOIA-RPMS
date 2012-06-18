BKMIXX ;PRXM/HC/CLT - TAXONOMY ACCESS UTILITIES ; 11 Mar 2005  12:26 PM
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
LABTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Lab Taxonomy Check
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,LAB,COLDTM
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXLAB("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVLAB("AC",DFN,TEST),-1) Q:TEST=""  D
 .S LAB=$$GET1^DIQ(9000010.09,TEST,.01,"I")
 .I LAB="" Q
 .I '$D(^ATXLAB(TXIEN,21,"B",LAB)) Q
 .S VISIT=$$GET1^DIQ(9000010.09,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .; Get collection date/time
 .S COLDTM=$P($G(^AUPNVLAB(TEST,12)),U,1)\1
 .;S COLDTM=$$GET1^DIQ(9000010.09,TEST,1201,"I")\1
 .I COLDTM'=0 S VSTDT=COLDTM
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.09,TEST,.04,"I")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
CPTTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; CPT Taxonomy Check
 ;
 NEW I,TEST,PRM,CNTR
 I DFN="" Q
 I $TR(TAX,$C(29))="" Q
 ;
 S CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 ;Parse out input parameters into array
 F I=1:1:$L(TAX,$C(29)) D
 .N TX,TXN,EDT,SDT,TGT,LDT,LIN
 .S TX=$P(TAX,$C(29),I) Q:TX=""
 .S TXN=$O(^ATXAX("B",TX,"")) Q:TXN=""
 .S EDT=$P(EDATE,$C(29),I)
 .S SDT=$P(SDATE,$C(29),I)
 .S TGT=$P(TARGET,$C(29),I) Q:TGT=""
 .S LDT=$P(LDATE,$C(29),I)
 .S LIN=$P(LIEN,$C(29),I)
 .S PRM(TX_$C(29)_TXN_$C(29)_SDT_$C(29)_EDT_$C(29)_TGT_$C(29)_LDT_$C(29)_LIN)=I
 ;
 S TEST="",CNT=0
 F  S TEST=$O(^AUPNVCPT("AC",DFN,TEST)) Q:TEST=""  D
 .S CPT=$$GET1^DIQ(9000010.18,TEST,.01,"I") I CPT="" Q
 .;
 .S TXN="" F  S TXN=$O(PRM(TXN)) Q:TXN=""  D
 ..N TAX,EDATE,SDATE,TARGET,LDATE,LIEN,TXIEN,VISIT,VSTDT,RESULT,CT
 ..S TAX=$P(TXN,$C(29))
 ..S TXIEN=$P(TXN,$C(29),2)
 ..S SDATE=$P(TXN,$C(29),3)
 ..S EDATE=$P(TXN,$C(29),4)
 ..S TARGET=$P(TXN,$C(29),5)
 ..S LDATE=$P(TXN,$C(29),6)
 ..S LIEN=$P(TXN,$C(29),7)
 ..S CT=$G(PRM(TXN))
 ..;
 ..I $$ICD^BKMIXX5(CPT,TXIEN,1)=0 Q
 ..S VISIT=$$GET1^DIQ(9000010.18,TEST,.03,"I") I VISIT="" Q
 ..S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 ..I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 ..I $G(SDATE)'="",(VSTDT<SDATE) Q
 ..I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 ..I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 ..I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 ..S RESULT=$$GET1^DIQ(9000010.18,TEST,.04,"E")
 ..;S RESULT=$S($P(N0,U,4)]"":$P($G(^AUTNPOV($P(N0,U,4),0)),U),1:"")
 ..S CNTR(CT)=$G(CNTR(CT))+1
 ..I $G(TARGET)]"" S @TARGET=RESULT
 ;
 ;Handle Single/Multiple Counts
 I $L(TAX,$C(29))=1 S CNT=$G(CNTR(1))
 E  M CNT=CNTR
 Q
 ;
LOINC(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; LOINC Taxonomy Check
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,LOINC
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVLAB("AC",DFN,TEST)) Q:TEST=""  D
 .S LOINC=$$GET1^DIQ(9000010.09,TEST,1113,"E")
 .I LOINC="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",LOINC)) Q
 .S VISIT=$$GET1^DIQ(9000010.09,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .; Get collection date/time
 .S COLDTM=$P($G(^AUPNVLAB(TEST,12)),U,1)\1
 .;S COLDTM=$$GET1^DIQ(9000010.09,TEST,1201,"I")\1
 .I COLDTM'=0 S VSTDT=COLDTM
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.09,TEST,.04,"I")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
HFTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Health Factors Taxonomy Check (includes health factor)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,HF,CODE
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVHF("AC",DFN,TEST)) Q:TEST=""  D
 .S HF=$$GET1^DIQ(9000010.23,TEST,.01,"E")
 .I HF="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",HF)) Q
 .S VISIT=$$GET1^DIQ(9000010.23,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.23,TEST,.04,"E")
 .S CODE=$$GET1^DIQ(9000010.23,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_CODE
 Q
 ;
PRBTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; ICD Taxonomy Check (using PROBLEM file)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PROB
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNPROB("AC",DFN,TEST)) Q:TEST=""  D
 .S PROB=$$GET1^DIQ(9000011,TEST,.01,"I")
 .I PROB="" Q
 .I $$ICD^BKMIXX5(PROB,TXIEN,9)=0 Q
 .; Not related to Visit File (#9000010)
 .S VISIT="N/A"
 .; Problem does not connect to a visit so VSTDT is calculated differently.
 .S VSTDT=$$PROB^BKMVUTL(TEST)
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000011,TEST,.05,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
MEDTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; Medication Taxonomy Check (using Medication IEN)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,DRGPTR,SIG,QTY,DAY
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVMED("AC",DFN,TEST)) Q:TEST=""  D
 .S DRGPTR=$$GET1^DIQ(9000010.14,TEST,.01,"I")
 .I DRGPTR="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",DRGPTR)) Q
 .S VISIT=$$GET1^DIQ(9000010.14,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
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
ADATAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT) ; PEP
 ; ADA Code Taxonomy Check (using ADA Code)
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,ADA
 I DFN="" Q
 I TAX="" Q
 S TXIEN=$O(^ATXAX("B",TAX,""))
 I TXIEN="" Q
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVDEN("AC",DFN,TEST)) Q:TEST=""  D
 .S ADA=$$GET1^DIQ(9000010.05,TEST,.01,"E")
 .I ADA="" Q
 .I '$D(^ATXAX(TXIEN,21,"B",ADA)) Q
 .S VISIT=$$GET1^DIQ(9000010.05,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VSTDT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .;Nothing identified in file as a 'RESULT'. Using "N/A" for now for consistency with other functions.
 .;S RESULT=$$GET1^DIQ(9000010.05,TEST,.04,"I")
 .S RESULT="N/A"
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT
 Q
 ;
 ; For this entry point only:
 ; 
 ; Input:
 ;     TAX = PATIENT EDUCATION TOPIC CODE LIST to search for
 ;           (required)
 ;
 ;     Example: "CD-,-CD,AOD-,-AOD"
 ;     Example: "*BGP HIV/AIDS DXS"
 ;
 ;     Returns items where the MNEMONIC field for the Patient
 ;     Education entry contains one of the listed values.
 ;
 ;     Second example shows an ICD taxonomy name.
 ;     If used, will search for any Patient Education entry
 ;     containing one of the values in that Taxonomy.
 ;
 ; The data in this file is too volatile to use Taxonomies for most entries.
 ; Variables are still named the same for consistency with other functions.
 ;
PTEDTAX(DFN,TAX,EDATE,SDATE,TARGET,LDATE,LIEN,CNT,SVTX) ; PEP
 ; Patient Education Taxonomy check (by Education Code List) (includes topic)
 ; PTEDTAX^BKMIXX1 does this by Taxonomy
 ;
 N TXIEN,TEST,VISIT,VSTDT,RESULT,PTED,CODE
 I DFN="" Q
 I TAX="" Q
 ;Not really needed, but set to maintain same variable list as other functions.
 S TXIEN=TAX
 I TXIEN="" Q
 ;Build a list of Education Code Entries based on the code list supplied.
 I $D(SVTX(TAX)) M TXIEN=SVTX(TAX)
 E  D BLDTAX1^BKMIXX5(TAX,"TXIEN") M SVTX(TAX)=TXIEN
 S TEST="",CNT=0,LDATE=$G(LDATE,""),LIEN=$G(LIEN,"")
 F  S TEST=$O(^AUPNVPED("AC",DFN,TEST)) Q:TEST=""  D
 .S PTED=$$GET1^DIQ(9000010.16,TEST,.01,"I")
 .I PTED="" Q
 .I '$D(TXIEN(PTED)) Q
 .S VISIT=$$GET1^DIQ(9000010.16,TEST,.03,"I") I VISIT="" Q
 .S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I") I VISIT="" Q
 .I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .I $G(SDATE)'="",(VSTDT<SDATE) Q
 .I $G(EDATE)'="",(VSTDT\1>EDATE) Q
 .I VSTDT>LDATE S LDATE=VSTDT,LIEN=TEST
 .I VSTDT=LDATE,TEST>LIEN S LDATE=VSTDT,LIEN=TEST
 .S RESULT=$$GET1^DIQ(9000010.16,TEST,.04,"E")
 .S CODE=$$GET1^DIQ(9000010.16,TEST,.01,"E")
 .S CNT=CNT+1
 .I $G(TARGET)]"" S @TARGET=RESULT_U_CODE
 Q
