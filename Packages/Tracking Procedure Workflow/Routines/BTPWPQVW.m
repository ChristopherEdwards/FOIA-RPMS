BTPWPQVW ;VNGT/HS/ALA-CMET Queue User View ; 16 Jun 2009  4:49 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
RET(DATA,FAKE) ; EP -- BTPW GET CMET PREFS
 ;Description
 ;  Retrieve the queue preferences for an owner
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
 S DATA=$NA(^TMP("BTPWPQVW",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPQVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00001TYPE^T03200PARMS"_$C(30)
 ;
 S MIEN=0,PARMS=""
 ; if no defined user preference, set the default values
 F TYPE="Q" D
 . S MIEN=$O(^BQICARE(DUZ,9,"B",TYPE,""))
 . I MIEN="" D
 .. S PARMS="STATUS=P"_$C(28)_"TMFRAME=T-3M"
 .. S PARMS=$$DCAT(PARMS)  ;Add CAT values, if needed
 .. S II=II+1,@DATA@(II)=TYPE_"^"_PARMS_$C(30)
 . I MIEN'="" D GET(TYPE,MIEN)
 ;
 S MIEN=0,PARMS=""
 F TYPE="T" D
 . S MIEN=$O(^BQICARE(DUZ,9,"B",TYPE,""))
 . I MIEN="" D
 .. S PARMS="STATE=O"_$C(28)_"TMFRAME=T-12M"
 .. S PARMS=$$DCAT(PARMS)  ;Add CAT values, if needed
 .. S II=II+1,@DATA@(II)=TYPE_"^"_PARMS_$C(30)
 . I MIEN'="" D GET(TYPE,MIEN)
 ;
 S MIEN=0,PARMS=""
 F TYPE="P" D
 . S MIEN=$O(^BQICARE(DUZ,9,"B",TYPE,""))
 . I MIEN="" D
 .. ;S PARMS="STATE=F"_$C(28)_"TMFRAME=T-12M"
 .. S PARMS="TMFRAME=T+6M"
 .. S PARMS=$$DCAT(PARMS)  ;Add CAT values, if needed
 .. S II=II+1,@DATA@(II)=TYPE_"^"_PARMS_$C(30)
 . I MIEN'="" D GET(TYPE,MIEN)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
GET(TYPE,MIEN) ;EP
 S PIEN=0
 F  S PIEN=$O(^BQICARE(DUZ,9,MIEN,1,PIEN)) Q:'PIEN  D
 . NEW DA,IENS
 . S DA(2)=DUZ,DA(1)=MIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.161,IENS,.01,"E")
 . S VALUE=$$GET1^DIQ(90505.161,IENS,.03,"E")
 . I VALUE="" S VALUE=$$GET1^DIQ(90505.161,IENS,.02,"E")
 . S PARMS=PARMS_$S(PARMS]"":$C(28),1:"")_NAME_"="
 . I VALUE'="" S PARMS=PARMS_VALUE Q
 . ;
 . ; Check for multiple values
 . N VALSTR S VALSTR=""
 . S PMIEN=0
 . F  S PMIEN=$O(^BQICARE(DUZ,9,MIEN,1,PIEN,1,PMIEN)) Q:'PMIEN  D
 .. NEW DA,IENS
 .. S DA(3)=DUZ,DA(2)=MIEN,DA(1)=PIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 .. S VALUE=$$GET1^DIQ(90505.1611,IENS,.02,"E")
 .. I VALUE="" S VALUE=$$GET1^DIQ(90505.1611,IENS,.01,"E")
 .. S VALSTR=VALSTR_$S(VALSTR]"":$C(29),1:"")_VALUE
 . ;
 . ; Tack on Multiple Values
 . S PARMS=PARMS_VALSTR
 . K VALSTR
 . ;
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
UPD(DATA,TYPE,PARMS) ;  EP - BTPW SET CMET PREFS
 ;
 ;Input
 ;  TYPE  - 'P' for Planned preferences, 'Q' for Queued preferences and 'T' for Tracked preferences
 ;  PARMS - Parameters
 ;Assumes
 ;  DUZ - User who signed onto iCare
 ;
 NEW UID,II,X,MIEN,PIEN,PMIEN,VALUE,PDATA,ALDA,QFL,BQ,NAME,MVAL,BQII,PPIEN,TYPN,TEMP,LDTM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPQVW",UID)),TEMP=$NA(^TMP("TEMP",UID))
 K @DATA,@TEMP
 ;
 S II=0,TYPE=$G(TYPE,"")
 ;
 I TYPE="" S BMXSEC="RPC Failed: No Type of Preferences passed in" Q
 I $D(PARMS)>10 D
 . NEW LIST,BN,BBN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  D
 .. I BN=1,PARMS(BN)["COMM=" D
 ... S @TEMP@(BN)="COMM="_$P(PARMS(BN),"COMM=",2)
 ... S BBN=BN F  S BBN=$O(PARMS(BBN)) Q:BBN=""  S @TEMP@(BBN)=PARMS(BBN) K PARMS(BBN)
 ... S PARMS(BN)=$P(PARMS(BN),"COMM=",1)
 .. S LIST=LIST_PARMS(BN)
 . K PARMS S PARMS=LIST
 ;
 ;I PARMS="" S BMXSEC="RPC Failed: No parameters passed in" Q
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPQVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S TYPN=$O(^BQICARE(DUZ,9,"B",TYPE,""))
 ;  Clean out all the previous parameters
 I TYPN'="" D DEL
 I TYPN="" D
 . NEW DA,DIC
 . S DA(1)=DUZ,X=$S(TYPE="P":"Followup Events",TYPE="T":"Tracked Events",1:"Events"),DIC(0)="LNZ",DLAYGO=90505.16
 . I $G(^BQICARE(DUZ,9,0))="" S ^BQICARE(DUZ,9,0)="^90505.16S^^"
 . S DIC="^BQICARE("_DA(1)_",9,"
 . D ^DIC S TYPN=+Y I TYPN=-1 K DO,DD D FILE^DICN S TYPN=+Y
 ;
 S QFL=0
 F BQ=1:1:$L(PARMS,$C(28)) D  G DONE:QFL
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . D NPM(TYPN,NAME,.PDA) I QFL Q
 . ;
 . NEW DA,IENS
 . S DA(2)=DUZ,DA(1)=TYPN,DA=PDA
 . S IENS=$$IENS^DILF(.DA)
 . I VALUE'[$C(29) D NRC(IENS,VALUE) Q
 . ;
 . I VALUE[$C(29) D  Q:QFL
 .. I '$D(^BQICARE(DA(2),9,DA(1),1,PDA,1,0)) S ^BQICARE(DA(2),9,DA(1),1,PDA,1,0)="^90505.1611^^"
 .. F BQII=1:1:$L(VALUE,$C(29)) D
 ... S MVAL=$P(VALUE,$C(29),BQII)
 ... D NML(TYPN,PDA,MVAL)
 ;
 ; Check for community list
 I $D(@TEMP)>0 D  Q:QFL
 . D NPM(TYPN,"COMM",.PDA) I QFL Q
 . S DA(2)=DUZ,DA(1)=TYPN,DA=PDA
 . I '$D(^BQICARE(DA(2),9,DA(1),1,PDA,1,0)) S ^BQICARE(DA(2),9,DA(1),1,PDA,1,0)="^90505.1611^^"
 . NEW BN,LINE,NBN,LSTI,BQII
 . S BN="",LINE=""
 . F  S BN=$O(@TEMP@(BN)) Q:BN=""  D
 .. S NBN=$O(@TEMP@(BN))
 .. S LINE=LINE_@TEMP@(BN) I NBN'="" S LINE=LINE_@TEMP@(NBN)
 .. I LINE["COMM=" S LINE=$P(LINE,"COMM=",2)
 .. S LSTI=$L(LINE,$C(29))-10
 .. F BQII=1:1:LSTI S MVAL=$P(LINE,$C(29),BQII) D NML(TYPN,PDA,MVAL)
 .. S LINE=$P(LINE,$C(29),LSTI+1,$L(LINE,$C(29)))
 .. I NBN'="" S BN=NBN
 . F BQII=1:1 S MVAL=$P(LINE,$C(29),BQII) Q:MVAL=""  D NML(TYPN,PDA,MVAL)
 ;
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K @TEMP
 Q
 ;
DELA(DATA) ;  Delete all CMET User definitions
 NEW UID,II,DA,DIK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPQVW",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPQVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 S DA(1)=DUZ,DA=0,DIK="^BQICARE("_DA(1)_",9,"
 F  S DA=$O(^BQICARE(DUZ,9,DA)) Q:'DA  D ^DIK
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL ;  Delete the previous User preferences for the Type
 NEW DA,DIK
 S DA(2)=DUZ,DA(1)=TYPN,DA=0,DIK="^BQICARE("_DA(2)_",9,"_DA(1)_",1,"
 F  S DA=$O(^BQICARE(DUZ,9,TYPN,1,DA)) Q:'DA  D ^DIK
 ;F  S DA=$O(^BQICARE(DUZ,9,DA)) Q:'DA  D ^DIK
 Q
 ;
NPM(TYPN,NAME,PDA) ;EP - Add new parameter
 NEW DA,IENS,DIC,DLAYGO
 S DA(2)=DUZ,DA(1)=TYPN,X=NAME,DIC="^BQICARE("_DA(2)_",9,"_DA(1)_",1,"
 I '$D(^BQICARE(DA(2),9,DA(1),1,0)) S ^BQICARE(DA(2),9,DA(1),1,0)="^90505.161^^"
 S DLAYGO=90505.161,DIC(0)="L",DIC("P")=DLAYGO
 K DO,DD D FILE^DICN
 S (DA,PDA)=+Y
 I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 Q
 ;
NRC(IENS,VALUE) ;EP - New record
 I VALUE?.N S BQIUPD(90505.161,IENS,.03)=VALUE
 I VALUE'?.N S BQIUPD(90505.161,IENS,.02)=VALUE
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
NML(TYPN,PDA,MVAL) ; EP - New multiple record
 NEW DA,IENS
 S DA(3)=DUZ,DA(2)=TYPN,DA(1)=PDA,X=MVAL
 S DLAYGO=90505.1611,DIC(0)="L",DIC("P")=DLAYGO
 S DIC="^BQICARE("_DA(3)_",9,"_DA(2)_",1,"_DA(1)_",1,"
 K DO,DD D FILE^DICN
 S DA=+Y
 I DA=-1 S II=II+1,@DATA@(II)="-1"_$C(30),QFL=1 Q
 S IENS=$$IENS^DILF(.DA)
 I MVAL?.N S BQIUPD(90505.1611,IENS,.02)=MVAL
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
DCAT(PARM) ; Add all categories if not present in return parameters
 ;
 N IEN,VALUE
 I PARM["CAT=" G XDCAT
 ;
 S VALUE="",IEN=0 F  S IEN=$O(^BTPW(90621.2,IEN)) Q:'IEN  D
 . N INACTIVE
 . S INACTIVE=$$GET1^DIQ(90621.2,IEN_",",.03,"I") Q:INACTIVE=1
 . S VALUE=VALUE_$S(VALUE="":"",1:$C(29))_IEN
 S PARM=PARM_$S(PARM="":"",1:$C(28))_"CAT="_VALUE
 ;
XDCAT Q PARM
