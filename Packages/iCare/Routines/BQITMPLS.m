BQITMPLS ;VNGT/HS/BEE-Template Add/Edit/Delete/Share ; 05 May 2011  12:06 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 Q
 ;
DIST(DATA,TIEN,OWNR) ;EP -- BQI GET TMP DIST LIST
 ;
 ;Description
 ;  Get the Distribution List for the Template
 ;Input
 ;  TIEN - The IEN of the Template
 ;  OWNR - If not use DUZ
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 S:$G(OWNR)="" OWNR=DUZ
 ;
 ;Check for existence of template
 I TIEN="" S BMXSEC="Template IEN is missing" Q
 I '$D(^BQICARE(OWNR,15,TIEN)) S BMXSEC="Template isn't defined" Q
 ;
 NEW UID,II,TMPLT,DA,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S II=0
 S @DATA@(II)="I00010USER^I00040USER_NAME^D00030DATE_DISTRIBUTED^T00001DELETED^I00010USER_TMPIEN"_$C(30)
 ;
 S DA=TIEN,DA(1)=OWNR,IEN=$$IENS^DILF(.DA)
 D GETS^DIQ(90505.015,IEN,"2*","IE","TMPLT")
 ;
 S IEN="" F  S IEN=$O(TMPLT(90505.152,IEN)) Q:IEN=""  D
 . ;
 . NEW USERID,USERNM,DTTM,DELT,UIEN
 . S USERID=$G(TMPLT(90505.152,IEN,.01,"I")) Q:USERID=""
 . S USERNM=$G(TMPLT(90505.152,IEN,.01,"E"))
 . S DTTM=$G(TMPLT(90505.152,IEN,.02,"I"))
 . S DELT=$G(TMPLT(90505.152,IEN,.03,"I"))
 . S UIEN=$G(TMPLT(90505.152,IEN,.04,"I"))
 . S II=II+1,@DATA@(II)=USERID_U_USERNM_U_$$FMTE^BQIUL1(DTTM)_U_DELT_U_UIEN_$C(30)
 ;
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
UPLOAD(DATA,OWNR,TIEN) ;EP -- BQI TEMPLATE UPLOAD
 ;
 ;Description
 ;  Upload the template to the directory
 ;Input
 ;  OWNR - The template owner
 ;  TIEN - The IEN of the Template
 ;  
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 S:$G(OWNR)="" OWNR=DUZ
 ;
 ;Check for existence of template
 I TIEN="" S BMXSEC="Template IEN is missing" Q
 I '$D(^BQICARE(OWNR,15,TIEN)) S BMXSEC="Template isn't defined" Q
 ;
 NEW UID,II,TMPLT,DA,IENS,DIC,X,Y,DIEN,OIEN,ERROR,BQIUPD,DLAYGO
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S II=0
 S @DATA@(II)="T00001RESULT"_$C(30)
 ;
 S DA=TIEN,DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 D GETS^DIQ(90505.015,IENS,"**","I","TMPLT")
 ;
 ;Look for existing entry or create new one
 S X=$G(TMPLT("90505.015",IENS,".01","I")) I X="" G XUPLD
 S X=OWNR_X
 S DIC(0)="XL",DIC="^BQI(90508.1,",DLAYGO=90508.1
 D ^DIC
 I Y="-1" S BMXSEC="UNABLE TO UPLOAD ENTRY" Q
 S DIEN=+Y
 ;
 ;If existing entry delete existing data
 I $$GET1^DIQ(90508.1,DIEN_",",".02","I")]"" D
 . ;
 . N DA,DIK
 . S DIK="^BQI(90508.1,"_DIEN_",10,"
 . S DA(1)=DIEN
 . S DA=0 F  S DA=$O(^BQI(90508.1,DIEN,10,DA)) Q:'DA  D ^DIK
 ;
 ;Save template in ICARE USER TEMPLATES
 ;
 S OIEN=$O(TMPLT("90505.015",""))
 I OIEN]"" D
 . NEW BQIUPD
 . S BQIUPD("90508.1",DIEN_",",".02")=$G(TMPLT("90505.015",OIEN,".02","I"))
 . S BQIUPD("90508.1",DIEN_",",".03")=$G(TMPLT("90505.015",OIEN,".01","I"))
 . S BQIUPD("90508.1",DIEN_",",".04")=$G(TMPLT("90505.015",OIEN,".04","I"))
 . S BQIUPD("90508.1",DIEN_",",".05")=DUZ
 . S BQIUPD("90508.1",DIEN_",",".06")=$$NOW^XLFDT()
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S OIEN="" F  S OIEN=$O(TMPLT("90505.151",OIEN)) Q:OIEN=""  D
 . N FIEN,X,DIC,Y,DA,FLD
 . ;
 . ;Add field .01 field
 . S X=$G(TMPLT("90505.151",OIEN,".01","I")) I X="" Q
 . S DA(1)=DIEN
 . S DIC(0)="XL",DIC="^BQI(90508.1,"_DIEN_",10,"
 . D ^DIC
 . I Y="-1" S BMXSEC="UNABLE TO UPLOAD ENTRY" Q
 . S FIEN=+Y
 . ;
 . ;Save each field
 . S FLD="" F  S FLD=$O(TMPLT("90505.151",OIEN,FLD)) Q:FLD=""  D
 .. N IENS
 .. S IENS=FIEN_","_DIEN_","
 .. S BQIUPD("90508.11",IENS,FLD)=$G(TMPLT("90505.151",OIEN,FLD,"I"))
 . ;
 . ;File entry in new
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 E  S II=II+1,@DATA@(II)="1"_$C(30)
 ;
XUPLD S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
LIST(DATA,FAKE) ;EP -- BQI GET TEMPLATE LIST
 ;
 ;Description
 ;  Get the list of available templates
 ;  
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S II=0
 S @DATA@(II)="I00010HIDE_TMP_IEN^T00001TMP_TYPE^T00040TMP_NAME^I00010TMP_AUTHOR_IEN^T00050TMP_AUTHOR^D00030DT_LAST_EDIT^D00030DT_UPLOAD"_$C(30)
 ;
 S IEN=0 F  S IEN=$O(^BQI(90508.1,IEN)) Q:'IEN  D
 . ;
 . NEW TMP,IENS,INAME,TTYPE,TNAME,TAUTH,TLEDT,TUPDT,DAUTH
 . S IENS=IEN_","
 . D GETS^DIQ(90508.1,IENS,".01:.06","I","TMP")
 . ;
 . S INAME=$G(TMP(90508.1,IENS,.01,"I"))
 . S TTYPE=$G(TMP(90508.1,IENS,.02,"I"))
 . S TNAME=$G(TMP(90508.1,IENS,.03,"I"))
 . S TAUTH=$G(TMP(90508.1,IENS,.05,"I"))
 . S DAUTH="" S:TAUTH]"" DAUTH=$$GET1^DIQ(200,TAUTH_",",".01","E")
 . S TLEDT=$$FMTE^BQIUL1($G(TMP(90508.1,IENS,.04,"I")))
 . S TUPDT=$$FMTE^BQIUL1($G(TMP(90508.1,IENS,.06,"I")))
 . ;
 . S II=II+1,@DATA@(II)=IEN_U_TTYPE_U_TNAME_U_TAUTH_U_DAUTH_U_TLEDT_U_TUPDT_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;
DNLOAD(DATA,OWNR,TIEN) ;EP -- BQI DOWNLOAD TEMPLATE
 ;
 ;Description
 ;  Download the template to the user's account
 ;Input
 ;  OWNR - The iCare user to copy the template to
 ;  TIEN - The IEN of the template in 90508.1
 ;  
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 S:$G(OWNR)="" OWNR=DUZ
 ;
 ;Check for existence of template
 I TIEN="" S BMXSEC="Template IEN is missing" Q
 I '$D(^BQI(90508.1,TIEN)) S BMXSEC="Template isn't defined" Q
 ;
 NEW UID,II,TMPLT,DIC,X,Y,DIEN,IENS,AUTHOR,LSTEDT,LEN,DA,OIEN,ERROR,BQIUPD
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S II=0
 S @DATA@(II)="T00001RESULT"_$C(30)
 ;
 D GETS^DIQ(90508.1,TIEN_",","**","I","TMPLT")
 ;
 ;Look for existing entry or create new one
 ;
 ;Get template author
 S AUTHOR=$G(TMPLT("90508.1",TIEN_",",".05","I"))
 I AUTHOR]"" S AUTHOR=$$GET1^DIQ(200,AUTHOR_",",.01,"E")
 ;
 ;Get template last edit date
 S LSTEDT=$G(TMPLT("90508.1",TIEN_",",".04","I"))
 I LSTEDT]"" S LSTEDT=$$FMTE^BQIUL1(LSTEDT)
 ;
 ;Create entry in 90505.015
 S X=$S(AUTHOR]"":AUTHOR,1:"")_$S((AUTHOR]""&(LSTEDT]"")):"-",1:"")_LSTEDT
 S:X]"" X="-"_X
 S LEN=80-$L(X)
 S X=$E($G(TMPLT("90508.1",TIEN_",",".03","I")),1,LEN)_X I X="" G XDNLD
 S DA(1)=OWNR
 S DIC(0)="XL",DIC="^BQICARE("_DA(1)_",15,"
 D ^DIC
 I Y="-1" S BMXSEC="UNABLE TO DOWNLOAD ENTRY" Q
 S DIEN=+Y
 ;
 ;If existing entry delete existing data
 S DA=DIEN,DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ(90505.015,IENS,".02","I")]"" D
 . ;
 . N DA,DIK
 . S DIK="^BQICARE("_OWNR_",15,"_DIEN_",1,"
 . S DA(2)=OWNR,DA(1)=DIEN
 . S DA=0 F  S DA=$O(^BQICARE(OWNR,15,DIEN,1,DA)) Q:'DA  D ^DIK
 ;
 ;Save template in ICARE USER
 ;
 S OIEN=$O(TMPLT("90508.1",""))
 I OIEN]"" D
 . N DA,IENS,BQIUPD
 . S DA(1)=OWNR,DA=DIEN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD("90505.015",IENS,".02")=$G(TMPLT("90508.1",OIEN,".02","I"))
 . S BQIUPD("90505.015",IENS,".04")=$G(TMPLT("90508.1",OIEN,".04","I"))
 . S BQIUPD("90505.015",IENS,".05")="Y"
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S OIEN="" F  S OIEN=$O(TMPLT("90508.11",OIEN)) Q:OIEN=""  D
 . N FIEN,X,DIC,Y,DA,FLD,BQIUPD
 . ;
 . ;Add field .01 field
 . S X=$G(TMPLT("90508.11",OIEN,".01","I")) I X="" Q
 . S DA(2)=OWNR,DA(1)=DIEN
 . S DIC(0)="XL",DIC="^BQICARE("_DA(2)_",15,"_DA(1)_",1,"
 . D ^DIC
 . I Y="-1" S BMXSEC="UNABLE TO DOWNLOAD ENTRY" Q
 . S FIEN=+Y
 . ;
 . ;Save each field
 . S FLD="" F  S FLD=$O(TMPLT("90508.11",OIEN,FLD)) Q:FLD=""  D
 .. N IENS
 .. S IENS=FIEN_","_DIEN_","_OWNR_","
 .. S BQIUPD("90505.151",IENS,FLD)=$G(TMPLT("90508.11",OIEN,FLD,"I"))
 . ;
 . ;File entry in new
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 E  S II=II+1,@DATA@(II)="1"_$C(30)
 ;
XDNLD S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DTMPSET(DTYP) ;EP - SET UP DEFAULT TEMPLATE ENTRY FOR USER
 N DOR,SOR,SDIR,DATA,UID
 ;
 ;Pull the standard fields and sort values for each type
 D
 . ; If the type is Patient, get the default definition
 . I DTYP="D" S DOR=$$DFNC^BQIPLVW(),SOR=$$SFNC^BQIPLVW(),SDIR="A" Q
 . ;
 . ; If the type is Reminders, get the default definition
 . I DTYP="R" S DOR=$$RDEF^BQIRMPL(),SOR=$$SFNC^BQIPLVW(),SDIR="A" Q
 . ;
 . ; If the type is Performance, get the default definition
 . I DTYP="G" S DOR=$$DFNC^BQIGPVW()_$C(29)_$$GDEF^BQIGPVW(),SOR=$$SFNC^BQIGPVW(),SDIR="A" Q
 . ;
 . ; If the type is MY MEASURES, get the default definition
 . I DTYP="Q"!(DTYP="T")!(DTYP="N") D  Q
 .. N CRN,CARE
 .. S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 .. S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 .. S DOR=$$DFNC^BQICEVW()_$C(29)_$$CDEF^BQICEVW(),SOR=$$SFNC^BQICEVW(CRN,DTYP),SDIR="A"_$C(29)_"D"_$C(29)_"A"
 . I DTYP'="D",DTYP'="R",DTYP'="G" D  Q
 .. S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 .. S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 .. S DOR=$$DFNC^BQICMVW()_$C(29)_$$CDEF^BQICMVW(),SOR=$$SFNC^BQICMVW(),SDIR="A"
 ;
 ;Save the entry, clear scratch global
 D SAV^BQILYDEF("",DUZ,"","",DTYP,"",SOR,SDIR,DOR)
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYSAV",UID))
 K @DATA
 ;
 Q
 ;
DTMPDEF(DTYP) ;EP - SET THE DEFAULT TEMPLATE TO THE USER'S DEFAULT
 ;
 N SRCN,TEMPL,TIEN,UID,DATA
 ;
 S SRCN=$O(^BQI(90506.5,"C",DTYP,"")) Q:SRCN=""
 S TEMPL=$P(^BQI(90506.5,SRCN,0),U,1)_" Default" Q:TEMPL=""
 ;
 S TIEN=$$TPN^BQILYUTL(DUZ,TEMPL) Q:TIEN=""
 ;
 ;Set as default for this type, clear scratch global
 D DFLT^BQILYDEF("",DUZ,TIEN,DTYP,TEMPL)
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYDEF",UID))
 K @DATA
 ;
 Q
 ;
VIEW(DATA,TIEN) ;EP -- BQI VIEW PUBLIC TEMPLATE
 ; Parameters
 ; TIEN - Public Template IEN
 ;
 NEW UID,II,SDIR,DOR,SOR,SORT,DISPLAY,TMPNM,TMPTY,HTMPNM,TMPLE
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S II=0
 ;
 S @DATA@(II)="I00010TEMPL_IEN^T00001TMP_TYPE^T00040TMP_NAME^T00120DISPLAY_ORDER"
 S @DATA@(II)=@DATA@(II)_"^T00120SORT_ORDER^T00120SORT_DIRECTION^D00030LAST_EDITED"_$C(30)
 ;
 S HTMPNM=$$GET1^DIQ(90508.1,TIEN_",",.01,"E")
 S TMPTY=$$GET1^DIQ(90508.1,TIEN_",",.02,"I")
 S TMPNM=$$GET1^DIQ(90508.1,TIEN_",",.03,"E")
 S TMPLE=$$GET1^DIQ(90508.1,TIEN_",",.04,"I")
 ;
 ;Get field list
 S DOR="",DISPLAY=""
 F  S DOR=$O(^BQI(90508.1,TIEN,10,"C",DOR)) Q:DOR=""  D
 . N IEN
 . S IEN="" F  S IEN=$O(^BQI(90508.1,TIEN,10,"C",DOR,IEN)) Q:IEN=""  D
 .. N CODE
 .. S CODE=$P($G(^BQI(90508.1,TIEN,10,IEN,0)),U,1)
 .. S DISPLAY=DISPLAY_CODE_$C(29)
 ;
 S SOR="",SORT="",SDIR=""
 F  S SOR=$O(^BQI(90508.1,TIEN,10,"D",SOR)) Q:SOR=""  D
 . N IEN
 . S IEN=""
 . F  S IEN=$O(^BQI(90508.1,TIEN,10,"D",SOR,IEN)) Q:IEN=""  D
 .. N CODE,DIR
 .. S CODE=$P($G(^BQI(90508.1,TIEN,10,IEN,0)),U,1)
 .. S DIR=$P($G(^BQI(90508.1,TIEN,10,IEN,0)),U,4)
 .. S SORT=SORT_CODE_$C(29),SDIR=SDIR_DIR_$C(29)
 ;
 S DISPLAY=$$TKO^BQIUL1(DISPLAY,$C(29))
 S SORT=$$TKO^BQIUL1(SORT,$C(29))
 S SDIR=$$TKO^BQIUL1(SDIR,$C(29))
 I SDIR="" S SDIR="A"
 ;
 S II=II+1,@DATA@(II)=TIEN_U_TMPTY_U_TMPNM_U_DISPLAY_U_SORT_U_SDIR_U_$$FMTE^BQIUL1(TMPLE)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL(DATA,TIEN) ;EP -- BQI DELETE PUBLIC TEMPLATE
 ; Parameters
 ; TIEN - Public Template IEN
 ;
 NEW UID,II,DA,DIK
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITMPLS",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITMPLS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I TIEN="" S BMXSEC="Template IEN is blank" Q
 ;
 S II=0
 ;
 S @DATA@(II)="I00001RESULT"_$C(30)
 ;
 ;Delete template entry
 S DIK="^BQI(90508.1,"
 S DA=TIEN D ^DIK
 ;
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
