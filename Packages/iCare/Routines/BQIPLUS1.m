BQIPLUS1 ;GDIT/HS/ALA-User Preferences continued ; 26 Apr 2013  11:11 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
UGVMCH(DATA,FAKE) ;EP -- BQI GET USER VERSION
 ;
 ;Description
 ;  Determine if user iCare version does not match iCare server version
 ;  
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  Returns user GUI version, server version, and whether versions match (1-Match/0-Do Not Match)
 ;          
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,BQIDA,MVRSN,UVRSN,SVRSN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 I '$$OWNR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 S @DATA@(II)="T00001MATCHING_VERSION^T00020USER_VERSION^T00020SERVER_VERSION"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BQIDA=$$SPM^BQIGPUTL()
 ;
 S UVRSN=$$GET1^DIQ(90505,DUZ_",",.17,"E")
 S SVRSN=$$GET1^DIQ(90508,BQIDA_",",.08,"E")
 S MVRSN=0 I UVRSN=SVRSN S MVRSN=1
 ;
 S II=II+1,@DATA@(II)=MVRSN_U_UVRSN_U_SVRSN_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
USVMCH(DATA,FAKE) ;EP -- BQI SET USER VERSION
 ;
 ;Description
 ;  Set the user's iCare GUI version to match the iCare server GUI version
 ;  
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  Returns 1-Successful save/-1 - Unsuccessful save
 ;          
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,BQIDA,SVRSN,BQIUPD,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 I '$$OWNR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BQIDA=$$SPM^BQIGPUTL()
 S SVRSN=$$GET1^DIQ(90508,BQIDA_",",.08,"E")
 ;
 S BQIUPD(90505,DUZ_",",.17)=SVRSN
 ;
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 S II=II+1
 I '$D(ERROR) S @DATA@(II)="1"_$C(30)
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
OWNR(USR) ;EP -- Check owner
 ;
 ;Description
 ;  Check if this user who has signed into iCare is already
 ;  in ICARE USER File #90505
 ;Input
 ;  DUZ - User internal entry number signed into iCare
 ;Output
 ;   1 - if user exists or if user added okay
 ;   0 - if there was an error adding user
 ;
 I $G(^BQICARE(USR,0))'="" Q 1
 I $D(^BQICARE(USR)),$G(^BQICARE(USR,0))="" D  Q 1
 . NEW DIE,DA,DR
 . S DIE="^BQICARE(",DA=USR,DR=".01///^S X=USR" D ^DIE
 ;
CR ;  Create new entry
 NEW IENARRY,BQIUSR,ERROR
 S IENARRY(1)=USR
 S BQIUSR(90505,"+1,",.01)=USR
 D UPDATE^DIE("","BQIUSR","IENARRY","ERROR")
 I $D(ERROR) Q 0
 Q 1
