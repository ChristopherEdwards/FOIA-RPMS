BQIRMPL ;PRXM/HC/ALA-Reminders By Panel ; 20 Feb 2007  4:04 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,PLIST) ;EP -- BQI GET REMINDERS BY PANEL
 ;Description - Entry point for the panel
 ;Input Parameters
 ;  OWNR  - Owner of panel
 ;  PLIEN - Panel IEN
 ;  PLIST - List of DFNs (optional)
 NEW UID,II,X,BQIRM,VAL,DFN,HIEN,E,J,K,L,MAX,MIN,NAFLG,STVWCD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRMPL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
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
 I II=0,$G(@DATA@(II))="" D PAT(.DATA,OWNR,PLIEN,"")
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
 NEW IEN,HDR,VALUE,HEADR,DORD,HDOB,Y,ORD
 S VALUE="",CTYP="R"
 I DFN'="" S Y=$$GET1^DIQ(9000001,DFN_",",1102.2,"I"),HDOB=$$FMTE^BQIUL1(Y)
 I DFN'="" S VALUE=DFN_U_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_U_$$SENS^BQIULPT(DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U_HDOB_U
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^D00030HIDE_DOB^"
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
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,IEN,0),U,1)
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... I $P(^BQI(90506.1,GIEN,0),U,10)=1 Q
 ... S HDR=$$GET1^DIQ(90506.1,GIEN_",",.08,"E")
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Patient" S STVW=GIEN D CVAL
 ... I $$GET1^DIQ(90506.1,GIEN_",",3.01,"E")="Reminders" S STVW=CODE D RMVL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 ; If no template, check for customized
 I OWNR=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,22,IEN))
 . I CIEN'="" D  Q
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,22,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,22,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... S HDR=$$GET1^DIQ(90506.1,SIEN_",",.08,"E")
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" S STVW=SIEN D CVAL
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Reminders" S STVW=CODE D RMVL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized found, use default
 . I CIEN="" D STAND()
 ;
 I OWNR'=DUZ D
 . S IEN=0,CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,22,IEN))
 . I CIEN'="" D  Q
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,22,IEN)) Q:'IEN  D
 ... S CODE=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,22,IEN,0),"^",1)
 ... S SIEN=$O(^BQI(90506.1,"B",CODE,"")) I SIEN="" Q
 ... I $P(^BQI(90506.1,SIEN,0),U,10)=1 Q
 ... S HDR=$$GET1^DIQ(90506.1,SIEN_",",.08,"E")
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Patient" S STVW=SIEN D CVAL
 ... I $$GET1^DIQ(90506.1,SIEN_",",3.01,"E")="Reminders" S STVW=CODE D RMVL
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
 I VALUE'="",$P($G(@DATA@(II)),$C(30),1)'=VALUE S II=II+1,@DATA@(II)=VALUE_$C(30)
 Q
 ;
STAND() ;EP - Get standard display
 NEW IEN,HDR,SENS,HDOB,Y,STVW,TEXT,ORD
 S VALUE=""
 I DFN'="" S Y=$$GET1^DIQ(9000001,DFN_",",1102.2,"I"),HDOB=$$FMTE^BQIUL1(Y)
 I DFN'="" S VALUE=DFN_U_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_U_$$SENS^BQIULPT(DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U_HDOB_U
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^D00030HIDE_DOB^"
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","D",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 .. S STVW=IEN
 .. D CVAL
 .. S VALUE=VALUE_VAL_"^"
 .. S HEADR=HEADR_HDR_"^"
 ;
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","R",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),U,10)=1 Q
 . I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 .. S STVW=$P(^BQI(90506.1,IEN,0),U,1)
 .. S HDR=$P(^BQI(90506.1,IEN,0),U,8)
 .. D RMVL
 .. S VALUE=VALUE_VAL_"^"
 .. S HEADR=HEADR_HDR_"^"
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 S VALUE=$$TKO^BQIUL1(VALUE,"^")
 ;
 I DFN="" S VALUE=""
 ;
 I II=0 S @DATA@(II)=HEADR_$C(30)
 I VALUE'="" S II=II+1,@DATA@(II)=VALUE_$C(30)
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
RMVL ;  Reminder value
 NEW RDATA,CT,I,RIEN,BQIDOD,CMIEN,REG,DUE
 S CMIEN=""
 I DFN="" S VAL="",HDR="T00025"_STVW Q
 ; If paitnet is deceased
 S BQIDOD=$$GET1^DIQ(2,DFN_",",.351,"I") I BQIDOD'="" S VAL="1/1/0001 12:00:00 AM" Q
 ; if patient has no reminders, then No Data Available (NDA)
 I $O(^BQIPAT(DFN,40,0))="" S VAL="1/1/0001 12:00:00 AM" Q
 I $L(STVW,"_")>2 D
 . S REG=$P(STVW,"_",2) I REG'="" D
 .. S CMIEN=$O(^BQI(90506.5,"D",REG,""))
 ; if patient does not meet denominator, then Not Applicable (N/A)
 I CMIEN'="",'$$NRPC^BQICMDNM(DFN,CMIEN) S VAL="1/1/0001 12:01:00 AM" Q
 ; if patient has no data for this particular reminder, then Not Applicable (N/A)
 S RIEN=$O(^BQIPAT(DFN,40,"B",STVW,"")) I RIEN="" S VAL="1/1/0001 12:01:00 AM" Q
 S RDATA=$G(^BQIPAT(DFN,40,RIEN,0))
 S CT=0
 I $P(STVW,"_",1)="EHR",$P(RDATA,U,3)="N/A" S VAL="1/1/0001 12:01:00 AM" Q
 F I=2:1:4 S:$P(RDATA,U,I)'=""&($P(RDATA,U,I)'="N/A") CT=CT+1
 S HDR="T00030"_STVW
 ;S HDR="D00030"_STVW
 ;I CT=0 S VAL="N/A" Q
 I CT=0 S VAL="1/1/0001 12:01:00 AM" Q
 S DUE=$P(RDATA,U,4)
 I $P(RDATA,U,3)'="",DUE="" S DUE=DT
 ;I DUE>DT S VAL="F" Q
 ;S ODT=$$FMADD^XLFDT(DT,-30)
 ;I DUE<ODT S VAL="O" Q
 ;S VAL="C"
 ;S VAL=$$FMTE^BQIUL1(DUE)
 ;I VAL[",",VAL'[", " S VAL=$P(VAL,",")_", "_$P(VAL,",",2,99)
 S VAL=$$FMTMDY^BQIUL1(DUE)
 Q
 ;
RDEF() ;EP - Reminders default
 NEW RVALUE,IEN,STVCD,REMNM,BQIARRAY
 S RVALUE=""
 ;
 ; Check for normal display order
 S DOR="" F  S DOR=$O(^BQI(90506.1,"AD","D",DOR)) Q:DOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD","D",DOR,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S RVALUE=RVALUE_STVCD_$C(29)
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","R",IEN)) Q:IEN=""  D
 . ;I $$GET1^DIQ(90506.1,IEN_",",.09,"I")'="O" D
 . I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 .. S REMNM=$$GET1^DIQ(90506.1,IEN_",",.03,"E")
 .. S BQIARRAY(REMNM,IEN)=STVCD
 S REMNM=""
 F  S REMNM=$O(BQIARRAY(REMNM)) Q:REMNM=""  D
 . S IEN=""
 . F  S IEN=$O(BQIARRAY(REMNM,IEN)) Q:IEN=""  D
 .. S STVCD=BQIARRAY(REMNM,IEN)
 .. S RVALUE=RVALUE_STVCD_$C(29)
 S RVALUE=$$TKO^BQIUL1(RVALUE,$C(29))
 Q RVALUE
