BSTSUPRF ;GDIT/HS/BEE - SNOMED User Preferences - RPC Calls ; 10 Aug 2012  9:24 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
SET(DATA,NMID,INPUT) ;EP - BSTS SET USER PREFS
 ;
 ;Description
 ;  Saves search preference for a user
 ;  
 ;Input
 ; INPUT - NMID - Namespace ID - Default to SNOMED US EXT (#36)
 ;           FS - Default Search Type (F-FSN/S-Synonym), default it F
 ;          CNT - Number of records to return (25, 50, 100, 200, ALL), default is 50
 ;           PC - Display Parent Child Info (1-Yes/0-No) - default is No
 ;           AC - Disable Autocomplete
 ;
 ;Output
 ;  ^TMP("BSTSUPRF") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 NEW UID,II,DLAYGO,X,Y,DIC,DA,NMIEN,BSTSUP,IENS,ERROR,NMID,FS,CNT,PC,AC
 ;
 ;Address blank inputs
 S INPUT=$G(INPUT)
 S NMID=$G(NMID) S:NMID="" NMID=36
 S FS=$P(INPUT,"|")
 S CNT=$P(INPUT,"|",2)
 S PC=$P(INPUT,"|",3)
 S AC=$P(INPUT,"|",4)
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSUPRF",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSUPRF D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S II=0
 S @DATA@(0)="T00001RESULT^T00100ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I '$D(^BSTS(9002318.1,"B",NMID)) S II=II+1,@DATA@(II)="-1^Invalid Namespace ID"_$C(30) G XSET
 I CNT'="",CNT'=25,CNT'=50,CNT'=100,CNT'=200,CNT'="ALL" S II=II+1,@DATA@(II)="-1^Invalid Record Count Value"_$C(30) G XSET
 I PC'="",PC'=1,PC'=0 S II=II+1,@DATA@(II)="-1^Invalid Display Parents/Children Value"_$C(30) G XSET
 I FS'="",FS'="F",FS'="S" S II=II+1,@DATA@(II)="-1^Invalid Search Type"_$C(30) G XSET
 I AC'="",AC'=1,AC'=0 S II=II+1,@DATA@(II)="-1^Invalid Disable Auto-complete Value"_$C(30) G XSET
 ;
 ;Process resets
 I CNT="",PC="",FS="",AC="" D  G XSET
 . NEW RES
 . S RES=$$RESET(NMID)
 . S II=II+1,@DATA@(II)=RES_$C(30)
 ;
 ;Plug in details
 S:FS="" FS="F"
 S:CNT="" CNT=50
 S:PC="" PC=0
 S:AC="" AC=0
 ;
 ;Check for existing user entry
 I '$D(^BSTS(9002318.7,"B",DUZ)) D
 . S DLAYGO=9002318.7,DIC(0)="LX",DIC="^BSTS(9002318.7,",X=DUZ
 . K DO,DD D FILE^DICN
 S DA(1)=$O(^BSTS(9002318.7,"B",DUZ,"")) I DA(1)="" S II=II+1,@DATA@(II)="-1^Could not file new user entry"_$C(30) G XSET
 ;
 ;Check for namespace entry
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) I NMIEN="" S II=II+1,@DATA@(II)="-1^Invalid Namespace ID"_$C(30) G XSET
 I '$D(^BSTS(9002318.7,DA(1),1,"B",NMIEN)) D
 . S DLAYGO=9002318.71,DIC(0)="LX",DIC="^BSTS(9002318.7,"_DA(1)_",1,",X=NMIEN
 . K DO,DD D FILE^DICN
 S DA=$O(^BSTS(9002318.7,DA(1),1,"B",NMIEN,"")) I DA="" S II=II+1,@DATA@(II)="-1^Could not add namespace multiple"_$C(30) G XSET
 S IENS=$$IENS^DILF(.DA)
 ;
 S BSTSUP(9002318.71,IENS,.02)=FS
 S BSTSUP(9002318.71,IENS,.03)=CNT
 S BSTSUP(9002318.71,IENS,.04)=PC
 S BSTSUP(9002318.71,IENS,.05)=AC
 D FILE^DIE("","BSTSUP","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Could not file entry"_$C(30) G XSET
 ;
 ;Log success
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XSET S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
GET(DATA,NMID) ;EP - BSTS GET USER PREFS
 ;
 ;Description
 ;  Retrieves search preference for a user
 ;  
 ;Input
 ; INPUT - NMID - Namespace ID - Default to SNOMED US EXT (#36)
 ;
 ;Output
 ;  ^TMP("BSTSUPRF") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 ;Address blank inputs
 S NMID=$G(NMID) S:NMID="" NMID=36
 ;
 N UID,II,DA,NMIEN,IENS,NIEN,PC,CNT,FS,DIEN,AC
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSUPRF",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSUPRF D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S II=0
 S @DATA@(0)="T00100SETTINGS"_$C(30)
 ;
 ;Check for existing user entry
 S DIEN=$O(^BSTS(9002318.7,"B",DUZ,"")) I DIEN="" S II=II+1,@DATA@(II)="|||"_$C(30) G XGET
 ;
 ;Check for namespace entry
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) I NMIEN="" S II=II+1,@DATA@(II)="|||"_$C(30) G XGET
 S NIEN=$O(^BSTS(9002318.7,DIEN,1,"B",NMIEN,"")) I NIEN="" S II=II+1,@DATA@(II)="|||"_$C(30) G XGET
 ;
 ;Retrieve entry
 S DA(1)=DIEN,DA=NIEN
 S IENS=$$IENS^DILF(.DA)
 S FS=$$GET1^DIQ(9002318.71,IENS,.02,"I")
 S CNT=$$GET1^DIQ(9002318.71,IENS,.03,"I")
 S PC=$$GET1^DIQ(9002318.71,IENS,.04,"I")
 S AC=$$GET1^DIQ(9002318.71,IENS,.05,"I")
 S II=II+1,@DATA@(II)=FS_"|"_CNT_"|"_PC_"|"_AC_$C(30)
 ;
XGET S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
RESET(NMID) ;Reset user settings
 ;
 ;Description
 ;  Resets search preference for a user
 ;  
 ;Input
 ; INPUT - NMID - Namespace ID - Default to SNOMED US EXT (#36)
 ;
 ;Output
 ;  ^TMP("BSTSUPRF") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 ;Address blank inputs
 S NMID=$G(NMID) S:NMID="" NMID=36
 ;
 N UID,II,DA,NMIEN,DIEN,DIK,CIEN
 ;
 ;Input validation
 I '$D(^BSTS(9002318.1,"B",NMID)) Q "-1^Invalid Namespace ID"
 ;
 ;Check for existing user entry
 S DIEN=$O(^BSTS(9002318.7,"B",DUZ,"")) I DIEN="" Q "1^"
 ;
 ;Check for namespace entry
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) I NMIEN="" Q "-1^Invalid Namespace ID"
 S CIEN=$O(^BSTS(9002318.7,DIEN,1,"B",NMIEN,"")) I CIEN="" Q "1^"
 ;
 ;Remove entry
 S DIK="^BSTS(9002318.7,"_DIEN_",1,",DA(1)=DIEN,DA=CIEN
 D ^DIK
 ;
 Q "1^"
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
