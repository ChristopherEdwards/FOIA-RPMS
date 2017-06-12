BQIUSPRF ;GDHD/HS/ALA-User GUI Preferences ; 26 Sep 2007  1:53 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 Q
 ;
GTAB(DATA,FAKE) ;EP - BQI GET USER GUI TABS
 ;
 ;Description
 ;  Get the user's preferences
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 NEW UID,II,IEN,TEXT,BN,TYP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIGTAB",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUSPRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010IEN^T00001STATUS^T00010TYPE"_$C(30)
 I $O(^BQICARE(DUZ,13,0))="" D DEF G DONE
 S BN=0
 F  S BN=$O(^BQICARE(DUZ,13,BN)) Q:'BN  D
 . S IEN=$P(^BQICARE(DUZ,13,BN,0),U,1)
 . ;S TEXT=$P(^BQI(90506.4,IEN,0),U,1),STAT=$P(^(0),U,2)
 . S STAT=$P(^BQICARE(DUZ,13,BN,0),U,2)
 . S TYP=$$GET1^DIQ(90506.4,IEN_",",.03,"E")
 . S II=II+1,@DATA@(II)=IEN_U_STAT_U_TYP_$C(30)
 ;
 ;Check for new tabs
 S IEN=0 F  S IEN=$O(^BQI(90506.4,IEN)) Q:'IEN  D
 . I '$D(^BQICARE(DUZ,13,"B",IEN)) D
 .. S TYP=$$GET1^DIQ(90506.4,IEN_",",.03,"E")
 .. S II=II+1,@DATA@(II)=IEN_U_"S"_U_TYP_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEF ;
 S IEN=0
 F  S IEN=$O(^BQI(90506.4,IEN)) Q:'IEN  D
 . S TEXT=$P(^BQI(90506.4,IEN,0),U,1),DEF=""
 . ;I TEXT="Cover Sheet"!(TEXT="Patient List") S DEF="D"
 . S TYP=$$GET1^DIQ(90506.4,IEN_",",.03,"E")
 . S II=II+1,@DATA@(II)=IEN_U_"S"_U_TYP_$C(30)
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
UTAB(DATA,TYP,TABS) ;EP - BQI SET USER GUI TABS
 ; Input
 ;   Assumes DUZ
 ;   TABS - list of tab IENs separated by $C(29)
 NEW UID,II,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIUTAB",UID))
 K @DATA
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUSPRF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S ^ALTST($$NOW^XLFDT())=$G(TABS)
 ; Clean up previous list of GUI tabs
 NEW DA,DIK,TBS
 S DA(1)=DUZ,DIK="^BQICARE("_DA(1)_",13,",DA=""
 F  S DA=$O(^BQICARE(DUZ,13,"AC",TYP,DA)) Q:'DA  D ^DIK
 ;
 F BI=1:1:$L(TABS,$C(29)) S TBS=$P(TABS,$C(29),BI) Q:TBS=""  D
 . NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 . ;Get IEN and Status
 . S TIEN=$P(TBS,$C(28),1),STAT=$P(TBS,$C(28),2)
 . S DA(1)=DUZ
 . S DIC="^BQICARE("_DA(1)_",13,",DIE=DIC
 . S DLAYGO=90505.013,DIC(0)="L",DIC("P")=DLAYGO
 . S X=TIEN
 . I '$D(^BQICARE(DA(1),13,0)) S ^BQICARE(DA(1),13,0)="^90505.013P^^"
 . ;K DO,DD D ^DIC
 . D ^DIC i Y=-1 K DO,DD D FILE^DICN
 . I +Y<1 S RESULT=-1 Q
 . S DA=+Y,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.013,IENS,.02)=STAT,BQIUPD(90505.013,IENS,.03)=TYP
 . S RESULT=1
 ;
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR") I $D(ERROR) S RESULT=-1
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
