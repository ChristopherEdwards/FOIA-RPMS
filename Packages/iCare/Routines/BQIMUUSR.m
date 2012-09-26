BQIMUUSR ;VNGT/HS/BEE-MU User Prefs ; 10 Aug 2011  10:52 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
RET(DATA,TYPE) ; EP -- BQI GET MU PREFS
 ;Description
 ;  Retrieve the MU Preferences for an owner
 ;  
 ;Input
 ;  TYPE - PCQ - Providers CQ)
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,PARMS,TYP,MIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUUSR",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMUUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00001TYPE^T03200PARMS"_$C(30)
 ;
 S TYPE=$G(TYPE,"")
 ;
 ;Return Provider CQ Detail
 ;
 S MIEN=0,PARMS=""
 I TYPE=""!(TYPE="PCQ") D
 . S TYP="PCQ"
 . S MIEN=$O(^BQICARE(DUZ,12,"B",TYP,""))
 . ;
 . ;No preferences on file - use default
 . I MIEN="" D  Q
 .. S PARMS=$$DCAT(PARMS)
 .. S II=II+1,@DATA@(II)=TYP_"^"_PARMS_$C(30)
 . ;
 . ;Preferences defined - pull values
 . I MIEN'="" D GET(TYP,MIEN)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
GET(TYPE,MIEN) ;EP - Pull the individual definition
 ;
 NEW PIEN,PARMS
 S PIEN=0,PARMS=""
 F  S PIEN=$O(^BQICARE(DUZ,12,MIEN,1,PIEN)) Q:'PIEN  D
 . NEW DA,IENS,NAME,VALUE
 . S DA(2)=DUZ,DA(1)=MIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.022,IENS,.01,"E")
 . ;
 . ;Try pulling an individual value first
 . S VALUE=$$GET1^DIQ(90505.022,IENS,.03,"E")
 . I VALUE="" S VALUE=$$GET1^DIQ(90505.022,IENS,.02,"E")
 . S PARMS=PARMS_$S(PARMS]"":$C(28),1:"")_NAME_"="
 . I VALUE'="" S PARMS=PARMS_VALUE Q
 . ;
 . ;If no individual definition, check for multiple values
 . NEW PMIEN,VALSTR
 . S PMIEN=0,VALSTR=""
 . F  S PMIEN=$O(^BQICARE(DUZ,12,MIEN,1,PIEN,1,PMIEN)) Q:'PMIEN  D
 .. NEW DA,IENS
 .. S DA(3)=DUZ,DA(2)=MIEN,DA(1)=PIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 .. S VALUE=$$GET1^DIQ(90505.221,IENS,.02,"E")
 .. I VALUE="" S VALUE=$$GET1^DIQ(90505.221,IENS,.01,"E")
 .. S VALSTR=VALSTR_$S(VALSTR]"":$C(29),1:"")_VALUE
 . ;
 . ; Tack on Multiple Values
 . S PARMS=PARMS_VALSTR
 . K VALSTR
 ;
 S PARMS=$$DCAT(PARMS)  ;Add CAT values, if needed
 ;
 S II=II+1,@DATA@(II)=TYPE_"^"_PARMS_$C(30)
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
UPD(DATA,TYPE,PARMS) ;  EP -- BQI SET MU PREFS
 ;
 ;Input
 ;  TYPE    - PCQ - Providers CQ
 ;  PARMS   - Parameters
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,TYPN,QFL,BQ,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUUSR",UID))
 K @DATA
 ;
 S II=0,TYPE=$G(TYPE,"")
 ;
 I TYPE="" S BMXSEC="RPC Failed: No Type of Preferences passed in" Q
 ;
 I $D(PARMS)>10 D
 . NEW LIST,BN,QFL,BQ
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  D
 .. S LIST=LIST_PARMS(BN)
 . K PARMS S PARMS=LIST
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMUUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S TYPN=$O(^BQICARE(DUZ,12,"B",TYPE,""))
 ;
 ;Clean out all the previous parameters
 I TYPN'="" D DEL(TYPN)
 ;
 ;If no previous, add new entry
 I TYPN="" D
 . NEW DA,DIC,DLAYGO,X,Y
 . S DA(1)=DUZ,X=$S(TYPE="PCQ":"Providers CQ",1:"Providers CQ"),DIC(0)="LNZ",DLAYGO=90505.012
 . I $G(^BQICARE(DUZ,12,0))="" S ^BQICARE(DUZ,12,0)="^90505.012S^^"
 . S DIC="^BQICARE("_DA(1)_",12,"
 . D ^DIC S TYPN=+Y I TYPN=-1 K DO,DD D FILE^DICN S TYPN=+Y
 ;
 S QFL=0
 F BQ=1:1:$L(PARMS,$C(28)) D  G DONE:QFL
 . ;
 . N PDATA,NAME,VALUE,PDA,DA,IENS
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . D NPM(TYPN,NAME,.PDA) I QFL Q
 . ;
 . S DA(2)=DUZ,DA(1)=TYPN,DA=PDA
 . S IENS=$$IENS^DILF(.DA)
 . ;
 . ;Single value
 . I VALUE'[$C(29) D NRC(IENS,VALUE,.ERROR) Q
 . ;
 . ;Multiple values
 . I VALUE[$C(29) D  Q:QFL
 .. N BQII,MVAL
 .. I '$D(^BQICARE(DA(2),12,DA(1),1,PDA,1,0)) S ^BQICARE(DA(2),12,DA(1),1,PDA,1,0)="^90505.221^^"
 .. F BQII=1:1:$L(VALUE,$C(29)) D
 ... S MVAL=$P(VALUE,$C(29),BQII)
 ... D NML(TYPN,PDA,MVAL,.ERROR)
 ;
 S II=II+1
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 E  S @DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL(TYPN) ; EP - Delete the previous User preferences for the Type
 ;
 NEW DA,DIK
 S DA(2)=DUZ,DA(1)=TYPN,DA=0,DIK="^BQICARE("_DA(2)_",12,"_DA(1)_",1,"
 F  S DA=$O(^BQICARE(DUZ,12,TYPN,1,DA)) Q:'DA  D ^DIK
 ;
 Q
 ;
NPM(TYPN,NAME,PDA) ;EP - Add new parameter
 NEW DA,IENS,DIC,DLAYGO,X,DLAYGO
 S DA(2)=DUZ,DA(1)=TYPN,X=NAME,DIC="^BQICARE("_DA(2)_",12,"_DA(1)_",1,"
 I '$D(^BQICARE(DA(2),12,DA(1),1,0)) S ^BQICARE(DA(2),12,DA(1),1,0)="^90505.022^^"
 S DLAYGO=90505.022,DIC(0)="L",DIC("P")=DLAYGO
 K DO,DD D FILE^DICN
 S (DA,PDA)=+Y
 I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1
 Q
 ;
NRC(IENS,VALUE,ERROR) ;EP - New single record
 N BQIUPD
 I VALUE?.N S BQIUPD(90505.022,IENS,.03)=VALUE
 I VALUE'?.N S BQIUPD(90505.022,IENS,.02)=VALUE
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
NML(TYPN,PDA,MVAL,ERROR) ; EP - New multiple record
 NEW DA,IENS,DLAYGO,DIC,Y,IENS,BQIUPD,ERROR
 S DA(3)=DUZ,DA(2)=TYPN,DA(1)=PDA,X=MVAL
 S DLAYGO=90505.221,DIC(0)="L",DIC("P")=DLAYGO
 S DIC="^BQICARE("_DA(3)_",12,"_DA(2)_",1,"_DA(1)_",1,"
 K DO,DD D FILE^DICN
 S DA=+Y
 I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 S IENS=$$IENS^DILF(.DA)
 I MVAL?.N S BQIUPD(90505.221,IENS,.02)=MVAL
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
DCAT(PARMS) ; Set up default return list
 ;
 N IEN,VALUE
 ;
 S PARMS=$G(PARMS,"")
 I PARMS]"" G XDCAT
 ;
 S PARMS="PREV=Y"_$C(28)_"MENUSET=Y"_$C(28)_"CORE=Y"_$C(28)_"ALT=N"
 S PARMS=PARMS_$C(28)_"MSM=N"_$C(28)_"MEASURE=N"
 ;
XDCAT Q PARMS
