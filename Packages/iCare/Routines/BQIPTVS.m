BQIPTVS ;PRXM/HC/BWF-Patient Visit Utilities ; 15 Nov 2005  3:17 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; This is a utility program containing special function calls
 ; needed for patient visit data.
 Q
 ;
PNLVST(DATA,DFN,DRANGE) ; EP -- BQI PATIENT RECENT VISITS
 ;
 ; Description:
 ;   Function used to gather visit information for a patient for a relative date range.
 ;   Gathers provider name ICD narrative, POV narrative, and clinic.
 ;   This function will gather 1.) A list of visit related information based on a date range
 ;                             2.) If no date is provided, all visits will be reported.
 ;
 ;   Use date range to drive through visits.
 ;   
 ; Input
 ;   DFN (Required)     - Patient IEN
 ;   DRANGE - Date to pull past appointments from (to the present).
 ;   
 ; Output
 ;   Global array containing information for patients.
 ;   ^TMP("BQIPTVS",UID,BQII)=VISIT DATE_^_CLINIC_^_PROVIDER NAME_^_ICD NARRATIVE_^_POV NARRATIVE
 ;
 ; Variables
 ;   DFN           - Patient Identifier
 ;   VSTDT         - Visit Date
 ;   VSTIEN        - Visit IEN
 ;
 N VSTIEN,VSTDT,RDRANGE,BQII,UID,X
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTVS",UID))
 K @DATA
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTVS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 S DRANGE=$$DATE^BQIUL1($G(DRANGE))
 S RDRANGE=9999999-DRANGE+1   ; Add one day to include visits on that day.
 ;                            ; Otherwise, they will not be included.
 S VSTDT=""
 F  S VSTDT=$O(^AUPNVSIT("AA",DFN,VSTDT)) Q:(VSTDT="")!(VSTDT>RDRANGE)  D
 .S VSTIEN=0
 .F  S VSTIEN=$O(^AUPNVSIT("AA",DFN,VSTDT,VSTIEN)) Q:VSTIEN=""  D
 ..D VSTDATA(VSTIEN,.BQII)
 ;
 ; DROP DOWN TO DONE
 ;
DONE ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
VSTDATA(VSTIEN,BQII) ;EP
 ;Gather visit date, visit provider, clinic, ICD narrative, POV code narrative,
 ; and provider narrative for each patient and set into global array ^TMP("BQIPTVS",UID).
 ;
 ; Input
 ;  VSTIEN - Visit IEN
 ;  BQII   - Increment variable for output.
 ;
 ; Output
 ;   Global array containing information for patients.
 ;   ^TMP("BQIPTVS",UID,BQII)=VISIT IEN^VISIT DATE_^_CLINIC_^_PROVIDER NAME_^_ICD NARRATIVE_^_POV NARRATIVE
 ;
 ; Variables
 ;   VSTDT         - Visit Date
 ;   VPRVIEN       - Provider IEN(s) for last visit
 ;   VPOVIEN       - V POV file IEN
 ;       
 N CLINIC,VPRVIEN,VSTDT,PRIMPROV,ICDNAR,ICDNSTR,POVNAR,POVNSTR,VPOVIEN,CLN,CSTCD
 S VSTDT=$$GET1^DIQ(9000010,VSTIEN,.01,"I")
 ; If visit has been deleted, don't include
 I $$GET1^DIQ(9000010,VSTIEN_",",.11,"I")=1 Q
 S CLN=$$GET1^DIQ(9000010,VSTIEN,.08,"I"),CSTCD=""
 I CLN'="" S CSTCD=$$GET1^DIQ(40.7,CLN_",",1,"E")
 S CLINIC=$$GET1^DIQ(9000010,VSTIEN,.08,"E")_" "_CSTCD
 ;
 ; Loop through providers. Only primary providers will be returned.
 S VPRVIEN=0,PRIMPROV=""
 F  S VPRVIEN=$O(^AUPNVPRV("AD",VSTIEN,VPRVIEN)) Q:VPRVIEN=""  D
 .I $$GET1^DIQ(9000010.06,VPRVIEN,.04,"I")'="P" Q
 .S PRIMPROV=$$GET1^DIQ(9000010.06,VPRVIEN,.01,"E")
 S BQII=BQII+1,@DATA@(BQII)=VSTIEN_U_$$FMTE^BQIUL1(VSTDT)_U_CLINIC_U_PRIMPROV
 ;
 ; Gather all ICD narratives, separated by a LF/CR.
 S VPOVIEN=0,ICDNSTR=""
 F  S VPOVIEN=$O(^AUPNVPOV("AD",VSTIEN,VPOVIEN)) Q:VPOVIEN=""  D
 .S ICDNAR=$$GET1^DIQ(9000010.07,VPOVIEN,".019","E")
 .I ICDNAR'="" S ICDNSTR=$S(ICDNSTR'="":ICDNSTR_$C(13)_$C(10)_ICDNAR,1:ICDNAR)
 ;
 ; Gather all POV narratives, separated by a LF/CR.
 S VPOVIEN=0,POVNSTR=""
 F  S VPOVIEN=$O(^AUPNVPOV("AD",VSTIEN,VPOVIEN)) Q:VPOVIEN=""  D
 .S POVNAR=$$GET1^DIQ(9000010.07,VPOVIEN,".04","E")
 .I POVNAR'="" S POVNSTR=$S(POVNSTR'="":POVNSTR_$C(13)_$C(10)_POVNAR,1:POVNAR)
 ;
 S @DATA@(BQII)=@DATA@(BQII)_U_ICDNSTR_U_POVNSTR_$C(30)
 Q
 ;
HDR ;
 S @DATA@(BQII)="I00010VST_IEN^D00015VST_DT^T00050VST_CLIN^T00050VST_PROV^T01000VST_ICD^T01000VST_POV"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
