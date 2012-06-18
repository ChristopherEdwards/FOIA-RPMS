BQIPLMY ;PRXM/HC/ALA-Get "My Patients" Definition ; 29 Nov 2005  4:59 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(DATA,OWNR) ;  EP - BQI GET USER MY PATIENTS DEF
 ;
 ;Description
 ;  Retrieve all the defined "my patients" definitions for an owner
 ;  
 ;Input
 ;  OWNR - Person to retrieve the "my patients" definition for
 ;         If not defined, it is assumed to be the user
 ;  
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,MIEN,PARMS,PIEN,PMIEN,VALUE,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLMY",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLMY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S OWNR=$G(OWNR,"") S:OWNR="" OWNR=DUZ
 S @DATA@(II)="T00030SOURCE_NAME^T00250GENERATED_DESCRIPTION^T03200PARMS"_$C(30)
 ;
 S MIEN=0
 F  S MIEN=$O(^BQICARE(OWNR,7,MIEN)) Q:'MIEN  D
 . NEW DA,IENS
 . S DA(1)=OWNR,DA=MIEN,IENS=$$IENS^DILF(.DA)
 . S II=II+1
 . S @DATA@(II)=$$GET1^DIQ(90505.07,IENS,.01,"E")_"^"_$$GET1^DIQ(90505.07,IENS,2,"E")_"^"
 . S PIEN=0,PARMS=""
 . F  S PIEN=$O(^BQICARE(OWNR,7,MIEN,10,PIEN)) Q:'PIEN  D
 .. NEW DA,IENS
 .. S DA(2)=OWNR,DA(1)=MIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 .. S PARMS=PARMS_$$GET1^DIQ(90505.08,IENS,.01,"E")_"="
 .. ;
 .. ;  Check for multiple values
 .. S PMIEN=0
 .. F  S PMIEN=$O(^BQICARE(OWNR,7,MIEN,10,PIEN,1,PMIEN)) Q:'PMIEN  D
 ... NEW DA,IENS
 ... S DA(3)=OWNR,DA(2)=MIEN,DA(1)=PIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 ... S VALUE=$S($$GET1^DIQ(90505.81,IENS,.02,"E")'="":$$GET1^DIQ(90505.81,IENS,.02,"E"),1:$$GET1^DIQ(90505.81,IENS,.01,"E"))
 ... S PARMS=PARMS_VALUE_$C(29)
 .. ; remove trailing $C(29)
 .. S PARMS=$$TKO^BQIUL1(PARMS,$C(29))
 .. S VALUE=$S($$GET1^DIQ(90505.08,IENS,.02,"E")'="":$$GET1^DIQ(90505.08,IENS,.02,"E"),1:$$GET1^DIQ(90505.08,IENS,.03,"E"))
 .. S PARMS=PARMS_VALUE_$C(28)
 . ; remove trailing $C(28)
 . S PARMS=$$TKO^BQIUL1(PARMS,$C(28))
 . S @DATA@(II)=@DATA@(II)_PARMS_$C(30)
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
DEL ;  Delete the previous 'My Patients' definitions
 NEW DA,DIK
 S DA(1)=OWNR,DA=0,DIK="^BQICARE("_DA(1)_",7,"
 F  S DA=$O(^BQICARE(OWNR,7,DA)) Q:'DA  D ^DIK
 Q
 ;
UPD(DATA,SRCNM,PARMS) ;  EP - BQI SET USER MY PATIENTS DEF
 ;Input
 ;  SRCNM - Source Name of the My Patient definition
 ;  PARMS - Parameters for the source
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,MIEN,PIEN,PMIEN,VALUE,X,PPIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLMY",UID))
 K @DATA
 ;
 I '$$OWNR^BQIPLUSR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLMY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S PARMS=$G(PARMS,"")
 S PPIEN=$$PP^BQIDCDF(SRCNM) I PPIEN=-1 S BMXSEC="Source not found." Q
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW DA,DIC,DLAYGO,BDATA,BQ,BQI,ALDA,QFL
 S DA(1)=DUZ,X=SRCNM
 S DLAYGO=90505.07,DIC(0)="LNXZ"
 S DIC="^BQICARE("_DA(1)_",7,"
 I '$D(^BQICARE(DA(1),7,0)) S ^BQICARE(DA(1),7,0)="^90505.07P^^"
 D ^DIC
 S ALDA=+Y
 I ALDA=-1 S II=II+1,@DATA@(II)="-1"_$C(30) G DONE
 ;
 ;  delete parameters before storing new values
 NEW DA,DIK,PN
 S DA(2)=DUZ,DA(1)=ALDA,DIK="^BQICARE("_DA(2)_",7,"_DA(1)_",10,",PN=0
 F  S PN=$O(^BQICARE(DA(2),7,DA(1),10,PN)) Q:'PN  S DA=PN D ^DIK
 ;
 NEW QFL,BQ,BDATA,PTYP,BQI,VALUE,MVAL,NAME,PDA
 S QFL=0
 F BQ=1:1:$L(PARMS,$C(28)) D  G DONE:QFL
 . S BDATA=$P(PARMS,$C(28),BQ) Q:BDATA=""
 . S NAME=$P(BDATA,"=",1),VALUE=$P(BDATA,"=",2,99)
 . S PTYP=$$PTYP^BQIDCDF(SRCNM,NAME)
 . NEW DA,IENS,DIC
 . S DA(2)=DUZ,DA(1)=ALDA,X=NAME
 . S DLAYGO=90505.08,DIC(0)="L",DIC("P")=DLAYGO
 . S DIC="^BQICARE("_DA(2)_",7,"_DA(1)_",10,"
 . I '$D(^BQICARE(DA(2),7,DA(1),10,0)) S ^BQICARE(DA(2),7,DA(1),10,0)="^90505.08^^"
 . K DO,DD D FILE^DICN
 . S (DA,PDA)=+Y
 . I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 . ;
 . NEW DA,IENS
 . S DA(2)=DUZ,DA(1)=ALDA,DA=PDA
 . S IENS=$$IENS^DILF(.DA)
 . I VALUE'[$C(29) D  Q
 .. I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 .. I PTYP="T" S BQIUPD(90505.08,IENS,.03)=VALUE
 .. I PTYP'="T" S BQIUPD(90505.08,IENS,.02)=VALUE
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 . ;
 . I VALUE[$C(29) D  Q:QFL
 .. I '$D(^BQICARE(DA(2),7,DA(1),1,DA,1,0)) S ^BQICARE(DA(2),7,DA(1),1,DA,1,0)="^90505.81^^"
 .. F BQI=1:1:$L(VALUE,$C(29)) D
 ... S MVAL=$P(VALUE,$C(29),BQI)
 ... NEW DA,IENS
 ... S DA(3)=DUZ,DA(2)=ALDA,DA(1)=PDA,X=MVAL
 ... S DLAYGO=90505.81,DIC(0)="L",DIC("P")=DLAYGO
 ... S DIC="^BQICARE("_DA(3)_",7,"_DA(2)_",10,"_DA(1)_",1,"
 ... K DO,DD D FILE^DICN
 ... S DA=+Y
 ... I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 ... I PTYP="D" S MVAL=$$DATE^BQIUL1(MVAL)
 ... S IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" S BQIUPD(90505.81,IENS,.02)=MVAL
 ... D FILE^DIE("","BQIUPD","ERROR")
 ... K BQIUPD
 ;
DSC ; Update generated description
 S ALDA=0
 F  S ALDA=$O(^BQICARE(DUZ,7,ALDA)) Q:'ALDA  D
 . NEW DA,IENS
 . S DA(1)=DUZ,DA=ALDA,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.07,IENS,2)=$$MEN^BQIPLDSC(DUZ,ALDA)
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 ;
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
