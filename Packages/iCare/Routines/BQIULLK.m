BQIULLK ;PRXM/HC/DB-Miscellaneous BQI utilities - Lock/Unlock Functions ; 28 May 2008  4:03 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LOCK(DATA,DFN,TYPE) ; EP - BQI LOCK RECORD BY TYPE
 ; Description
 ;   Attempt to lock a record type (problem, family history, etc.) for a patient
 ;   If successful, sets 'LAST LOCKED BY' with the current DUZ
 ;   and returns a RESULT of 1 and the current DUZ.
 ;   If unsuccessful, returns a RESULT of 0 and the DUZ from the
 ;   'LAST LOCKED BY' field.
 ; Input:
 ;   DFN     - Patient IEN
 ;   TYPE    - Type of record to be locked for this patient
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
 I $G(TYPE)="" S BMXSEC="Invalid record type passed." Q
 N UID,X,BQII,MSG,RESULT,DCATIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIULLK"_$E(TYPE,1,5),UID))
 K ^TMP("BQIULLK"_$E(TYPE,1,5),UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIULLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 S MSG=""
 N USER
 ;
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +^BQILOCK(TYPE,DFN):1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$G(^XTMP("BQIULLK",TYPE,DFN))
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This record is currently being updated by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("BQIULLK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of "_TYPE_" data"
 . S ^XTMP("BQIULLK",TYPE,DFN)=DUZ
 ;
 D UPD
 Q
 ;
UNLOCK(DATA,DFN,TYPE) ; EP - BQI UNLOCK RECORD BY TYPE
 ; Description
 ;   Unlock a record type (problem, family history, etc. - specified by TYPE)
 ;   for a patient previously locked for exclusive editing access. If the
 ;   entry in the 'LAST LOCKED BY' field is for this DUZ then
 ;   delete it (so another user can't accidentally update it).
 ; Input:
 ;   DFN     - Patient IEN
 ;   TYPE    - Type of record to be locked for this patient
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 (unlock will always succeed)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 I $G(TYPE)="" S BMXSEC="Invalid record type passed." Q
 N UID,X,BQII,MSG,REGIEN,RDATA
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIULLK"_$E(TYPE,1,5),UID))
 K ^TMP("BQIULLK"_$E(TYPE,1,5),UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIULLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 N RESULT,USER
 ;
 S MSG=""
 ; Get 'LAST LOCKED BY'.
 S USER=$G(^XTMP("BQIULLK",TYPE,DFN))
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("BQIULLK",TYPE,DFN)
 ;
 ; Unlock and set RESULT
 S RESULT=1
 L -^BQILOCK(TYPE,DFN)
 ;
 D UPD
 Q
 ;
UPD ; Report results
 S BQII=BQII+1,@DATA@(BQII)=RESULT_"^"_MSG_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;
 L
 I $G(DCAT)'="",$G(DFN)'="",$G(^XTMP("BQIULLK",TYPE,DFN))=DUZ K ^XTMP("BQIULLK",TYPE,DFN)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
