BQIRPWH ;VNGT/HS/DB - Retrieve Patient Wellness Handout list  ; 04 Nov 2008  5:58 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
 ; This function will gather a list of Patient Wellness Handout types and set them
 ; into a temporary global array for use by RPC: BQI PATIENT WELLNESS TYPE.
 ; 
 ; INPUT:
 ;       USER - The DUZ of the user selecting the Health summaries.
 ;
 ; OUTPUT:
 ;       DATA - name of global (passed by reference) in which the data is stored
 ;       ^TMP("BQIRPWH",UID,PATIENT WELLNESS IEN)
 ; 
PWHLST(DATA,FAKE)   ; EP -- BQI PATIENT WELLNESS TYPE
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  
 N UID,PWHIEN,PWHNAME,BQII,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRPWH",UID))
 ; Initialize global array
 K @DATA
 S PWHIEN=0,BQII=1
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRPWH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010PATIENT_WELLNESS_TYPE^T00030PATIENT_WELLNESS_TYPE_NM"_$C(30)
 F  S PWHIEN=$O(^APCHPWHT(PWHIEN)) Q:'PWHIEN  D
 .;get patient wellness handout type name.
 .S PWHNAME=$$GET1^DIQ(9001026,PWHIEN,.01,"E")
 .;Set target global for calling routine.
 .S BQII=BQII+1,@DATA@(BQII)=PWHIEN_"^"_PWHNAME_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;Error trap for PWHLST
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
