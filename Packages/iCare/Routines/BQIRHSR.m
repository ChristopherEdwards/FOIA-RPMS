BQIRHSR ;PRXM/HC/BWF - Retrieve Health summary list  ; 20 Dec 2005  3:53 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
 ; This function will gather a list Health summary types and set them into
 ; a temporary global array for use by RPC: BQI HEALTH SUMMARY TYPE.
 ; 
 ; INPUT:
 ;       USER - The DUZ of the user selecting the Health summaries.
 ;
 ; OUTPUT:
 ;       DATA - name of global (passed by reference) in which the data is stored
 ;       ^TMP("BQIRHSR",UID,HEALTH SUMMARY IEN)
 ;
 ; Calling routines must Kill ^TMP("BQIRHSR",UID) after use
 ; 
HSLIST(DATA,FAKE)   ; EP -- BQI HEALTH SUMMARY TYPE
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  
 N UID,HSIEN,HSNAME,BQII,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRHSR",UID))
 ; Initialize global array
 K @DATA
 S HSIEN=0,BQII=1
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRHSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010HEALTH_SUMMARY_TYPE^T00030HEALTH_SUMMARY_TYPE_NM"_$C(30)
 F  S HSIEN=$O(^APCHSCTL(HSIEN)) Q:'HSIEN  D
 .;get health summary name.
 .S HSNAME=$$GET1^DIQ(9001015,HSIEN,.01,"E")
 .;Set target global for calling routine.
 .S BQII=BQII+1,@DATA@(BQII)=HSIEN_"^"_HSNAME_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;Error trap for HSLIST
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
