BQIREFPL ;GDIT/HS/ALA-Get Referrals by Panel ; 31 Dec 2014  2:27 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,PLIST) ;EP -- BQI GET REFERRALS BY PANEL
 ;Description - Entry point for the panel
 ;Input Parameters
 ;  OWNR  - Owner of panel
 ;  PLIEN - Panel IEN
 ;  PLIST - List of DFNs (optional)
 NEW UID,II,DFN,HEADER,TMP,BHEADR,BVALUE,VAL,VALUE,FLDS,RFIEN,CIEN,CTYPD00015
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIREFPL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIREFPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S RHEADR="",CTYP="RF" D RHD
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
PAT(DATA,OWNR,PLIEN,DFN) ;EP - Build record by patient
 K VALUE
 D HDR^BQIHEADR(OWNR,PLIEN,DFN,.BHEADR,.BVALUE)
 S BVALUE=$$TKO^BQIUL1(BVALUE,"^"),VALUE(0)=BVALUE
 S HEADR=BHEADR_RHEADR,HEADR=$$TKO^BQIUL1(HEADR,"^")
 I II=0 S @DATA@(II)=HEADR_$C(30)
 S CTYP="RF",CRE=0
 ;
 D REFF
 S TMP=$NA(^TMP("BQIREFS",UID)) K @TMP
 I DFN'="" D RFPT(DFN,FLDS)
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
 I TEMPL'="" S QFL=0 D  Q
 . S LYIEN=$$TPN^BQILYUTL(DUZ,TEMPL)
 . I LYIEN="" S QFL=1 Q
 . I DFN="" S VALUE(1)="" Q
 . I '$D(@TMP@(DFN)) S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 . S RFIEN="" F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 . S DOR=""
 . F  S DOR=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR)) Q:DOR=""  D
 .. S IEN=""
 .. F  S IEN=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR,IEN)) Q:IEN=""  D
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,IEN,0),U,1)
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... I $P(^BQI(90506.1,GIEN,0),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Patient" D
 .... S STVW=GIEN D CVAL
 .... F C=1:1:CRE S VALUE(C)=VALUE(C)_VAL_"^"
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Referrals" D
 .... S RFIEN="",C=0 F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  D RVAL(GIEN) S C=C+1,VALUE(C)=VALUE(C)_VAL_"^"
 . ;
 . F C=1:1:CRE S VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^")
 . I DFN="" S VALUE(1)=""
 . I $D(VALUE) D
 .. F C=1:1:CRE S CLNG=$L(HEADR,"^")-$L(VALUE(C),"^") D
 ... I CLNG>0 S $P(VALUE(C),"^",$L(HEADR,"^"))=""
 ... I CLNG<0 S VALUE(C)=$P(VALUE(C),"^",1,$L(HEADR,"^"))
 . F C=1:1:CRE S II=II+1,VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^"),@DATA@(II)=VALUE(C)_$C(30)
 . K VALUE S VALUE(0)=BVALUE
 . ;
 ; If no template, check for customized
 I OWNR=DUZ D  Q
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,26,IEN))
 . I CIEN'="" D  Q
 .. I DFN="" S VALUE(1)="" Q
 .. I '$D(@TMP@(DFN)) S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 .. S RFIEN="" F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,26,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,26,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" D
 .... S STVW=SIEN D CVAL
 .... F C=1:1:CRE S VALUE(C)=VALUE(C)_VAL_"^"
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Referrals" D
 .... I '$D(@TMP@(DFN)) S VALUE(CRE)=VALUE(CRE)_"^" Q
 .... S RFIEN="",C=0 F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  D RVAL(SIEN) S C=C+1,VALUE(C)=VALUE(C)_VAL_"^"
 .. I DFN="" S VALUE(1)=""
 .. I $D(VALUE) D
 .. F C=1:1:CRE S CLNG=$L(HEADR,"^")-$L(VALUE(C),"^") D
 ... I CLNG>0 S $P(VALUE(C),"^",$L(HEADR,"^"))=""
 ... I CLNG<0 S VALUE(C)=$P(VALUE(C),"^",1,$L(HEADR,"^"))
 .. F C=1:1:CRE S II=II+1,VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^"),@DATA@(II)=VALUE(C)_$C(30)
 . K VALUE S VALUE(0)=BVALUE
 . ; If no customized found, use default
 . I CIEN="" D STAND()
 ;
 I OWNR'=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN))
 . I CIEN'="" D  Q
 .. I DFN="" S VALUE(1)="" Q
 .. I '$D(@TMP@(DFN)) S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 .. S RFIEN="" F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" D
 .... S STVW=SIEN D CVAL
 .... F C=1:1:CRE S VALUE(C)=VALUE(C)_VAL_"^"
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Referrals" D
 .... I '$D(@TMP@(DFN)) S VALUE(CRE)=VALUE(CRE)_"^" Q
 .... S RFIEN="",C=0 F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  D RVAL(SIEN) S C=C+1,VALUE(C)=VALUE(C)_VAL_"^"
 .. ;
 .. I $D(VALUE) D
 .. F C=1:1:CRE S CLNG=$L(HEADR,"^")-$L(VALUE(C),"^") D
 ... I CLNG>0 S $P(VALUE(C),"^",$L(HEADR,"^"))=""
 ... I CLNG<0 S VALUE(C)=$P(VALUE(C),"^",1,$L(HEADR,"^"))
 .. F C=1:1:CRE S II=II+1,VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^"),@DATA@(II)=VALUE(C)_$C(30)
 . K VALUE S VALUE(0)=BVALUE
 . ; If no customized found, use default
 . I CIEN="" D STAND()
 Q
 ;
STAND() ;EP - Get standard display
 S CRE=0
 S RHEADR=BHEADR D RSH() S HEADR=RHEADR
 S RHEADR=$$TKO^BQIUL1(RHEADR,"^")
 I II=0 S @DATA@(II)=RHEADR_$C(30)
 I '$D(@TMP) S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 S RFIEN="" F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  S CRE=CRE+1,VALUE(CRE)=VALUE(0)_"^"
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","D",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . S KEY=$$GET1^DIQ(90506.1,IEN_",",3.1,"E")
 . I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 . I $P($G(^BQI(90506.1,IEN,3)),"^",4)'="O" D
 .. S STVW=IEN
 .. D CVAL
 .. F C=1:1:CRE S VALUE(C)=VALUE(C)_VAL_"^"
 ;
 ;Get patient referrals
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","RF",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . S KEY=$$GET1^DIQ(90506.1,IEN_",",3.1,"E")
 . I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 . I $P($G(^BQI(90506.1,IEN,3)),"^",4)'="O" D
 .. S STVW=IEN
 .. I '$D(@TMP@(DFN)) S VALUE(CRE)=VALUE(CRE)_"^" Q
 .. S RFIEN="",C=0 F  S RFIEN=$O(@TMP@(DFN,RFIEN)) Q:RFIEN=""  D RVAL(IEN) S C=C+1,VALUE(C)=VALUE(C)_VAL_"^"
 ;
 F C=1:1:CRE S VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^")
 I DFN="" S VALUE(1)=""
 I $D(VALUE) D
 . F C=1:1:CRE S CLNG=$L(HEADR,"^")-$L(VALUE(C),"^") D
 .. I CLNG>0 S $P(VALUE(C),"^",$L(HEADR,"^"))=""
 .. I CLNG<0 S VALUE(C)=$P(VALUE(C),"^",1,$L(HEADR,"^"))
 F C=1:1:CRE S II=II+1,VALUE(C)=$$TKO^BQIUL1(VALUE(C),"^"),@DATA@(II)=VALUE(C)_$C(30)
 K VALUE S VALUE(0)=BVALUE
 ;
FIN ;
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
 S FIL=$P(^BQI(90506.1,STVW,0),"^",5)
 S FLD=$P(^BQI(90506.1,STVW,0),"^",6)
 S EXEC=$$GET1^DIQ(90506.1,STVW_",",1,"E")
 S EXEC=$G(^BQI(90506.1,STVW,1))
 S HDR=$P(^BQI(90506.1,STVW,0),"^",8)
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" X EXEC Q
 ;
 I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 Q
 ;
REFF ;EP
 NEW ORD,IEN,FLD,FIE
 ;set up fields by display order
 S ORD="",FLDS=""
 F  S ORD=$O(^BQI(90506.1,"AD","RF",ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD","RF",ORD,IEN)) Q:IEN=""  D
 .. S FLD=$$GET1^DIQ(90506.1,IEN_",",.06,"E"),FIE=$$GET1^DIQ(90506.1,IEN_",",.2,"I")
 .. I FIE="" S FIE="E"
 .. S FLDS=FLDS_FLD_"/"_FIE_";"
 S FLDS=$$TKO^BQIUL1(FLDS,";")
 Q
 ;
RFPT(DFN,FLDS) ;EP
 NEW BGDT,BQIPAT
 S TMP=$NA(^TMP("BQIREFS",UID)) K @TMP
 S BGDT=$P($G(^BQI(90508,1,16)),"^",4) I BGDT="" S BGDT="T-12M"
 S BGDT=$$DATE^BQIUL1(BGDT)
 S BQIPAT(DFN)=""
 D API^BMCAPI1(.BQIPAT,BGDT,"",FLDS,TMP)
 K BQIPAT
 ;
 Q
 ;
RVAL(STVW) ;EP
 NEW FIL,FLD,EXEC,DTY
 S FIL=$P(^BQI(90506.1,STVW,0),"^",5)
 S FLD=$P(^BQI(90506.1,STVW,0),"^",6)
 S EXEC=$G(^BQI(90506.1,STVW,1))
 S DTY=$P(^BQI(90506.1,STVW,0),"^",20)
 S ORD=$P($G(^BQI(90506.1,STVW,3)),"^",5)
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" X EXEC Q
 ;
 I FLD'="" S VAL=$G(@TMP@(DFN,ORD,FLD,DTYP))
 Q
 ;
DSP() ;EP
 NEW ORD,FIE,VAL
 S VAL=""
 S ORD=$$GET1^DIQ(90506.1,STVW_",",3.05,"E")
 S FIE=$$GET1^DIQ(90506.1,STVW_",",.2,"I") S:FIE="" FIE="E"
 S VAL=$G(@TMP@(DFN,RFIEN,ORD,FLD,FIE))
 I FIE="I" S VAL=$$FMTMDY^BQIUL1(VAL)
 Q VAL
 ;
RHD ;EP - Referral header
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
 I TEMPL'="" S QFL=0 D  G FH:'QFL
 . S LYIEN=$$TPN^BQILYUTL(DUZ,TEMPL)
 . I LYIEN="" S QFL=1 Q
 . S DOR=""
 . F  S DOR=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR)) Q:DOR=""  D
 .. S IEN=""
 .. F  S IEN=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR,IEN)) Q:IEN=""  D
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,IEN,0),U,1)
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... I $P(^BQI(90506.1,GIEN,0),U,10)=1 Q
 ... S HDR=$P(^BQI(90506.1,STVW,0),"^",8)
 ... S RHEADR=RHEADR_HDR_"^"
 . S RHEADR=$$TKO^BQIUL1(RHEADR,"^")
 ;
 ; If no template, check for customized
 I OWNR=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,26,IEN))
 . I CIEN'="" D  Q
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,26,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,26,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... S HDR=$$GET1^DIQ(90506.1,SIEN_",",.08,"E")
 ... S RHEADR=RHEADR_HDR_"^"
 . S RHEADR=$$TKO^BQIUL1(RHEADR,"^")
 . ;
 . ; If no customized found, use default
 . I CIEN="" D RSH()
 ;
 I OWNR'=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN))
 . I CIEN'="" D  Q
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,26,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... S HDR=$P(^BQI(90506.1,SIEN,0),"^",8)
 ... S RHEADR=RHEADR_HDR_"^"
 . S RHEADR=$$TKO^BQIUL1(RHEADR,"^")
 . ;
 . ; If no customized found, use default
 . I CIEN="" D RSH()
 ;
FH ;
 Q
 ;
RSH() ;EP - Get standard header
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","D",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . S KEY=$$GET1^DIQ(90506.1,IEN_",",3.1,"E")
 . I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 . I $P($G(^BQI(90506.1,IEN,3)),"^",4)'="O" D
 .. S STVW=IEN
 .. S HDR=$P(^BQI(90506.1,STVW,0),"^",8)
 .. S RHEADR=RHEADR_HDR_"^"
 ;
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","RF",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . S KEY=$$GET1^DIQ(90506.1,IEN_",",3.1,"E")
 . I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 . I $P($G(^BQI(90506.1,IEN,3)),"^",4)'="O" D
 .. S STVW=IEN
 .. S HDR=$P(^BQI(90506.1,STVW,0),"^",8)
 .. S RHEADR=RHEADR_HDR_"^"
 S RHEADR=$$TKO^BQIUL1(RHEADR,"^")
 Q
