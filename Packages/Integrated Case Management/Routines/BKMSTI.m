BKMSTI ;PRXM/HC/ALA - Sexually Transmitted Infection Screening ; 12 Mar 2007  1:52 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;**1,2**;Feb 07, 2011;Build 11
 ;
 ;
EN(BKMDFN,BKBDT,BKEDT,TYPE,VALUE,HVDFL) ;EP
 ;
 ; Input
 ;   BKMDFN - Patient internal entry number
 ;   BRDT   - CRS Report Period begin date
 ;   ERDT   - CRS Report Period end date (not used at this time because of the 300
 ;            day limitation see BKEDT below)
 ;   TYPE   - Type of STI (can be an individual one such as CHLAMYDIA, etc.;
 ;            those 'KEY' STIs or 'OTHER' STIs as defined in the HMS STI SCREENING
 ;            File #90454)
 ;   VALUE  - The name of the array to return the data in
 ;   HVDFL  - The HIV Diagnosis contraindication flag
 ;   
 ; Output
 ;   VALUE  - structure is
 ;            STI is the sexual transmitted infection code
 ;            "DEN" is denominator data
 ;            "NUM" is numerator data
 ;            "REF" is refusal data
 ;            SCSTI is the screening STI code
 ;            # of incidences found within a 2-month period
 ;               0 is no incidences found
 ;               otherwise is number found within date range
 ;            (STI,"DEN")=#^date diagnosis;
 ;            STI,"NUM",SCSTI)=#^screening information
 ;            STI,"REF",SCSTI)=#^refusal information
 ;
 NEW BKMIEN,BKDEN,ARRAY,BKTY,IEN,STIEN,BKPER,BKREF,BKNMTY,BKDATE
 NEW BKMEDT,GLOBAL,IDATE,PDATE,IDXDT,LDATE,LIEN,LV,NDATE,NR,NXDT,PDATE,OFLG
 NEW OR,PR,ODATE,VISIT,VSDT,QFL,RIEN,RTY
 ;
 ;  Set beginning date to 2 months (60 days) prior to CRS report period begin date
 ;  through the first 300 days of the CRS report period
 K ARRAY,ZARRAY
 ;
 ;  Check if passed a specific STI
 S BKMIEN=$$FIND1^DIC(90454,,"MX",TYPE)
 I BKMIEN D
 . S BKTY=$$GET1^DIQ(90454,BKMIEN_",",.03,"E")
 . ; Get the denominator executable
 . S BKDEN=$$GET1^DIQ(90454,BKMIEN_",",1,"E")
 . ;
 . X BKDEN
 . ; if no data, then the denominator should be zero
 . I '$D(ARRAY) S VALUE(BKTY,"DEN")=0 Q
 . ; find any numerator or refusal information
 . D FND
 ;
 ; Only pull the key information
 I TYPE="KEY" D
 . S BKMIEN=""
 . F  S BKMIEN=$O(^BKM(90454,"C","K",BKMIEN)) Q:BKMIEN=""  D
 .. S BKTY=$$GET1^DIQ(90454,BKMIEN_",",.03,"E")
 .. S BKDEN=$$GET1^DIQ(90454,BKMIEN_",",1,"E")
 .. ; Denominator code
 .. X BKDEN
 .. ; if no data, then the denominator should be zero
 .. I '$D(ARRAY) S VALUE(BKTY,"DEN")=0 Q
 .. ; find any numerator or refusal information
 .. D FND
 ;
 ; Only pull the other STIs
 I TYPE="OTHER" D
 . S BKMIEN=""
 . F  S BKMIEN=$O(^BKM(90454,"C","O",BKMIEN)) Q:BKMIEN=""  D
 .. S BKTY=$$GET1^DIQ(90454,BKMIEN_",",.03,"E")
 .. S BKDEN=$$GET1^DIQ(90454,BKMIEN_",",1,"E")
 .. ; Denominator code
 .. X BKDEN
 .. ; if no data, then the denominator should be zero
 .. I '$D(ARRAY) S VALUE(BKTY,"DEN")=0 Q
 .. ; find any numerator or refusal information
 .. D FND
 ;
 ; Pull all STIs
 I TYPE="" D
 . S BKMIEN=0
 . F  S BKMIEN=$O(^BKM(90454,BKMIEN)) Q:'BKMIEN  D
 .. S BKTY=$$GET1^DIQ(90454,BKMIEN_",",.03,"E")
 .. S BKDEN=$$GET1^DIQ(90454,BKMIEN_",",1,"E")
 .. ; Denominator code
 .. X BKDEN
 .. ; if no data, then the denominator should be zero
 .. I '$D(ARRAY) S VALUE(BKTY,"DEN")=0 Q
 .. ; find any numerator or refusal information
 .. D FND
 Q
 ;
FND ;  Find numerator data for all associated screenings
 ; Parameters
 ;   BKPER - Performance executable
 ;   BKREF - Refusal executable
 ;
 S IEN=0
 F  S IEN=$O(^BKM(90454,BKMIEN,10,IEN)) Q:'IEN  D
 . S STIEN=$P(^BKM(90454,BKMIEN,10,IEN,0),U,1)
 . S BKPER=$$GET1^DIQ(90454,STIEN_",",2,"E")
 . S BKREF=$$GET1^DIQ(90454,STIEN_",",3,"E")
 . S BKNMTY=$$GET1^DIQ(90454,STIEN_",",.03,"E")
 . ;   For each denominator date
 . S BKDATE=""
 . F  S BKDATE=$O(ARRAY(BKTY,BKDATE)) Q:BKDATE=""  D
 .. NEW EDATE,BDATE
 .. ; Check for performance of a screen 30 days prior and 2 months after
 .. ; the denominator date
 .. ;S EDATE=$$FMADD^XLFDT(BKDATE,60),BDATE=$$FMADD^XLFDT(BKDATE,-30)
 .. S EDATE=$$FMADD^XLFDT(BKDATE,(30.4167*2)),BDATE=$$FMADD^XLFDT(BKDATE,-30.4167)
 .. X BKPER
 .. I '$D(VALUE(BKTY,"NUM",BKNMTY)) S VALUE(BKTY,"NUM",BKNMTY)=0
 .. I $D(VALUE(BKTY,"NUM",BKNMTY))>1 S VALUE(BKTY,"NUM",BKNMTY)=1
 .. ; Check for refusals of a screening
 .. X BKREF
 .. I '$D(BKMT) S VALUE(BKTY,"REF",BKNMTY)=0 Q
 .. NEW LBIEN,PRNM,RETURN,RDT,REF,RFN,BKTT
 .. S BKTT="",RETURN="",REF=0
 .. F  S BKTT=$O(BKMT(BKTT)) Q:BKTT=""  D
 ... S RDT="",QFL=0
 ... F  S RDT=$O(BKMT(BKTT,RDT)) Q:RDT=""  D  Q:QFL
 .... I RDT<BDATE Q
 .... I RDT>EDATE Q
 .... S RETURN=RETURN_$$FMTE^XLFDT(RDT,"2Z")
 .... S RFN=""
 .... F  S RFN=$O(BKMT(BKTT,RDT,RFN)) Q:RFN=""  D  Q:QFL
 ..... S RTY=""
 ..... F  S RTY=$O(BKMT(BKTT,RDT,RFN,RTY)) Q:RTY=""  D  Q:QFL
 ...... S RIEN=$P(^AUPNPREF(RFN,0),U,6),QFL=1
 ...... I $T(CPT^ICPTCOD)'="" S PRNM=$S(RTY="LAB":$P($G(^LAB(60,RIEN,.1)),U,1),RTY="CPT":$$ICPT^BKMUL3(RIEN,RDT,2),1:"") ; csv
 ...... I $T(CPT^ICPTCOD)="" S PRNM=$S(RTY="LAB":$P($G(^LAB(60,RIEN,.1)),U,1),RTY="CPT":$P(^ICPT(RIEN,0),U,1),1:"")
 ...... S RETURN=RETURN_" REF "_RTY_" "
 ...... S RETURN=RETURN_"["_$S(PRNM'="":PRNM,1:$P(^AUPNPREF(RFN,0),U,5))_"]"_U_RFN
 ...... S VALUE(BKTY,"REF",BKNMTY,BKDATE)=RETURN
 .. ;S VALUE(BKTY,"REF",BKNMTY)=REF_U_RETURN
 .. K BKMT
 Q
 ;
SYP ;EP - Syphilis performance measures
 D LABCODES^BKMCRS(BKMDFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","",EDATE,BDATE,.IDATE,.LDATE,"",.PDATE,.PR,.NDATE,.NR,.LV)
 I $G(LDATE)'="",(LDATE\1)<EDATE,(LDATE\1)>BDATE Q
 D LABCODES^BKMCRS(BKMDFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","",EDATE,BDATE,.IDATE,.LDATE,"",.PDATE,.PR,.NDATE,.NR,.LV)
 Q
 ;
SRF ;EP - Syphilis refusal
 S GLOBAL="BKMT(""SYP"",VSTDT,TEST,""LAB"")"
 D REFUSAL^BKMIXX2(BKMDFN,60,"BKM FTA-ABS TEST TAX","","",GLOBAL)
 D REFUSAL^BKMIXX2(BKMDFN,60,"BKM RPR TAX","","",GLOBAL)
 S GLOBAL="BKMT(""SYP"",VSTDT,TEST,""CPT"")"
 D REFUSAL^BKMIXX2(BKMDFN,81,"BKM FTA-ABS CPTS","","",GLOBAL)
 D REFUSAL^BKMIXX2(BKMDFN,81,"BKM RPR CPTS","","",GLOBAL)
 Q
 ;
HIV ;EP - HIV performance measure
 ; Check for any HIV/AIDS diagnosis prior to the STI diagnosis
 ; This is a contraindication for HIV/AIDS screening
 NEW HEDATE,HKDATE
 S HEDATE=EDATE,HKDATE=""
 ;S HVDFL=$$HIVS^BKMRMDR(.BKMDFN,.HKDATE,.HEDATE)
 ;I HVDFL D HIVE^BKMRMDR(.BKMDFN,.HKDATE,.HEDATE)
 D HIVE^BKMRMDR(.BKMDFN,.HKDATE,.HEDATE)
 I +$G(VALUE(BKTY,"NUM",BKNMTY,BKDATE))'=0 Q
 ;
 D LABCODES^BKMCRS(BKMDFN,"BGP HIV TEST TAX","BGP HIV TEST LOINC CODES","BGP CPT HIV TESTS","",EDATE,BDATE,.IDATE,.LDATE,.LR,.PDATE,.PR,.NDATE,.NR,.LV)
 Q
