BQITMPLE ;GDIT/HC/BEE-Template Handling ; 01 Jun 2007  11:51 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
DFLT(DATA,OWNR,LYIEN,TYPE,TMPNAM) ;EP -- BQI SET TEMPLATE DFLT
 ;
 ; Input
 ;   OWNR  - Whose template this is
 ;   LYIEN - Template internal entry number
 ;   TYPE  - The type of template
 ;  TMPNAM - The template name
 ;
 NEW UID,II,ERROR,HDR,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYDEF",UID))
 K @DATA
 ;
 ;Define Header
 S @DATA@(0)="T00001RESULT"_$C(30)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILYDEF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S:$G(OWNR)="" OWNR=DUZ
 S LYIEN=$G(LYIEN,"")
 S TYPE=$G(TYPE,"")
 ;
 I LYIEN="" S BMXSEC="Template IEN is blank." Q
 I TYPE="" D  I TYPE="" S BMXSEC="Template TYPE is blank." Q
 . N DA,IENS
 . S DA(1)=OWNR,DA=LYIEN,IENS=$$IENS^DILF(.DA)
 . S TYPE=$$GET1^DIQ(90505.015,IENS,".02","I")
 ;
 ;Loop through all templates for type and set/remove default
 S IEN=0 F  S IEN=$O(^BQICARE(OWNR,15,"C",TYPE,IEN)) Q:'IEN  D  Q:$D(ERROR)
 . ;
 . NEW DA,IENS,BQIUPD,CHG,DEF
 . S DA(1)=OWNR,DA=IEN,IENS=$$IENS^DILF(.DA)
 . ;
 . ;Get current default value
 . S DEF=$$GET1^DIQ(90505.015,IENS,".03","I")
 . ;
 . ;Set Change Flag
 . S CHG=0
 . ;
 . ;If this one is the passed in one
 . I IEN=LYIEN D
 .. I DEF="Y" Q  ;Already default - don't save
 .. S BQIUPD(90505.015,IENS,".03")="Y",CHG=1
 . ;
 . ;Look for other templates
 . I IEN'=LYIEN D
 .. I DEF="" Q  ;Already not the default - don't save
 .. S BQIUPD(90505.015,IENS,".03")="",CHG=1
 . ;
 . ;Set last edited
 . I CHG=1 S BQIUPD(90505.015,IENS,.04)=$$NOW^XLFDT()
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S II=II+1
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 E  S @DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TMUSE(DATA,OWNR,TIEN) ;EP -- BQI GET TEMPLATE USE
 ;
 ; Input
 ;   OWNR  - Whose template this is
 ;   TIEN - Template internal entry number
 ;
 NEW UID,II,ERROR,HDR,TNAME,PLIEN,DA,IENS,OWNIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYDEF",UID))
 K @DATA
 ;
 ;Define Header
 S @DATA@(0)="I00010PANEL_IEN^T00120PANEL_NAME^T00250PANEL_DESCRIPTION^I00010PANEL_OWNER"_$C(30)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILYDEF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S:$G(OWNR)="" OWNR=DUZ
 ;
 I TIEN="" S BMXSEC="Template IEN is blank." Q
 ;
 ;Get template name
 S DA(1)=OWNR,DA=TIEN,IENS=$$IENS^DILF(.DA)
 S TNAME=$$GET1^DIQ(90505.015,IENS,".01","E") I TNAME="" S BMXSEC="Template does not have a NAME assigned to it" Q
 ;
 ;Loop through all panels for user to see if template in use
 S PLIEN=0
 F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 . NEW PNAME,PDESC,DA,IENS,DIC,X,Y
 . ;
 . ;Quit if template isn't used in panel
 . S DIC="^BQICARE("_OWNR_",1,"_PLIEN_",4,",DIC(0)="X"
 . S X=TNAME D ^DIC I +Y=-1 Q
 . ;
 . S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 . S PNAME=$$GET1^DIQ(90505.01,IENS,.01,"E")
 . S PDESC=$$GET1^DIQ(90505.01,IENS,1,"E")
 . S II=$G(II)+1,@DATA@(II)=PLIEN_U_PNAME_U_PDESC_U_OWNR_$C(30)
 ;
 ;Loop through all panels shared to user and see if template is in use
 S OWNRIEN=""
 F  S OWNRIEN=$O(^BQICARE("C",OWNR,OWNRIEN)) Q:'OWNRIEN  D
 . S PLIEN=0 F  S PLIEN=$O(^BQICARE("C",OWNR,OWNRIEN,PLIEN)) Q:'PLIEN  D
 .. ;
 .. ;Quit if template isn't used in panel
 .. N DIC,X,Y
 .. S DIC="^BQICARE("_OWNRIEN_",1,"_PLIEN_",30,"_OWNR_",4,",DIC(0)="X"
 .. S X=TNAME D ^DIC I +Y=-1 Q
 .. ;
 .. S DA(1)=OWNRIEN,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. S PNAME=$$GET1^DIQ(90505.01,IENS,.01,"E")
 .. S PDESC=$$GET1^DIQ(90505.01,IENS,1,"E")
 .. S II=$G(II)+1,@DATA@(II)=PLIEN_U_PNAME_U_PDESC_U_OWNRIEN_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DELTMP(OWNR,TIEN,TNAME,ERROR) ;EP - Delete Template
 ;
 ;Input: TIEN - Template IEN
 ;Output: ERROR (if unsuccessful)
 ; 
 NEW DA,IENS,OWNRIEN,PLIEN
 ;
 ;Check for template IEN
 I TIEN="" S ERROR="Template IEN is null" Q
 ;
 S DA(1)=OWNR,DA=TIEN,IENS=$$IENS^DILF(.DA)
 ;
 ;Check for default template
 I $$GET1^DIQ(90505.015,IENS,".05","I")'="Y" S ERROR="Cannot delete default templates" Q
 ;
 ;Get Template name
 I TNAME="" D  Q:$G(ERROR)=1
 . S TNAME=$$GET1^DIQ(90505.015,IENS,".01","E") I TNAME="" S ERROR="Cannot find template name" Q
 ;
 ;Loop through all panels for user to see if template in use
 S PLIEN=0
 F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 . NEW DA,DIK
 . ;
 . ;Quit if template isn't used in panel
 . S DIC="^BQICARE("_OWNR_",1,"_PLIEN_",4,",DIC(0)="X"
 . S X=TNAME D ^DIC I +Y=-1 Q
 . ;
 . S DA=+Y Q:DA=0
 . S DA(2)=OWNR,DA(1)=PLIEN,IENS=$$IENS^DILF(.DA)
 . S DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",4,"
 . D ^DIK
 ;
 ;Loop through all panels shared to user and see if template is in use
 S OWNRIEN=""
 F  S OWNRIEN=$O(^BQICARE("C",OWNR,OWNRIEN)) Q:'OWNRIEN  D
 . S PLIEN=0 F  S PLIEN=$O(^BQICARE("C",OWNR,OWNRIEN,PLIEN)) Q:'PLIEN  D
 .. N DA,IENS,DIK
 .. ;
 .. ;Quit if template isn't used in panel
 .. N DIC,X,Y
 .. S DIC="^BQICARE("_OWNRIEN_",1,"_PLIEN_",30,"_OWNR_",4,",DIC(0)="X"
 .. S X=TNAME D ^DIC I +Y=-1 Q
 .. ;
 .. S DA=+Y Q:DA=0
 .. S DA(3)=OWNRIEN,DA(2)=PLIEN,DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 .. S DIK="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",4,"
 .. D ^DIK
 ;
 ;Delete the template
 S DA(1)=OWNR,DA=TIEN
 S DIK="^BQICARE("_DA(1)_",15,"
 D ^DIK
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
