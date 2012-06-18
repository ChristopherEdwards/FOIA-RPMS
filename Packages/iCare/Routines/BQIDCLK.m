BQIDCLK ;PRXM/HC/DB-Patient Diagnostic Tag Lock/Unlock Functions ; 18 Mar 2008  4:03 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LOCK(DATA,DFN,DCAT) ; EP - BQI LOCK PATIENT BY DX TAG
 ; Description
 ;   Attempt to lock a patient diagnostic tag record specified by DCAT for
 ;   exclusive editing access.
 ;   If successful, sets 'LAST LOCKED BY' with the current DUZ
 ;   and returns a RESULT of 1 and the current DUZ.
 ;   If unsuccessful, returns a RESULT of 0 and the DUZ from the
 ;   'LAST LOCKED BY' field.
 ; Input:
 ;   DFN     - Patient IEN
 ;   DCAT    - Diagnostic tag defined in ^BQI(90506.2
 ;
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 if the lock succeeded
 ;          = 0 if the lock failed
 ;          = -1 if problem identified with DCAT (shouldn't happen)
 ;   USER   = DUZ of the last user to successfully lock this panel
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 N UID,X,BQII,MSG,RESULT,DCATIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCLK",UID))
 K ^TMP("BQIDCLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 S MSG=""
 ; If adding register information create temporary ien for locking
 S DCATIEN=$O(^BQI(90506.2,"B",DCAT,"")) I DCATIEN="" D INV Q
 ; Subdefinitions (risk factors that are not standalone) are not valid here
 I $$GET1^DIQ(90506.2,DCATIEN_",",.05,"I") D INV Q
 ;
 N USER
 ;
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +^BQIREG(DCAT,DFN):1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$G(^XTMP("BQIDCLK",DCAT,DFN))
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This record is currently being updated by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("BQIDCLK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of patient register data"
 . S ^XTMP("BQIDCLK",DCAT,DFN)=DUZ
 ;
 D UPD
 Q
 ;
UNLOCK(DATA,DFN,DCAT) ; EP - BQI UNLOCK PATIENT BY DX TAG
 ; Description
 ;   Unlock the patient diagnostic tag record specified by DCAT which was
 ;   previously locked for exclusive editing access. If the
 ;   entry in the 'LAST LOCKED BY' field is for this DUZ then
 ;   delete it (so another user can't accidentally update it).
 ; Input:
 ;   DFN     - Patient IEN
 ;   DCAT    - Diagnostic tag defined in ^BQI(90506.2
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 (unlock will always succeed)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 N UID,X,BQII,MSG,REGIEN,RDATA
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCLK",UID))
 K ^TMP("BQIDCLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 N RESULT,USER
 ;
 S MSG=""
 ; Get 'LAST LOCKED BY'.
 S USER=$G(^XTMP("BQIDCLK",DCAT,DFN))
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("BQIDCLK",DCAT,DFN)
 ;
 ; Unlock and set RESULT
 S RESULT=1
 L -^BQIREG(DCAT,DFN)
 ;
 D UPD
 Q
 ;
UPD ; Report results
 S BQII=BQII+1,@DATA@(BQII)=RESULT_"^"_MSG_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
INV ; Invalid dx tag passed - either a subdefinition or not in the file
 S MSG="Invalid diagnostic tag selected.",RESULT=-1
 D UPD
 Q
 ;
ERR ;
 L
 I $G(DCAT)'="",$G(DFN)'="",$G(^XTMP("BQIDCLK",DCAT,DFN))=DUZ K ^XTMP("BQIDCLK",DCAT,DFN)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
