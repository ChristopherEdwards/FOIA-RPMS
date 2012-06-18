BQIPTSEN ;PRXM/HC/ALA-Sensitive Patient Options ; 13 Jul 2006  1:25 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
CHK(DATA,DFN) ; EP -- BQI CHECK SENSITIVE PATIENT
 ;Description
 ;  Checks whether a patient with a sensitive flag is accessible by
 ;  this user or not
 ;
 ;Input
 ;  DFN = Patient IEN
 ;  Assumes DUZ
 ;Output
 ;  0 = is not really sensitive
 ;  1 = is sensitive but DUZ has key that allows access
 ;  2 = is sensitive but DUZ does not have key that allows access
 ;      so if user continues on, a record must be logged
 ;
 NEW UID,II,TEXT,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTSEN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTSEN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00001SENSITIVE_INDICATOR"_$C(30)
 D SENS^DGSEC4(.TEXT,DFN,DUZ)
 S II=II+1,@DATA@(II)=$G(TEXT(1))_$C(30)
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
NOT(DATA,DFN) ; EP -- BQI SEND SENSITIVE NOTIFY
 ;Description
 ;  Send sensitive patient notification
 ;Input
 ;  DFN - Patient IEN
 ;  Assumes DUZ
 ;
 NEW UID,II,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTSEN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTSEN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 D NOTICE^DGSEC4(.RESULT,DFN,"BQIRPC^BQI RPC Calls")
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
