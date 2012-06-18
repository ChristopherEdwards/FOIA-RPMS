BQIPLVEW ;VNGT/HS/ALA-Get all Views for a Panel ; 08 Jul 2009  5:51 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
GET(DATA,OWNR,PLIEN) ; EP -- BQI GET PANEL LAYOUTS
 ;Description
 ;  This returns all displays for a panel
 ;Input
 ;  OWNR  - Owner of panel internal entry number
 ;  PLIEN - Panel internal entry number
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expected
 ;  DUZ   - User internal entry number
 ;Variables used
 ;  UID - TMP global subscript. Will be either $J or "Z" plus the
 ;        TaskMan Task ID
 ;
 NEW UID,II,IEN,DOR,SOR,DVALUE,SVALUE,X,SRC,TN,TYP,BQVW,SRN,BQVWS,CARE,DEF,GVALUE,MVALUE,STVCD,TEMPL,TMP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLVEW",UID))
 K @DATA
 S II=0
 S @DATA@(II)="I00010TEMPL_IEN^T00040TEMPLATE_NAME^T00001DEFAULT^T00001TYPE^T00120DISPLAY_ORDER^T00120SORT_ORDER^T00120SORT_DIRECTION"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLVEW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;  If user is the owner 
 I OWNR=DUZ D
 . ; Check for templates
 . S TN=0
 . F  S TN=$O(^BQICARE(OWNR,1,PLIEN,4,TN)) Q:'TN  D
 .. S TYP=$P(^BQICARE(OWNR,1,PLIEN,4,TN,0),U,2),TMPL=$P(^(0),U,1)
 .. S BQVW(TYP)=$O(^BQICARE(OWNR,15,"B",TMPL,""))
 . ;
 . ; Check for customized views
 . I $O(^BQICARE(OWNR,1,PLIEN,20,0))'="" S BQVW("D")="C^20"
 . I $O(^BQICARE(OWNR,1,PLIEN,22,0))'="" S BQVW("R")="C^22"
 . I $O(^BQICARE(OWNR,1,PLIEN,25,0))'="" S BQVW("G")="C^23"
 . ; 
 . ; Check for source views
 . S TN=0
 . F  S TN=$O(^BQICARE(OWNR,1,PLIEN,23,TN)) Q:'TN  D
 .. S SRC=$P(^BQICARE(OWNR,1,PLIEN,23,TN,0),U,1)
 .. S SRN=$O(^BQI(90506.5,"B",SRC,"")),TYP=$P(^BQI(90506.5,SRN,0),U,2)
 .. S BQVW(TYP)="S^"_SRC
 ;
 ; If user is not the owner
 I OWNR'=DUZ D
 . ; Check for templates
 . S TN=0
 . F  S TN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,TN)) Q:'TN  D
 .. S TYP=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,TN,0),U,2),TMPL=$P(^(0),U,1)
 .. S BQVW(TYP)=$O(^BQICARE(OWNR,15,"B",TMPL,""))
 . ;
 . ; Check for customized views
 . I $O(^BQICARE(OWNR,1,PLIEN,30,DUZ,20,0))'="" S BQVW("D")="C^20"
 . I $O(^BQICARE(OWNR,1,PLIEN,30,DUZ,22,0))'="" S BQVW("R")="C^22"
 . I $O(^BQICARE(OWNR,1,PLIEN,30,DUZ,25,0))'="" S BQVW("G")="C^23"
 . ; 
 . ; Check for source views
 . S TN=0
 . F  S TN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,TN)) Q:'TN  D
 .. S SRC=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,TN,0),U,1)
 .. S SRN=$O(^BQI(90506.5,"B",SRC,"")),TYP=$P(^BQI(90506.5,SRN,0),U,2)
 .. S BQVW(TYP)="S^"_SRC
 ;
 ; Otherwise define defaults
 S TMP=$NA(BQVW)
 F TYP="D","R","G","A" D
 . I $D(@TMP@(TYP)) D  Q
 .. S VALUE=@TMP@(TYP)
 .. ;
 .. ; If this is a template, get the template definition
 .. I VALUE?.N D DEF^BQILYDEF(VALUE) Q
 .. ;
 .. ; If this is a source view, check for a customized view or else return the default
 .. I $E(VALUE,1)="S" D
 ... S SRC=$P(@TMP@(TYP),U,2) I $$CVW^BQICMVW(SRC) Q
 ... D STND^BQILYDEF(TYP)
 .. ;
 .. ; If this is a customized view
 .. I $E(VALUE,1)="C" D
 ... I TYP="D" D
 .... I $$CVW^BQIPLVWC() Q
 .... D STND^BQILYDEF(TYP)
 ... I TYP="R" D
 .... I $$CVW^BQIPLRVW() Q
 .... D STND^BQILYDEF(TYP)
 ... I TYP="G" D
 .... I $$CVW^BQIGPVW() Q
 .... D STND^BQILYDEF(TYP)
 . D STND^BQILYDEF(TYP)
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
UPD(DATA,OWNR,PLIEN,TYPE,TEMPL,SOR,SDIR,DOR) ; EP -- BQI SAVE PANEL LAYOUTS
 ;Input
 ;   OWNR  - Owner IEN
 ;   PLIEN - Panel IEN
 ;   TYPE  - Type of layout that is being saved
 ;   TEMPL - Template name
 ;   YEAR  - GRPA Year
 ;   DOR   - The display order
 ;   SOR   - The sort order
 ;   SDIR  - The sort direction
 NEW UID,II,TMPL,YEAR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLVUP",UID))
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER"_$C(30)
 ;
 I $G(YEAR)="" D
 . I OWNR'="",PLIEN'="" D
 .. NEW DA,IENS
 .. S DA(1)=$S(OWNR=DUZ:DUZ,1:OWNR)
 .. S DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. S YEAR=$$GET1^DIQ(90505.01,IENS,3.3,"E")
 . S BQIH=$$SPM^BQIGPUTL()
 . I $G(YEAR)="" S YEAR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 ;
 S TEMPL=$G(TEMPL,"")
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
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLVEW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S RESULT=1_U_U
 ;
 ; If the template is not null, save the template
 I TEMPL'="" D  G FIN
 . I OWNR=DUZ D
 .. NEW DA,IENS,DIC
 .. S DA(2)=OWNR,DA(1)=PLIEN,X=TEMPL,DIC(0)="LNZ",DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",4,"
 .. D ^DIC
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.14,IENS,.02)=TYPE
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. I $D(ERROR) S RESULT=-1_U_$G(ERROR("DIERR",1,"TEXT",1))_U
 . I OWNR'=DUZ D
 .. S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,X=TEMPL,DIC(0)="LNZ"
 .. S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",4,"
 .. D ^DIC
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.34,IENS,.02)=TYPE
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. I $D(ERROR) S RESULT=-1_U_$G(ERROR("DIERR",1,"TEXT",1))_U
 ;
 ; If the template name is blank, then each type must be saved as customized
 I TEMPL="" D
 . I TYPE="R" D FIL^BQIPLRVW(OWNR,PLIEN,SOR,SDIR,DOR) Q
 . I TYPE="G" D FIL^BQIGPVW(OWNR,PLIEN,YEAR,SOR,SDIR,DOR) Q
 . I TYPE="D" D FIL^BQIPLVWC(OWNR,PLIEN,SOR,SDIR,DOR) Q
 . S CRN=$O(^BQI(90506.5,"C",TYPE,"")) Q:CRN=""
 . S CARE=$P(^BQI(90506.5,CRN,0),U,1)
 . D FIL^BQICMVW(OWNR,PLIEN,CARE,SOR,SDIR,DOR)
 Q
 ;
FIN ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
