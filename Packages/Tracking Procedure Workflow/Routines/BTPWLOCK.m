BTPWLOCK ;VNGT/HS/ALA-Locking Routine for CMET ; 31 Dec 2009  10:11 AM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
LOCK(DATA,DFN,TYPE,CMIEN) ; EP - BTPW LOCK CMET RECORD
 ; Input
 ;   DFN   - Patient IEN
 ;   TYPE  - T=Tracked, Q=Queued
 ;   CMIEN - Record IEN
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
 NEW UID,X,II,MSG,VAL,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWLCK",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWLOCK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S II=0,@DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 S VAL=$$VAL(TYPE,CMIEN),MSG=$P(VAL,U,2),VAL=$P(VAL,U)
 I VAL=-1 S RESULT=-1 D SET Q
 ;
 NEW USER
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 I TYPE="T" L +^BTPWP(CMIEN):1 E  S RESULT=0
 I TYPE="Q" L +^BTPWQ(CMIEN):1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$G(^XTMP("BTPWLCK",TYPE,CMIEN))
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This event is locked for editing by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("BTPWLCK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of CMET data"
 . S ^XTMP("BTPWLCK",TYPE,CMIEN)=DUZ
 ;
 D SET
 Q
 ;
UNLOCK(DATA,DFN,TYPE,CMIEN) ; EP - BTPW UNLOCK CMET RECORD
 ; Input
 ;   DFN   - Patient IEN
 ;   TYPE  - T=Tracked, Q=Queued
 ;   CMIEN - Record IEN
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;   RESULT = 1 (unlock will always succeed)
 ;   RESULT = -1 if problem identified with file 90507 (shouldn't happen)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 NEW UID,X,II,MSG,VAL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWLCK",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWLOCK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S II=0,@DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 NEW RESULT,USER
 S VAL=$$VAL(TYPE,CMIEN),MSG=$P(VAL,U,2),VAL=$P(VAL,U)
 I VAL=-1 S RESULT=-1 D SET Q
 ;
 ; Unlock and set RESULT
 D UNL(TYPE,CMIEN)
 S RESULT=1
 D SET
 Q
 ;
SET ; Report results
 S II=II+1,@DATA@(II)=RESULT_"^"_$G(MSG)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
VAL(TYPE,IEN) ;EP - Validate RECORD ien
 I IEN="" Q "-1^Invalid CMET record selected"
 I TYPE="" Q "-1^Invalid CMET event selected"
 I TYPE="T",'$D(^BTPWP(IEN)) Q "-1^Tracked Event does not exist"
 I TYPE="Q",'$D(^BTPWQ(IEN)) Q "-1^Queued Event does not exist"
 Q 1
 ;
UNL(TYPE,CMIEN) ; EP
 ; Get 'LAST LOCKED BY'.
 S USER=$G(^XTMP("BTPWLCK",TYPE,CMIEN))
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("BTPWLCK",TYPE,CMIEN)
 I TYPE="T" L -^BTPWP(CMIEN)
 I TYPE="Q" L -^BTPWQ(CMIEN)
 Q
