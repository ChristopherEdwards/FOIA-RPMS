BQIPLLK ;PRXM/HC/KJH-Panel Lock/Unlock Functions ; 23 Feb 2006  5:08 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LOCK(DATA,OWNR,PLIEN) ; EP - BQI LOCK PANEL
 ; Description
 ;   Attempt to lock the panel specified by OWNR and PLIEN for
 ;   exclusive editing access.
 ;   If successful, sets 'LAST LOCKED BY' with the current DUZ
 ;   and returns a RESULT of 1 and the current DUZ.
 ;   If unsuccessful, returns a RESULT of 0 and the DUZ from the
 ;   'LAST LOCKED BY' field.
 ; Input:
 ;   OWNR   - Owner of the panel to be locked
 ;   PLIEN  - Panel IEN to be locked
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 if the lock succeeded
 ;          = 0 if the lock failed
 ;   USER   = DUZ of the last user to successfully lock this panel
 ; or
 ;   BMXSEC - if $D(ERROR) when filing or M error encountered
 ;            
 N UID,X,BQII
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLLK",UID))
 K ^TMP("BQIPLLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,^TMP("BQIPLLK",UID,BQII)="I00010RESULT^I00010USER^T00035NAME"_$C(30)
 ;
 ; Check for existence of the panel. (May have been edited/deleted by owner while share had it on their list.)
 I $G(PLIEN)="" S BMXSEC="RPC Call Failed: Panel does not exist. May have been edited by another user." Q
 I '$D(^BQICARE(OWNR,1,PLIEN,0)) S BMXSEC="RPC Call Failed: Panel does not exist. May have been edited by another user." Q
 ;
 N DA,IENS,RESULT,USER,NAME,ERROR
 S DA=PLIEN,DA(1)=OWNR,IENS=$$IENS^DILF(.DA),USER=""
 ;
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +^BQICARE(OWNR,1,PLIEN,0):1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 S USER=$$GET1^DIQ(90505.01,IENS,.16,"I")
 ;
 ; If lock is successful, update 'LAST LOCKED BY' on the panel.
 I RESULT=1 D
 . N BQINEW
 . S (BQINEW(90505.01,IENS,.16),USER)=DUZ
 . D FILE^DIE("","BQINEW","ERROR")
 . I $D(ERROR) S BMXSEC="RPC Call Failed: Error encountered while updating user last locked." Q
 . Q
 ;
 ; If an error occurred after the lock was set then unlock and quit.
 I $G(BMXSEC)'="" L -^BQICARE(OWNR,1,PLIEN,0) Q
 ;
 ; Get user name (if available)
 S NAME=$$GET1^DIQ(200,USER,.01,"E")
 I NAME="" S NAME="an unknown user"
 ;
 ; Report results
 S BQII=BQII+1,^TMP("BQIPLLK",UID,BQII)=RESULT_"^"_USER_"^"_NAME_$C(30)
 S BQII=BQII+1,^TMP("BQIPLLK",UID,BQII)=$C(31)
 Q
 ;
UNLOCK(DATA,OWNR,PLIEN) ; EP - BQI UNLOCK PANEL
 ; Description
 ;   Unlock the panel specified by OWNR and PLIEN which was
 ;   previously locked for exclusive editing access. If the
 ;   entry in the 'LAST LOCKED BY' field is for this DUZ then
 ;   delete it (so another user can't accidentally update it).
 ; Input:
 ;   OWNR   - Owner of the panel to be unlocked
 ;   PLIEN  - Panel IEN to be unlocked
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 (unlock will always succeed)
 ; or
 ;   BMXSEC - if $D(ERROR) when filing or M error encountered
 ;            
 N UID,X,BQII
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLLK",UID))
 K ^TMP("BQIPLLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,^TMP("BQIPLLK",UID,BQII)="I00010RESULT"_$C(30)
 ;
 N DA,IENS,RESULT,USER,ERROR
 S DA=PLIEN,DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 ;
 ; Get 'LAST LOCKED BY' from the panel.
 S USER=$$GET1^DIQ(90505.01,IENS,.16,"I")
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete it from the panel.
 I USER=DUZ D
 . N BQINEW
 . S BQINEW(90505.01,IENS,.16)="@"
 . D FILE^DIE("","BQINEW","ERROR")
 . I $D(ERROR) S BMXSEC="RPC Call Failed: Error encountered while updating user last locked." Q
 . Q
 ;
 ; Unlock and set RESULT
 S RESULT=1
 L -^BQICARE(OWNR,1,PLIEN,0)
 ;
 ; Report results
 S BQII=BQII+1,^TMP("BQIPLLK",UID,BQII)=RESULT_$C(30)
 S BQII=BQII+1,^TMP("BQIPLLK",UID,BQII)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
