BQILYDEF ;PRXM/HC/ALA-Layout Template Defaults ; 01 Jun 2007  11:51 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
RET(DATA,TMIEN) ;EP -- BQI GET LAYOUTS
 ;
 ; Input
 ;   TMIEN = Template internal entry number, if null gets all
 ;           defaults for a user
 ;   Assumes DUZ of user
 ; 
 NEW UID,II,BN,CODE,BQARY,DIEN,DISPLAY,IEN,SORT,TYP,TMIEN,DEF,TEMPL,DTYP
 NEW DOR,SOR,SDIR,LEDT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILYDEF",UID))
 K @DATA
 ;
 S TMIEN=$G(TMIEN,"")
 I TMIEN'?.N S TMIEN=$O(^BQICARE(DUZ,15,"B",TMIEN,""))
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILYDEF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010TEMPL_IEN^T00040TEMPLATE_NAME^T00001DEFAULT^T00001TYPE^T00120DISPLAY_ORDER^T00120SORT_ORDER^T00120SORT_DIRECTION^D00030LAST_EDITED"_$C(30)
 ;
 ; Checks if there are any default templates defined
 S DIEN=$O(^BQICARE(DUZ,15,0))
 ;
 ; If the template IEN is not null, get the specific information about that template
 I TMIEN'="" D
 . S TYP=$P(^BQICARE(DUZ,15,TMIEN,0),U,2)
 . D STND(TYP) Q
 . D DEF(TMIEN)
 ;
 I TMIEN="" D
 . ; Get the standard default displays for all four types if there are no default
 . ; templates defined
 . I DIEN="" D  Q
 .. F TYP="D","G","R","A","H","Q","T","N" D STND(TYP)
 . ; Otherwise, get the displays for any defined default template
 . S DIEN=0
 . F  S DIEN=$O(^BQICARE(DUZ,15,DIEN)) Q:'DIEN  D
 .. I $P(^BQICARE(DUZ,15,DIEN,0),U,3)'="Y" Q
 .. S BQARY($P(^BQICARE(DUZ,15,DIEN,0),U,2))=""
 .. D DEF(DIEN)
 . ; If no default template for a particular type is not defined, set it as
 . ; the standard default
 . F TYP="D","G","R","A","H","Q","T","N" I '$D(BQARY(TYP)) D STND(TYP)
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
STND(DTYP) ;EP - Get the standard display for each type
 ; Parameters
 ;   TEMPL - Template name composed of type and 'Default'
 ;   DEF   - Whether this template is a default template
 ;
 ; Define the template name
 NEW CRN,CNAM
 S CRN=$O(^BQI(90506.5,"C",DTYP,"")),CNAM="Unknown"
 I CRN'="" D
 . S CNAM=$P(^BQI(90506.5,CRN,0),U,9) I CNAM'="" Q
 . S CNAM=$P(^BQI(90506.5,CRN,0),U,1)
 S TEMPL=CNAM_" Default"
 S DEF="Y"
 S II=II+1,@DATA@(II)=U_TEMPL_U_DEF_U_DTYP
 ;
 ; If the type is Patient, get the default definition
 I DTYP="D" D
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQIPLVW()_"^"_$$SFNC^BQIPLVW()_"^A^"_$C(30) Q
 ; If the type is Reminders, get the default definition
 I DTYP="R" D
 . S @DATA@(II)=@DATA@(II)_U_$$RDEF^BQIRMPL()_"^"_$$SFNC^BQIPLVW()_"^A^"_$C(30) Q
 ; If the type is Performance, get the default definition
 I DTYP="G" D
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQIGPVW()_$C(29)_$$GDEF^BQIGPVW()_"^"_$$SFNC^BQIGPVW()_"^A^"_$C(30) Q
 ; If the type is MY MEASURES, get the default definition
 ;I DTYP="M" S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQIMSVW()_$C(29)_$$MDEF^BQIMSVW()_"^"_$$SFNC^BQIMSVW()_"^A"_$C(30)
 I DTYP="Q"!(DTYP="T")!(DTYP="N") D  Q
 . S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 . S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQICEVW()_$C(29)_$$CDEF^BQICEVW()_"^"_$$SFNC^BQICEVW(CRN,DTYP)_"^A"_$C(29)_"D"_$C(29)_"A^"_$C(30) Q
 I DTYP'="D",DTYP'="R",DTYP'="G" D
 . S CRN=$O(^BQI(90506.5,"C",DTYP,"")) I CRN="" Q
 . S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 . S @DATA@(II)=@DATA@(II)_U_$$DFNC^BQICMVW()_$C(29)_$$CDEF^BQICMVW()_"^"_$$SFNC^BQICMVW()_"^A^"_$C(30) Q
 Q
 ;
DEF(TIEN) ;EP - Get a default display by a specific template record
 ; Parameters
 ;   TEMPL   - Template name composed of type and 'Default'
 ;   DEF     - Whether this template is a default template
 ;   DISPLAY - Display order
 ;   SORT    - Sort order
 ;   SDIR    - Sort direction
 ;  
 S TEMPL=$P(^BQICARE(DUZ,15,TIEN,0),U,1),TYP=$P(^(0),U,2)
 S DEF=$P(^BQICARE(DUZ,15,TIEN,0),U,3) S:DEF=1 DEF="Y"
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
 .. S CODE=$P(^BQICARE(DUZ,15,TIEN,1,IEN,0),U,1)
 .. S DIR=$P(^BQICARE(DUZ,15,TIEN,1,IEN,0),U,4)
 .. S SORT=SORT_CODE_$C(29),SDIR=SDIR_DIR_$C(29)
 S SORT=$$TKO^BQIUL1(SORT,$C(29))
 S SDIR=$$TKO^BQIUL1(SDIR,$C(29))
 I SDIR="" S SDIR="A"
 ;
 S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_LEDT_$C(30)
 Q
 ;
SAV(DATA,OWNR,LYIEN,TEMPL,TYPE,DEF,SOR,SDIR,DOR) ;EP -- BQI SAVE LAYOUTS
 ; Input
 ;   OWNR  - Whose layout this is
 ;   LYIEN - Layout internal entry number, will exist if updating an existing
 ;           layout and will be null if new layout record
 ;   TEMPL - Template name, if null will default to a standard name
 ;   TYPE  - The type of template P=Patient;G=GPRA;R=Reminders;M=My Measures
 ;   DEF   - Is this a default template?
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
 I $G(TEMPL)="" D
 . S SRCN=$O(^BQI(90506.5,"C",TYPE,""))
 . S TEMPL=$P(^BQI(90506.5,SRCN,0),U,1)_" Default"
 I $G(LYIEN)="" D
 . NEW DIC,Y
 . I $G(^BQICARE(OWNR,15,0))="" S ^BQICARE(OWNR,15,0)="^90505.015^^"
 . S DIC(0)="L",DA(1)=OWNR,DIC="^BQICARE("_DA(1)_",15,",X=TEMPL
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
 S BQIUPD(90505.015,IENS,.03)=DEF
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
 S @DATA@(II)="I00010RESULT"_$C(30)
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
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
