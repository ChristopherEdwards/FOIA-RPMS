BQIPLMRU ;PRXM/HC/ALA - Most Recently Viewed Panels ; 17 Feb 2006  12:20 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(DATA) ; EP - BQI GET MRU PANELS
 ;Get the list of most recently viewed panels
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,BQIN,BQITXT,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLMRU",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLMRU D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00250PANEL_ID_LIST"_$C(30)
 S BQIN=0,BQITXT=""
 F  S BQIN=$O(^BQICARE(DUZ,5,BQIN)) Q:'BQIN  D
 . NEW DA,IENS
 . S DA(1)=DUZ,DA=BQIN,IENS=$$IENS^DILF(.DA)
 . S BQITXT=BQITXT_$$GET1^DIQ(90505.5,IENS,.01,"E")_$C(29)
 S BQITXT=$$TKO^BQIUL1(BQITXT,$C(29))
 S II=II+1,@DATA@(II)=BQITXT_$C(30)
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
UPD(DATA,PLIST) ;  EP - BQI SET MRU PANELS
 ;Update the list of most recently viewed panels
 ;
 ;Input
 ;  PLIST - List of panel ids separated by $C(29)
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,X,RESULT,BQI
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLMRU",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLMRU D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S PLIST=$G(PLIST,"")
 NEW DIK,DA
 D DEL
 ;
 I $G(PLIST)="" D  Q
 . S II=II+1,@DATA@(II)="1"_$C(30)
 . S II=II+1,@DATA@(II)=$C(31)
 ;
 I '$D(^BQICARE(DA(1),5,0)) S ^BQICARE(DA(1),5,0)="^90505.5^^"
 S RESULT=0
 F BQI=1:1:$L(PLIST,$C(29)) D
 . NEW DA,IENS,BQIVL,DIC
 . S BQIVL=$P(PLIST,$C(29),BQI)
 . S DA(1)=DUZ,X=BQIVL,DIC(0)="L",DIC="^BQICARE("_DA(1)_",5,"
 . D ^DIC
 . I +Y>0 S RESULT=1
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL ;  Remove old panel id list first
 S DA(1)=DUZ,DA=0,DIK="^BQICARE("_DA(1)_",5,"
 F  S DA=$O(^BQICARE(DA(1),5,DA)) Q:'DA  D ^DIK
 Q
