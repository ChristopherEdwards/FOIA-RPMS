BQICAPT ;GDIT/HS/ALA-Community Alerts Patients ; 16 Oct 2011  11:49 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;
EN(DATA,PARMS) ; EP - BQI GET COMM ALERTS PATIENTS
 ; Gets a list of patients that go along with community alerts
 ;  Input parameters
 ;    PARMS - Parameters of communities and dx categories
 ;
 NEW UID,II,DATE,IEN,COMM,TYP,TYPE,ADATE,ASSOC,BGPHOME,BQ,BQI,BQIINDF,BQIINDG,BQIMEASF
 NEW BQIMEASG,BQIROU,BQIY,BQIYR,CIEN,BN,DCAT,DCN,DXC,DXN,FILE,HDR,HEADR,LOOK,OCDT,ORD
 NEW PAT,QFL,RECORD,TEMP,VAL,VALUE,NAFLG,NAME,PDATA,DXCAT,PATNAM,NVAL,TCAT,LBN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQICAPT",UID)),TEMP=$NA(^TMP("BQITMP",UID))
 K @DATA,@TEMP
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQICAPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I PARMS'="" D
 . F BQ=1:1:$L(PARMS,$C(28)) D
 .. S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 .. S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 .. F BQI=1:1:$L(VALUE,$C(29)) D
 ... S VAL=$P(VALUE,$C(29),BQI),ASSOC=$P(VAL,$C(25),2,99)
 ... I NAME="COMM" S CIEN=$P(VAL,$C(25),1),COMM(CIEN)=""
 ... I NAME="DX" D
 .... S DXC=$P(VAL,$C(25),1)
 .... ;S TIEN=$$FIND1^DIC(90507.8,"","BX",TYPE,"","","ERROR")
 .... S DXCAT(DXC)=""
 ... I ASSOC="" Q
 ... S NAME=$P(ASSOC,"=",1),NVAL=$P(ASSOC,"=",2,99)
 ... I NAME="DX" D
 .... F BQQ=1:1:$L(NVAL,$C(24)) S DXC=$P(NVAL,$C(24),BQQ),DXCAT(DXC)=""
 . I '$D(COMM) D ACOM
 . I '$D(DXCAT) D ADXC
 ;
 I PARMS="" D
 . D ACOM
 . D ADXC
 ;
 S CIEN=""
 F  S CIEN=$O(COMM(CIEN)) Q:CIEN=""  D
 . D COM(CIEN)
 D SOR
 Q
 ;
ACOM ; Get all communities
 K COMM
 NEW CIEN
 S CIEN=0
 F  S CIEN=$O(^BQI(90507.6,CIEN)) Q:'CIEN  S COMM(CIEN)=""
 Q
 ;
ADXC ; Get all types
 K TYP
 NEW TIEN,NAM
 S TIEN=0
 F  S TIEN=$O(^BQI(90507.8,TIEN)) Q:'TIEN  S DXCAT($P(^BQI(90507.8,TIEN,0),U,1))=""
 F NAM="Attempt","Ideation","Completion" S DXCAT(NAM)=""
 Q
 ;
COM(CIEN) ;EP
 S COMM=$$GET1^DIQ(90507.6,CIEN_",",.01,"E")
 ; Get the type of the alert, either CDC NND or Suicide
 S TYP=0
 F  S TYP=$O(^BQI(90507.6,CIEN,1,TYP)) Q:'TYP  D FND(CIEN,TYP)
 Q
 ;
FND(CIEN,TYP) ;EP
 S TYPE=$P(^BQI(90507.6,CIEN,1,TYP,0),U,1)
 NEW DA,IENS,BQIH,BQI,SDATE
 S BQIH=$$SPM^BQIGPUTL()
 S BQI=$O(^BQI(90508,BQIH,15,"B",TYPE,""))
 S DA(1)=BQIH,DA=BQI,IENS=$$IENS^DILF(.DA)
 S SDATE=$$GET1^DIQ(90508.015,IENS,.03,"E")
 I SDATE="" S SDATE=30
 I SDATE'="" S ADATE=$$DATE^BQIUL1("T-"_SDATE)
 ; Get the Diagnosis Category
 S DCAT=""
 F  S DCAT=$O(DXCAT(DCAT)) Q:DCAT=""  D
 . S DXC=$O(^BQI(90507.6,CIEN,1,TYP,1,"B",$E(DCAT,1,30),""))
 . I DXC="" Q
 . I TYPE'="Suicidal Behavior" S QFL=0 D  Q:QFL
 .. S DCN=$$FIND1^DIC(90507.8,"","BX",DCAT,"","","ERROR")
 .. I DCN=0 S QFL=1 Q
 .. S LOOK=$$VAL^BQICAVW(DUZ,DCN)
 .. I $P(LOOK,U,1)="OFF"!($P(LOOK,U,1)=0) S QFL=1 Q
 .. S ADATE=$P(LOOK,U,2)
 . S DXN=0
 . F  S DXN=$O(^BQI(90507.6,CIEN,1,TYP,1,DXC,1,DXN)) Q:'DXN  D
 .. NEW DA,IENS
 .. S DA(3)=CIEN,DA(2)=TYP,DA(1)=DXC,DA=DXN,IENS=$$IENS^DILF(.DA)
 .. S OCDT=$P(^BQI(90507.6,CIEN,1,TYP,1,DXC,1,DXN,0),U,2)
 .. I (OCDT\1)'>ADATE Q
 .. S PAT=$P(^BQI(90507.6,CIEN,1,TYP,1,DXC,1,DXN,0),U,4),RECORD=$P(^(0),U,3),FILE=$P(^(0),U,5),VISIT=$P(^(0),U,6)
 .. S PATNAM=$P($G(^DPT(PAT,0)),U,1) S:PATNAM="" PATNAM="~"
 .. S $P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,1,2)=RECORD_U_FILE
 . S LBN=0
 . F  S LBN=$O(^BQI(90507.6,CIEN,1,TYP,1,DXC,2,LBN)) Q:'LBN  D
 .. S LOCDT=$P(^BQI(90507.6,CIEN,1,TYP,1,DXC,2,LBN,0),U,2)
 .. I (LOCDT\1)'>ADATE Q
 .. S PAT=$P(^BQI(90507.6,CIEN,1,TYP,1,DXC,2,LBN,0),U,4),RECORD=$P(^(0),U,3),FILE=$P(^(0),U,5),VISIT=$P(^(0),U,6)
 .. S PATNAM=$P($G(^DPT(PAT,0)),U,1) S:PATNAM="" PATNAM="~"
 .. I $D(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT)) D
 ... S $P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,3,5)=RECORD_U_FILE_U_LOCDT
 .. I '$D(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT)) D
 ... S $P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,"~"),U,3,5)=RECORD_U_FILE_U_LOCDT
 Q
 ;
SOR ; Sort out the alerts
 NEW COMM,TYPE,LINK,DCAT,NUM,OCDT,PATNAM,DOCDT,LOCDT,TCAT,OCDT,FILE
 NEW LBREC,LBFIL,PAT,LBN
 S PATNAM=""
 F  S PATNAM=$O(@TEMP@(PATNAM)) Q:PATNAM=""  D
 . S PAT=""
 . F  S PAT=$O(@TEMP@(PATNAM,PAT)) Q:PAT=""  D
 .. S COMM=""
 .. F  S COMM=$O(@TEMP@(PATNAM,PAT,COMM)) Q:COMM=""  D
 ... S TYPE=""
 ... F  S TYPE=$O(@TEMP@(PATNAM,PAT,COMM,TYPE)) Q:TYPE=""  D
 .... NEW DA,IENS,BQIH,BQI
 .... S BQIH=$$SPM^BQIGPUTL()
 .... S BQI=$O(^BQI(90508,BQIH,15,"B",TYPE,""))
 .... S DA(1)=BQIH,DA=BQI,IENS=$$IENS^DILF(.DA)
 .... ;S LINK=$$GET1^DIQ(90508.015,IENS,.02,"E")
 .... S DCAT=""
 .... F  S DCAT=$O(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT)) Q:DCAT=""  D
 ..... S OCDT=""
 ..... F  S OCDT=$O(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT)) Q:OCDT=""  D
 ...... S RECORD=$P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,1)
 ...... S FILE=$P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,2)
 ...... S LBREC=$P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,3)
 ...... S LBFIL=$P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,4)
 ...... S LOCDT=$P(@TEMP@(PATNAM,PAT,COMM,TYPE,DCAT,OCDT),U,5)
 ...... S LOCDT=$S(+$P(^BQI(90508,1,0),U,25)=0:"",1:LOCDT)
 ...... S DOCDT=$S(OCDT="~":"",1:OCDT)
 ...... D STAND(PAT)
 ...... S TCAT=$S(DCAT="Ideation":"Ideation with Plan and Intent",DCAT="Completion":"Completed Suicide",1:DCAT)
 ...... S HDR=$P(HEADR,"^",1,9)_"^T00045ALERT_TYPE^T00045DX_CAT^D00015VISITDATE^I00010VISIT_IEN^I00010DFN^D00015LABDATE"_$C(30)
 ...... S II=II+1,@DATA@(II)=$P(VALUE,"^",1,9)_U_TYPE_U_TCAT_U_$$FMTE^BQIUL1(DOCDT)_U_VISIT_U_PAT_U_$$FMTE^BQIUL1(LOCDT)_$C(30)
 ;
DONE ;
 I $G(HDR)="" D
 . S HDR="T00030PN^T00030HRN^T00001SX^T00010AGE^D00030DOB^T00035DPCP^T00030COM^T00120DCAT^"
 . S HDR=HDR_"T00045ALERT_TYPE^T00045DX_CAT^D00015VISITDATE^I00010VISIT_IEN^I00010DFN^D00015LABDATE"_$C(30)
 S @DATA@(0)=HDR
 S II=II+1,@DATA@(II)=$C(31)
 K @TEMP
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
STAND(DFN) ;EP - Get standard display
 NEW IEN,STVW,KEY,ORD
 S HEADR="",VALUE=""
 ; Check for alternate display order first
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AF","D",ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AF","D",ORD,IEN)) Q:IEN=""  D
 .. S STVW=IEN
 .. ; if the field has been inactivated, don't get data
 .. I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 .. S KEY=$$GET1^DIQ(90506.1,STVW_",",3.1,"E")
 .. I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 .. ; For a standard display,  display the 'R'equired and 'D'efault fields
 .. I $$GET1^DIQ(90506.1,STVW_",",3.04,"I")'="O" D
 ... D GVAL
 ... Q:HDR=""
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 ; Check for normal display order
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD","D",ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD","D",ORD,IEN)) Q:IEN=""  D
 .. S STVW=IEN
 .. ; if the field has been inactivated, don't get data
 .. I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 .. S KEY=$$GET1^DIQ(90506.1,STVW_",",3.1,"E")
 .. I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 .. ; For a standard display,  display the 'R'equired and 'D'efault fields
 .. I $$GET1^DIQ(90506.1,STVW_",",3.04,"I")'="O" D
 ... D GVAL
 ... Q:HDR=""
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 S VALUE=$$TKO^BQIUL1(VALUE,"^")
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
 S FIL=$$GET1^DIQ(90506.1,STVW_",",.05,"E")
 S FLD=$$GET1^DIQ(90506.1,STVW_",",.06,"E")
 S EXEC=$$GET1^DIQ(90506.1,STVW_",",1,"E")
 S HDR=$$GET1^DIQ(90506.1,STVW_",",.08,"E")
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" D  Q
 . I EXEC["PLIEN" S VAL="",HDR="" Q
 . X EXEC
 ;
 I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 Q
