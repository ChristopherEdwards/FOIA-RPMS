BQIMSVW ;PRXM/HC/ALA-My Measures View ; 01 Jun 2007  5:38 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
RET(DATA,OWNR,PLIEN) ; EP -- BQI GET MEASURES VIEW
 ; Input
 ;   OWNR  - Owner of the panel
 ;   PLIEN - Panel internal entry number
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Variables used
 ;  UID - TMP global subscript. Will be either $J or "Z" plus the
 ;        TaskMan Task ID
 ;        
 NEW UID,II,MVALUE,IEN,GIEN,SIEN,DISPLAY,SOR,SDIR,TEMPL,LYIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMSVW",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMSVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T01024DISPLAY_ORDER^T00300SORT_ORDER^T00300SORT_DIRECTION"_$C(30)
 ;
 S OWNR=$G(OWNR,$G(DUZ)),PLIEN=$G(PLIEN,"") ; If no owner supplied use DUZ
 ;
 I OWNR=DUZ,PLIEN'="" D  G DONE
 . ; Check if customized My Measures view
 . S IEN=0,DISPLAY="",SOR="",SDIR=""
 . F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,21,IEN)) Q:'IEN  D
 .. S GIEN=$P(^BQICARE(OWNR,1,PLIEN,21,IEN,0),"^",1)
 .. S SIEN=$P(^BQICARE(OWNR,1,PLIEN,21,IEN,0),"^",3)
 .. S RIEN=$P(^BQICARE(OWNR,1,PLIEN,21,IEN,0),"^",4)
 .. S DISPLAY=DISPLAY_GIEN_$C(29)
 .. S SOR=SOR_SIEN_$C(29)
 .. S SDIR=SDIR_RIEN_$C(29)
 . S DISPLAY=$$TKO^BQIUL1(DISPLAY,$C(29))
 . S SOR=$$TKO^BQIUL1(SOR,$C(29))
 . S SDIR=$$TKO^BQIUL1(SDIR,$C(29))
 . ;
 . I $G(DISPLAY)="" D
 .. ; check if layout template used
 .. NEW DA,IENS,TEMPL,LYIEN
 .. S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. S TEMPL=$$GET1^DIQ(90505.01,IENS,4.02,"E")
 .. I TEMPL'="" D
 ... S LYIEN=$$DEF^BQILYUTL(OWNR,"M")
 ... I LYIEN="" Q
 ... D DEF^BQILYDEF(LYIEN)
 ... S DISPLAY=$P(@DATA@(II),U,3),SOR=$P(@DATA@(II),U,4),SDIR=$P(@DATA@(II),U,5)
 .. ;
 .. I $G(DISPLAY)'="" Q
 .. ;
 .. S DISPLAY=$$DFNC()_$C(29)_$$MDEF()
 .. ;S DISPLAY=$$DFNC()
 .. ;S SOR=$$SFNC()_$C(29)
 .. S SOR=$$SFNC()
 .. S SDIR=""
 . I SDIR="" S SDIR="A"
 . S II=II+1,@DATA@(II)=DISPLAY_"^"_SOR_"^"_SDIR_$C(30)
 ;
 I OWNR'="",OWNR'=DUZ,PLIEN'="" D
 . S IEN=0,DISPLAY="",SORT="",SDIR=""
 . F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,21,IEN)) Q:'IEN  D
 .. S GIEN=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,21,IEN,0),"^",1)
 .. S SR=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,21,IEN,0),"^",2)
 .. S SD=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,21,IEN,0),"^",3)
 .. S DISPLAY=DISPLAY_GIEN_$C(29)
 .. I SR'="" S SORT=SORT_SR_$C(29)
 .. I SD'="" S SDIR=SDIR_SD_$C(29)
 . S DISPLAY=$$TKO^BQIUL1(DISPLAY,$C(29))
 . S SORT=$$TKO^BQIUL1(SORT,$C(29))
 . S SDIR=$$TKO^BQIUL1(SDIR,$C(29))
 ;
 I $G(DISPLAY)="" D
 .; check if layout template used
 . NEW DA,IENS,TEMPL,LYIEN
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=DUZ,IENS=$$IENS^DILF(.DA)
 . S TEMPL=$$GET1^DIQ(90505.03,IENS,4.02,"E")
 . I TEMPL'="" D
 .. S LYIEN=$$DEF^BQILYUTL(OWNR,"M")
 .. I LYIEN="" Q
 .. D DEF^BQILYDEF(LYIEN)
 .. S DISPLAY=$P(@DATA@(II),U,3),SOR=$P(@DATA@(II),U,4),SDIR=$P(@DATA@(II),U,5)
 . ;
 . I $G(DISPLAY)'="" Q
 . ;
 . S DISPLAY=$$DFNC()_$C(29)_$$MDEF()
 . ;S DISPLAY=$$DFNC()
 . S SORT=$$SFNC()
 . S SDIR="A"
 S II=II+1,@DATA@(II)=DISPLAY_"^"_$G(SORT)_"^"_$G(SDIR)_$C(30)
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
UPD(DATA,OWNR,PLIEN,SOR,SDIR,DOR) ; EP -- BQI SET MEASURES VIEW
 ;
 ;Description
 ;   Update the display and sort order for a specified owner and panel
 ;Input
 ;   DOR  - The display order
 ;   SOR  - The sort order
 ;   SDIR - The sort direction
 ;
 ; If the Owner and the User are the same person.
 NEW UID,II,IEN,ERROR,BQIDEL,DI,GIEN,SI
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMSVW",UID))
 K @DATA
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S SOR=$G(SOR,""),SDIR=$G(SDIR,"")
 S DOR=$G(DOR,"")
 I DOR="" D
 . S LIST="",BN=""
 . F  S BN=$O(DOR(BN)) Q:BN=""  S LIST=LIST_DOR(BN)
 . K DOR
 . S DOR=LIST
 . K LIST
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMSVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; If the user is the owner, delete the previous view values
 I OWNR=DUZ D  G DONE
 . NEW DA,IENS
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=0
 . F  S DA=$O(^BQICARE(OWNR,1,PLIEN,21,DA)) Q:'DA  D
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIDEL(90505.13,IENS,.01)="@"
 . I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 . ;
 . F DI=1:1:$L(DOR,$C(29)) S GIEN=$P(DOR,$C(29),DI) Q:GIEN=""  D
 .. NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 .. S DA(2)=OWNR,DA(1)=PLIEN
 .. S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",21,",DIE=DIC
 .. S DLAYGO=90505.13,DIC(0)="L",DIC("P")=DLAYGO
 .. S X=GIEN
 .. I '$D(^BQICARE(DA(2),1,DA(1),21,0)) S ^BQICARE(DA(2),1,DA(1),21,0)="^90505.13^^"
 .. K DO,DD D FILE^DICN
 .. S DA=+Y I DA<1 S ERROR=1 Q
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.13,IENS,.02)=DI
 .. D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . F SI=1:1:$L(SOR,$C(29)) S SIEN=$P(SOR,$C(29),SI) D
 .. NEW DA,X,IENS,BQIUPD
 .. S DA(2)=OWNR,DA(1)=PLIEN,DA=SI,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.13,IENS,.03)=SIEN
 .. S BQIUPD(90505.13,IENS,.04)=$P(SDIR,$C(29),SI)
 .. D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 . I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
 ;
 ; If the user is sharing someone else's panel.
 NEW DA,IENS
 S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,DA=0
 F  S DA=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,21,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIDEL(90505.321,IENS,.01)="@"
 I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 ;
 F DI=1:1:$L(DOR,$C(29)) S GIEN=$P(DOR,$C(29),DI) Q:GIEN=""  D
 . NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ
 . S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",21,",DIE=DIC
 . S DLAYGO=90505.321,DIC(0)="L",DIC("P")=DLAYGO
 . S X=GIEN
 . I '$D(^BQICARE(DA(3),1,DA(2),30,DA(1),21,0)) S ^BQICARE(DA(3),1,DA(2),30,DA(1),21,0)="^90505.321^^"
 . K DO,DD D FILE^DICN
 . S DA=+Y I DA<1 S ERROR=1
 ;
 F SI=1:1:$L(SOR,$C(29)) S SIEN=$P(SOR,$C(29),SI) Q:SIEN=""  D
 . NEW DA,X,IENS
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,DA=SI,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.321,IENS,.02)=SIEN
 . S BQIUPD(90505.321,IENS,.03)=$P(SDIR,$C(29),SI)
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DFNC() ;EP -- Get the standard display order
 S DVALUE=""
 S DOR="" F  S DOR=$O(^BQI(90506.1,"AD","D",DOR)) Q:DOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD","D",DOR,IEN)) Q:IEN=""  D
 .. ;I $$GET1^DIQ(90506.1,IEN_",",.13,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S DVALUE=DVALUE_STVCD_$C(29)
 S DVALUE=$$TKO^BQIUL1(DVALUE,$C(29))
 Q DVALUE
 ;
SFNC() ;EP -- Get the standard sort order
 S SVALUE=""
 S SOR="" F  S SOR=$O(^BQI(90506.1,"AE","D",SOR)) Q:SOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AE","D",SOR,IEN)) Q:IEN=""  D
 .. ;I $$GET1^DIQ(90506.1,IEN_",",.13,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S SVALUE=SVALUE_STVCD_$C(29)
 S SVALUE=$$TKO^BQIUL1(SVALUE,$C(29))
 Q SVALUE
 ;
MDEF() ; EP - Get Measures default fields
 S MVALUE=""
 F TYP="G","R","A","H" D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AC",TYP,IEN)) Q:IEN=""  D
 .. ;I $$GET1^DIQ(90506.1,IEN_",",.09,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S MVALUE=MVALUE_STVCD_$C(29)
 ;
 S MVALUE=$$TKO^BQIUL1(MVALUE,$C(29))
 Q MVALUE
