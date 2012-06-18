BQIRGPT ;PRXM/HC/ALA-Get register data by patient ; 05 Nov 2007  12:19 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN,REG) ;EP -- BQI GET REG DATA BY PATIENT
 ;Input parameter
 ;  DFN - Patient internal entry number
 ;  REG - Register name
 ;
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGPT",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;Build record by patient
 NEW IEN,HDR,VALUE,HEADR,SENS,HDOB,Y,STVW,TEXT,ORD,HDIEN,SUB,SREG,RIENS,RGIEN
 NEW CODE,TYPE,BI,IENS,RIEN,SEXEC,SFIL,SFLD,VAL
 ;
 S RGIEN=$O(^BQI(90506.3,"B",REG,""))
 I RGIEN="" S @DATA@(II)="T00030IEN"_$C(30) G DONE
 ;
 ; Check if this is a sub-definition
 ;
 S SUB=+$P(^BQI(90506.3,RGIEN,0),U,7)
 ;
 S SREG=$O(^BQI(90507,"B",REG,""))
 NEW PTEXEC
 S PTEXEC=$$GET1^DIQ(90507,SREG_",",3,"E")
 I PTEXEC'="" X PTEXEC S RIENS=IENS
 ;
 ; if not a subdefinition, define the record internal entry number
 S HDIEN=$O(^BQI(90506.3,RGIEN,10,"AE","Y",""))
 S HEADR=$S(HDIEN'="":$P(^BQI(90506.3,RGIEN,10,HDIEN,0),U,2),1:"T00030IEN")_"^"
 S VALUE=$G(RIENS)_U
 ;
 S ORD="" K DISPLAY
 F  S ORD=$O(^BQI(90506.3,RGIEN,10,"C",ORD)) Q:ORD=""  D
 . S RIEN=""
 . F  S RIEN=$O(^BQI(90506.3,RGIEN,10,"C",ORD,RIEN)) Q:RIEN=""  D
 .. ;I $P(^BQI(90506.3,RGIEN,10,RIEN,0),U,4)'="S" Q
 .. S CODE=$P(^BQI(90506.3,RGIEN,10,RIEN,0),U,7) I CODE="" Q
 .. S TYPE=$P($G(^BQI(90506.3,RGIEN,10,RIEN,1)),U,1)
 .. S IEN=$O(^BQI(90506.1,"B",CODE,"")) I IEN="" Q
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. I $$GET1^DIQ(90506.1,IEN_",",3.07,"I")=1 Q
 .. S STVW=$P(^BQI(90506.1,IEN,0),U,1)
 .. S HDR=$$GET1^DIQ(90506.1,IEN_",",.08,"E")
 .. I SUB S DISPLAY(ORD)=HDR_"^"_$$GET1^DIQ(90506.1,IEN_",",.06,"E")_"^"_TYPE Q
 .. S STVW=IEN D CVAL
 .. S VALUE=VALUE_VAL_"^"
 .. S HEADR=HEADR_HDR_"^"
 ;
 I SUB D
 . S SREG=$P(^BQI(90506.3,RGIEN,0),U,8)
 . S SFIL=$P(^BQI(90506.3,RGIEN,0),U,10)
 . S SFLD=$P(^BQI(90506.3,RGIEN,0),U,11)
 . S SEXEC=$G(^BQI(90506.3,RGIEN,1))
 . I SEXEC'="" X SEXEC
 . ;D EN^BQIRGHML(.HEADR,.VALUE,DFN,SFIL,SFLD,.DISPLAY)
 ;
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 ;
 S @DATA@(II)=HEADR_$C(30)
 I $D(VALUE)=1,$G(VALUE)="" G DONE
 I $D(VALUE)<11 D
 . S VALUE=$$TKO^BQIUL1(VALUE,"^")
 . S II=II+1,@DATA@(II)=VALUE_$C(30)
 I $D(VALUE)>1 D
 . S BI=""
 . F  S BI=$O(VALUE(BI)) Q:BI=""  D
 .. S VALUE=VALUE(BI)
 .. S VALUE=$$TKO^BQIUL1(VALUE,"^")
 .. S II=II+1,@DATA@(II)=VALUE_$C(30)
 ;
 K VALUE
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
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
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FND(SBFIL,SBFLD) ;
 NEW PTEXEC
 S PTEXEC=$$GET1^DIQ(90507,SREG_",",3,"E") I PTEXEC="" Q
 X PTEXEC
 ;
 Q
