BQIRMREG ;PRXM/HC/ALA-Reminders by Register ; 30 Oct 2007  5:25 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,REG,PLIST) ;EP -- BQI REGISTER REMIND BY PANEL
 ;Description - Entry point for the panel
 ;Input Parameters
 ;  OWNR  - Owner of panel
 ;  PLIEN - Panel IEN
 ;  REG   - Register
 ;  PLIST - List of DFNs (optional)
 NEW UID,II,X,BQIRM,VAL,DFN,HIEN,E,J,K,L,MAX,MIN,NAFLG,STVWCD,RGIEN
 NEW CODE,NCODE,RMIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRMPL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(REG)="" S BMXSEC="No register selected" Q
 ;
 S RGIEN=$O(^BQI(90507,"B",REG,"")) I RGIEN="" S BMXSEC=REG_" register does not exist" Q
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
 I II=0,'$D(@DATA) D PAT(.DATA,OWNR,PLIEN,"")
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
 NEW GMET,GHDR
 D STAND()
 ;
EXIT ;
 Q
 ;
STAND() ;EP - Get standard display
 NEW IEN,HDR,VALUE,HEADR,SENS,HDOB,Y,STVW,TEXT,ORD
 S VALUE=""
 I DFN'="" S Y=$$GET1^DIQ(9000001,DFN_",",1102.2,"I"),HDOB=$$FMTE^BQIUL1(Y)
 I DFN'="" S VALUE=DFN_U_$$FLG^BTPWPPAT(DFN)_U_$$FLG^BQIULPT(DUZ,PLIEN,DFN)_U_$$SENS^BQIULPT(DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U_HDOB_U
 S HEADR="I00010DFN^T00001TICKLER_INDICATOR^T00001FLAG_INDICATOR^T00001SENS_FLAG^T00001COMM_FLAG^T00001HIDE_MANUAL^D00030HIDE_DOB^"
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","D",IEN)) Q:IEN=""  D
 . I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 . I $$GET1^DIQ(90506.1,IEN_",",.04,"I")'="R" Q
 . S STVW=IEN
 . D CVAL
 . S VALUE=VALUE_VAL_"^"
 . S HEADR=HEADR_HDR_"^"
 ;
 S NCODE="REG_"_RGIEN,ORD=""
 F  S ORD=$O(^BQI(90507,RGIEN,15,"AC",ORD)) Q:ORD=""  D
 . S RMIEN=""
 . F  S RMIEN=$O(^BQI(90507,RGIEN,15,"AC",ORD,RMIEN)) Q:RMIEN=""  D
 .. S CODE=NCODE_"_"_RMIEN
 .. S IEN=""
 .. F  S IEN=$O(^BQI(90506.1,"B",CODE,IEN)) Q:IEN=""  D
 ... I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 ... S STVW=$P(^BQI(90506.1,IEN,0),U,1)
 ... S HDR=$$GET1^DIQ(90506.1,IEN_",",.08,"E")
 ... D RMVL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
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
 NEW RDATA,CT,I,RIEN,REG,CMIEN,BQIDOD,DUE
 S CMIEN=""
 I DFN="" S VAL="",HDR="T00025"_STVW Q
 ; If patient is deceased
 S BQIDOD=$$GET1^DIQ(2,DFN_",",.351,"I") I BQIDOD'="" S VAL="1/1/0001 12:00:00 AM" Q
 ; if patient has no reminders, then No Data Available (NDA)
 I $O(^BQIPAT(DFN,40,0))="" S VAL="1/1/0001 12:00:00 AM" Q
 S REG=$P(STVW,"_",2) I REG'="" D
 . S CMIEN=$O(^BQI(90506.5,"D",REG,""))
 ; if patient does not meet denominator, then Not Applicable (N/A)
 I CMIEN'="",'$$NRPC^BQICMDNM(DFN,CMIEN) S VAL="1/1/0001 12:01:00 AM" Q
 ; if patient has no data for this particular reminder, then Not Applicable (N/A)
 S RIEN=$O(^BQIPAT(DFN,40,"B",STVW,"")) I RIEN="" S VAL="1/1/0001 12:01:00 AM" Q
 S RDATA=$G(^BQIPAT(DFN,40,RIEN,0))
 S CT=0
 F I=2:1:4 S:$P(RDATA,U,I)'="" CT=CT+1
 S HDR="T00025"_STVW
 ;I CT=0 S VAL="N/A" Q
 I CT=0 S VAL="1/1/0001 12:01:00 AM" Q
 S DUE=$P(RDATA,U,4)
 I $P(RDATA,U,3)'="",DUE="" S DUE=DT
 ;I DUE>DT S VAL="F" Q
 ;S ODT=$$FMADD^XLFDT(DT,-30)
 ;I DUE<ODT S VAL="O" Q
 ;S VAL="C"
 S VAL=$$FMTE^BQIUL1(DUE)
 Q
