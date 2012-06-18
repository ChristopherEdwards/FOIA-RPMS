BQIPLLOG ;PRXM/HC/ALA-Login Date/Time ; 04 May 2006  2:37 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,FAKE) ;  EP -- BQI GET LAST LOGIN
 ;Description
 ; Get date/time of last login
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,LOGDTM,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLLOG",UID))
 K @DATA
 ;
 S II=0
 S @DATA@(II)="D00030LAST_LOG_DATETIME"_$C(30)
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLOG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S LOGDTM=$$GET1^DIQ(90505,DUZ_",",.06,"I")
 S II=II+1,@DATA@(II)=$$FMTE^BQIUL1(LOGDTM)_$C(30)
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
UPD(DATA,VALUE) ; EP -- BQI SET LAST LOGIN
 ;
 ; Input
 ;  VALUE - the value
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes DUZ the user signed onto iCare
 NEW UID,II,ERROR,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLLOG",UID))
 K @DATA
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLOG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 S VALUE=$G(VALUE,"")
 I VALUE="" S VALUE=$$NOW^XLFDT()
 ;
 S BQIUPD(90505,DUZ_",",.06)=VALUE
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 S II=II+1
 I '$D(ERROR) S @DATA@(II)="1"_$C(30)
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
CHK ; Check for the first log in of the day
 NEW DA,LOGDTM,CDTM,CFLG
 S DA=$O(^BQI(90508,0)) Q:DA=""
 S LOGDTM=$$GET1^DIQ(90508,DA_",",9,"I")
 S CDTM=$$NOW^XLFDT(),CFLG=0
 I LOGDTM="" S BQIUPD(90508,DA_",",9)=CDTM,CFLG=1
 I LOGDTM'="" D
 . I $P(CDTM,".",1)=$P(LOGDTM,".",1) Q
 . S BQIUPD(90508,DA_",",9)=CDTM,CFLG=1
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Check tasks
 I CFLG D ^BQISCHED
 Q
