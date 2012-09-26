BQILYDEF ;PRXM/HC/ALA-Layout Template Defaults ; 01 Jun 2007  11:51 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
RET(DATA,TMIEN) ;EP -- BQI GET LAYOUTS
 ;
 ; Input
 ;   TMIEN = Template internal entry number, if null gets all
 ;           defaults for a user
 ;   Assumes DUZ of user
 ; 
 NEW UID,II,BN,CODE,BQARY,DIEN,DISPLAY,IEN,SORT,TYP,TMIEN,DEF,TEMPL,DTYP
 NEW DOR,SOR,SDIR,LEDT,TDEF,DDEF
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYGET",UID))
 K @DATA
 ;
 S TMIEN=$G(TMIEN,"")
 I TMIEN'?.N S TMIEN=$$TPN^BQILYUTL(DUZ,TMIEN)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILYDEF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010TEMPL_IEN^T00040TEMPLATE_NAME^T00001DEFAULT^T00001TYPE^T00120DISPLAY_ORDER"
 S @DATA@(II)=@DATA@(II)_"^T00120SORT_ORDER^T00120SORT_DIRECTION^D00030LAST_EDITED^T00001CAN_DELETE"_$C(30)
 ;
 ; Make sure user has all templates defined - If not, set up
 S DIEN=0
 F  S DIEN=$O(^BQICARE(DUZ,15,DIEN)) Q:'DIEN  D
 . N DA,IENS,TYP,DEF
 . ;
 . ;Track whether each type has a default template set up (and if each type has one designated as the default)
 . S DA(1)=DUZ,DA=DIEN,IENS=$$IENS^DILF(.DA)
 . S TYP=$$GET1^DIQ(90505.015,IENS,.02,"I") Q:TYP=""
 . I $$GET1^DIQ(90505.015,IENS,.05,"I")'="Y" S TDEF(TYP)=""
 . I $$GET1^DIQ(90505.015,IENS,.03,"I")="Y" S DDEF(TYP)=""
 F TYP="D","G","R","A","H","Q","T","N" D
 . I '$D(TDEF(TYP)) D DTMPSET^BQITMPLS(TYP) ;Create default template if missing
 . I '$D(DDEF(TYP)) D DTMPDEF^BQITMPLS(TYP) ;Set to default if needed
 ;
 ; Make sure templates are now defined
 S DIEN=$O(^BQICARE(DUZ,15,0))
 ;
 ; If the template IEN is not null, get the specific information about that template
 I TMIEN'="" D
 . S TYP=$P(^BQICARE(DUZ,15,TMIEN,0),U,2)
 . D STND(TYP) Q
 . D DEF(TMIEN,1)
 ;
 I TMIEN="" D
 . N STDLST,DEFLST
 . ; Get the standard default displays for all types if there are no default
 . ; templates defined
 . I DIEN="" D  Q
 .. F TYP="D","G","R","A","H","Q","T","N" D STND(TYP)
 . ;
 . ; Otherwise, get the displays for any defined default template
 . S DIEN=0
 . F  S DIEN=$O(^BQICARE(DUZ,15,DIEN)) Q:'DIEN  D
 .. N DA,IENS,TYP,DEF
 .. ;
 .. ;Track whether each type has a default template set up
 .. S DA(1)=DUZ,DA=DIEN,IENS=$$IENS^DILF(.DA)
 .. S TYP=$$GET1^DIQ(90505.015,IENS,.02,"I") Q:TYP=""
 .. S ISDEL=$$GET1^DIQ(90505.015,IENS,.05,"I") ;If deletable, not a standard template
 .. I ISDEL="" S STDLST(TYP,DIEN)="" Q
 .. ;
 .. ;Look for non-standard defaults
 .. S DEF=$$GET1^DIQ(90505.015,IENS,.03,"I")
 .. S:DEF="Y" DEFLST(TYP)=""
 .. ;
 .. ;Set up the added entries
 .. D DEF(DIEN,1)
 . ;
 . ;Now set up the standard entries (which may not be defined)
 . ;If no default set yet, set this one as the default
 . F TYP="D","G","R","A","H","Q","T","N" D
 .. ;
 .. ;IF STANDARD NOT DEFINED - CREATE IT
 .. ;
 .. I '$D(STDLST(TYP)) D  Q
 ... ;
 ... ;Already have a default template for type
 ... I $D(DEFLST(TYP)) D STND(TYP,"N") Q
 ... ;
 ... ;No default template yet - use this one
 ... D STND(TYP)
 ... ;
 .. ;If STANDARD DEFINED - USE IT
 .. ;
 .. S DIEN=$O(STDLST(TYP,"")) Q:DIEN=""
 .. ;
 .. ;Already have a default template for type
 .. I $D(DEFLST(TYP)) D DEF(DIEN,1) Q
 .. ;
 .. ;No default template yet - use this one
 .. D DEF(DIEN,1,1)
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
STND(DTYP,DEF) ;EP - Get the standard display for each type
 ; Parameters
 ;   TEMPL - Template name composed of type and 'Default'
 ;   DEF   - Whether this template is a default template
 ;
 NEW CRN,CNAM
 S CRN=$O(^BQI(90506.5,"C",DTYP,"")),CNAM="Unknown"
 I CRN'="" D
 . S CNAM=$P(^BQI(90506.5,CRN,0),U,9) I CNAM'="" Q
 . S CNAM=$P(^BQI(90506.5,CRN,0),U,1)
 S TEMPL=CNAM_" Default"
 S DEF=$G(DEF,""),DEF=$S(DEF="N":"",1:"Y")
 ;
 S II=II+1,@DATA@(II)=U_TEMPL_U_DEF_U_DTYP
 ;
 ; If the type is Patient, get the default definition
 I DTYP="D" D
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQIPLVW()_"^"_$$SFNC^BQIPLVW()_"^A^^"_$C(30) Q
 ; If the type is Reminders, get the default definition
 I DTYP="R" D
 . S @DATA@(II)=@DATA@(II)_U_$$RDEF^BQIRMPL()_"^"_$$SFNC^BQIPLVW()_"^A^^"_$C(30) Q
 ; If the type is Performance, get the default definition
 I DTYP="G" D
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQIGPVW()_$C(29)_$$GDEF^BQIGPVW()_"^"_$$SFNC^BQIGPVW()_"^A^^"_$C(30) Q
 I DTYP="Q"!(DTYP="T")!(DTYP="N") D  Q
 . S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 . S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQICEVW()_$C(29)_$$CDEF^BQICEVW()_"^"_$$SFNC^BQICEVW(CRN,DTYP)_"^A"_$C(29)_"D"_$C(29)_"A^^"_$C(30) Q
 I DTYP'="D",DTYP'="R",DTYP'="G" D
 . N CRN,CARE
 . S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 . S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQICMVW()_$C(29)_$$CDEF^BQICMVW()_"^"_$$SFNC^BQICMVW()_"^A^^"_$C(30) Q
 Q
 ;
DEF(TIEN,DEL,DEF) ;EP - Get a default display by a specific template record
 ; Parameters
 ; TIEN - Template IEN
 ;  DEL - 1 - Return CAN_DELETE field (used by BQI GET LAYOUTS but not BQI GET PANEL LAYOUTS)
 ;  DEF - 1 - This template should be set as the default
 ;
 N TEMPL,ISDEL,LEDT,DOR,DISPLAY
 S TEMPL=$P(^BQICARE(DUZ,15,TIEN,0),U,1),TYP=$P(^(0),U,2)
 S DEF=$S($G(DEF)=1:1,1:$P(^BQICARE(DUZ,15,TIEN,0),U,3)) S:DEF=1 DEF="Y"
 S ISDEL=$P(^BQICARE(DUZ,15,TIEN,0),U,5)
 S LEDT=$P(^BQICARE(DUZ,15,TIEN,0),U,4),LEDT=$$FMTE^BQIUL1(LEDT)
 S DOR="",DISPLAY=""
 F  S DOR=$O(^BQICARE(DUZ,15,TIEN,1,"C",DOR)) Q:DOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQICARE(DUZ,15,TIEN,1,"C",DOR,IEN)) Q:IEN=""  D
 .. S CODE=$P(^BQICARE(DUZ,15,TIEN,1,IEN,0),U,1)
 .. S DISPLAY=DISPLAY_CODE_$C(29)
 S DISPLAY=$$TKO^BQIUL1(DISPLAY,$C(29))
 ;
 S SOR="",SORT="",SDIR=""
 F  S SOR=$O(^BQICARE(DUZ,15,TIEN,1,"D",SOR)) Q:SOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQICARE(DUZ,15,TIEN,1,"D",SOR,IEN)) Q:IEN=""  D
 .. N CODE,DIR
 .. S CODE=$P(^BQICARE(DUZ,15,TIEN,1,IEN,0),U,1)
 .. S DIR=$P(^BQICARE(DUZ,15,TIEN,1,IEN,0),U,4)
 .. S SORT=SORT_CODE_$C(29),SDIR=SDIR_DIR_$C(29)
 S SORT=$$TKO^BQIUL1(SORT,$C(29))
 S SDIR=$$TKO^BQIUL1(SDIR,$C(29))
 I SDIR="" S SDIR="A"
 ;
 I $G(DEL)=1 S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_LEDT_U_ISDEL_$C(30) Q
 E  S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_LEDT_$C(30)
 Q
 ;
SAV(DATA,OWNR,LYIEN,TEMPL,TYPE,ADDEL,SOR,SDIR,DOR) ;EP -- BQI SAVE LAYOUTS
 ; Input
 ;   OWNR  - Whose layout this is
 ;   LYIEN - Layout internal entry number, will exist if updating an existing
 ;           layout and will be null if new layout record
 ;   TEMPL - Template name, if null will default to a standard name
 ;   TYPE  - The type of template P=Patient;G=GPRA;R=Reminders;M=My Measures
 ; ADDEL   - Is this a template add (NEW) or a template delete (DEL) - if an add, it is deletable
 ;   DOR   - Display order
 ;   SOR   - Sort order
 ;   SDIR  - Sort direction
 ;
 NEW UID,II,ERROR,DIC,DI,BQIUPD,SI,STVW,STVCD,SRDR,SRCN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYSAV",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILYDEF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S:$G(OWNR)="" OWNR=DUZ
 S TEMPL=$E($G(TEMPL),1,80)
 ;
 S @DATA@(II)="I00010RESULT^T00120ERROR_MESSAGE"_$C(30)
 ;
 ;Perform Deletes
 I $G(ADDEL)="DEL" D DELTMP(OWNR,LYIEN,TEMPL,.ERROR) G XSAV
 ;
 I $G(TEMPL)="" D
 . S SRCN=$O(^BQI(90506.5,"C",TYPE,""))
 . S TEMPL=$P(^BQI(90506.5,SRCN,0),U,1)_" Default"
 I $G(LYIEN)="" D
 . NEW DIC,Y,DLAYGO
 . I $G(^BQICARE(OWNR,15,0))="" S ^BQICARE(OWNR,15,0)="^90505.015^^"
 . S DIC(0)="L",DA(1)=OWNR,DLAYGO="90505.015",DIC="^BQICARE("_DA(1)_",15,",X=TEMPL
 . D ^DIC
 . S LYIEN=+Y
 ;
 ;Remove the previous parameters
 NEW DA,IENS,DIK
 S DA(2)=OWNR,DA(1)=LYIEN,DA=0
 S DIK="^BQICARE("_DA(2)_",15,"_DA(1)_",1,"
 F  S DA=$O(^BQICARE(OWNR,15,LYIEN,1,DA)) Q:'DA  D ^DIK
 ;
 NEW DA,IENS
 S DA(1)=OWNR,DA=LYIEN,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90505.015,IENS,.01)=TEMPL
 S BQIUPD(90505.015,IENS,.02)=TYPE
 I $G(ADDEL)="NEW" S BQIUPD(90505.015,IENS,.05)="Y"
 S BQIUPD(90505.015,IENS,.04)=$$NOW^XLFDT()
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 S SOR=$G(SOR,""),SDIR=$G(SDIR,"")
 S:SOR="" SOR="PN" S:SDIR="" SDIR="A"
 ;
 S DOR=$G(DOR,"")
 I DOR="" D
 . S LIST="",BN=""
 . F  S BN=$O(DOR(BN)) Q:BN=""  S LIST=LIST_DOR(BN)
 . K DOR
 . S DOR=LIST
 . K LIST
 ;
 F DI=1:1:$L(DOR,$C(29)) S STVCD=$P(DOR,$C(29),DI) Q:STVCD=""  D
 . S STVW=STVCD
 . NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 . S DA(2)=OWNR,DA(1)=LYIEN
 . S DIC="^BQICARE("_DA(2)_",15,"_DA(1)_",1,",DIE=DIC
 . S DLAYGO=90505.151,DIC(0)="L",DIC("P")=DLAYGO
 . S X=STVW
 . I '$D(^BQICARE(DA(2),15,DA(1),1,0)) S ^BQICARE(DA(2),15,DA(1),1,0)="^90505.151^^"
 . K DO,DD D FILE^DICN
 . S DA=+Y
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.151,IENS,.02)=DI
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 ;
 F SI=1:1:$L(SOR,$C(29)) S STVCD=$P(SOR,$C(29),SI) Q:STVCD=""  D
 . S SRDR=$P(SDIR,$C(29),SI) S:SRDR="" SRDR="A"
 . S STVW=STVCD
 . NEW DA,IENS
 . S DA(2)=OWNR,DA(1)=LYIEN,DA=$O(^BQICARE(OWNR,15,LYIEN,1,"B",STVW,""))
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.151,IENS,.03)=SI
 . S BQIUPD(90505.151,IENS,.04)=SRDR
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 ;
XSAV I $D(ERROR) S II=II+1,@DATA@(II)="-1^"_$G(ERROR)_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DFLT(DATA,OWNR,LYIEN,TYPE,TMPNAM) ;EP -- BQI SET TEMPLATE DFLT
 ;
 ; Input
 ;   OWNR  - Whose template this is
 ;   LYIEN - Template internal entry number
 ;   TYPE  - The type of template
 ;  TMPNAM - The template name
 ;
 NEW UID,II,ERROR,HDR
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
