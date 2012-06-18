BQIPLFLG ;PRXM/HC/ALA-Get "Flags" Definition ; 09 Dec 2005  5:18 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(DATA,FAKE) ; EP - BQI GET FLAG PREFS
 ;
 ;Description
 ;  Retrieve all the defined "flags" definitions for an owner
 ;  
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,X,MIEN,SOURCE,PARMS,PIEN,NAME,PTYP,VALUE,PMIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLFLG",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLFLG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00030SOURCE_NAME^T03200PARMS"_$C(30)
 ;
 S MIEN=0
 F  S MIEN=$O(^BQICARE(DUZ,10,MIEN)) Q:'MIEN  D
 . NEW DA,IENS
 . S DA(1)=DUZ,DA=MIEN,IENS=$$IENS^DILF(.DA)
 . S SOURCE=$$GET1^DIQ(90505.09,IENS,.01,"E")
 . S II=II+1,@DATA@(II)=SOURCE
 . S PIEN=0,PARMS=""
 . F  S PIEN=$O(^BQICARE(DUZ,10,MIEN,1,PIEN)) Q:'PIEN  D
 .. NEW DA,IENS
 .. S DA(2)=DUZ,DA(1)=MIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 .. S NAME=$$GET1^DIQ(90505.1,IENS,.01,"E")
 .. S PTYP=$$PTYP^BQIDCDF(SOURCE,NAME)
 .. I PTYP="T" S VALUE=$$GET1^DIQ(90505.1,IENS,.03,"E")
 .. I PTYP'="T" S VALUE=$$GET1^DIQ(90505.1,IENS,.02,"E")
 .. ;  if the parameter type is a date, convert to non FileMan date format
 .. I PTYP="D" S VALUE=$$FMTMDY^BQIUL1(VALUE)
 .. S PARMS=PARMS_NAME_"="
 .. ;
 .. ;  Check for values
 .. S PMIEN=0
 .. F  S PMIEN=$O(^BQICARE(DUZ,10,MIEN,1,PIEN,1,PMIEN)) Q:'PMIEN  D
 ... NEW DA,IENS
 ... S DA(3)=DUZ,DA(2)=MIEN,DA(1)=PIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" S VALUE=$$GET1^DIQ(90505.11,IENS,.02,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.11,IENS,.01,"E")
 ... ;  if the parameter type is a date, convert to non FileMan date format
 ... I PTYP="D" S VALUE=$$FMTMDY^BQIUL1(VALUE)
 ... S PARMS=PARMS_VALUE_$C(29)
 .. ; Remove trailing $C(29)
 .. S PARMS=$$TKO^BQIUL1(PARMS,$C(29))
 .. S PARMS=PARMS_VALUE_$C(28)
 . ; Remove trailing $C(28)
 . S PARMS=$$TKO^BQIUL1(PARMS,$C(28))
 . S $P(@DATA@(II),"^",2)=PARMS_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
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
UPD(DATA,SRCNM,PARMS) ;  EP - BQI SET FLAG PREFS
 ;
 ;Input
 ;  SRCNM - Source Name of the flag
 ;  PARMS - Parameters for the source
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,X,MIEN,PIEN,PMIEN,VALUE,PDATA,ALDA,QFL,BQ,NAME,MVAL,BQII,PPIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLFLG",UID))
 K @DATA
 ;
 S II=0,PARMS=$G(PARMS,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLFLG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S PPIEN=$$PP^BQIDCDF(SRCNM) I PPIEN=-1 S BMXSEC="Source not found." Q
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW DA,DIC,DLAYGO
 S DA(1)=DUZ,X=SRCNM
 S DLAYGO=90505.09,DIC(0)="LNXZ"
 S DIC="^BQICARE("_DA(1)_",10,"
 I '$D(^BQICARE(DA(1),10,0)) S ^BQICARE(DA(1),10,0)="^90505.09P^^"
 ;K DO,DD D FILE^DICN
 D ^DIC
 S ALDA=+Y
 I ALDA=-1 S II=II+1,@DATA@(II)="-1"_$C(30) G DONE
 ;
 ;  Clean out all the previous parameters
 NEW DA,DIK,PN,PDA
 S DA(2)=DUZ,DA(1)=ALDA,DIK="^BQICARE("_DA(2)_",10,"_DA(1)_",1,",PN=0
 F  S PN=$O(^BQICARE(DA(2),10,DA(1),1,PN)) Q:'PN  S DA=PN D ^DIK
 ;
 S QFL=0
 F BQ=1:1:$L(PARMS,$C(28)) D  G DONE:QFL
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . S PTYP=$$PTYP^BQIDCDF(SRCNM,NAME)
 . NEW DA,IENS,DIC
 . S DA(2)=DUZ,DA(1)=ALDA,X=NAME
 . S DLAYGO=90505.1,DIC(0)="L",DIC("P")=DLAYGO
 . S DIC="^BQICARE("_DA(2)_",10,"_DA(1)_",1,"
 . I '$D(^BQICARE(DA(2),10,DA(1),1,0)) S ^BQICARE(DA(2),10,DA(1),1,0)="^90505.1^^"
 . K DO,DD D FILE^DICN
 . S (DA,PDA)=+Y
 . I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 . ;
 . NEW DA,IENS
 . S DA(2)=DUZ,DA(1)=ALDA,DA=PDA
 . S IENS=$$IENS^DILF(.DA)
 . I VALUE'[$C(29) D  Q
 .. ;  if the parameter type is a date, convert to FileMan date format
 .. I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 .. I PTYP="T" S BQIUPD(90505.1,IENS,.03)=VALUE
 .. I PTYP'="T" S BQIUPD(90505.1,IENS,.02)=VALUE
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 . ;
 . I VALUE[$C(29) D  Q:QFL
 .. I '$D(^BQICARE(DA(2),10,DA(1),1,DA,1,0)) S ^BQICARE(DA(2),10,DA(1),1,DA,1,0)="^90505.11^^"
 .. F BQII=1:1:$L(VALUE,$C(29)) D
 ... S MVAL=$P(VALUE,$C(29),BQII)
 ... NEW DA,IENS
 ... S DA(3)=DUZ,DA(2)=ALDA,DA(1)=PDA,X=MVAL
 ... S DLAYGO=90505.11,DIC(0)="L",DIC("P")=DLAYGO
 ... S DIC="^BQICARE("_DA(3)_",10,"_DA(2)_",1,"_DA(1)_",1,"
 ... K DO,DD D FILE^DICN
 ... S DA=+Y
 ... I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 ... ;  if the parameter type is a date, convert to FileMan date format
 ... I PTYP="D" S MVAL=$$DATE^BQIUL1(MVAL)
 ... S IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" S BQIUPD(90505.11,IENS,.02)=MVAL
 ... D FILE^DIE("","BQIUPD","ERROR")
 ... K BQIUPD
 ;
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DELA(DATA) ;  Delete all flag definitions
 NEW UID,II,DA,DIK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLFLG",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLFLG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 S DA(1)=DUZ,DA=0,DIK="^BQICARE("_DA(1)_",10,"
 F  S DA=$O(^BQICARE(DUZ,10,DA)) Q:'DA  D ^DIK
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL ;  Delete the previous flag definitions
 NEW DA,DIK
 S DA(1)=DUZ,DA=0,DIK="^BQICARE("_DA(1)_",10,"
 F  S DA=$O(^BQICARE(DUZ,10,DA)) Q:'DA  D ^DIK
 Q
 ;
GPARMS(USR,ADSC,PARMS,MPARMS) ;EP - Get parameters for a user's flag preference
 ;
 ;Input
 ;  USR  = User/Owner internal entry number
 ;  ADSC = Flag description
 ;
 NEW DA,IENS,DIC,AIEN,SOURCE,PIEN,PTYP,VALUE,PMIEN
 S DA(1)=USR,X=ADSC,DIC(0)="XZ",DIC="^BQICARE("_DA(1)_",10,"
 D ^DIC
 I +Y<1 Q
 S (DA,AIEN)=+Y,IENS=$$IENS^DILF(.DA)
 S SOURCE=$$GET1^DIQ(90505.09,IENS,.01,"E")
 S PIEN=0,PARMS=""
 F  S PIEN=$O(^BQICARE(USR,10,AIEN,1,PIEN)) Q:'PIEN  D
 . NEW DA,IENS
 . S DA(2)=USR,DA(1)=AIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.1,IENS,.01,"E")
 . S PTYP=$$PTYP^BQIDCDF(SOURCE,NAME)
 . ;  if the parameter type is a table, use the pointer (IEN) value
 . I PTYP="T" S VALUE=$$GET1^DIQ(90505.1,IENS,.03,"E")
 . ;  if the parameter type is not a table, use the free text value
 . I PTYP'="T" S VALUE=$$GET1^DIQ(90505.1,IENS,.02,"E")
 . ;  if the parameter type is a date, convert to FileMan date format
 . I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 . S PARMS(NAME)=VALUE
 . ;
 . ;  Check for values
 . S PMIEN=0
 . F  S PMIEN=$O(^BQICARE(USR,10,AIEN,1,PIEN,1,PMIEN)) Q:'PMIEN  D
 .. NEW DA,IENS
 .. S DA(3)=USR,DA(2)=AIEN,DA(1)=PIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;  if the parameter type is a table, use the pointer (IEN) value
 .. I PTYP="T" S VALUE=$$GET1^DIQ(90505.11,IENS,.02,"E")
 .. ;  if the parameter type is not a table, use the free text value
 .. I PTYP'="T" S VALUE=$$GET1^DIQ(90505.11,IENS,.01,"E")
 .. S MPARMS(NAME,VALUE)=""
 Q
