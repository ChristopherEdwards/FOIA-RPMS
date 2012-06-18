BQIMUVFL ;VNGT/HS/BEE-MU Retrieve V UPDATED/REVIEWED information ; 17 Dec 2010  9:03 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 ;
EN(DATA,DFN,ACTION) ;EP -- BQI GET VFILE INFO
 ;
 ;Returns V UPDATED/REVIEWED file information
 ;
 ;Input:
 ; DFN - Patient IEN
 ; ACTION - NULL - Return most recent information for all CLINICAL REVIEW ACTIONS
 ;        - Unique CLINICAL ACTION ENTRY - Return just the most recent information for that entry
 ;        - ALLERGY - Returns the most recent information for Allergy-related CLINICAL REVIEW ACTIONS
 ;        - PROBLEM LIST - Returns the most recent information for Problem List-related CLINICAL REVIEW ACTIONS
 ;        - MEDICATION - Returns the most recent information for Medication-related CLINICAL REVIEW ACTIONS
 ;        
 NEW UID,II,HDR,ACT,IEN,CACT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUVFL",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMUVFL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S HDR="T00045ACTION^D00015DATE^T00030ENCOUNTER_PROVIDER"
 S @DATA@(II)=HDR_$C(30)
 ;
 ; Set up listing of ACTIONs to return
 S:ACTION="ALLERGY" ACTION="ALLERG"
 S:ACTION="PROBLEM LIST" ACTION="PROBLEM"
 D
 . I ACTION="ALLERG"!(ACTION="PROBLEM")!(ACTION="MEDICATION") D  Q
 .. S ACT=0 F  S ACT=$O(^AUTTCRA(ACT)) Q:'ACT  S CACT=$G(^AUTTCRA(ACT,0)) I $P(CACT,U)[ACTION,$P(CACT,U,2)]"" S ACT($P(CACT,U,2))=$P(CACT,U)
 . I ACTION]"" D  Q
 .. S ACT=$O(^AUTTCRA("B",ACTION,"")) I ACT]"" S CACT=$G(^AUTTCRA(ACT,0)) I $P(CACT,U,2)]"" S ACT($P(CACT,U,2))=ACTION
 . S ACT=0 F  S ACT=$O(^AUTTCRA(ACT)) Q:'ACT  S CACT=$G(^AUTTCRA(ACT,0)) I $P(CACT,U,2)]"" S ACT($P(CACT,U,2))=$P(CACT,U)
 ;
 ; Loop through desired list and pull entries
 S ACT="" F  S ACT=$O(ACT(ACT)) Q:ACT=""  I $T(@ACT)]"" D @(ACT_"("_DFN_")")
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
RPBL(DATA,DFN,ACTION) ;EP -- BQI GET MU PRB INFO
 ;
 ;Returns Problem List MU individual information for a particular patient
 ;
 ;Input:
 ; DFN - Patient IEN
 ; ACTION - PROBLEM LIST REVIEWED/PROBLEM LIST UPDATED/NO ACTIVE PROBLEMS
 ;        
 NEW UID,II,HDR,ACT,IEN,CACT,CALL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUVFL",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMUVFL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S HDR="I00010DFN^T00045ACTION^D00030APCDTCDT^T00035APCDTEPR"
 S @DATA@(II)=HDR_$C(30)
 ;
 S CALL=""
 S ACT=$O(^AUTTCRA("B",ACTION,"")) I ACT]"" S CACT=$G(^AUTTCRA(ACT,0)) I $P(CACT,U,2)]"" S CALL="P"_$P(CACT,U,2)
 ;
 ;If defined, call tag
 I CALL]"",$T(@CALL)]"" D @(CALL_"("_DFN_")")
 ;
XRPBL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PLR(DFN) ;EP-Retrieve PROBLEM LIST REVIEWED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTPLR^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
PLU(DFN) ;EP-Retrieve PROBLEM LIST UPDATED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTPLU^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
NAP(DFN) ;EP-Retrieve NO ACTIVE PROBLEMS info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTNAP^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
PPLR(DFN) ;EP-Retrieve PROBLEM LIST REVIEWED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTPLR^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D PWRT(RSLT,DFN)
 Q
 ;
PPLU(DFN) ;EP-Retrieve PROBLEM LIST UPDATED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTPLU^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D PWRT(RSLT,DFN)
 Q
 ;
PNAP(DFN) ;EP-Retrieve NO ACTIVE PROBLEMS info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTNAP^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D PWRT(RSLT,DFN)
 Q
 ;
MLR(DFN) ;EP-Retrieve MEDICATION LIST REVIEWED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTMLR^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
MLU(DFN) ;EP-Retrieve MEDICATION LIST UPDATED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTMLU^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
NAM(DFN) ;EP-Retrieve NO ACTIVE MEDICATIONS info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTNAM^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
ALR(DFN) ;EP-Retrieve ALLERGY LIST REVIEWED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTALR^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
ALU(DFN) ;EP-Retrieve ALLERGY LIST UPDATED info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTALU^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
NAA(DFN) ;EP-Retrieve NO ACTIVE ALLERGIES info
 ;
 ;Input:
 ; II - Index entry
 ; DATA - Array to store info
 ;Output:
 ; @DATA = CLINICAL ACTION^DATE OF OCCURRANCE^ENTERED BY
 ;
 N RSLT
 S RSLT=$$LASTNAA^APCLAPI6(DFN,,DT,"A") Q:RSLT=""
 D WRT(RSLT)
 Q
 ;
FRMT(X) ;EP-Format output for BQI GET VFILE INFO
 N RSLT
 Q:X="" ""
 ;
 ;Pull time from entry if not defined (current API doesnt return time)
 I $P($P(X,U),".",2)="" D
 . N IEN,DTM
 . S IEN=$P(X,U,6) Q:IEN=""
 . S DTM=$$GET1^DIQ(9000010.54,IEN_",",1201,"I")
 . S:DTM["." $P(X,U)=DTM
 ;
 S RSLT=$P(X,U,2)_U_$$FMTE^BQIUL1($P(X,U))_U_$$GET1^DIQ(200,$P(X,U,3)_",",.01,"E")
 Q RSLT
 ;
WRT(RSLT) ;EP-Write output string to Global Array for BQI GET VFILE INFO
 S RSLT=$$FRMT(RSLT)
 S II=II+1,@DATA@(II)=RSLT_$C(30)
 Q
 ;
PFRMT(X,DFN) ;EP-Format output for BQI GET MU PRB INFO
 N RSLT
 Q:X="" ""
 ;
 ;Check for time in result - Pull from file if blank (current API doesn't include time)
 I $P($P(X,U),".",2)="" D
 . N IEN,DTM
 . S IEN=$P(X,U,6) Q:IEN=""
 . S DTM=$$GET1^DIQ(9000010.54,IEN_",",1201,"I")
 . S:DTM["." $P(X,U)=DTM
 ;
 S RSLT=DFN_U_$P(X,U,2)_U_$$FMTE^BQIUL1($P(X,U))_U_$P(X,U,3)_$C(28)_$$GET1^DIQ(200,$P(X,U,3)_",",.01,"E")
 Q RSLT
 ;
PWRT(RSLT,DFN) ;EP-Write output string to Global Array for BQI GET MU PRB INFO
 S RSLT=$$PFRMT(RSLT,DFN)
 S II=II+1,@DATA@(II)=RSLT_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
