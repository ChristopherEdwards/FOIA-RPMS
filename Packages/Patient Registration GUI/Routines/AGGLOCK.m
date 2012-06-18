AGGLOCK ;VNGT/HS/ALA-Locking Routine for Patient Reg ; 16 May 2010  1:07 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
LOCK(DATA,DFN) ; EP - AGG LOCK PATIENT
 ; Input
 ;   DFN   - Patient IEN
 ;   
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 if the lock succeeded
 ;          = 0 if the lock failed
 ;          = -1 if invalid patient IEN (shouldn't happen)
 ;   USER   = DUZ of the last user to successfully lock this panel
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 NEW UID,X,II,MSG,VAL,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGLCK",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGLOCK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S II=0,@DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 ;S AGIEN=$$FIND1^DIC(9009068.3,"","BX",DEF,"","","ERROR")
 ;I AGIEN=0 S BMXSEC="RPC Failed: Passed in window name "_DEF_" not found" Q
 ;
 ;S FILE=$P(^AGG(9009068.3,AGIEN,0),U,2),SECFILE=$P(^AGG(9009068.3,AGIEN,0),U,14)
 ;
 S VAL=$$VAL(DFN),MSG=$P(VAL,U,2),VAL=$P(VAL,U)
 I VAL=-1 S RESULT=-1 D SET Q
 ;
 NEW USER
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +^DPT(DFN):1 E  S RESULT=0
 L +^AUPNPAT(DFN):1 E  S RESULT=0 L -^DPT(DFN)
 ; figure out what to lock
 ;
 ;
LST ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$P($G(^XTMP("AGGLCK",DFN)),"^")
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This event is locked for editing by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("AGGLCK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of Reg data"
 . S CNT=+$P($G(^XTMP("AGGLCK",DFN)),"^",2)+1
 . S ^XTMP("AGGLCK",DFN)=DUZ_"^"_CNT
 ;
 D SET
 Q
 ;
UNLOCK(DATA,DFN) ; EP - AGG UNLOCK PATIENT
 ; Input
 ;   DFN   - Patient IEN
 ;   
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;   RESULT = 1 (unlock will always succeed)
 ;   RESULT = -1 if invalid patient IEN (shouldn't happen)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 NEW UID,X,II,MSG,VAL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGLCK",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGLOCK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S II=0,@DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 NEW RESULT,USER
 S VAL=$$VAL(DFN),MSG=$P(VAL,U,2),VAL=$P(VAL,U)
 I VAL=-1 S RESULT=-1 D SET Q
 ;
 ; Unlock and set RESULT
 D UNL(DFN)
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
 D UNL(DFN)
 Q
 ;
VAL(IEN) ; Validate RECORD ien
 I $G(^DPT(IEN,0))="" Q "-1^Invalid Patient selected"
 I $G(^AUPNPAT(IEN,0))="" Q "-1^Invalid Patient selected"
 Q 1
 ;
UNL(DFN) ;
 Q:$G(DFN)=""
 ; Get 'LAST LOCKED BY'.
 N DAT,CNT
 S DAT=$G(^XTMP("AGGLCK",DFN))
 S USER=$P(DAT,"^")
 S CNT=+$P(DAT,"^",2)
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("AGGLCK",DFN)
 F I=1:1:CNT L -^AUPNPAT(DFN),-^DPT(DFN)
 Q
