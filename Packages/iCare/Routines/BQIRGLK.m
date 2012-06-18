BQIRGLK ;PRXM/HC/DB-Patient Register Lock/Unlock Functions ; 14 Nov 2007  4:03 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LOCK(DATA,DFN,REG,PTIEN) ; EP - BQI LOCK PATIENT BY REGISTER
 ; Description
 ;   Attempt to lock a patient register record specified by REG and PTIEN for
 ;   exclusive editing access.
 ;   If successful, sets 'LAST LOCKED BY' with the current DUZ
 ;   and returns a RESULT of 1 and the current DUZ.
 ;   If unsuccessful, returns a RESULT of 0 and the DUZ from the
 ;   'LAST LOCKED BY' field.
 ; Input:
 ;   DFN     - Patient IEN
 ;   REG     - Register defined in ^BQI(90507
 ;   PTIEN   - Register patient IEN to be locked
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 if the lock succeeded
 ;          = 0 if the lock failed
 ;          = -1 if problem identified with file 90507 (shouldn't happen)
 ;   USER   = DUZ of the last user to successfully lock this panel
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 N UID,X,BQII,MSG,FILE,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGLK",UID))
 K ^TMP("BQIRGLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 S FILE=$$RFILE(REG),MSG=$P(FILE,U,2),FILE=$P(FILE,U)
 I FILE=-1 S RESULT=-1 D UPD Q
 ; If adding register information create temporary ien for locking
 I $L(PTIEN,",")=3 S PTIEN=$P(PTIEN,",",2) ; Returned as IENS
 I $E(PTIEN,$L(PTIEN))="," S PTIEN=$$TKO^BQIUL1(PTIEN,",")
 I 'PTIEN S PTIEN="T"_DFN
 S GLBREF=$$ROOT^DILFD(FILE,"")_$S('PTIEN:""""_PTIEN_"""",1:PTIEN)_")"
 ;
 N USER
 ;
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +@GLBREF:1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$G(^XTMP("BQIRGLK",FILE,PTIEN))
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This record is currently being updated by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("BQIRGLK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of patient register data"
 . S ^XTMP("BQIRGLK",FILE,PTIEN)=DUZ
 ;
 D UPD
 Q
 ;
UNLOCK(DATA,DFN,REG,PTIEN) ; EP - BQI UNLOCK PATIENT BY REGISTER
 ; Description
 ;   Unlock the patient register record specified by REG and PTIEN which was
 ;   previously locked for exclusive editing access. If the
 ;   entry in the 'LAST LOCKED BY' field is for this DUZ then
 ;   delete it (so another user can't accidentally update it).
 ; Input:
 ;   DFN     - Patient IEN
 ;   REG     - Register defined in ^BQI(90507
 ;   PTIEN  - Register IEN to be locked
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 (unlock will always succeed)
 ;   RESULT = -1 if problem identified with file 90507 (shouldn't happen)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 N UID,X,BQII,MSG,REGIEN,RDATA,FILE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGLK",UID))
 K ^TMP("BQIRGLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGLK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 N RESULT,USER
 ;
 S FILE=$$RFILE(REG),MSG=$P(FILE,U,2),FILE=$P(FILE,U)
 I FILE=-1 S RESULT=-1 D UPD Q
 ; If adding register information create temporary ien for locking
 I $L(PTIEN,",")=3 S PTIEN=$P(PTIEN,",",2) ; Returned as IENS
 I $E(PTIEN,$L(PTIEN))="," S PTIEN=$$TKO^BQIUL1(PTIEN,",")
 I 'PTIEN S PTIEN="T"_DFN
 S GLBREF=$$ROOT^DILFD(FILE,"")_$S('PTIEN:""""_PTIEN_"""",1:PTIEN)_")"
 ;
 ; Get 'LAST LOCKED BY'.
 S USER=$G(^XTMP("BQIRGLK",FILE,PTIEN))
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("BQIRGLK",FILE,PTIEN)
 ;
 ; Unlock and set RESULT
 S RESULT=1
 L -@GLBREF
 ;
 D UPD
 Q
 ;
UPD ; Report results
 S BQII=BQII+1,@DATA@(BQII)=RESULT_"^"_MSG_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
RFILE(REG) ; Get register file number
 N REGIEN,RDATA,FILE
 S REGIEN=$O(^BQI(90507,"B",REG,""))
 I 'REGIEN Q "-1^Invalid register"
 I $$GET1^DIQ(90507,REGIEN_",",.08,"I")=1 Q "-1^Inactive register"
 S RDATA=^BQI(90507,REGIEN,0),FILE=$P(RDATA,"^",7)
 I '$$VFILE^DILFD(FILE) Q "-1^Invalid file number"
 Q FILE
 ;
ERR ;
 L
 I $G(FILE)'="",$G(PTIEN)'="",$G(^XTMP("BQIRGLK",FILE,PTIEN))=DUZ K ^XTMP("BQIRGLK",FILE,PTIEN)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
