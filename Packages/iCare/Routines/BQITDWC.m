BQITDWC ;VNGT/HS/ALA-Calculate Waist Circumference ; 18 Feb 2010  10:14 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
WC(BDFN,TMFRAME) ;EP -- Waist Circumference
 ;  Get the waist circumference for a patient and a time frame
 ;Input
 ;  BDFN - Patient IEN
 ;  TMFRAME - Time frame in relative date format
 ;
 ;   If no time frame passed in, default to 60 months (5 years)  
 I $G(TMFRAME)="" S TMFRAME="T-60M"
 S BDATE=$$DATE^BQIUL1(TMFRAME),BDATE=$$FMTE^XLFDT(BDATE),EDATE=$$FMTE^XLFDT(DT)
 NEW BQIPRY
 S %=BDFN_"^LAST MEAS WC;DURING "_BDATE_"-"_EDATE
 S E=$$START1^APCLDF(%,"BQIPRY(")
 Q $P($G(BQIPRY(1)),U,2)_U_$P($G(BQIPRY(1)),U,5)_U_$P($P($G(BQIPRY(1)),U,4),";",1)
 ;
AWC(TMFRAME,TPGLOB) ;EP - Get waist circumferences for all patients
 ; Input
 ;   TMFRAME - Timeframe for search
 ;   TPGLOB  - Temporary global
 NEW BDATE,EDATE,TMDATA,BTYP,IEN,DATE,VISIT,MIEN,DFN,RESULT
 S BDATE=$$DATE^BQIUL1(TMFRAME),EDATE=DT
 S BTYP=$$FIND1^DIC(9999999.07,,"X","WC")
 S DATE=BDATE
 F  S DATE=$O(^AUPNVSIT("B",DATE)) Q:DATE=""!((DATE\1)>EDATE)  D
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",DATE,VISIT)) Q:VISIT=""  D
 .. I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .. S MIEN=""
 .. F  S MIEN=$O(^AUPNVMSR("AD",VISIT,MIEN)) Q:MIEN=""  D
 ... I $$GET1^DIQ(9000010.01,MIEN_",",.01,"I")'=BTYP Q
 ... ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 ... I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,MIEN_",",2,"I")=1
 ... S DFN=$$GET1^DIQ(9000010.01,MIEN_",",.02,"I") I DFN="" Q
 ... S RESULT=$$GET1^DIQ(9000010.01,MIEN_",",.04,"E") I RESULT="" Q
 ... S @TPGLOB@(DFN,DATE)=RESULT_"^"_VISIT_"^"_MIEN_"^9000010.01"
 Q
