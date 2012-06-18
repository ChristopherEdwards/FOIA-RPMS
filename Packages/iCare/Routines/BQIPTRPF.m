BQIPTRPF ;VNGT/HS/ALA-Reproductive Factors Grid RPC ; 25 Jan 2010  1:26 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN(DATA,DFN) ; EP -- BQI REPRODUCTIVE FACTORS GRID
 ;
 ;Description - all the reproductive factors that a patient has in grid format
 ;
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW UID,II,VFIEN,HEADR,VALUE,N,CODE,VAL,IEN,HDR,SEX,AGE
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTRPF",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTRPF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I"),AGE=$$AGE^BQIAGE(DFN)
 I SEX'="F" S BMXSEC="RPC Failed: Patient is not Female" Q
 ;
 D REP^BQIPTREP(.NDATA,DFN)
 S VFIEN=$O(^BQI(90506.3,"B","Reproductive Factors",""))
 S N=0,HEADR="",VALUE=""
 F  S N=$O(@NDATA@(N)) Q:'N  D
 . S CODE=$P(@NDATA@(N),U,1),VAL=$P(@NDATA@(N),U,3)
 . I $E(CODE,1,2)'="RF" Q
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.3,VFIEN,10,"AC",CODE,IEN)) Q:IEN=""  D
 .. I $P(^BQI(90506.3,VFIEN,10,IEN,0),U,11)=1 Q
 .. S HDR=$P(^BQI(90506.3,VFIEN,10,IEN,0),U,2)
 .. NEW TYP,CIEN,TBL,GROOT,GBL
 .. S TYP=$P($G(^BQI(90506.3,VFIEN,10,IEN,1)),U,1)
 .. I TYP="C"!(TYP="T"),VAL'="" D
 ... I TYP="T" D
 .... S TBL=$P($G(^BQI(90506.3,VFIEN,10,IEN,2)),U,3)
 .... S GROOT=$$ROOT^DILFD(TBL),GBL=GROOT_"""B"""_")"
 .... S VAL=$O(@GBL@(VAL,""))
 ... I TYP="C" D
 .... S CCIEN=$O(^BQI(90506.3,VFIEN,10,IEN,5,"B",VAL,"")) I CCIEN="" Q
 .... S VAL=$P(^BQI(90506.3,VFIEN,10,IEN,5,CCIEN,0),U,2)
 .. S HEADR=HEADR_HDR_U
 .. S VALUE=VALUE_VAL_U
 S HEADR=$$TKO^BQIUL1(HEADR,U)
 S VALUE=$$TKO^BQIUL1(VALUE,U)
 S @DATA@(II)=HEADR_$C(30)
 S II=II+1,@DATA@(II)=VALUE_$C(30)
 K @NDATA,NDATA
 ;
DONE ;
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
LOCK(DATA,DFN) ; EP - BQI LOCK REPROD FACTOR
 N UID,X,BQII,MSG,VAL,RESULT,USER
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRFLK",UID))
 K ^TMP("BQIRFLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTRPF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 ; Attempt lock and set RESULT accordingly
 S RESULT=1
 L +^AUPNREP(DFN):1 E  S RESULT=0
 ;
 ; If lock is unsuccessful, get 'LAST LOCKED BY' from the panel.
 I RESULT=0 D
 . S USER=$G(^XTMP("BQIRFLK",DFN))
 . S NAME=$$GET1^DIQ(200,USER,.01,"E")
 . I NAME="" S NAME="an unknown user"
 . S MSG="This record is currently being updated by "_NAME_"."
 ; If lock is successful, update 'LAST LOCKED BY' in ^XTMP.
 I RESULT=1 D
 . S ^XTMP("BQIRFLK",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()_U_"Maintain locked by information for current locks of reproductive factors data"
 . S ^XTMP("BQIRFLK",DFN)=DUZ
 ;
 D SET
 Q
 ;
UNLOCK(DATA,DFN) ; EP - BQI UNLOCK REPROD FACTOR
 N UID,X,BQII,MSG,RESULT,USER
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRFLK",UID))
 K ^TMP("BQIRFLK",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,@DATA@(BQII)="I00010RESULT^T00080MESSAGE"_$C(30)
 ;
 ; Get 'LAST LOCKED BY'.
 S USER=$G(^XTMP("BQIRFLK",DFN))
 ;
 ; If 'LAST LOCKED BY' is this DUZ then delete the lock entry from ^XTMP.
 I USER=DUZ K ^XTMP("BQIRFLK",DFN)
 ;
 ; Unlock and set RESULT
 S RESULT=1
 L -^AUPNREP(DFN)
 D SET
 Q
 ;
SET ; Report results
 S BQII=BQII+1,@DATA@(BQII)=RESULT_"^"_$G(MSG)_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
