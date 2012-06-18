BQIPLVWP ;PRXM/HC/ALA-Get Patient Data by View ; 17 Oct 2005  4:49 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,DFN) ;EP - Starting point
 ;
 ;Description
 ;  Builds the header and data string in the panel
 ;  display order.  If a customized view exists, it
 ;  builds it, otherwise it builds the standard.
 ;Input
 ;  OWNR  - owner of the panel
 ;  PLIEN - panel internal entry number
 ;  PLIST - List of patient IENs separated by $C(28)
 ;  DATA  - Global reference
 ;Expects
 ;  DUZ   - person signed onto system
 ;  II    - counter variable
 ;
 ; if the user is the owner of the panel, use the owner's display order
 NEW BQI,CTYP,SRC,HEADR,VALUE,QFL
 S CTYP="D",SRC=$O(^BQI(90506.5,"C",CTYP,""))
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^",VALUE=""
 I $G(DFN)'="" S VALUE=DFN_U_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_U_$$SENS^BQIULPT(DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U
 ; Check for template
 NEW DA,IENS,TEMPL,LYIEN,VWIEN
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
 . S LYIEN=$$TPN^BQILYUTL(DUZ,TEMPL)
 . I LYIEN="" S QFL=1 Q
 . S DOR=""
 . F  S DOR=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR)) Q:DOR=""  D
 .. S VWIEN=""
 .. F  S VWIEN=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR,VWIEN)) Q:VWIEN=""  D
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,VWIEN,0),U,1)
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... ; if the field has been inactivated, don't get data
 ... I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 ... D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 ; If no template, check for customized
 ;
 I OWNR=DUZ D
 . S VWIEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,20,VWIEN))
 . I CIEN'="" D  Q
 .. F  S VWIEN=$O(^BQICARE(OWNR,1,PLIEN,20,VWIEN)) Q:'VWIEN  D
 ... NEW DA,IENS,STVW
 ... S DA(2)=OWNR,DA(1)=PLIEN,DA=VWIEN,IENS=$$IENS^DILF(.DA)
 ... S STVW=$$GET1^DIQ(90505.05,IENS,.01,"I")
 ... ; if the field has been inactivated, don't get data
 ... I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 ... ; if the source does not match, quit
 ... I $$GET1^DIQ(90506.1,STVW_",",3.01,"I")'=SRC Q
 ... D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized found, use default
 . I CIEN="" D STAND()
 ;
 I OWNR'=DUZ D
 . S VWIEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,20,VWIEN))
 . I CIEN'="" D  Q
 .. F  S VWIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,20,VWIEN)) Q:'VWIEN  D
 ... NEW DA,IENS,STVW
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,DA=VWIEN
 ... S IENS=$$IENS^DILF(.DA)
 ... S STVW=$$GET1^DIQ(90505.06,IENS,.01,"I")
 ... ; if the field has been inactivated, don't get data
 ... I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 ... ; if the source does not match, quit
 ... I $$GET1^DIQ(90506.1,STVW_",",3.01,"I")'=SRC Q
 ... D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized found, use default
 . I CIEN="" D STAND()
 ;
FIN ; Finish
 ; remove trailing up-arrows
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 S VALUE=$$TKO^BQIUL1(VALUE,"^")
 I DFN="" S VALUE=""
 ;
 I II=0 S @DATA@(II)=HEADR_$C(30)
 I VALUE'="" S II=II+1,@DATA@(II)=VALUE_$C(30) K VALUE
 K HEADR
 Q
 ;
STAND() ;EP - Get standard display
 NEW VWIEN,HDR,SENS
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^",VALUE=""
 I $G(DFN)'="" S VALUE=DFN_U_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_U_$$SENS^BQIULPT(DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U
 ;
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD","D",ORD)) Q:ORD=""  D
 . S VWIEN=""
 . F  S VWIEN=$O(^BQI(90506.1,"AD","D",ORD,VWIEN)) Q:VWIEN=""  D
 .. S STVW=VWIEN
 .. ; if the field has been inactivated, don't get data
 .. I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 .. ; For a standard display,  display the 'R'equired and 'D'efault fields
 .. I $$GET1^DIQ(90506.1,STVW_",",3.04,"I")'="O" D
 ... D GVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 Q
 ;
GVAL ; Get values
 ;Parameters
 ;  FIL  = FileMan file number
 ;  FLD  = FileMan field number
 ;  EXEC = If an executable is needed to determine value
 ;  HDR  = Header value
 ;the executable expects the value to be returned in variable VAL
 NEW FIL,FLD,EXEC
 S VAL=""
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
PAT(DATA,OWNR,PLIEN,PLIST) ; EP -- BQI GET PATIENT LIST BY DFN
 ;  Get a single patient list record
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLVWP",UID))
 K @DATA
 S II=0,PLIST=$G(PLIST,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLVWP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR^BQIPLPT
 ;
 I PLIST="" D
 . S LIST="",BN=""
 . F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 . K PLIST S PLIST=LIST
 ;
 F BQI=1:1 S DFN=$P(PLIST,$C(28),BQI) Q:DFN=""  D
 . ;I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 . D EN(.DATA,OWNR,PLIEN,.DFN)
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
