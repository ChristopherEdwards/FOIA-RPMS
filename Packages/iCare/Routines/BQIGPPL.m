BQIGPPL ;VNGT/HS/ALA-GPRA by Panel ; 10 Jul 2009  1:30 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
PNL(DATA,OWNR,PLIEN,PLIST) ;EP - BQI GET GPRA RESULTS BY PANEL
 ;Description - Entry point for the panel
 ;Input Parameters
 ;  OWNR  - Owner of panel
 ;  PLIEN - Panel IEN
 ;  PLIST - List of DFNs (optional) 
 NEW UID,II,X,PGIEN,STVWCD,VALUE,HEADR,BQIYR,BQIH,BQIY,DFN,NAFLG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIGPPL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIGPPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;  get the current GPRA year for this panel
 NEW DA,IENS
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S BQIYR=$$GET1^DIQ(90505.01,IENS,3.3,"E")
 S BQIH=$$SPM^BQIGPUTL()
 I BQIYR="" S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 S BQIY=$$LKP^BQIGPUTL(BQIYR)
 ;  get the global references for the corresponding CRS year
 D GFN^BQIGPUTL(BQIH,BQIY)
 S CTYP="G"
 ;
 ; If a list of DFNs, process them instead of entire panel
 I $D(PLIST)>0 D  G DONE
 . I $D(PLIST)>1 D
 .. S LIST="",BN=""
 .. F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 .. K PLIST S PLIST=LIST
 . F BQI=1:1 S DFN=$P(PLIST,$C(28),BQI) Q:DFN=""  D
 .. I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 .. D PAT(.DATA,OWNR,PLIEN,DFN)
 ;
 S DFN=0
 I $O(^BQICARE(OWNR,1,PLIEN,40,DFN))="" D PAT(.DATA,OWNR,PLIEN,"") G DONE
 ;
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 . D PAT(.DATA,OWNR,PLIEN,DFN)
 ;
DONE ;
 ; If no data was found, generate the header
 I II=0,'$D(@DATA) D DEF S @DATA@(II)=$$TKO^BQIUL1(HEADR,"^")_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PAT(DATA,OWNR,PLIEN,DFN) ;EP - Build record by patient
 NEW IEN,HDR,DORD,HDOB,Y,VAL,BQIH,BQIYR
 S VALUE=""
 I $G(BQIH)="" S BQIH=$$SPM^BQIGPUTL()
 I $G(BQIYR)="" S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 I DFN'="" S Y=$$GET1^DIQ(9000001,DFN_",",1102.2,"I"),HDOB=$$FMTE^BQIUL1(Y)
 I DFN'="" S VALUE=DFN_"^"_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_"^"_$$SENS^BQIULPT(DFN)_"^"_$$CALR^BQIULPT(DFN)_"^"_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_"^"_HDOB_"^"_BQIYR_"^"
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^D00030HIDE_DOB^T00004HIDE_YEAR^"
 ;
 ; Check for template
 NEW DA,IENS,TEMPL,LYIEN,QFL
 S TEMPL=""
 I OWNR'=DUZ D
 . S DA=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,"C",CTYP,""))
 . I DA="" Q
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,IENS=$$IENS^DILF(.DA)
 . S TEMPL=$$GET1^DIQ(90505.34,IENS,.01,"E")
 I OWNR=DUZ D
 . S DA=$O(^BQICARE(OWNR,1,PLIEN,4,"C",CTYP,""))
 . I DA="" Q
 . S DA(2)=OWNR,DA(1)=PLIEN,IENS=$$IENS^DILF(.DA)
 . S TEMPL=$$GET1^DIQ(90505.14,IENS,.01,"E")
 ;
 ; If template, use it
 I TEMPL'="" S QFL=0 D  G FIN:'QFL
 . ;S LYIEN=$$DEF^BQILYUTL(OWNR,"M")
 . S LYIEN=$$TPN^BQILYUTL(DUZ,TEMPL)
 . I LYIEN="" S QFL=1 Q
 . S DOR=""
 . F  S DOR=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR)) Q:DOR=""  D
 .. S IEN=""
 .. F  S IEN=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR,IEN)) Q:IEN=""  D
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,IEN,0),U,1),STVWCD=CODE
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... I $P($G(^BQI(90506.1,GIEN,0)),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Patient" S STVW=GIEN D CVAL
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Performance" S STVW=STVWCD D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 ; If no template, check for customized
 I OWNR=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,25,IEN))
 . I CIEN'="" D
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,25,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,25,IEN,0),"^",1),STVWCD=CODE
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... S STVW=SIEN
 ... I $P($G(^BQI(90506.1,SIEN,0)),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" S STVW=SIEN D CVAL
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Performance" S STVW=STVWCD D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized found, use default
 . I CIEN="" D DEF
 ;
 I OWNR'=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,25,IEN))
 . I CIEN'="" D
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,25,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,25,IEN,0),"^",1),STVWCD=CODE
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P($G(^BQI(90506.1,SIEN,0)),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" S STVW=SIEN D CVAL
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Performance" S STVW=STVWCD D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized found, use default
 . I CIEN="" D DEF
 ;
FIN ; Finish
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 S VALUE=$$TKO^BQIUL1(VALUE,"^")
 ;
 I DFN="" S VALUE=""
 ;
 I II=0 S @DATA@(II)=HEADR_$C(30)
 I VALUE'="",$P($G(@DATA@(II)),$C(30),1)'=VALUE S II=II+1,@DATA@(II)=VALUE_$C(30)
 Q
 ;
CVAL ; Get demographic values
 ;Parameters
 ;  FIL  = FileMan file number
 ;  FLD  = FileMan field number
 ;  EXEC = If an executable is needed to determine value
 ;  HDR  = Header value
 ;the executable expects the value to be returned in variable VAL
 NEW FIL,FLD,EXEC
 S FIL=$$GET1^DIQ(90506.1,STVW_",",.05,"E")
 S FLD=$$GET1^DIQ(90506.1,STVW_",",.06,"E")
 S EXEC=$$GET1^DIQ(90506.1,STVW_",",1,"E")
 S HDR=$$GET1^DIQ(90506.1,STVW_",",.08,"E")
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" X EXEC Q
 ;
 I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 Q
 ;
GVAL ;EP - Get GPRA value for patient
 NEW PIEN,DEN,NUM,SPVW,SPIEN,VER,BQIDOD
 I $G(BQIMEASF)="" D INP^BQINIGHT
 I $G(DFN)="" S VAL="",HDR="T00003"_STVW,GMET="" Q
 S BQIDOD=$$GET1^DIQ(2,DFN_",",.351,"I") ; Is patient deceased?
 S PIEN=$O(^BQIPAT(DFN,30,"B",STVW,""))
 I PIEN="" S VAL=$S(BQIDOD'="":"{D}",1:"NDA"),HDR="T00003"_STVW,GMET="" Q
 ;
 I $G(BQIH)="" S BQIH=$$SPM^BQIGPUTL()
 I $G(BQIYR)="" S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 S BQIY=$$LKP^BQIGPUTL(BQIYR)
 ;
 S VER=$$VERSION^XPDUTL("BGP")
 S SPVW=$P(STVW,"_",2),NAFLG=0
 I VER<8.0 D
 . S SPIEN=$O(^BQI(90508,BQIH,20,BQIY,20,"B",SPVW,"")) I SPIEN="" Q
 . S NAFLG=+$P(^BQI(90508,BQIH,20,BQIY,20,SPIEN,0),"^",4)
 ;
 I VER>7.0 D
 . S NAFLG=$$GET1^DIQ(BQIMEASF,SPVW_",",1704,"I")
 . S NAFLG=$S(NAFLG="Y":1,1:0)
 ;
 S DEN=$P(^BQIPAT(DFN,30,PIEN,0),U,4)
 S NUM=+$P(^BQIPAT(DFN,30,PIEN,0),U,3)
 ;
 I DEN="" D
 . I NAFLG'=1 S VAL="N/A" Q
 . I 'NUM S VAL=0,GMET=0 Q
 . S VAL=NUM
 I DEN D
 . I 'NUM S VAL="NO",GMET=0 Q
 . S VAL="YES"
 S HDR="T00003"_STVW
 I BQIDOD'="" S VAL="{D}"
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
DEF ; Default list of fields
 S IEN=0
 F  S IEN=$O(^BQI(90506.1,"AC","D",IEN)) Q:IEN=""  D
 . S STVW=IEN
 . I $P($G(^BQI(90506.1,IEN,0)),U,10)=1 Q
 . ; For a standard display, only display the 'R'equired fields.
 . I $$GET1^DIQ(90506.1,STVW_",",3.04,"I")'="O" D
 .. D CVAL
 .. S VALUE=$G(VALUE)_VAL_"^"
 .. S HEADR=$G(HEADR)_HDR_"^"
 ;
 I $G(BQIMEASF)="" D INP^BQINIGHT
 S IEN=0
 F  S IEN=$O(^BQI(90506.1,"AC","G",IEN)) Q:IEN=""  D
 . S STVW=$P(^BQI(90506.1,IEN,0),U,1)
 . I $P(STVW,"_",1)'=BQIYR Q
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . S GIEN=$P(STVW,"_",2)
 . S VER=$$VERSION^XPDUTL("BGP")
 . I $P($G(^BQI(90506.1,IEN,0)),U,10)=1 Q
 . I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 .. I VER<8.0 D
 ... S PGIEN=$O(^BQI(90508,BQIH,20,BQIY,20,"B",GIEN,"")) I PGIEN="" Q
 ... S NAFLG=+$P(^BQI(90508,BQIH,20,BQIY,20,PGIEN,0),U,4)
 .. I VER>7.0 D
 ... S NAFLG=$$GET1^DIQ(BQIMEASF,GIEN_",",1704,"I")
 ... S NAFLG=$S(NAFLG="Y":1,1:0)
 .. D GVAL
 .. S VALUE=VALUE_VAL_"^"
 .. S HEADR=HEADR_HDR_"^"
 Q
